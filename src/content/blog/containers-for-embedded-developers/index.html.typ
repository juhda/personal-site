#import "../_preamble.typ": blog-img, callout, horizontalrule

#emph[Part~2 of the “]#link("https://davidjuhasz.dev/blog/series/containerized-embedded-dev")[#emph[Practical Embedded Development, Containerized]]#emph[” series --- ]
#link("https://davidjuhasz.dev/blog/containerized-embedded-development")[Catch up on Part~1: Why Containers Matter]

You've seen the pitch: containers can fix the #emph[fragile], machine-tied #emph[build environments] that plague embedded teams. You've read about how they make onboarding
smoother, ensure consistent builds, and bring some much-needed structure to the chaos of
embedded workflows.

You're convinced they're worth a look. But now you're standing at the edge of the
container world --- and it feels… fuzzy.

Dockerfiles, images, volumes --- every tutorial seems written for cloud engineers
deploying web apps, not people who build firmware. The examples are noisy, the jargon is
thick, and no one's explaining the #emph[basics] in a way that maps to your reality.
You're not looking to become a DevOps engineer. You just want to understand what
containers are and how to start using them --- without spending three weekends lost in
documentation.

That's exactly what this post is for.

In this post, you'll build a #emph[clear, grounded understanding] of containers --- how
they work, how they compare to virtual machines, and how to spot the handful of concepts
that actually matter for your day-to-day. You won't learn everything, but you'll learn
enough to stop feeling lost and start navigating container-based tools with confidence.

= What Exactly Is a Container in Embedded Development?
Let's strip away the buzzwords. At its core, a container is a lightweight, isolated
environment that runs your software exactly the same way every time --- no matter where
it's executed.

Imagine a tiny, disposable Linux machine that comes preloaded with exactly what you
need --- compiler, libraries, scripts. You can spin it up, run your build in a clean
environment, and when you\'re done, it can vanish like it was never there. That's a
container.

From an embedded developer's point of view, this is powerful because:

- No more worrying about installing the right toolchain on your main machine.

- Everyone on your team can use the exact same build setup.

- If it builds once, it'll build again --- on another laptop, in CI, or six months from now.

Containers aren't full systems --- they're processes running in isolation, bundled with
their own filesystem and environment. Instead of virtualizing hardware like a VM,
containers virtualize the operating system. They share the host kernel and create an
environment that #emph[feels] like a clean, standalone machine. That's what makes them
lightweight and fast.

#blog-img(
  "Container.png",
  alt: "A container illustrated as a box containing a toolchain, scripts, libraries, and a Linux base — representing a self-contained development environment.",
)

Once you get a feel for what's #emph[inside] a container, the tooling and terminology
click into place.

= Containers vs. VMs: What's the Difference, and Why It Matters
Before jumping into the relevant concepts inside containers, let's clarify how they
really differ from VMs.

If you've worked with virtual machines before, containers might feel familiar at first
glance. After all, both offer isolated environments, both can run software consistently
across different systems, and both help avoid “it works on my machine” issues.

But under the hood, they work very differently.

A virtual machine behaves like a complete computer. It runs its own operating system,
includes virtualized hardware, and needs gigabytes of storage and memory. Starting one
is like booting up a full machine --- slow and resource-hungry, but fully isolated from
the host.

A container, by contrast, doesn't virtualize hardware. It runs directly on the host's
kernel and shares it with other containers and processes. What's virtualized is the
#emph[operating system environment], not the whole machine. That's why containers start
faster, use fewer resources, and are much better suited for quick, repeatable tasks like
builds or automated tests.

Here's another key difference: containers are #strong[designed] to be ephemeral. The
model encourages you to spin them up, do your job, and tear them down --- leaving no
clutter behind. In practice, though, especially during development, you might keep a
container alive longer to avoid repeating experimental setups or long initialisation
scripts. The important takeaway is this: containers are meant to be #strong[disposable],
even if you don't always treat them that way. Any data you want to persist should live
#emph[outside] the container.

So while VMs and containers solve some similar problems, they do so with very different
trade-offs.

#strong[Containers vs. Virtual Machines at a Glance]

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Feature], [Virtual Machine], [Container]),
    table.hline(),
    [Virtualizes], [Full hardware], [OS environment],
    [Startup time], [Slow], [Fast],
    [Resource usage], [Heavy], [Lightweight],
    [Isolation], [Strong --- complete system sandbox], [Limited --- isolated but shared kernel],
    [Portability], [Portable VM image across hypervisors], [Portable image across systems with container support],
    [Persistence model], [Persistent by default], [Ephemeral by default],
    [Typical use case], [Long-running, full-system environments], [Short-lived, task-specific environments],
  ),
  kind: table,
)

