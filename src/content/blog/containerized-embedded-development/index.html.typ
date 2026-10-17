#let (blog-img, callout, horizontalrule) = eval(read("../_preamble.typ"), mode: "code")

Every embedded development team has one: the laptop where everything still works. It has
the correct SDK, the toolchain is in precisely the right location, and firmware builds
without error. No one is entirely sure why. People copy from it, avoid changing anything
on it, and rely on it far more than they should.

But the “golden laptop” is not sustainable --- especially as embedded environments become
more complex, varied, and harder to reproduce.

If you're leading a team or managing multiple hardware targets, you have likely
experienced the frustration of inconsistent development environments. A new colleague
joins and spends days trying to build the project. Someone upgrades their operating
system and the toolchain silently stops working. Switching between hardware variants or
firmware versions requires environment changes that are had to undo. Your development
setup cannot accommodate both without being reconfigured --- or completely broken.

These issues are common in embedded workflows --- but they are not inevitable.

#horizontalrule

I ran into these same problems while working on embedded systems. Containerization first
caught my eye as a way to add automated testing to embedded workflows. I soon discovered
that containerized environments can offer consistency, speed, and predictability. I also
saw how effective this approach is in cloud-based development. The difference was
immediate. Reproducibility, onboarding, and switching between setups all became
predictable and manageable. Since then, I\'ve been applying these ideas to embedded
development, learning about the benefits and understanding the limitations.

In this post, you will see how containerization can help you build cleaner, more
reliable development environments for embedded work. It is not a silver bullet, but it
is a powerful tool --- one that can support automation, improve team workflows, and, in
some cases, assist with compliance in regulated domains. Most importantly, it offers a
path away from fragile setups and toward development environments that are consistent by
design.

= “It Works on My Machine” --- Until It Doesn't
In embedded development, the environment you work in --- your toolchain, SDKs, drivers,
and supporting tools --- is rarely managed as a whole. Instead, it evolves over time
through patches, tweaks, and undocumented installations. It might work for you today,
but it's hard to replicate, share, or reset with confidence.

When you add multiple hardware variants, firmware versions, or team members into the
mix, this fragility compounds. One setup needs GCC 9.3, another requires 10.2. Your JTAG
tool works on Linux, but a teammate is on Windows and needs a vendor-specific driver.
Reconfiguring your environment for one target often breaks another. It is not just
inconvenient --- it becomes a bottleneck to progress.

Even well-documented setup scripts and pinned versions can't keep up with the
complexity. Over time, they drift, get bypassed, or only work on the machines of the
people who wrote them.

The result is a kind of accidental infrastructure, where your development environment is
an undocumented system that “just about works,” if you are careful not to touch it.

#blog-img("Golden_Laptop_vs_Containerzied_Setup.png", alt: "From Fragile Setups to Portable Environments")

This is where containerization becomes relevant. By isolating each environment into a
self-contained, declaratively defined unit, you reduce complexity and risk. You no
longer need to align your system to the project --- instead, the project brings its own
environment with it.

= What Containers Solve in Embedded Development
At its core, a container is a lightweight, isolated environment. It includes just enough
of an operating system to run the tools you need, configured specifically for your
project. Containers are defined using a file --- typically a
#link("https://docs.docker.com/reference/dockerfile/")[`Dockerfile`] --- that lists which
packages, versions, and configurations to include. While Docker is a common choice,
alternatives like #link("https://podman.io/")[Podman] or other
#link("https://opencontainers.org/")[OCI]-compliant runtimes can be used with the same
underlying format.

This gives you a structured, version-controlled description of your development
environment. You no longer need to install tools globally, adjust paths manually, or
worry about which version of GCC, Python, or make is installed on the host machine. A
container might include, for example, GCC 10.3, CMake, OpenOCD, and a vendor SDK --- all
configured exactly as your project needs. Everything is set up in a consistent,
automated way --- ready to launch on demand.

For embedded development, this helps solve several persistent problems:

- #strong[Onboarding is faster]. New team members can clone the repository, launch the container, and start building without additional setup. IDE integrations, such as #link("https://code.visualstudio.com/docs/devcontainers/containers")[Visual Studio Code\'s Dev Containers], further streamline this by letting developers use a familiar editor while working inside the container.

- #strong[Consistency improves]. You can define and pin specific versions of tools, SDKs, and compilers, reducing the risk of “it works on my machine” failures.

- #strong[Automation is easier]. The same container can run locally and in CI pipelines, aligning your development and testing environments.

- #strong[Compliance is more practical]. In regulated domains, where fixed toolchains and verifiable build environments are required, containers provide a documented and inspectable basis for each release.

