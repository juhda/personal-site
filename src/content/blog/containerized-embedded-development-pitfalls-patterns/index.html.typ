#let (blog-img, callout, horizontalrule) = eval(read("../_preamble.typ"), mode: "code")

#emph[Missed Part 2 of the “]#link("https://davidjuhasz.dev/blog/series/containerized-embedded-dev")[#emph[Practical Embedded Development, Containerized]]#emph[” series? Read about]
#link("https://davidjuhasz.dev/blog/containers-for-embedded-developers")[#emph[#strong[Containers for Embedded Developers]]] #emph[first.]

#emph[You containerized your embedded workflow to end “works on my machine” --- only to find builds crawling, debuggers detaching, and “reproducible” meaning “broken the same way everywhere.”] What's the disconnect?

Containers promise embedded teams #strong[consistency]: no ‘works on my machine'
headaches, no manual toolchain setups. #strong[Yet they introduce friction web devs never see:]

- #strong[Hardware access hacks:] USB passthrough works until it doesn't (and then nothing does).

- #strong[Toolchain fragmentation:] Your container has the compiler, but you might run the debugger on the host --- and the container's compiler and host debugger are now out of sync.

- #strong[The illusion of isolation:] Bind-mounting `/dev` or host libraries feels harmless --- until it breaks CI.

#strong[The core issue:] Containers thrive in #emph[homogeneous] environments (web apps,
microservices). #strong[Embedded development is #emph[heterogeneous] by design --- your container must bridge three disjointed worlds:]

+ #strong[Containerized tools] (compilers, build systems)

+ #strong[Host-bound hardware] (JTAG, logic analyzers)

+ #strong[Target devices] (bare-metal MCUs, custom bootloaders)

#strong[The Three Worlds Problem]

#blog-img(
  "The_Three_Worlds_Problem.png",
  alt: "A Venn diagram illustrating the three intersecting environments in containerized embedded development: 1. Containerized Tools (e.g., compilers, build systems), 2. Host Hardware (e.g., JTAG probes, USB devices, /dev), 3. Target Devices (e.g., MCUs, bootloaders). Overlaps show friction points like path mismatches (Tools/Host), driver dependencies (Host/Target), and debug symbols (Tools/Target). A warning symbol at the center indicates the container must bridge these heterogeneous worlds.",
)

#callout[
  💡 #strong[Why \"Three Worlds\"?]

  Web developers containerize one environment.

  Embedded developers must sync #strong[toolchain ↔ host ↔ target] --- each with its own
  quirks.
]

#strong[Who this is for:] You're a #strong[senior embedded engineer] who's:

- #strong[Evaluating] whether to containerize your team's dev environment (or already did and are second-guessing it).

- Responsible for #strong[long-term maintainability], not just \"making it work today.\"

- Asking:

  - #emph[\"Will this save us time, or just create new kinds of technical debt?\"]

  - #emph[\"How do we avoid locking ourselves into a bad setup?\"]

  - #emph[\"What's the escape hatch when containers get in the way?\"]

#strong[What you'll get:]

- #strong[6 key decision areas] where teams trade short-term wins for long-term pain.

- #strong[Trade-offs, not prescriptions] --- because the right answer for a #strong[Yocto team] differs from a #strong[bare-metal STM32 shop].

- #strong[Actionable patterns] for toolchains, debugging, and CI that #emph[actually] work in embedded.

#strong[What you #emph[won't] get:]

- ❌ Generic Docker tutorials.

- ❌ One-size-fits-all solutions.

- ❌ “Just use `--privileged`“ hand-waving.

= Why “Cattle” Containers Fail Embedded Teams (And What Works Instead)
DevOps preaches: #emph[“Treat servers like cattle, not pets.”] #strong[Yet embedded environments are pets] --- hand-tuned, tribal-knowledge-dependent, irreplaceable.
Containers promise disposable cattle #strong[but deliver service animals: reliable only if meticulously trained.]

#blog-img(
  "Pet-Cattle-Service_Animals-ChatGPT.png",
  alt: "A three-part illustration comparing system management metaphors: 1. Pets: a person holding a bandaged server labeled 'SERVER1' with 'FEED ME UPDATES,' representing high-maintenance embedded environments. 2. Cattle: a robotic arm replacing identical servers (NODE1, NODE2, NODE3), symbolizing disposable DevOps infrastructure. 3. Service Animals: a trained service dog in a vest labeled 'EMBED'S ED LOV/ICE,' illustrating containerized embedded systems as reliable and purpose-built. Captions reinforce that pets need care, cattle get replaced, and service animals serve reliably.",
)