For embedded workflows, containers offer a more practical balance: they're lighter,
quicker to spin up, and easier on your system. This matters whether you\'re automating
builds, managing multiple toolchains, or just trying to keep your development machine
clean and responsive.

= What You #emph[Actually] Need to Understand
#blog-img(
  "Docker_From_Definition_to_Execution.png",
  alt: "Containers are built from Dockerfiles into images, which are then run as isolated environments.",
)

Containers come with a lot of jargon --- Dockerfiles, images, layers, volumes. But the
good news is, you don't need to learn everything to start using them effectively. If
you're coming from an embedded background, here are the concepts worth wrapping your
head around:

== Dockerfile
A Dockerfile is a script that tells Docker how to build your image. It lists
instructions like:

- what base image to start from (e.g., Ubuntu, Alpine)

- what packages to install

- which files to copy in

- what command to run when the container starts

It's a bit like a Makefile for your environment --- declarative, readable, and repeatable.

== Base Image
Every Dockerfile starts with a base image --- this is the foundation your environment is
built on. It could be a minimal OS like `alpine`, a more complete one like `ubuntu`, or
even a pre-built SDK image from a vendor. You can also use your own previously built
image as a base, layering new functionality on top.

== Image
Once Docker reads your Dockerfile and executes the instructions, it creates an image. An
image is a #emph[self-contained environment] --- a snapshot that includes everything your
container will provide once it runs: OS packages, build tools, scripts, and environment
variables.

You can think of it like a packaged SDK or toolchain archive: something you'd normally
download, unpack, and use to get started quickly. But instead of just pointing to tools,
it #emph[includes] them --- already configured and ready to go. That means your build
environment is consistent, portable, and easy to reuse across machines or teammates.

== Container
A container is a #emph[running instance] of an image. Once you create and run a
container from an image, it becomes a live environment that runs in isolation from the
rest of the system. You can run many containers from the same image --- just like
launching multiple instances of a tool from the same SDK, each working independently on
a different task or project.

It's helpful to think of containers as short-lived, task-specific environments --- though
you might keep one alive longer during development.

== Container Registry
Container images don't come out of nowhere. When you pull a base image like `ubuntu` or
`python`, it's downloaded from a #emph[registry] --- a sort of package repository for
containers.

Docker Hub is the most common, but you'll also encounter others like GitHub Container
Registry or private ones used inside companies. You can also push your own images to
registries to share with teammates or CI pipelines.

== Volumes
Data written inside a container stays there only as long as the container exists. When a
container is deleted, its internal filesystem --- and anything saved inside it --- is lost.

If you want to persist data --- like build artifacts, logs, or test results --- you use a
#emph[volume]. Volumes link a folder inside the container to a storage location on the
host, managed by Docker. While you #emph[can] access the data directly from the host,
it\'s generally intended to be used through Docker itself.

They're the bridge between “disposable” environments and persistent work.

== Bind Mounts
Bind mounts are an alternative to volumes. Instead of letting Docker manage storage, you
map a specific host directory into the container. This gives you direct control over
what data is shared and where it lives on your system.

That flexibility comes with a tradeoff: bind mounts provide less isolation. Because the
container can directly read from and write to the host, any changes made inside the
container will affect the original files on your system. For development, that's
powerful --- but it also means you need to be a bit more careful.

One small caveat: because containers and hosts might use different users, ownership and
file permissions can sometimes cause hiccups --- especially on Linux, where UID mismatches
are most visible.

#horizontalrule

These are the core concepts worth knowing. With them in your toolkit, you'll be able to
follow most examples, make sense of Dockerfiles, and start using containers with
confidence.

#callout[
  #strong[🚫 Ignore the Noise] \
  Just as important as knowing what #emph[to focus on] is knowing what you can #emph[safely ignore]. When reading Docker tutorials, you'll often see mentions of Kubernetes, OpenShift, container orchestration, or cloud deployment. #strong[Don't worry about any of that.] For embedded work, containers are just a clean, consistent environment --- not a deployment platform.
]

