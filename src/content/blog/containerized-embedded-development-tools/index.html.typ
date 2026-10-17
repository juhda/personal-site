#let (blog-img, callout, horizontalrule) = eval(read("../_preamble.typ"), mode: "code")

#emph[Missed Part 3 of the “]#link("https://davidjuhasz.dev/blog/series/containerized-embedded-dev")[#emph[Practical Embedded Development, Containerized]]#emph[” series? Read about]
#link("https://davidjuhasz.dev/blog/containerized-embedded-development-pitfalls-patterns")[#strong[Bridging the Three Worlds in Containerized Embedded Develoment]] #emph[first.]

#strong[You're sold on containerizing embedded development] --- but the wrong tools mean fighting #strong[daemon overhead], #strong[security risks], or #strong[cloud development environments] that can't reach your #strong[JTAG debugger] or #strong[USB hardware]. As this series has shown, containers eliminate #strong[\"works on my machine\"] problems by packaging #strong[toolchains] and #strong[debugger setups] into #strong[reproducible, portable environments].

Now it's time to #strong[pick the right tools] for #strong[containerized embedded workflows]. This guide covers:

- ✅ #strong[Podman vs. Docker]: Why Podman's #strong[daemonless design] wins for #strong[security and performance] --- and where Docker's #strong[polished UI and multi-platform builds] still excel.

- ✅ #strong[VSCode DevContainers]: How the #strong[open DevContainer Spec] turns containers into #strong[standardized IDEs] --- with #strong[direct hardware access].

- ✅ #strong[GitHub Codespaces]: When #strong[cloud development environments] work (and where they #strong[fail] for #strong[embedded development]).

- ✅ #strong[Other Tools]: Beyond Docker/Podman for #strong[legacy toolchains], #strong[on-premises CI with hardware access], and #strong[Kubernetes-native workflows].

#emph[No vendor lock-in. No hand-wavy advice. Just] #emph[#strong[industry-standard tools]] #emph[for] #emph[#strong[embedded engineers]].

= OCI and DevContainer Standards: The Foundation
Before comparing tools, let's ground ourselves in the standards that make them
interchangeable. These aren't theoretical --- they're what let you #strong[build once, run anywhere], without rewriting configs when tools evolve.

== OCI Standard: The USB of Containers
The #link("https://opencontainers.org/")[#strong[Open Container Initiative (OCI)]]
standardizes #emph[containers]. Just as USB lets any device plug into any
computer --- regardless of brand or OS --- OCI ensures any container runs on any compliant
tool (Podman, Docker, Kubernetes, etc.). It defines three critical specs:

- #link("https://github.com/opencontainers/runtime-spec")[#strong[Runtime Spec]]#strong[:] How containers execute: process isolation, filesystem bundles --- the “connector shape”.

- #link("https://github.com/opencontainers/image-spec")[#strong[Image Spec]]#strong[:] How images are structured, built, and shared --- the “data transfer protocol”.

- #link("https://github.com/opencontainers/distribution-spec/")[#strong[Distribution Spec]]#strong[:] How container images are stored and pulled from registries --- the #emph[\"USB hub\".]

#strong[Why it matters for embedded:]

- #strong[Tool agnosticism:] Build with Podman, debug with Docker, deploy with Kubernetes --- #strong[same image, zero changes].

- #strong[Future-proofing:] Your 2020 `Dockerfile` still works today (like USB 2.0 in a USB-C port with an adapter).

- #strong[Ecosystem leverage:] CI systems, registries, and orchestrators all “speak OCI”.

#emph[Example:] A Podman-built image runs unchanged in Docker, `containerd`, or AWS ECS.

== DevContainer Spec: IKEA Instructions for Your Dev Environment
While OCI standardizes #emph[containers], the
#link("https://containers.dev/")[#strong[DevContainer Specification]] standardizes
#emph[development environments.] Just as IKEA's flat-pack designs let you assemble the
same bookshelf in any home, this spec lets you #strong[replicate a full workspace]
(toolchain, debuggers, IDE settings) from a single `devcontainer.json` file.