#figure(
  table(
    columns: 4,
    align: (auto, auto, auto, auto),
    table.header([Concept], [🐈 Pet], [🐄 Cattle], [🐕‍🦺 Service Animal]),
    table.hline(),
    [Care], [Manual (tribal knowledge)], [Automated], [Designed + maintained],
    [Replaceability], [Irreplaceable], [Replaceable], [Upgradable],
    [Role], [Companion], [Worker], [Specialized assistant],
    [Embedded Relevance], [❌], [❌], [✅],
  ),
  kind: table,
)

#callout[
  ⚠️ #strong[The Clash]

  Web developers: #emph[\"Containers = replaceable cattle.\"]

  Embedded developers: #emph[\"Containers = service animals.”]
]

#strong[The Fallout:]

- #strong[Resistance]: Teams push back --- containers feel like #strong[losing control].

- #strong[Workarounds]: Bind-mounting `/home`, X11 forwarding for GUIs, or #emph[\"just this one tool\"] exceptions.

#strong[How to Manage It:]

- ✅ #strong[Start small:] Containerize #strong[one part] of the workflow (e.g., the build system).

- ✅ #strong[Document the “why”:] Explain that containers aren't about replacing pets --- they're about #strong[taming the unruly dependencies] (e.g., the 50GB toolchain that breaks every OS update).

- ✅ #strong[Plan for exceptions:] Some tools #strong[will never go in a container].

== The Blame Game: How Unclear Ownership Derails Containerized Embedded Development
In web development, containers are DevOps' domain. In embedded, #strong[you own the entire stack --- from container to silicon]. #strong[The result?] Ambiguous ownership and
#strong[a blame game that stalls debugging.]

#strong[When a build fails in containerized embedded development]

#blog-img(
  "The_Blame_Game.png",
  alt: "A flowchart titled 'The Blame Game' depicting the diagnostic process when a containerized embedded build fails. It starts with 'Build Failed!' and progresses through 'Is it the code?', 'Is it the container?', 'Is it the host?', and 'Is it the hardware?' — each answered 'No' until ending with a shrugging emoji (🤷). The footer advises: 'Assign a container owner → Fix the blame game.'",
)

#strong[Fix it with:]

- #strong[A designated “container owner”] (rotational or permanent).

- #strong[Log everything:] Use `docker history` and `docker inspect` to track changes.

- #strong[Version containers with code:] Embed the Git commit SHA as a #emph[label] for traceability.

  ```dockerfile
  ARG COMMIT_SHA
  LABEL com.example.commit-sha=$COMMIT_SHA
  ```

= Toolchain Triage: What to Containerize (And What to Leave on the Host)
Not all tools belong in containers. Here's how to decide:

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Tool], [✅ Container?], [🚧 Host Workaround]),
    table.hline(),
    [Compilers], [✅ Yes], [Multi-stage builds],
    [Simulators/Emulators], [✅ Yes], [Run on host],
    [Debuggers], [⚠️ Maybe], [Run on host],
    [IDEs], [❌ No], [Remote connection (SSH + VSCode)],
    [License Managers], [⚠️ Maybe], [Run on host],
    [Flashing Tools], [⚠️ Maybe], [Run on host],
    [Custom Scripts], [✅ Yes (usually)], [Rewrite for container, run on host],
  ),
  kind: table,
)

Most toolchains #emph[work] in containers --- #strong[but watch for:]

- #strong[Hardware access]: JTAG/USB needs `--device` or host hacks.

- #strong[Network tools]: License managers fail in locked-down environments.

- #strong[Heavy tasks]: Linking/analysis/simulation may hit container memory/CPU limits.

Validate your containerized toolchain with a #strong[real project build] early --- don\'t
assume it works until you\'ve tested your actual workflow.

== Debugging in Containers: How to Cross the Host-Container Boundary
Building and simulation can run #strong[inside the container], but hardware flashing and
debugging #strong[must cross the container boundary] --- either by:

- #strong[Device passthrough] (preferred), or

- #strong[Host tools] (fallback).

If you build in the container and debug from the host, watch for these friction points:

- #strong[Paths]: Debugger looks for `/workspace` (container) but finds `/home/user/project` (host). #strong[Fix:] `-fdebug-prefix-map=/workspace=/home/user/project`.

- #strong[Artifacts]: Bind mounts cause permission hell. #strong[Use] `docker cp` instead.