Containers represent a substantial improvement over traditional development setups.
Compared to manual installation, shared scripts, or even VMs, containers offer more
precision, less overhead, and better integration with modern development workflows.
Unlike virtual machines, containers start quickly, consume fewer resources, and are
easier to version and distribute.

They also offer a consistent path from development to automation --- and even to release.
Whether you\'re building locally, testing in CI, or delivering a toolchain to others,
containers give you a single environment to carry through the entire process. Once
defined, that environment behaves the same on any compatible host --- whether it's a
teammate's laptop, a CI runner, or a shared development server --- reducing host-specific
surprises and failures.

Containers do not eliminate every problem --- especially when it comes to long-term
reproducibility --- but they shift the development environment from something fragile and
improvised to something defined, repeatable, and far easier to work with as part of a
modern embedded workflow.

= Embedded Workflows: Where Containers Shine
Embedded development environments are particularly sensitive to inconsistencies.
Toolchains are often specific to chip families. SDKs come bundled with tightly versioned
build tools. Proprietary flashing utilities may only work on certain platforms or
require specific drivers. These dependencies don't just vary between projects --- they
often vary between hardware revisions or firmware branches within the same project.

This is where containers become especially valuable. Instead of one global setup that
tries to support everything, build #strong[isolated environments per target or configuration]. For example, each container can be tailored to a specific setup:

- An older ARM GCC version with a vendor SDK for a legacy board;

- A newer hardware variant using a different toolchain or build system;

- Firmware debugging setup with platform-specific drivers or flashing tools.

Switching containers avoids polluting or breaking your system-wide environment.

This approach also helps prevent toolchain drift across teams. When every developer uses
the same container image to build and flash firmware, you eliminate a major source of
subtle, hard-to-reproduce bugs. The exact compiler version and auxiliary tooling can be
defined and reused consistently.

I still remember working on competitive benchmarking across several vendor toolchains
years ago --- juggling environment setups, clashing paths, and tools that refused to
coexist. It took days just to get builds working. If I had had containers then, the time
and headache saved would have been substantial.

Containerization also integrates cleanly with continuous integration systems. The
container you use for local development can run in your CI pipeline as-is --- what builds
in automation also builds on your machine, without duplicating setup across
environments.

It also brings consistency to more complex test setups, such as hardware-in-the-loop,
where reproducible environments across machines are critical. Just as importantly, that
same container can be used to produce verified release builds. What you test is what you
ship.

If you\'re delivering an SDK or toolchain --- whether internally or to
partners --- providing it as a container image ensures consistency across teams and
platforms. As long as the receiving side is aligned on container usage, handoff becomes
smooth and predictable.

The reuse of a container can span your entire development lifecycle. The table below
shows how one container definition can support different phases of an embedded workflow:

#strong[One Container Across the Embedded Development Lifecycle]

