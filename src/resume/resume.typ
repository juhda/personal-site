// Resume of Dávid Juhász.
//
// Compiled to public/resume/DavidJuhasz_Resume.pdf by scripts/generate-resume.mjs
// (npm run generate:resume, part of generate:all); the /resume redirect in
// astro.config.mjs serves the PDF. The build injects a `last-updated` sys.input
// from the git history of this directory and fails unless the document is one
// page; editor previews get no input and show a placeholder date instead.
//
// How to edit — all content lives in this file:
// - Header: the two blocks at the top (name/tagline, contact links).
// - Sections: `#section[Title]`, followed by its body.
// - Skills: plain list items (`- ...`) under the Skills heading.
// - Entries: one `#entry` call per job or education entry, newest first:
//
//     #entry((
//       title: [Job title],
//       company: [Company],
//       location: [City, Country],
//       dates: [Month Year -- Month Year],
//       bullets: ([...], ...),
//     ))
//
// Typography is print-oriented EB Garamond, sizes matching the original Word
// document (11pt body, 14pt bold headings, 16pt bold name). Committed as
// static instances in fonts/ (SIL OFL 1.1) — typst.ts cannot resolve variable
// fonts, so static instances are required.

// Underlined blue hyperlink (standard for print documents).
#let hlink(url, body) = link(url)[#underline(text(fill: rgb("#0563C1"))[#body])]

// Section heading ("Summary", "Skills", ...): its own block with a small,
// uniform gap to the section body (instead of Typst's default paragraph
// spacing).
#let section(title) = block(above: 12pt, below: 8pt)[#text(size: 14pt, weight: "bold")[#title]]

// Job or education entry — see the header comment for an example call.
#let entry(data) = [
  #block[
    #text(weight: "bold")[#data.title] | #text(style: "italic")[#data.company] | #text(style: "italic")[#data.location] | #text(style: "italic")[#data.dates]
    #list(..data.bullets)
  ]
]

// ------------------------------------------------------------------- footer
// Rendered by the page setup below in the bottom margin of the page: rule,
// centered portfolio line, second line with the git-derived last-updated
// note (placeholder date without the input, i.e. in editor previews).

#let last-updated = sys.inputs.at("last-updated", default: "Month Year")

#let footer-note = [
  #line(length: 100%, stroke: 0.5pt)
  #v(5pt, weak: false)
  #align(center)[
    Explore portfolio and technical projects: #hlink("https://davidjuhasz.dev/portfolio")[davidjuhasz.dev/portfolio] \
    #text(size: 9pt, fill: luma(96))[Last updated: #last-updated]
  ]
]

// PDF document metadata (Info dictionary of the generated PDF).
#set document(
  title: "Dávid Juhász — Résumé",
  author: ("Dávid Juhász",),
  keywords: ("résumé", "software consultant", "compilers", "LLVM", "embedded systems", "edge AI", "hardware-software co-design"),
  description: "Résumé of Dávid Juhász — Software Consultant for software platforms powering custom hardware.",
)

// Word-style narrow margins (1.27cm = 0.5in); the bottom margin is deeper to
// host the footer.
#set page(paper: "a4", margin: (x: 1.27cm, top: 1.27cm, bottom: 2.7cm), footer: footer-note)
#set text(font: "EB Garamond", size: 11pt, lang: "en")
#set par(justify: true, leading: 0.5em)
#set list(marker: [•], indent: 5pt, body-indent: 5pt)

// ------------------------------------------------------------------ header

#block[
  #text(size: 16pt, weight: "bold")[Dávid Juhász]
  #text(size: 14pt)[ | Software Consultant | Software Platforms for Custom Hardware]
]
#block[
  #text(size: 12pt)[
    #hlink("tel:0036209309220")[+36 20 930 92 20] |
    #hlink("mailto:hello@davidjuhasz.dev")[hello\@davidjuhasz.dev] |
    #hlink("https://davidjuhasz.dev/")[davidjuhasz.dev] |
    #hlink("https://linkedin.com/in/juhaszdavid")[linkedin.com/in/juhaszdavid] |
    Hungary
  ]
]

// ------------------------------------------------------------------ summary

#section[Summary]

#pad(left: 5pt)[
  I am a Software Consultant working at the intersection of hardware and software, focusing on the
  0-to-1 phase of complex systems. I build compilers, tools, and firmware --- the software platforms
  that make custom embedded compute architectures and System-on-Chip designs usable. I believe that
  engineering efficiency and technical leadership emerge from choosing clarity and aligning efforts to
  build unified, high-impact ecosystems.
]

// ------------------------------------------------------------------- skills

#section[Skills]

