import Cocoa
import WebKit

let app = NSApplication.shared
app.setActivationPolicy(.regular)

let window = NSWindow(
    contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
    styleMask: [.titled, .closable, .miniaturizable, .resizable],
    backing: .buffered,
    defer: false
)
window.title = "TikFlow"
window.center()
window.minSize = NSSize(width: 900, height: 600)

let webView = WKWebView(frame: window.contentView!.bounds)
webView.autoresizingMask = [.width, .height]
window.contentView?.addSubview(webView)

webView.load(URLRequest(url: URL(string: "http://localhost:5050")!))

window.makeKeyAndOrderFront(nil)
app.activate(ignoringOtherApps: true)
app.run()
