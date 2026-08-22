import AppKit
import Foundation

private struct VisibleWorkspace {
    let screenIndex: Int
    let name: String
}

private enum OverlayError: LocalizedError {
    case aerospaceNotFound
    case aerospaceFailed(String)

    var errorDescription: String? {
        switch self {
        case .aerospaceNotFound:
            return "Could not find the aerospace executable"
        case let .aerospaceFailed(message):
            return "Could not query AeroSpace: \(message)"
        }
    }
}

private func findAeroSpace() throws -> String {
    let candidates = [
        ProcessInfo.processInfo.environment["AEROSPACE_BIN"],
        "/opt/homebrew/bin/aerospace",
        "/usr/local/bin/aerospace",
        "/run/current-system/sw/bin/aerospace",
    ].compactMap { $0 }

    if let executable = candidates.first(where: {
        FileManager.default.isExecutableFile(atPath: $0)
    }) {
        return executable
    }

    throw OverlayError.aerospaceNotFound
}

private func listVisibleWorkspaces() throws -> [VisibleWorkspace] {
    let process = Process()
    let outputPipe = Pipe()
    let errorPipe = Pipe()

    process.executableURL = URL(fileURLWithPath: try findAeroSpace())
    process.arguments = [
        "list-workspaces",
        "--monitor", "all",
        "--visible",
        "--format", "%{monitor-appkit-nsscreen-screens-id}\t%{workspace}",
    ]
    process.standardOutput = outputPipe
    process.standardError = errorPipe

    try process.run()
    process.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

    guard process.terminationStatus == 0 else {
        let message = String(data: errorData, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        throw OverlayError.aerospaceFailed(message?.isEmpty == false ? message! : "unknown error")
    }

    let output = String(data: outputData, encoding: .utf8) ?? ""
    return output.split(whereSeparator: \Character.isNewline).compactMap { line in
        let fields = line.split(separator: "\t", maxSplits: 1, omittingEmptySubsequences: false)
        guard fields.count == 2, let screenIndex = Int(fields[0]) else {
            return nil
        }
        return VisibleWorkspace(screenIndex: screenIndex, name: String(fields[1]))
    }
}

private final class OverlayController: NSObject, NSApplicationDelegate {
    private static let dismissNotification = Notification.Name(
        "com.andrea.aerospace-workspace-overlay.dismiss"
    )

    private let workspaces: [VisibleWorkspace]
    private var panels: [NSPanel] = []
    private var dismissObserver: NSObjectProtocol?
    private var isDismissing = false

    init(workspaces: [VisibleWorkspace]) {
        self.workspaces = workspaces
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let notificationCenter = DistributedNotificationCenter.default()

        // Replace overlays left by a rapid sequence of workspace changes.
        notificationCenter.postNotificationName(
            Self.dismissNotification,
            object: nil,
            userInfo: nil,
            deliverImmediately: true
        )
        dismissObserver = notificationCenter.addObserver(
            forName: Self.dismissNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.dismiss()
        }

        let screens = NSScreen.screens
        for workspace in workspaces {
            let zeroBasedIndex = workspace.screenIndex - 1
            guard screens.indices.contains(zeroBasedIndex) else {
                continue
            }

            let panel = makePanel(workspace: workspace.name, screen: screens[zeroBasedIndex])
            panels.append(panel)
            panel.alphaValue = 0
            panel.orderFrontRegardless()
        }

        guard !panels.isEmpty else {
            NSApp.terminate(nil)
            return
        }

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.12
            panels.forEach { $0.animator().alphaValue = 1 }
        }

        let configuredDuration = ProcessInfo.processInfo.environment["AEROSPACE_OVERLAY_DURATION"]
            .flatMap(Double.init)
        let duration = max(0.2, configuredDuration ?? 1.4)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.dismiss()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let dismissObserver {
            DistributedNotificationCenter.default().removeObserver(dismissObserver)
        }
    }

    private func makePanel(workspace: String, screen: NSScreen) -> NSPanel {
        let label = NSTextField(labelWithString: workspace)
        label.font = NSFont.systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .labelColor
        label.alignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.maximumNumberOfLines = 1

        let panelWidth = min(max(label.intrinsicContentSize.width + 56, 150), screen.frame.width - 80)
        let panelSize = NSSize(width: panelWidth, height: 68)
        // NSPanel's `screen` initializer expects a screen-local content rect,
        // while NSScreen.visibleFrame is expressed in the global coordinate space.
        let visibleFrame = screen.visibleFrame.offsetBy(
            dx: -screen.frame.minX,
            dy: -screen.frame.minY
        )
        let panelOrigin = NSPoint(
            x: visibleFrame.maxX - panelSize.width - 24,
            y: visibleFrame.maxY - panelSize.height - 24
        )

        let panel = NSPanel(
            contentRect: NSRect(origin: panelOrigin, size: panelSize),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.hidesOnDeactivate = false
        panel.ignoresMouseEvents = true
        panel.level = .floating
        panel.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary,
            .stationary,
            .ignoresCycle,
        ]

        let background = NSVisualEffectView(frame: NSRect(origin: .zero, size: panelSize))
        background.material = .hudWindow
        background.blendingMode = .behindWindow
        background.state = .active
        background.wantsLayer = true
        background.layer?.cornerRadius = 14
        background.layer?.masksToBounds = true

        label.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 22),
            label.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -22),
            label.centerYAnchor.constraint(equalTo: background.centerYAnchor),
        ])

        panel.contentView = background
        return panel
    }

    private func dismiss() {
        guard !isDismissing else {
            return
        }
        isDismissing = true

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.18
            panels.forEach { $0.animator().alphaValue = 0 }
        } completionHandler: {
            NSApp.terminate(nil)
        }
    }
}

do {
    let workspaces = try listVisibleWorkspaces()
    let app = NSApplication.shared
    let controller = OverlayController(workspaces: workspaces)
    app.setActivationPolicy(.accessory)
    app.delegate = controller
    app.run()
} catch {
    FileHandle.standardError.write(Data("\(error.localizedDescription)\n".utf8))
    exit(EXIT_FAILURE)
}