#strong[Key Components:]

- #link("https://containers.dev/implementors/spec/")[#strong[Configuration format]] (`.devcontainer.json`): Blueprint for base image, runtime args, extensions, and hardware access.

- #link("https://containers.dev/features")[#strong[Features]]#strong[:] Modular components (e.g., `common-utils`, `docker-in-docker`) to avoid reinventing setups.

#strong[Why it matters for teams:]

- #strong[Shareable configs:] One file (`devcontainer.json`) replicates your entire environment.

- #strong[IDE-agnostic:] Officially supported by VSCode and GitHub Codespaces; adopted by other IDEs (e.g., JetBrains IDEs, Eclipse).

- #strong[Hardware-aware:] USB/JTAG passthrough works if your host OS permits it.

#emph[Example:] Minimal embedded setup with a custom Dockerfile control:

```json
{
  "name": "Custom Embedded DevContainer",
  "build": {
    "dockerfile": "./Dockerfile"
  },
  "runArgs": ["--device=/dev/ttyACM0"],
  "customizations": {
    "vscode": {
      "extensions": ["ms-vscode.cpptools"]
    }
  }
}
```

#horizontalrule

Standards turn containers from #strong[\"works on my machine\"] to #strong[\"works on #emph[every] machine\"] --- with no lock-in.

These #strong[standards] enable an entire ecosystem. Here's how the pieces fit together:

#blog-img(
  "Container_Tooling.png",
  alt: "A layered diagram showing the DevContainer ecosystem. At the top, “DevContainer Platforms” includes VSCode DevContainers and GitHub Codespaces. Below that, “Container Engines” lists Docker, Podman, and nerdctl. Next, “Container Runtimes” shows containerd slightly above runc and crun. At the bottom, “Open Standards” includes the OCI Image and Runtime specs and the DevContainer Specification. On the right side, an “Advanced/Alternative Tooling” column lists DevContainer-capable IDEs, CI and orchestration tools like Kubernetes, Helm, and GitHub Actions, and additional runtimes and tooling such as lilipod, youki, and distrobox.",
)