- #strong[Toolchain/libraries]: Mismatching versions of toolchain and vendor libraries make low-level debugging unreliable. #strong[Ensure] #emph[identical toolchain versions] on host and container.

== CI for Embedded: Where Containers Shine (And Where They Don't)
Containerized CI is generally #strong[highly effective] for embedded development because
it aligns with container strengths: headless operation, isolation, and reproducibility.
Simple build-and-unit-test workflows work perfectly in containers. However, complexity
increases if your CI includes:

- #strong[Hardware-in-the-loop (HIL) testing] (requires USB/device passthrough)

- #strong[Automated flashing] (may need host tools or dedicated test rigs)

- #strong[Debug symbol generation] (ensure paths match between container and host)

For most teams, #strong[build-only CI containers] are the sweet spot --- keep
hardware-dependent testing on separate, specially configured machines.

= Rootless Containers: How to Debug Hardware Without Root (Safely)
Rootless containers are secure by default, but hardware debugging requires careful
device management. Here\'s how to make them work for embedded development.

== The Rootless Roadblock: 3 Hardware Access Hurdles
Many embedded teams default to rootful containers because embedded debugging requires:

- #strong[Hardware access] (USB devices, debug adapters via `/dev`)

- #strong[Network access] (for remote debugging/probing)

- #strong[Legacy tool support] (tools expecting direct host access)

Rootless containers #strong[block these by default] for security. Running as root (i.e.,
`docker --priviliged`) makes everything \"just work\" --- but sacrifices isolation that
matters even in development environments:

- #strong[CI/CD pipelines] where containers run untrusted code (e.g., third-party scripts)

- #strong[Shared development machines] where multiple engineers access the same host

- #strong[Protecting IP] by limiting access to host files and devices

- #strong[Preventing accidental damage] to host systems from misconfigured tools

#strong[The trade-off is clear:]

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Approach], [✅ Pros], [❌ Cons]),
    table.hline(),
    [Rootless], [Security-hardened, follows least-privilege], [Upfront setup (udev rules, permissions)],
    [Rootful], [Easy hardware access], [Reduced security isolaion],
  ),
  kind: table,
)

#blog-img(
  "Rootless_vs_Rootful.png",
  alt: "Balance scale showing rootless containers (secure, udev rules) vs. rootful (easy USB, risky), tilted toward rootless for most embedded use cases.",
)

== The Fix to Rootless Hardware Debugging
Nearly all embedded debugging scenarios can use rootless containers with proper
configuration --- and the setup is simpler than it appears.

When using a Linux host, #strong[all relevant hardware interfaces] expose device nodes.
Use `--device` to pass these #strong[without root]:

- Serial/UART: `/dev/ttyACM0`, `/dev/ttyUSB0`

- SPI/I2C: `/dev/spidevX.Y`, `/dev/i2c-X`

- USB debug probes: `/dev/bus/usb/XXX/YYY`

- GPIO (RPi): `/dev/gpiomem`

#strong[Requirements:]

+ User in correct group (`dialout`, `spi`, etc.).

+ Host drivers assign #strong[group-readable permissions] (default on most distros).

#strong[Rootful is Only Required for:]

- Custom hardware with non-standard drivers

- Strange tools that explicitly demand host OS access

== Why Rootless Wins: Security, Portability, and Fewer Surprises
It's not about restriction --- it's about #strong[explicit requirements]. The initial
setup (udev rules, `--device` flags) is a one-time investment that pays off in:

- #strong[Security:] Containers can't escalate privileges

- #strong[Reproducibility:] No hidden dependencies on root access

- #strong[Portability:] Works across different host configurations

Most teams can achieve #strong[90%+ rootless coverage] with just:

- ✅ Standard group memberships (`dialout`, `spi`, `i2c`)

- ✅ Selective device passthrough (`--device=/dev/ttyACM0`)

- ✅ Minimal udev rules for non-standard devices

= Slow Containers? 3 Fixes to Cut Bloat and Boost Speed
=== Why Your Container Feels Like a VM
=== Symptom: \>2-second startup time.
#strong[Root cause:] Treating containers as #strong[mini-VMs] instead of
#strong[ephemeral tool wrappers].

#callout[
  💡 #strong[The Ephemeral Rule]

  If your container takes \>2 seconds to start, it's #strong[doing too much at runtime].
]

== Fix \#1: Shrink Your Image with Smarter Docker Layers
#strong[How Docker Filesystem Layers Work (And Why They Slow You Down):]