#figure(
  table(
    columns: 4,
    align: (auto, auto, auto, auto),
    table.header([#strong[Phase]], [#strong[Purpose]], [#strong[Environment]], [#strong[How the Same Container Helps]]),
    table.hline(),
    [#strong[Development]],
    [Build, test, and debug firmware],
    [Developer's machine (via container runtime or WSL2)],
    [Ensures consistent tools across all developers --- no host-specific issues],
    [#strong[Continuous Integration]],
    [Run automated builds and tests],
    [CI server (e.g. GitHub Actions, GitLab CI)],
    [Removes need to recreate tool setup in CI; builds match local development],
    [#strong[Release Builds]],
    [Produce verified firmware artifacts or packages],
    [Controlled CI or build node],
    [What you test is what you ship --- minimises drift or build-time surprises],
    [#strong[SDK / Toolchain Delivery]],
    [Deliver environment to external or internal teams],
    [Consumer's machine (aligned on container usage)],
    [Offers an isolated, ready-to-use client build environment --- no manual setup needed],
  ),
  kind: table,
)

For embedded teams juggling multiple toolchains, projects, or hardware platforms,
containerized development offers a much-needed degree of structure. It won't eliminate
complexity, but it helps you manage it cleanly and predictably.

= Not a Silver Bullet: Understanding the Trade-offs
Containerization can solve many of the recurring pain points in embedded
development --- but like any model, it has boundaries. Knowing where those boundaries are
helps you use containers effectively without running into avoidable issues.

== There is an initial learning curve
For teams new to containers, some upskilling is expected. The mental model is different
from working directly on a host system, and the tooling takes some adjustment.
Developers may initially find the setup restrictive, especially when they are used to
installing tools freely on their machine.

That said, getting started doesn't require deep knowledge of container internals. You
don't need to understand layered filesystems or build optimisations to benefit from a
basic, consistent containerized setup. In practice, many teams can begin with a simple
container definition and evolve it gradually as needs grow.

== Hardware access requires deliberate design
Embedded development often involves interacting with physical devices --- USB interfaces,
serial ports, JTAG tools, or custom peripherals. Containers can access these devices by
mapping them explicitly (for example, forwarding `/dev/ttyUSB0` into the container), but
this requires a small amount of additional setup compared to working directly on the
host.

Handling hot-pluggable or transient devices typically requires reconfiguring and
restarting containers. However, with a little extra setup around the container --- such as
dynamic device mapping or wrapper scripts --- this can be managed more gracefully.

On Windows, setup adds an extra layer. Forwarding USB devices into
#link("https://learn.microsoft.com/en-us/windows/wsl/connect-usb")[WSL2] --- and in turn
to a Linux container --- involves additional setup. With the right configuration though,
it works reliably for development purposes.

== Some tools don't work well in a container
Some vendor-provided tools can be difficult to containerize. This is often due to
assumptions they make about the host environment. Typical issues include:

- Assuming they're running on physical hardware;

- Checking for specific host identifiers (like MAC addresses);

- Requiring access to license servers or VPN-restricted networks.

#strong[Test tool compatibility #emph[early]] --- some tools simply won't cooperate inside
a container.

When containerization adds too much friction, teams can adopt a hybrid workflow --- using
containers for builds and automated testing, while keeping certain GUI tools or device
flashing on the host using exposed artifacts.

== Reproducibility has its limits
Containers can greatly improve consistency, but they do not guarantee full
reproducibility by default. You can specify exact versions of toolchains and
dependencies, but that only works if those versions remain available over time. For
example, a specific compiler version may be removed from upstream repositories, or a
vendor SDK might change without notice. Even base images --- such as
#link("https://hub.docker.com/_/ubuntu")[`ubuntu:24.04`] --- can receive updates under the
same tag. Unless you pin to a specific release, your environment might drift over time.

There is also a second layer of variability: the kernel. Containers are lightweight
because they share the host kernel, but that also introduces constraints. Since they
rely on Linux kernel features, you cannot run Linux containers natively on Windows.
However, WSL2 bridges that gap by providing a Linux-compatible kernel environment on
Windows systems.

In most cases, this works reliably.

But if your tooling depends on specific kernel behavior or system calls, running the
container on a different host may produce subtle issues. This is rare in everyday
development, but becomes relevant as host systems evolve --- especially in long-term or
regulated environments where reproducibility matters. In those cases, the kernel
boundary needs to be understood and managed carefully.

#horizontalrule

These limitations don't make containerization a poor fit for embedded development --- but
they do highlight that containers are not a drop-in solution for every situation. Many
of the practical issues can be addressed with a bit of structure and awareness.

For a high-level view, the table below summarises where containers introduce
friction --- and how teams can work around it:

#strong[Common Trade-Offs in Embedded Containerization]

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([#strong[Area]], [#strong[Challenge]], [#strong[How to Handle It]]),
    table.hline(),
    [#strong[Learning curve]], [New concepts and tooling can feel restrictive], [Start simple, evolve as needed],
    [#strong[Hardware access]],
    [Mapping devices and handling hot-plug behavior],
    [Use wrapper scripts or external helpers],
    [#strong[Tool limitations]],
    [Some tools may fail in container isolation],
    [Test early; use hybrid workflows when needed],
    [#strong[Reproducibility]],
    [Drift in base images or host kernel behavior],
    [Understand long-term dependencies and document them; pin image versions],
  ),
  kind: table,
)

These friction points are solvable --- but only if you know where they are. Upcoming posts
in this series will unpack the underlying concepts, explore common edge cases, and share
practical techniques for working around these limits --- especially in areas like
reproducibility, host interaction, and hardware access.

= From Myth to Method: Replace the Golden Laptop
The “golden laptop” lives on because, in many embedded teams, it feels like the only
thing that works. But that kind of setup is fragile, unscalable, and unsustainable. It
ties knowledge to individual machines and leaves your development process vulnerable to
change --- whether that's a new team member, a new hardware variant, or a routine system
update.

Containerization offers a structured alternative. Instead of relying on a machine that
happens to work, you can define an environment that is designed to work --- on any
developer's machine, in your CI system, or as the basis for a release. What you gain is
portable, consistent, and team-friendly. And while containers won't solve everything,
they give you a solid foundation to build from --- one that reflects how modern workflows
are evolving.

This shift is already underway across industries --- from automotive to medtech to
IoT --- driven by the growing need for reliable, reproducible environments in complex
development pipelines.

In the next post, we'll unpack the foundational concepts behind containers: what they
are, how they behave, and how to think about them as an embedded developer --- without the
cloud-native assumptions.

#horizontalrule

#strong[👉 Ready for Part 2?] \
#link("https://davidjuhasz.dev/blog/containers-for-embedded-developers")[Understanding Containers for Embedded Developers: A Practical Introduction]
