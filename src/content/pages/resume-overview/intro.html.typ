// Résumé Overview page, intro part: the h1 title and the opening
// paragraph. Page structure (layout, the download button between intro and
// highlights) stays in src/pages/resume-overview.astro.
#let (page-title,) = eval(read("../_preamble.typ"), mode: "code")
#let (jobTitle,) = eval(read("../../../generated/site.typ"), mode: "code")

#page-title[Résumé Overview]

I am a #jobTitle specializing in the software that makes custom hardware usable. My work focuses on the #strong["0 to 1" phase] of complex systems, where I develop system-level solutions and infrastructure --- such as compilers, simulators, and embedded firmware --- to enable hardware and software to evolve as a unified ecosystem.
