# MetalRT
Ray tracing with Metal. A lab to explore various ray tracing implementations with [Metal](https://developer.apple.com/metal/).

### Tools
Apps used on iPad
- [Swift Playgrounds 4](https://apps.apple.com/de/app/swift-playgrounds/id908519492)
- [Working Copy](https://workingcopyapp.com/)
- [Textastic](https://www.textasticapp.com/) (can edit SP4 `.swiftpm` files)
- [GitHub](https://apps.apple.com/us/app/github/id1477376905)

Apps used on Winos 10
- [Swift on Windows](https://www.swift.org/blog/swift-on-windows/) 5.6

### Setup
- Install [Cygwin](https://cygwin.com/install.html) with development tools (for what it's good for)
- [Install Swift on Windows](https://www.swift.org/getting-started/) (according to *Traditional Installation* section)
- Create repository on GitHub (default settings)
- Clone repository from GitHub

  **Cygwin command prompt (bash)**
  ```
  git clone https://github.com/otabuzzman/MetalRT
  # use SSH (optional)
  # git clone git://github.com/otabuzzman/MetalRT

  cd MetalRT
  ```
- Create SSH keys (optional)
  ```
  ssh-keygen -t ed25519 -C iuergen.schuck@gmail.com -f ~/.ssh/github.com.MetalRT
  chmod 400 ~/.ssh/github.com.MetalRT
  ```
- Swift package initialization

  **Winos command prompt (CMD)**
  ```
  cd MetalRT

  swift package init

  rem check
  swift build
  ```
- Sync package with GitHub

  **Cygwin command prompt (bash)**
  ```
  # enable SSH key usage for session
  # eval "$(ssh-agent -s)"
  # ssh-add ~/.ssh/github.com.MetalRT

  git add -A
  git push origin main

  # tag required to load package with SP4
  git tag -a 0.1.0 -m 'initial commit'
  git push origin 0.1.0
  ```

### Which file for what
|File|Comment|
|:---|:------|
|`MUIView.swift`|A SwiftUI wrapper for MRTView.|
|`MRTView.swift`|A Metal ray tracer view protocol derived from [MTKView](https://developer.apple.com/documentation/metalkit/mtkview).|
|`MRTRenderer.swift`|A Metal ray tracing renderer protocol.|
|`MRTObject.swift`|A class to read a Waveform OBJ file.|
|`MTLDevice.swift`|A protocol extension for [MTLDevice](https://developer.apple.com/documentation/metal/mtldevice) to read Metal files from resource files in SP4.|
|`MRTError.swift`|Error exceptions.|

### Usage
- Setup new app in SP4<br>
  Name must differ from _MetalRT_
- Delete `*.swift` files
- Add `MetalRT` package
- Create file `MetalHW.swift` :

  ```
  import SwiftUI
  import MetalRT

  struct ContentView: View {
      var body: some View {
          MUIView {
              MHWView()
          }
      }
  }

  @main
  struct MyApp: App {
      var body: some Scene {
          WindowGroup {
              ContentView()
          }
      }
  }
  ```
- Create file `MHWView.swift` :

  ```
  import MetalKit
  import MetalRT

  class MHWView: MTKView, MRTView {
      var renderer: MRTRenderer!

      required init() {
          guard let device = MTLCreateSystemDefaultDevice() else {
              let error: Error = MRTError.noDefaultDevice
              fatalError(error.localizedDescription)
          }
          super.init(frame: .zero, device: device)

          tune()
      }

      required init(coder: NSCoder) {
          super.init(coder: coder)
      }

      func tuneMTKView() {
          colorPixelFormat = .bgra8Unorm
          clearColor = MTLClearColor(red: 0.3, green: 0.1, blue: 0.2, alpha: 1.0)
      }

      func tuneMRTView() {
          renderer = try? MHWRenderer(view: self)
      }
  }
  ```
- Create file `MHWRenderer.swift` :

  ```
  import MetalKit
  import MetalRT

  final class MHWRenderer: NSObject, MRTRenderer {
      var mtlLibrary: [MTLLibrary]!

      func makeAccelerationStructure() {
      }

      func makeGraphicsPipeline() {
      }

      func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
      }

      func draw(in view: MTKView) {
      }
  }
  ```
- Run app and check result :<br>
  A white display with no errors.

### Findings
- No `.metal` file support in SP4. Metal Shader Language (MSL) code via `String` class in Swift source files (e.g. ending on `.metal.swift`) ok for SP4 playgrounds and apps. The latter allows MSL files as resources. File suffixes must have three characters (e.g. `.msl`). Otherwise (e.g. when using `.metal` suffix) SP4 will report an unknown resource error on app open.
- Removing resource files only make them disappear in file system but app still works as if they remain present.
