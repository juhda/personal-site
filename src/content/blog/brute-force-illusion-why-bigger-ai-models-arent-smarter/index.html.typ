#import "../_preamble.typ": blog-img, callout, horizontalrule

#emph[\"Bigger models, smarter AI\"] --- this mantra has defined recent years of
artificial intelligence, promising that scale alone would unlock human-like reasoning.
As the hype fades, the limitations of brute-force AI --- pattern matching without
reasoning, hallucinations in LLMs --- are undeniable. Some of the most reliable systems
in engineering, like a thermostat, succeed not by scaling up, but by focusing down.

In #link("https://davidjuhasz.dev/blog/ai-field-not-buzzword")[Part 1], we explored that
AI is more than neural networks --- it includes symbolic systems, statistical models,
and beyond. Here, we zoom in on the scaling obsession, exposing its limits in logic,
safety, and efficiency --- and pointing to approaches that prioritize smarter design
over sheer scale.

= The Scaling Obsession: Bigger Models, Bigger Promises
The AI landscape remains dominated by a seductive narrative: #emph[bigger models are smarter models]. Even some original proponents now admit its flaws. The promise of
brute-force scaling delivering AGI (Artifical General Intelligence) has collapsed into a
sober reality: #strong[scale alone cannot fulfill its delusional claims.]

Simpler, reactive systems reveal the contrast. Take the humble thermostat: it maintains
a set temperature without fanfare or claims of intelligence. Its simplicity #emph[is]
its strength: a system designed for a specific task, executing it flawlessly. Now
contrast this with the latest LLM, trained on trillions of tokens, generating human-like
text, yet struggling with basic logic puzzles or explaining its outputs. The thermostat
delivers exactly what it promises. The same cannot always be said for AI.

#blog-img(
  "Thermostat_vs_LLM-ChatGPT.png",
  alt: "Side-by-side infographic comparing a thermostat and a large language model: the thermostat uses explicit rules for predictable, reliable output, while the LLM uses probabilistic pattern matching for broad capability but opaque, brittle reasoning, illustrating capability versus comprehension.",
)

Below, we dissect what scaling #emph[actually] achieves, where it falls short, and why
the future of AI may lie in smarter, more deliberate design.

= How Brute-Force AI Learns: The Limits of High-Dimensional Pattern Matching
At its core, a neural network is a
#link("https://www.youtube.com/watch?v=OUE3FSIk46g")[statistical engine], not a
reasoning one. It operates in a vast, high-dimensional space, where each dimension
represents a feature or potential pattern. When we say these models \"learn,\" we mean
they optimize parameters to minimize prediction errors --- essentially, they
#emph[interpolate]. This is akin to fitting an impossibly complex curve through a cloud
of data points, where the curve\'s shape is dictated by the data it has seen, not by any
inherent understanding.

Researchers study #link("https://arxiv.org/pdf/2604.21691")[the mechanics of learning]
and the structures emerging from training. Neural networks can extract algorithmic
structures from data via statistical optimization --- sometimes even recover \"classic\"
algorithms, like #link("https://arxiv.org/pdf/2301.05217")[modulo addition]. In limited
cases, these structures produce well-defined outputs for well-defined inputs, achieving
a form of #emph[narrow comprehension]. Yet models generalize only across combinations of
learned patterns. They spot correlation, but lack the context or reasoning framework to
extend beyond them.

This distinction is critical. A model\'s ability to generalize is limited to its
training data\'s distribution. It excels at pattern recognition --- text generation,
image classification --- but falters with novel scenarios. The #emph[illusion] of
understanding arises because outputs #emph[appear] intelligent, a byproduct of mimicking
the human-generated content\'s statistical properties.

In short: #strong[brute-force AI masters interpolation, not extrapolation.]

#blog-img(
  "Interpolation_vs_Extrapoliation-ChatGPT.png",
  alt: "Line graph comparing interpolation and extrapolation in machine learning: known training data points are fit accurately within the training distribution (interpolation), while predictions become unreliable outside that range (extrapolation), highlighting that brute-force AI fills gaps well but struggles beyond known patterns.",
)

This limitation underscores the difference between #emph[capability] --- the ability to
perform specific tasks --- and #emph[comprehension] --- the ability to understand and
reason about those tasks. The former is what scaling achieves; the latter remains out of
reach.