= How Containers Are Used in Embedded Development
By now, you've got the basic concepts down. But what does containerization actually
#emph[look like] in the context of embedded systems?

Unlike in cloud --- where containers often run distributed services with various
lifetimes --- embedded teams use containers as #strong[development tools], not deployment
targets. Containers become a way to control the environment, not to run the final
product.

Here are a few practical ways containers show up in embedded workflows:

== Containerized Toolchains
Toolchains are often large, version-sensitive, and hard to wrangle. A container lets you
package the entire toolchain --- compiler, libraries, environment variables --- into one
clean, repeatable setup. This eliminates the “it only builds on Dave's laptop” syndrome
and gives your team a single, stable environment to work from.

Want to try out a Yocto SDK or a vendor's GCC toolchain without cluttering your host
system? Containerize it. You'll see this in action in the next section, where we walk
through isolating a basic ARM GCC setup using Docker.

== Build Isolation and Testing Environments
Containers also shine when you need temporary, clean environments for specific
tasks --- like running system-level tests, checking integration logic, or experimenting
with emulators like QEMU. These setups often require packages or configurations you
don't want polluting your main system.

Since containers are isolated and reproducible, they're ideal for creating throwaway
environments. You can spin up multiple containers for parallel testing, cleanly reset
them between runs, and avoid test interference --- something much harder to manage on a
shared development machine.

== Automation and CI Builds
Containers make it easy to run the exact same build across different systems --- locally
or in continuous integration. You don't need to install build tools on your CI server
anymore. Just run the same container image and get consistent, repeatable output every
time.

This consistency is especially valuable when you\'re dealing with multi-project or
multi-target pipelines. Small environmental differences can otherwise lead to big
debugging headaches.

== Onboarding and Developer Consistency
Instead of writing a ten-step “setup your dev machine” guide that breaks in three
months, you give new developers a container and say, “run this.” It works out of the
box, no matter their OS or installed packages.

It also means everyone's builds are consistent --- no more surprises because someone had
an outdated version of `make` or a slightly different Python environment.

#horizontalrule

In short, containers don't change #emph[what] you build --- they change #emph[how reliably and cleanly] you can build it. They isolate and compartmentalise your development
environments --- like a VM, but with far less overhead. They're not replacing your IDE or
your flashing tool. They're replacing the mess that often lives around them.

= Walkthrough: Minimal Containerized Toolchain for Embedded Cross-Compilation
Let's make this real. You don't need a full project or CI system to start experimenting
with containers. Here's a minimal example that shows how you can containerize a basic
toolchain and run it in isolation --- without installing anything on your main system.

#callout[
  #strong[✅ Prerequisite:] You'll need
  #link("https://www.docker.com/products/docker-desktop/")[Docker] installed. Docker runs
  as a background service (daemon), so make sure it's running before you begin.
]

#callout[
  💡 #strong[Tip: Prefer Rootless? Try Podman.] \
  #link("https://podman.io/")[Podman] is a drop-in, rootless alternative to Docker. Just
  swap `docker` with `podman` in all the commands below --- no daemon required.
]

We'll use a simple GCC cross-compiler setup as a starting point.

== 🗂️ Step 1: Create a Project Directory
<card_index_dividers-step-1-create-a-project-directory>
Make a clean folder to work in:

```bash
mkdir container-toolchain-demo
cd container-toolchain-demo
```

== 📄 Step 2: Write a Minimal Dockerfile
<page_facing_up-step-2-write-a-minimal-dockerfile>
Create a file named `Dockerfile`:

```dockerfile
FROM ubuntu

RUN apt-get update && apt-get install -y \
    gcc-arm-none-eabi \
    && apt-get clean

WORKDIR /project
```

This tells Docker to start from a base Ubuntu image, install a common ARM GCC toolchain,
and set up a working directory.

== 📦 Step 3: Build the Image
In the same directory as your `Dockerfile`, run:

```bash
docker build -t arm-toolchain .
```

This builds your container image and tags it as `arm-toolchain`.

== 🏃 Step 4: Run a Container
Now launch a container from that image:

```bash
docker run -it --rm -v "$PWD:/project" arm-toolchain
```

This does a few things:

- `-it` gives you an interactive terminal