- Each `RUN`/`COPY` = #strong[new read-only layer].

- Modify a file? #strong[Copy-on-Write (CoW) duplicates it] to the top layer.

- #strong[Result:] More layers = slower builds + bloated images

#callout[
  ⚠️ #strong[CI Pain Point]

  Large images → slow pulls → #strong[wasted CI minutes].
]

#strong[Key optimization principles:]

- ✅ #strong[Disable package caching if possible]

  ```dockerfile
  # For pip
  RUN pip install --no-cache-dir package
  ```

- ✅ #strong[Clean up in the same layer where files are created]

  ```dockerfile
  # ❌ Anti-pattern: 3 layers, bloated cache
  RUN apt-get update
  RUN apt-get install -y package
  RUN rm -rf /var/lib/apt/lists/*

  # Good: Single layer with cleanup
  RUN apt-get update && \
      apt-get install -y package && \
      rm -rf /var/lib/apt/lists/*
  ```

- ✅ #strong[Install only what you need]

  ```dockerfile
  # Bad: Pulls in hundreds of unnecessary packages
  FROM ubuntu:latest
  RUN apt-get update && apt-get install -y build-essential

  # Good: Only install required toolchain components
  FROM ubuntu:latest
  RUN apt-get update && apt-get install -y \
      gcc-arm-none-eabi \
      binutils-arm-none-eabi \
      && rm -rf /var/lib/apt/lists/*
  ```

- ✅ #strong[Use multi-stage builds to discard intermediate layers]

  ```dockerfile
  # Stage 1: Build a custom tool
  FROM ubuntu:latest as builder
  RUN apt-get update && apt-get install -y \
      build-essential \
      cmake
  WORKDIR /mytool
  COPY mytool .
  RUN mkdir build && cd build && \
      cmake -DCMAKE_BUILD_TYPE=Release .. && \
      cmake --build .

  # Stage 2: Minimal runtime environment
  FROM debian:stable-slim
  COPY --from=builder /mytool/build/output /opt/mytool
  ```

== Fix \#2: Stop Wasting Time on Heavy Init Scripts
#strong[The Problem:] Custom initialization scripts (like `postCreateCommands` in Dev
Containers or custom entrypoint scripts) are often misused for heavy setup tasks that
should happen at #strong[build time], not runtime.

#strong[Why This Matters:]

- Containers should start #strong[instantly] --- heavy init scripts slow down debugging cycles.

- Builds and dependency installation belong in the #strong[image], not the runtime container.

- #strong[Ephemeral containers] should be disposable --- avoid storing state in them.

#strong[What Belongs in Init Scripts:]

- ✅ Lightweight configuration (e.g., setting environment variables)

- ✅ Mounting volumes or binding ports

- ✅ Starting services required for debugging (e.g., `gdbserver`)

#strong[What Does NOT Belong in Init Scripts:]

- ❌ Installing packages (`apt-get install`)

- ❌ Running builds (`make`, `cmake`)

- ❌ Filling build caches (use #strong[host-mounted caches] instead)

- ❌ Downloading dependencies (do this in the `Dockerfile`)

#strong[Best Practices:]

- #strong[Do heavy setup in the] `Dockerfile` (e.g., toolchain installation).

- #strong[Use init scripts only for runtime adjustments] (e.g., setting up debug probes).

- #strong[For build caching], use a named volume (#emph[see later]) or mount a host directory (e.g., `-v /mnt/shared/ccache:/root/.ccache` for a shared build cache) instead of a local cache in the container.

== Fix \#3: Pick the Right Base Image
#strong[Image Comparison:]

#figure(
  table(
    columns: 5,
    align: (auto, auto, auto, auto, auto),
    table.header([Base Image], [Size], [Best For], [Avoid For], [Notes]),
    table.hline(),
    [ubuntu:latest],
    [\~30MB],
    [Full toolchain support],
    [Minimal environments],
    [Full-featured OS, includes init/systemd],
    [debian:stable-slim], [\~30MB], [General embedded development], [None], [“Slimified” Debian, glibc-based],
    [alpine:latest],
    [\~10MB],
    [Minimal builds (static toolchains)],
    [Glibc-dependent tools],
    [Ultra-lightweight, uses musl libc + BusyBox],
    [gcr.io/distroless/base],
    [\~1-2MB],
    [CI steps, single-command tasks],
    [Interactive build and debugging],
    [Minimal, no shell, no package manager],
  ),
  kind: table,
)

#strong[Choosing the Right Base:]