= The Illusion of Intelligence: Scaling Improves Capability, Not Comprehension
Scaling delivers quantitative gains: better text and broader task handling. But these
are purely #emph[quantitative] --- more data, parameters, and compute --- without a
#emph[qualitative] shift. Even phenomena like
#link("https://arxiv.org/pdf/2201.02177")[grokking], where models generalize after
overfitting, remain narrow in scope. The model simply gets better at mimicking its
training patterns.

While LLMs train via next-token prediction,
#link("https://www.semantic-web-journal.net/system/files/swj4039.pdf")[they develop ontological structures] --- frameworks organizing knowledge to #emph[mimic] reasoning
--- primed by prompts during inference. Mechanistic interpretability can reveal these
statistical artifacts, offering post-hoc insights. However, these describe rather than
prescribe: They explain #emph[what] a model learned, not #emph[why] or #emph[how] to
generalize universally.

#strong[Scaling expands capabilities; it does not transform them.] It sharpens
interpolation within the training distribution, but fails at extrapolation.
Hallucinations arise naturally: trained for fluency over accuracy, models invent details
when plausible outputs beat the truth.

= Where Brute-Force Fails: Real-World Breakpoints
The cracks appear where it matters most: #strong[logic, safety, and efficiency].

#blog-img(
  "Brute-Force_Scaling_Trade-Offs-ChatGPT.png",
  alt: "Minimalist infographic showing a central “brute-force scaling” concept surrounded by reliability, interpretability, and efficiency. The diagram indicates that scaling does not improve these three dimensions and reframes them as independent design goals rather than trade-offs, emphasizing the need for smarter architectural approaches.",
)

== Logical Consistency: Brittle Reasoning
Advances like fine-tuning, structured prompts, and guardrails have improved short-chain
coherence. Yet, #link("https://arxiv.org/pdf/2603.17169")[research shows] even
state-of-the-art models fail at #emph[sustained] logical consistency. They ace isolated
logic puzzles but falter in sequential, evolving contexts where each step depends on the
last. This exposes a persistent gap: #strong[Brute-force systems approximate reasoning in narrow constraints, but reliability degrades with complexity.]

== Safety-Critical Systems: The Opacity Problem
#link("https://www.nist.gov/itl/ai-risk-management-framework")[Brute-force AI\'s opacity is a liability] in fields like healthcare or autonomous driving, where interpretability is non-negotiable. Tools like mechanistic interpretability let us #emph[peek into the black box] --- even reverse-engineering certifiable solutions --- but #link("https://arxiv.org/pdf/2305.11391")[this is backward]. It\'s like dissecting a finished product to understand its design, rather than building with transparency from the start. More efficient, controlled methods (e.g., symbolic systems or hybrids) achieve the same goals without guesswork.

== Efficiency: The Unsustainable Cost of Scale
Even if scaling works, we must ask: #emph[Is it worth the cost?] The human brain runs on
#link("https://www.humanbrainproject.eu/en/follow-hbp/news/2023/09/04/learning-brain-make-ai-more-energy-efficient/")[\~20 watts], yet large AI systems demand #link("https://arxiv.org/pdf/2309.14393")[vast resources]. The illusion of intelligence may be compelling, but its price ---
environmental, financial, and computational --- exposes a fundamental inefficiency.

#horizontalrule

The contrast is clear: #strong[brute-force AI prioritizes capability over reliability, interpretability, and efficiency.] The question isn\'t whether scaling works --- it\'s
whether we can afford its trade-offs.

= Beyond Brute-Force: The Path Forward
The brute-force era has delivered #strong[real value:] fluency, practical conversational
solutions via pattern-matching, and limited but useful reasoning in trained contexts.
But it\'s hitting a wall.

The path forward isn\'t scaling further; it\'s rethinking #emph[how] we build
intelligence.

Reactive systems like thermostats or cruise control prove reliability doesn\'t demand
scale. Hybrid architectures blend symbolic logic with statistical learning, offering
#emph[and] adaptability. Emerging paradigms like
#link("https://neuromorphiccore.ai/")[neuromorphic computing] take inspiration from
biology, swapping brute-force interpolation for purpose-built, energy-efficient designs.
These approaches don\'t just optimize --- they rethink the foundation.

#strong[Scaling is a tool, not a theory of intelligence.] Like the thermostat, the
future of AI may lie in systems that do one thing well --- not everything poorly. The
next chapter won\'t be written by bigger models alone, but by smarter designs.