- `--rm` removes the container after you exit (so it doesn't clutter your system)

- `-v "$PWD:/project"` mounts your current folder into the container at `/project`

Once inside the container, you can use the toolchain exactly as if it were installed on
your host. Try running:

```bash
arm-none-eabi-gcc --version
```

You now have a working, isolated development environment.

#callout[
  💡 An interactive shell is just one way to work with a running container. You can also:

  - Attach additional shells using `docker exec -it <container> bash` (Replace `<container>` with the container's ID or name --- #strong[not] the image name)

  - Connect via SSH (if configured inside the container)

  - Run background services or tasks automatically on container startup
]

#callout[
  💻 #strong[Develop Inside the Container] \
  #link("https://code.visualstudio.com/docs/devcontainers/containers")[VSCode Dev Containers] let you open and edit your code directly inside a running container --- with
  terminals, tooling, and extensions that feel local.
]

== 🏁 Step 5: Exit Cleanly
<checkered_flag-step-5-exit-cleanly>
When you\'re done, just type `exit`. The container is removed, and your host environment
stays untouched.

== 🧹 Step 6: Check Your System and Clean Up
Even though containers are designed to be disposable, Docker stores things like images,
volumes, and stopped containers by default. Over time, these can add up and eat disk
space --- especially if you\'re experimenting or rebuilding often.

You don't need to micromanage everything, but it's helpful to know how to inspect and
clean up your Docker environment when needed.

#callout[
  💡 #strong[Common Docker Housekeeping Commands] \
  #emph[(Inspect, clean, and manage your containers and images)]

  ```bash
  docker ps             # List running containers
  docker ps -a          # List all containers (including stopped)
  docker images         # List images
  docker volume ls      # List volumes

  docker rm <container>     # Remove a container
  docker rmi <image>        # Remove an image
  docker volume rm <volume> # Remove a volume

  docker system df          # Show Docker disk usage
  docker system prune       # Remove unused data
  ```
]

If you\'re short on space or want to wipe your environment clean after testing,
`docker system prune` is a useful catch-all --- but make sure you understand what it
deletes before running it.

#horizontalrule

This example is intentionally minimal. No build scripts, no targets --- just enough to
show how a container can package up a development environment and let you work inside it
without installing anything locally.

Want to add custom scripts, libraries, or mount additional paths? That's easy --- and it
builds on this foundation.

#callout[
  🔁 #strong[Once you've set up a container for a real project], your builds can become as simple as:

  ```bash
  docker run --rm -v "$PWD:/project" arm-toolchain make all
  ```

  That's the entire environment --- tools, dependencies, and scripts --- packaged into a
  single image you can run anywhere. Fast, consistent, repeatable.
]

= What's Next: Becoming Container-Conversant, Not a DevOps Pro
You've crossed the threshold. You know what containers are, how they work, and how to
start using them in embedded development with confidence. That's more than enough to
make sense of real-world examples, follow tutorials, and start experimenting on your
own.

But don't worry --- you're not expected to become a container guru or switch careers into
DevOps.

For embedded developers, it's enough to be #strong[container-conversant]. That means:

- You can read a Dockerfile and understand what it's doing.

- You know how to run a container with your tools or code inside.

- You can follow a tutorial or CI setup without second-guessing every step.

That's a huge leap --- and it unlocks a more stable, repeatable way of working across
teams, projects, and systems.

In the next part of this series, we'll go a bit deeper: how to organise your container
setup for real projects, what pitfalls to avoid, and how to build workflows that are
clean, not clunky.

For now, you've got the mental model and the practical tools to get started. That's all
you need to begin.

#horizontalrule

#strong[👉 Ready for Part 3?] \
#link("https://davidjuhasz.dev/blog/containerized-embedded-development-pitfalls-patterns")[Containerized Embedded Development: 6 Pitfalls & Fixes]

#horizontalrule

== Further Reading & Resources
- #link("https://docs.docker.com/get-started/")[Docker Documentation -- Get Started]: The official quickstart to help you explore beyond the basics

- #link("https://podman.io/")[Podman -- A Free & Open-Source Docker Alternative]: Rootless and compatible --- swap `docker` for `podman` command-for-command

- #link("https://code.visualstudio.com/docs/devcontainers/containers")[VSCode: Developing Inside a Container]: Learn how VSCode connects to running containers for full-featured development

- #link("https://docs.github.com/en/codespaces")[GitHub Codespaces documentation]: GitHub's cloud-based development environments, built on containers and VSCode tooling.

- #link("https://containers.dev/")[Development Containers Specification]: The open standard that powers VSCode DevContainers, GitHub Codespaces, and more.