- Compilers & Tool Development: LLVM, TVM, code optimization, scheduling, code generation, static analysis
- Embedded & Systems Engineering: Hardware bring-up, bare-metal, firmware, RTOS, PCB- and IC-level understanding
- Communication Protocols: UART, SPI, I2C, CAN, Ethernet, TCP, UDP, sockets, custom protocol stacks
- Programming Languages: C, C++, Python, Rust, Assembly
- Toolchains & Build Systems: LLVM, Clang, GCC, Make, CMake
- Debugging & Optimization: GDB, LLDB, hardware probes, waveform analysis, performance profiling and tuning
- Software Architecture: Resource-constrained, multi-threaded, real-time systems, interpreters, virtual machines
- Modeling & Simulation: Performance modeling, system simulation, hardware-software interaction
- Hardware-Software Co-Design: FPGA integration, hardware acceleration, edge architectures, heterogeneous systems
- Machine Learning & AI Acceleration: PyTorch, Tensorflow, ONNX, interpretation and compilation-based deployment
- AI-Assisted Development: LLM-based coding and review workflows; sandboxed AI tooling for privacy
- Neuromorphic Computing: SNNs, Hybrid Neural Architectures, Event-based Sensors and Processing
- Technical Leadership & Mentorship: Guiding engineers, fostering knowledge sharing, driving architectural decisions
- Cross-Functional Collaboration: Strategic goal alignment, bridging engineering, product, and leadership teams

// --------------------------------------------------------------- experience

#section[Experience]

#entry((
  title: [Senior Software Engineer],
  company: [Frontgrade Gaisler],
  location: [Gothenburg, Sweden (Remote)],
  dates: [June 2025 -- ongoing],
  bullets: (
    [Enabled neuromorphic edge AI on space-grade RISC-V platforms via Akida runtime integration and benchmarking.],
    [Contributed to FPGA verification and RTL reviews for custom SoC designs, aligning hardware and software teams.],
  ),
))

#entry((
  title: [Senior Architectural Modeling Engineer],
  company: [FlexAI],
  location: [Paris, France (Remote)],
  dates: [July 2024 -- October 2024],
  bullets: (
    [Shaped team vision, roadmap, and modeling strategies to support next-generation AI accelerator development.],
    [Led profiling of PyTorch-based LLMs to assess execution time, memory usage, and optimization opportunities.],
  ),
))

#entry((
  title: [Expert Software Engineer --- Edge AI Systems],
  company: [Imsys],
  location: [Stockholm, Sweden (Hybrid)],
  dates: [November 2022 -- May 2024],
  bullets: (
    [Directed embedded software and AI toolchain development, aligning technical execution with strategic goals.],
    [Delivered runtime libraries, simulation frameworks, and code generation pipelines for a custom edge AI accelerator.],
    [Contributed to system architecture design for RISC-V integration and evaluated accelerator-software interfaces.],
  ),
))

#entry((
  title: [Head of Software Engineering],
  company: [Imsys],
  location: [Stockholm, Sweden (Hybrid)],
  dates: [March 2021 -- October 2022],
  bullets: (
    [Led software department strategy, team growth, and cross-functional coordination across edge AI projects.],
    [Defined system architecture for a scalable edge AI platform, guiding execution model and system co-design.],
    [Contributed to code generation and simulation tools enabling early-stage validation of accelerator architectures.],
  ),
))

#entry((
  title: [Software Architect],
  company: [Imsys],
  location: [Stockholm, Sweden (Hybrid)],
  dates: [January 2018 -- March 2021],
  bullets: (
    [Spearheaded LLVM-based toolchain and embedded software stack development for custom processor platforms.],
    [Delivered full toolchain solutions, including compiler, linker, debugger, and integrated VSCode extensions.],
    [Supervised system architecture, board bring-up, FreeRTOS porting, and hardware driver development.],
  ),
))

#entry((
  title: [Software Engineer],
  company: [Imsys],
  location: [Stockholm, Sweden],
  dates: [October 2013 -- January 2018],
  bullets: (
    [Authored the custom ISA specification and the LLVM-based code generator for a proprietary processor.],
    [Built low-level debugger, simulator, and assembler in modern C++ to enhance embedded system development.],
  ),
))

// ---------------------------------------------------------------- education

#section[Education]

#entry((
  title: [MSc and BSc in Computer Science],
  company: [Eötvös Loránd University],
  location: [Budapest, Hungary],
  dates: [2007 -- 2012],
  bullets: (
    [Specialized in compilers, formal methods, and programming languages; graduated with distinction for both degrees.],
  ),
))

#entry((
  title: [PhD Graduate Work (Industry-Based, Unfinished)],
  company: [Vienna University of Technology],
  location: [Vienna, Austria],
  dates: [2016 -- 2020],
  bullets: (
    [Conducted research at the intersection of compiler optimization, machine learning, and embedded systems.],
  ),
))