= Podman vs. Docker: Architectural Trade-offs
#strong[Both] #link("https://podman.io/")[#strong[Podman]] #strong[and]
#link("https://www.docker.com/")[#strong[Docker]] #strong[implement]
#link("https://opencontainers.org/")[#strong[OCI standards]], but their
#strong[underlying designs] create key differences:

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Criteria], [Podman], [Docker]),
    table.hline(),
    [#strong[Security]], [✅ Rootless default], [⚠️ Rootless optional],
    [#strong[Performance]], [✅ Daemonless (lower overhead)], [❌ Daemon overhead],
    [#strong[Ease of Setup]], [⚠️ VM required on Mac/Windows], [✅ Native desktop app],
    [#strong[OCI Compliance]], [✅ Full (community-driven)], [✅ Full (reference implementation)],
  ),
  kind: table,
)

== Podman's Strength
#link("https://docs.podman.io/en/latest/")[#strong[Daemonless architecture]] means no
persistent `dockerd` process to manage or debug. This translates to:

- Faster container startup times

- Cleaner resource isolation

- No single point of failure behind containers

#strong[Security-first design] with rootless operation by default. For embedded work
involving proprietary toolchains and hardware access, this reduces:

- Attack surface area

- Compliance risks in regulated environments

#strong[Fully open-source] implementation gives full auditability.

== Docker\'s Strengths
#strong[Polished user experience] through
#link("https://www.docker.com/products/docker-desktop/")[Docker Desktop]:

- Intuitive GUI for container management

- Built-in dashboard for monitoring resources

- Easier onboarding for teams new to containers

#strong[Mature ecosystem] with:

- `buildx` for well-documented #link("https://docs.docker.com/build/building/multi-platform/")[multi-platform builds]

- Extensive #link("https://docs.docker.com/engine/extend/legacy_plugins/")[plugin support] (volume drivers, logging, etc.)

== ⚠️ Podman's VM Layer on Mac/Windows
- Set VM resources upfront:

  ```bash
  podman machine set --cpus=4 --memory=4096 --disk-size=20
  ```

- USB/JTAG passthrough:

  - macOS: Manual attachment needed.

  - Windows: USB/IP forwarding needed, which may add latency.

  - #emph[Test early] --- some debuggers misbehave through the VM.

== The Bottom Line
Choose #strong[Podman] if you prioritize:

- ✅ Security and compliance

- ✅ Kubernetes-aligned architecture

- ✅ Linux-native workflows (best experience)

- ✅ Open-source purity

Choose #strong[Docker] if you need:

- ✅ Easiest team onboarding

- ✅ Multi-platform build maturity

- ✅ Windows compatibility (native device access)

- ✅ Proprietary tooling integrations

#emph[For most embedded teams --- especially on Linux --- Podman\'s advantages outweigh Docker\'s convenience.] However, #strong[Windows users] may prefer Docker for native
device access.

#horizontalrule

But selecting a runtime is only half the battle. The real challenge? #strong[Ensuring every engineer --- from the CI pipeline to the hardware bench --- uses the same environment, with the same tools, and the same access to devices.] That's where
#link("https://code.visualstudio.com/docs/devcontainers/containers")[#strong[VSCode DevContainers]] bridges the gap: turning containers into #strong[reproducible workspaces] that travel with your project.

= VSCode DevContainers: IDE as Code
#link("https://code.visualstudio.com/docs/devcontainers/containers")[#strong[VSCode DevContainers]] turn containers into #strong[reproducible workspaces] by encoding your
environment --- IDE settings, extensions, and hardware access --- in version-controlled
configs. The only setup required: cloning the repo.

== Why It's a Game-Changer
+ #strong[Vendor-Neutral Foundation] \
  It works identically across systems via the open #link("https://containers.dev/implementors/spec/")[#strong[DevContainer Specification]]#strong[.]

+ #strong[IDE as Code] \
  Your `.devcontainer/devcontainer.json` defines:

  - Toolchain versions (compilers, debuggers)

  - IDE extensions (C/C++ tools, Cortex-Debug)

  - Runtime arguments (device passthrough, privileges)

+ #strong[Hardware-Awareness] \
  Devices expose to the container via your host's Docker/Podman. You configure all hardware access in `devcontainer.json` just as you would for a standalone container.

#emph[Example config:]

```json
{
  "image": "ghcr.io/your-org/embedded-dev:latest",
  "runArgs": ["--device=/dev/ttyUSB0"],  // Direct USB access
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-vscode.cpptools"            // C/C++ support
      ],
      "settings": {
        "terminal.integrated.shell.linux": "/usr/bin/bash"
      }
    }
  },
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {}  // git, curl, etc.
  }
}
```

== Setup Steps for VSCode DevContainers
- #strong[Setup requirement]: Install the #link("https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers")[VSCode DevContainers extension]. It works with Docker out-of-the-box; for Podman, configure the Docker executable path in VSCode settings to point to `podman`.

- #strong[Workflow]: When opening a project with DevContainers configured, use the `DevContainers: Reopen in Container` command to start the containerized environment.

- #strong[User experience]: Once running in a container, VSCode behaves identically to local development or remote SSH --- just with your environment fully containerized.

#horizontalrule

DevContainers solve local standardization --- but what about the cloud?

= GitHub Codespaces: Cloud Portability (With Limits)
#link("https://docs.github.com/en/codespaces/quickstart")[GitHub Codespaces] extends
DevContainers to the cloud, offering #strong[browser-accessible environments] --- ideal
for collaboration but #strong[useless for hardware debugging.]

== The Embedded Limitation
❌ #strong[No hardware access].

Codespaces runs in a #strong[remote VM without local device connectivity]. This means
that your embedded hardware (JTAG debuggers, USB devices, serial ports) remains
#strong[completely unavailable]. Use Codespaces #strong[only for cloud-native tasks]
(e.g., code reviews, documentation, build testing).

== Where It Excels
#strong[✅ Cloud-native tasks]: Spin up identical environments for code reviews,
documentation, building, and simulation.

#strong[✅ Online collaboration]: Shared environments for pair programming or onboarding.

#strong[✅Zero local setup]: Develop from any machine with just a browser (or
#link("https://code.visualstudio.com/docs/remote/codespaces")[VSCode desktop]).

#strong[✅ Preconfigured environments]: Uses the same `devcontainer.json` as local
DevContainers.

== Availability & Usage
- #strong[Free for personal accounts] (with usage limits) on GitHub-hosted repositories.

- #strong[Enterprise/managed accounts] require paid access.

- #emph[Best practice]: Reserve Codespaces for #strong[occasional online collaboration] or #strong[development on the go] (when hardware debugging isn't needed). Combined with #link("https://docs.github.com/en/actions")[GitHub Actions], it's ideal for #strong[CI-based build testing and simulations].

#horizontalrule

#emph[Choosing between local and cloud DevContainers?] Here's how they stack up for
#strong[embedded development]:

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Feature], [VSCode DevContainers], [GitHub Codespaces]),
    table.hline(),
    [#strong[Hardware Access]], [✅ Full (USB/JTAG/serial passthrough)], [❌ #strong[None] (remote VM restriction)],
    [#strong[Configuration]],
    [✅ #strong[Same] `.devcontainer.json` (local execution)],
    [✅ #strong[Same] `.devcontainer.json` (cloud execution)],
    [#strong[Portability]],
    [✅ #strong[Run anywhere] (local machine, teammate's laptop)],
    [✅ #strong[Run anywhere with internet] (but #strong[no local hardware])],
    [#strong[OS Support]], [✅ Cross-platform (Win/macOS/Linux)], [✅ Any browser],
    [#strong[IDE Integration]], [✅ Native (VSCode + extensions)], [✅ Full (VSCode in browser)],
    [#strong[Performance]], [✅ Near-native (container overhead)], [⚠️ Cloud latency],
    [#strong[Security]], [✅ Isolated (local rootless containers)], [⚠️ Cloud VM (org trust required)],
    [#strong[Cost]], [Free (local)], [Free (limited) / Paid],
    [#strong[Collaboration]],
    [⚠️ Local-only (share via Git)],
    [✅ Built-in (#link("https://docs.github.com/en/codespaces/developing-in-a-codespace/working-collaboratively-in-a-codespace")[live shared envs])],
    [#strong[Use Case]],
    [#strong[Best for]: Daily development, hardware debugging, team onboarding],
    [#strong[Best for]: #strong[cloud-only tasks] (e.g., PR reviews, docs, CI build testing)],
  ),
  kind: table,
)

= The Broader Ecosystem
While Docker/Podman + DevContainers cover most use cases, the container ecosystem is
much broader and offers tools that you might encounter.

== Container Runtimes
Container Engines as Docker and Podman #strong[rely on Container Runtimes like]
#link("https://containerd.io/")[`containerd`] (or directly on `runc`/`crun`) under the
hood. You can use `containerd` directly for #strong[minimal overhead], but expect
#strong[no dev-friendly features] --- it's a plumbing layer, not a replacement.
#link("https://github.com/containerd/nerdctl")[`nerdctl`] is a Docker-like CLI for
`containerd`, useful if you're in a Kubernetes environment and miss `docker build`.

For #strong[experimental setups],
#link("https://github.com/89luca89/lilipod")[#strong[lilipod]] (a minimal and limited
container runtime in Rust) and
#link("https://github.com/youki-dev/youki")[#strong[youki]] (an OCI runtime also in
Rust) offer #strong[lighter-weight options], but neither is production-ready for
embedded work yet.

== Alternative Environment
#link("https://distrobox.it/")[#strong[distrobox]] lets you run #strong[full Linux distributions] (e.g., Ubuntu 18.04) as containers --- ideal for #strong[legacy toolchains]
or proprietary EDA tools without VMs.

== DevContainers in Other IDEs
The DevContainer Spec isn't VSCode-exclusive.
#link("https://www.jetbrains.com/ides/")[#strong[JetBrains IDEs]] and
#link("https://learn.microsoft.com/en-us/visualstudio/containers/overview?view=visualstudio")[#strong[Visual Studio]] support it officially. #link("https://codesandbox.io/")[#strong[CodeSandbox]]
provides a cloud development environment similar to GitHub Codespaces.

#link("https://devfile.io/")[#strong[Devfiles]] is a vendor-neutral #strong[alternative]
to DevContainers. Reproducible environments are defined in a `devfile.yaml`, which is
optimized for #strong[cloud/remote workspaces] and supported by
#link("https://eclipse.dev/che/")[#strong[Eclipse Che]] and
#link("https://developers.redhat.com/products/openshift-dev-spaces")[#strong[OpenShift DevSpaces]]. Devfiles are less mature for embedded work due to limited hardware
passthrough. #emph[Worth monitoring] if you're in a #strong[Kubernetes-heavy ecosystem].

== CI with Hardware
For #strong[on-premises CI with JTAG/USB access], use:

- #link("https://kubernetes.io/")[#strong[Kubernetes]] #strong[\+] #link("https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/device-plugins/")[#strong[device plugins]] (complex but powerful).

- #link("https://docs.github.com/en/actions")[#strong[GitHub Actions]] #strong[\+] #link("https://docs.github.com/en/actions/concepts/runners/self-hosted-runners")[#strong[self-hosted runners]] (simpler, if your runners have USB passthrough).

- #link("https://helm.sh/")[#strong[Helm]] to package/deploy containerized toolchains to your own infrastructure.

= Further Reading & Experiments
To go deeper, here are #strong[practical resources] for containerized embedded
development:

== Bookmark Suggestions
#strong[Podman:]

- #link(
    "https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md",
  )[Podman Rootless Guide] #emph[Critical for security-compliant embedded development.]

#strong[DevContainers Community:]

- #link(
    "https://containers.dev/implementors/spec/",
  )[DevContainer Specification] #emph[The \"IKEA instructions\" for your development environment --- study this before customizing.]

- #link(
    "https://github.com/devcontainers/templates",
  )[Official DevContainer Templates] #emph[Prebuilt configurations for common languages/tools.]

- #link(
    "https://github.com/devcontainers",
  )[Official DevContainer Resources] #emph[All repositories from the DevContainer Community.]

#strong[Embedded-Specific DevContainers:]

- #link(
    "https://github.com/embeddedcontainers",
  )[Embedded Container Resources] #emph[A curated collection of embedded-specific DevContainers.]

- #link(
    "https://github.com/islandcontroller/armcm-devcontainer",
  )[ARM Cortex-M DevContainer] #emph[A DevContainer for developing and debugging on ARM Cortex-M.]

- #link(
    "https://github.com/philips-software/amp-devcontainer",
  )[Philips AMP DevContainer] #emph[DevContainers for embedded C++ and Rust development.]

== Experiments to Try
+ #strong[Legacy Toolchain]: Containerize #strong[GCC 5.4] in `distrobox` to replace a VM

+ #strong[Debugger Test]: Compare #strong[Podman vs. Docker] with your JTAG debugger.

+ #strong[CI Pipeline]: Use #strong[GitHub Actions + Codespaces] to test builds #emph[without] hardware, and then with a #strong[self-hosted runner] with USB passthrough.

#horizontalrule

The container ecosystem is #strong[ready for embedded work today]. Start with
Docker/Podman + DevContainers, then explore advanced tools as needed. The frontier?
#strong[Standardizing hardware access] across runtimes and clouds.
