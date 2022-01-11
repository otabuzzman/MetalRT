# MetalRT
Ray tracing with Metal. The lab aims to get Peter Shirley's ray tracer from his mini-book [Ray Tracing in one weekend](https://github.com/RayTracing/raytracing.github.io/) (RTOW) with Metal up and running.

Due to the lack of Xcode capable equipment development happened on an iPad Pro using Swift Playgrounds 4 (SP4) and to a limited extent with [Swift on Windows](https://www.swift.org/blog/swift-on-windows/).

### Tools
Apps used on iPad
- [Swift Playgrounds 4](https://apps.apple.com/de/app/swift-playgrounds/id908519492)
- [Working Copy](https://workingcopyapp.com/)
- [Textastic](https://www.textasticapp.com/)
- [GitHub](https://apps.apple.com/us/app/github/id1477376905)

Apps used on Winos 10
- [Swift on Windows](https://www.swift.org/blog/swift-on-windows/) 5.5

### Concept
[Metal](https://developer.apple.com/metal/) is a compute shader (and more) API that utilizes GPUs in Apple devices. The [OptiX port](https://github.com/otabuzzman/RTXplay/tree/main/optx) (RTWO) of RTOW uses GPUs on NVIDIA graphic cards. The obvious idea was a port of RTWO to iOS though bearing some challenges: Swift instead of C/C++, Playgrounds instead of an IDE, and working on a tablet instead of PC name a few. The approach was to explore the new concepts one at a time.

### Setup
- Install Cygwin with development tools (for what it's good for)
- Swift on Windows [installation](https://www.swift.org/getting-started/) (according to *Traditional Installation* section)
- GitHub repository initialization

  ```
  git init MetalRT
  cd MetalRT

  swift package init
  ```
  In first line of `Package.swift` change Swift version from 5.5 to 5.3, the version supported by Swift Playgrounds 4.

  ```
  // swift-tools-version:5.3
  ...
  ```
  ```
  # on Winos generate SSH key (optional)
  # ssh-keygen -t ed25519 -C iuergen.schuck@gmail.com -f ~/.ssh/github.com.MetalRT
  # chmod 400 ~/.ssh/github.com.MetalRT

  # on https://github.com set up repository
  # - create SSH key (optional)
  # - paste ~/.ssh/github.com.MetalRT.pub

  # on Winos clone repository
  git clone https://github.com/otabuzzman/MetalRT
  cd MetalRT

  #  set remote URL
  git remote add origin https://github.com/otabuzzman/MetalRT.git

  # set remote URL with SSH (optional)
  # git remote add origin git@github.com:otabuzzman/MetalRT.git

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
|`Object.swift`|A class to read in a single scene object from a Waveform OBJ file.|

### Findings
- Using `MTLPrimitiveType point` for `renderEncoder.drawIndexedPrimitives.type` yields kind of *bricks* whereas `line` and `triangle` work.
- No `.metal` file support in SP4. Metal Shader Language (MSL) code via `String` class in Swift source files (e.g. ending on `.metal.swift`) works for SP4 playgrounds and apps. The latter allows MSL files as resources. File suffixes must have three characters (e.g. `.msl`). Otherwise (e.g. when using `.metal` suffix) SP4 will report an unknown resource error on app open.
- Full URL of repository including `.git` required by package import in a SP4 app.
- Opening source files from imported packages yields various compiler errors. App will not run as long as the file is open but work when the file is closed again.
- Removing resource files will only make them disappear in the file browser, not on storage.