- `debian:stable-slim` is the best default for most embedded toolchains --- it's #strong[small but fully functional] (glibc, standard tools).

- `alpine:latest` is ideal if you need #strong[minimal size] and can work with #strong[musl libc + BusyBox] (some toolchains may require adjustment).

- #link("http://gcr.io/distroless/base")[`gcr.io/distroless/base`] is the smallest option but #strong[lacks a shell] --- best for #strong[CI build steps] or #strong[dedicated flasher containers] where no interactive environment is needed.

- #strong[Avoid] `ubuntu:latest` unless you specifically need its package ecosystem --- it's #strong[heavier, slower, and less stable] than Debian, with no real benefits.

#strong[Example Embedded Toolchain:]

```dockerfile
# Good balance for embedded work
FROM debian:stable-slim
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc-arm-none-eabi \
    openocd \
    && rm -rf /var/lib/apt/lists/*
```

#horizontalrule

Treat your development container like a precision tool --- include only what you need, set
everything up at build time, and keep it as lightweight as possible. The goal isn\'t to
create a full OS environment, but to wrap your toolchain with just enough OS to make it
work.

= Bind Mounts: The Hidden Landmine in Embedded Containers
Binding host directories into containers feels convenient… and also create hidden
dependencies that break portability.

== How Bind Mounts Break Your Container
#strong[Bind mounts] (`-v /host/path:/container/path`) #strong[are the silent killer of portable embedded containers.] They seem convenient but introduce:

- #strong[Path dependencies] (e.g., `/opt/arm-toolchain` missing on CI).

- #strong[Permission landmines] (UID/GID mismatches).

- #strong[State leakage] (host tool updates breaking containers).

- #strong[Security risks] (accidentally exposing host files to containers).

