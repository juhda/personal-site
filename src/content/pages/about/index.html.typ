// About page body. Structure (profile photo, the "Next Steps" section with
// its download/config links) stays in src/pages/about.astro; the prose
// lives here.
#let (page-title, nowrap) = eval(read("../_preamble.typ"), mode: "code")
#let (cleanJobTitle,) = eval(read("../../../generated/site.typ"), mode: "code")

#page-title[About Me]

I am a #nowrap[#cleanJobTitle] specializing in the intersection of hardware and software. My work is driven by a core conviction: the most impactful technology emerges when we treat silicon and code as a #strong[unified ecosystem], not as separate domains.

= From Constraints to Platforms

My fascination with systems began with a computer and no internet — a constraint that forced me to understand how software interacts with hardware at the most fundamental level. That early curiosity evolved into a career centered on the software that makes custom hardware usable.

Today, I build that software: the platforms where silicon architecture and system software evolve in harmony, producing systems that are not only high-performance but also sustainable.

= Where I Thrive

I do my most meaningful work in the design and innovation phases, where the solution space is open and the architecture is yet to be defined. In greenfield projects, I:

- Establish a holistic system architecture from the ground up.

- Lead multidisciplinary teams from architecture study through integration, keeping hardware and software decisions in dialogue.

- Transform hardware constraints into opportunities for elegant, purposeful software design.

= Selected Work

My #link("/portfolio")[portfolio] groups that work into four themes:

- #link("/portfolio#edge-ai-and-hardware-software-co-design")[Edge AI and Hardware-Software Co-Design]

- #link("/portfolio#compilers-and-instruction-set-architectures")[Compilers and Instruction Set Architectures]

- #link("/portfolio#simulation-validation-and-developer-tooling")[Simulation, Validation, and Developer Tooling]

- #link("/portfolio#embedded-platforms-and-firmware")[Embedded Platforms and Firmware]

= Engineering with Purpose

At my core, I believe good engineering is about more than technical excellence — it is about #strong[shared understanding]. Its true value is unlocked when a team moves forward with clarity, purpose, and alignment.

I work pragmatically, navigating real-world trade-offs while staying true to broader goals. Whether I am architecting an API or aligning a cross-functional team, I prioritize logical clarity, reliability, and developer empowerment — ensuring the systems we build are resilient, purposeful, and easy for others to build upon.

= Beyond the Code

Outside of engineering, I explore the human side of technology. I am fascinated by psychology, communication dynamics, and the art of distilling complex topics into simple, actionable insights. These interests directly shape my leadership style and my approach to remote-first collaboration.

I share my evolving thoughts on engineering efficiency, leadership, and systems-level thinking on my #link("/blog")[blog].