== Better Approaches
#figure(
  table(
    columns: 4,
    align: (auto, auto, auto, auto),
    table.header([Solution], [When to Use], [Example], [Why It Works]),
    table.hline(),
    [#strong[Build-time injection]],
    [Static tools, configs, or libraries],
    [`COPY config.json /root/config.json`],
    [#strong[Self-contained]: No host dependencies.],
    [#strong[Multi-stage builds]],
    [Custom toolchains or generated artifacts],
    [`COPY --from=builder /opt/arm-gcc /opt/arm-gcc`],
    [#strong[Isolated]: Discards intermediate layers.],
    [#strong[Device passthrough]],
    [Hardware access (JTAG, UART, USB)],
    [`--device=/dev/ttyACM0`],
    [#strong[Secure]: No filesystem exposure.],
    [#strong[Named volumes]],
    [Persistent data (build caches, logs)],
    [`docker volume create ccache`],
    [#strong[Portable]: Managed by Docker.],
  ),
  kind: table,
)

#horizontalrule

#callout[
  💡 #strong[The Only Safe Bind Mounts]

  ✅ #strong[Devices]: `-v /dev/bus/usb:/dev/bus/usb` (when `--device` doesn't work)

  ✅ #strong[Source code]: `-v $(pwd):/workspace` (consider cloning #emph[inside] container, avoid Windows/WSL paths because of permission/performance issues)

  ❌ #strong[Everything else]: Use `COPY` or named volumes.
]

= Future-Proofing: How to Pin Toolchains, Images, and Host Dependencies
=== The `:latest` Trap
#strong[Problem:] Floating tags (`:latest`, `ubuntu:rolling`) #strong[guarantee future breakage] when:

- `gcc-arm-none-eabi:latest` pushes a breaking change.

- A base image security patch #strong[drops your toolchain's glibc version].

- Vendors #strong[delete old toolchain versions].

== Fix \#1: Archive Everything (Before It Disappears)
For embedded development --- where toolchains, debuggers, and custom scripts must work
together --- #strong[building your own image from a minimal Linux distribution is the safest choice].

=== How to Do It Right:
- Start from a #strong[pinned base image] (e.g., `alpine:3.18.4`, `debian:11-slim`).

- Install #strong[version-pinned packages] (e.g., `arm-none-eabi-gcc=12.2.1_r4`).

- #strong[Archive vendor toolchains] (e.g., STM32CubeIDE, IAR, Keil installers) in your project repo.

- Store the final image in a #strong[private registry] or as a `.tar` archive.

#strong[Example Dockerfile:]

```dockerfile
FROM alpine:3.18.4

# Install pinned versions of tools
RUN apk add --no-cache \
    arm-none-eabi-gcc=12.2.1_r4 \
    openocd=0.12.0-r0 \
    make=4.4.1-r0

# Copy archived vendor tools (e.g., STM32CubeProgrammer)
COPY stm32cubeprg-linux /opt/stm32cubeprg
ENV PATH="$PATH:/opt/stm32cubeprg"
```

#strong[Critical Step:] Once built, #strong[save the image permanently] to avoid future
rebuilds:

```bash
docker save -o my-embedded-env.1.0.tar my-embedded-env:1.0
```

#emph[Store this archive with your project. Now you can load it anytime, even if upstream sources vanish.]

== Fix \#2: Nix for “Set It and Forget It” Reproducibility
If you need #strong[guaranteed reproducibility] over years (or decades), consider
#strong[Nix/Nixpkgs]:

- Declaratively defines #strong[every dependency], including exact versions.

- Produces #strong[bit-identical environments] regardless of when or where you build.

- No reliance on external registries or package repos after the first build.

#callout[
  #strong[💡 Nix for the Long Haul]

  If your project spans #strong[years], Nix's declarative dependency locking is worth the
  learning curve:

  ```nix
  { pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    buildInputs = [
      (pkgs.gcc-arm-embedded.overrideAttrs (old: { version = "10-2021-q4-major"; }))
    ];
  }
  ```

  #emph[Trade-off:] Steep learning curve, but #strong[bit-identical rebuilds in 2035.]
]

#horizontalrule

#strong[Dependency Mitigation Strategies]

#figure(
  table(
    columns: 4,
    align: (auto, auto, auto, auto),
    table.header([Strategy], [Effort], [Reliability], [When to Use]),
    table.hline(),
    [Pin versions], [Low], [Medium], [Quick wins for most projects],
    [Archive images], [Medium], [High], [Long-term projects],
    [Use Nix], [High], [Very High], [Mission-critical and decade-long support],
  ),
  kind: table,
)

#strong[But there\'s a catch:] Even with perfect containerized dependencies, embedded development has one #strong[unavoidable external dependency] --- the host system.

== Document Host Dependencies (Or Regret It Later)
#strong[Here's the uncomfortable truth:] No matter how well you containerize your toolchain, you still depend on the host for:

- #strong[Debug hardware drivers]: You can't reach your target system if the host doesn't recognize your JTAG/SWD probe.

- #strong[Device access]: `--device` passthrough fails if the host can't find or expose the device file.

- #strong[Kernel quirks]: Ever had a USB device just #emph[refuse] to work on a new machine?

#strong[The fix?]

- #strong[Create a] `HOST_SETUP.md` listing #emph[exactly] what's needed:

  - Drivers (e.g., #link("http://stlink-drivers.zip")[`stlink-drivers.zip`])

  - Kernel modules (e.g., `ftdi_sio`, `cdc_acm`)

  - Udev rules for device access and stable device paths

- #strong[Document your host OS baseline] (distro + kernel version) --- future-you will thank you.

- #strong[Archive driver packages] in your repo (vendors #emph[will] delete old versions).

Think like this: #emph[\"Your container is only as portable as its host setup instructions.\"]

= Containerize Like You Mean It
#strong[Containerized embedded development isn't about convenience --- it's about #emph[controlled] chaos.]

#strong[The 2-Command Test]

Your containerized workflow should require #strong[only two commands] to build and flash
(after documented host setup):

#blog-img(
  "The_2_Command_Test-Carbon.png",
  alt: "Mock terminal illustrating the '2-Command Test' for a well-configured embedded container: two commands (build and flash) are all that should be needed. Success output indicates no hidden dependencies or manual host setup.",
)

#strong[If it needs more?] You've got #strong[hidden host dependencies] --- and they
#emph[will] cause pain later.

#callout[
  ✅ #strong[The Golden Rules]

  + #strong[Pin everything] (base images, toolchains, drivers).

  + #strong[Self-contain] (no bind mounts except `/dev`).

  + #strong[Archive the image]: `docker save my-env:1.0 > my-env.1.0.tar`.

  + #strong[Document host setup] (drivers, udev rules, kernel version).
]

Containers won't eliminate embedded complexity --- but they #emph[can] #strong[tame it.]

#strong[How to succeed?]

Iterate like you would with firmware:

#emph[\"Start small. Fix one thing. Repeat.\"]

#horizontalrule

#strong[👉 Ready for Part 4?] \
#link("https://davidjuhasz.dev/blog/containerized-embedded-development-tools")[Containerized Embedded Development: The Right Tools for Reproducible Workflows]
