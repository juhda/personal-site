#import "../_preamble.typ": blog-img, callout, horizontalrule

Artificial Intelligence (AI) is everywhere --- but what even is AI? Behind the buzzword
lies a diverse field: symbolic systems, statistical models, neural networks, each with
distinct strengths and trade-offs. This post cuts through the hype to explain the
field\'s diverse techniques, historical roots, and why engineers need to know the
difference.

= AI Is Not a Monolith
AI is often sold as a singular, revolutionary force --- a cure-all for complex problems.
It\'s not.

AI is a #strong[diverse field] composed of techniques, methodologies, and applications.
From rule-based systems to statistical models, Bayesian networks, evolutionary
algorithms, and neural networks, AI encompasses a spectrum of approaches, each suited to
different problems.

== The Field: A Spectrum of Techniques
At its core, AI is the study of creating systems that can perform tasks typically
requiring human intelligence: reasoning, learning, perception, and decision-making. Yet,
\"AI\" has become a catch-all, obscuring the lines between its subfields.

To make sense of this, think of AI not as a single thing but as a layered field:

#blog-img(
  "The_AI_Field-ChatGPT.png",
  alt: "Layered diagram showing AI as the umbrella field, with core methods (machine learning, symbolic methods, other approaches) inside it, and application domains below (computer vision, NLP, robotics, recommender systems, healthcare), illustrating how methods feed into real-world uses.",
)

For engineers and technical leaders, understanding AI as a field --- rather than a
single tool --- is crucial. It enables informed decisions about which techniques to
apply. Whether leveraging symbolic AI for rule-based decision-making or deploying neural
networks for pattern recognition, recognizing AI\'s diversity is the first step toward
building effective, intelligent systems.

== Historical Roots: From Dartmouth to Deep Learning
The term \"Artificial Intelligence\" emerged in 1956 at the
#link("https://home.dartmouth.edu/about/artificial-intelligence-ai-coined-dartmouth")[Dartmouth Conference], where researchers envisioned machines simulating human intelligence. Since
then, AI has evolved through multiple waves, each with distinct approaches and
ambitions.

Early AI was dominated by
#link("https://en.wikipedia.org/wiki/Symbolic_artificial_intelligence")[#strong[symbolic AI]], which relied on explicit rules and logic. These systems were transparent and
interpretable, but struggled with adaptability and uncertainty.

The 1980s and 1990s marked a shift toward #strong[statistical methods], as researchers
explored models that learned patterns from data rather than relying on pre-programmed
rules. This period saw the revival of #strong[connectionist models], including
#link("https://en.wikipedia.org/wiki/Neural_network_(machine_learning)")[#strong[Artificial Neural Networks]] #strong[(ANNs)], with advancements like
#link("https://www.nature.com/articles/323533a0")[#strong[backpropagation]] and
#link("https://en.wikipedia.org/wiki/Deep_learning")[#strong[multi-layer architectures]]. While these models laid the groundwork for modern machine learning,
their practical impact was limited by the computational power and data availability of
the time.

The true breakthrough for ANNs --- especially in image processing --- came later, with
#link(
  "https://proceedings.neurips.cc/paper_files/paper/2012/file/c399862d3b9d6b76c8436e924a68c45b-Paper.pdf",
)[#strong[AlexNet]]
#strong[in 2012]. This deep learning model demonstrated the power of
#link("https://cs231n.github.io/convolutional-networks/")[#strong[Convolutional Neural Networks]] #strong[(CNNs)] on large-scale datasets, revolutionizing the field. This
milestone underscores AI\'s diversity: each breakthrough solved a specific problem, not
\"intelligence\" as a whole.

Today, \"AI\" is often used interchangeably with #strong[machine learning models],
particularly deep learning and neural networks, which dominate headlines. This narrow
focus overshadows the broader field, fostering misconceptions. While neural networks
excel in areas like image recognition or natural language processing, they are just one
tool in the AI toolkit.

Understanding AI\'s historical context clarifies these misconceptions. It underscores
the importance of viewing AI as a #strong[diverse toolkit of techniques], not a
monolithic solution. This perspective is essential for leveraging AI effectively,
without falling prey to hype or oversimplification.

= From Magic to Mainstream: AI\'s Evolution
Artificial Intelligence often feels like magic --- especially when it performs tasks
that seem to require human-like intuition or reasoning. This perception isn\'t just a
side effect of AI\'s complexity, but a product of how the field evolved from niche
research to everyday tools.

== The Illusion of Intelligence
Early AI victories, like IBM\'s #link("https://www.ibm.com/history/deep-blue")[Deep Blue] defeating Garry Kasparov in 1997, relied on #strong[rule-based, expert systems]
--- not the statistical models we associate with AI today. Yet even these systems were
labeled \"intelligent,\" fueling the hype that still clouds the field.

How could a machine outmaneuver a human in a game of strategy? The answer isn\'t magic
--- it\'s #strong[method]. Early AI followed explicit rules; today\'s systems,
particularly machine learning, excel at #strong[finding patterns in data]. They
recognize statistical correlations and optimize performance through feedback. The
results may impress, but they don\'t imply understanding. The illusion fades when we see
AI for what it is: a tool for #strong[pattern recognition and optimization].

This misunderstanding persists because AI\'s inner workings are often opaque. Neural
networks, for example, are \"black boxes\": inputs go in, outputs come out, but the
intermediate steps are difficult to interpret. This opacity fuels the mystique, but it
also highlights a critical point: AI\'s power comes from its ability to process and
learn from data, not from any inherent intelligence.

== How AI Became Everywhere (and Everywhere Became AI)
AI\'s journey from laboratory curiosity to mainstream technology is a story of
#strong[evolution and specialization]. In its early days, AI was a broad, ambitious
field aiming to replicate human intelligence. Researchers explored symbolic reasoning,
expert systems, and even early neural networks. However, progress was slow, and
expectations often outpaced reality.

The turning point came with the rise of
#link("https://www.ibm.com/think/topics/machine-learning")[#strong[Machine Learning]]
#strong[(ML)] and
#link("https://www.ibm.com/think/topics/computer-vision")[#strong[Computer Vision]]
#strong[(CV)]. These subfields focused on solving specific, practical problems --- like
recognizing handwritten digits or classifying images --- rather than pursuing general
intelligence. For years, AI quietly powered tools like recommendation systems, fraud
detection algorithms, and driving assistants, #strong[augmenting human capabilities behind the scenes]. These applications demonstrated AI\'s potential long before it
became a household term.

The arrival of
#link("https://www.ibm.com/think/topics/large-language-models")[#strong[Large Language Models]] #strong[(LLMs)] in the 2020s thrust AI into the spotlight --- for better and
worse. Tools like ChatGPT transformed AI from an invisible enabler to a visible,
interactive force.

Today, when people say \"AI,\" they often mean
#link("https://www.ibm.com/think/topics/generative-ai")[#strong[generative AI]] ---
systems capable of producing human-like text, images, or even code. This transition from
specialized applications to broad, conversational interfaces has made AI more visible
and accessible than ever. However, it has also intensified the confusion around what AI
truly is. While LLMs excel at mimicking human communication, they remain statistical
models, not sentient beings.

#blog-img(
  "The_Evolution_of_AI-ChatGPT.png",
  alt: "Minimalist timeline showing four dominant AI approaches over time: Symbolic AI (designed intelligence, 1950s–70s), Statistical AI (measured intelligence, 1980s–90s), Neural Networks (learned intelligence, 2000s–2010s), and Foundation Models (scaled intelligence, 2020s), with a note that progress is enabled by advances in compute, data, and software.",
)

Understanding this evolution helps us appreciate AI\'s strengths and recognize its
boundaries. The term \"AI\" may now encompass everything from chatbots to self-driving
cars, but its core remains rooted in #strong[data-driven optimization and practical problem-solving].

= Neural Networks: Statistical Engines
As AI evolved from abstract theory to practical tools, ANNs emerged as its most powerful
--- yet most misunderstood --- workhorse. Unlike traditional rule-based systems, ANNs
represent a paradigm shift: they don\'t follow instructions, they #emph[learn] them.

== Why ANNs Aren\'t Algorithms
Neural networks are often mislabeled as \"algorithms,\" but this conflates two distinct
layers: the #strong[execution algorithm] and the #strong[model itself].

The execution --- training and inference --- #emph[is] algorithmic. We write precise
code to propagate data, compute gradients, and update weights. These steps are
deterministic and repeatable, though the #emph[results] of training are not fully
deterministic due to randomness in initialization and data sampling.

The #emph[model] --- the #strong[topology and learned weights] --- isn\'t an algorithm.
It\'s a #strong[statistical approximation], shaped by data. While we control the
skeleton (the architecture), the \"logic\" emerges from statistical optimization, not
explicit rules. The model doesn\'t follow a script. Instead, it adapts to minimize
error, which makes its behavior opaque --- even if its execution is transparent.

== The Black Box Trade-Off
The \"black box\" label for ANNs stems from this duality: while their #emph[execution]
is transparent, their #emph[behavior] remains unexplained. They achieve remarkable
accuracy --- recognizing images, translating languages, or predicting trends --- but
offer little in the way of
#link("https://en.wikipedia.org/wiki/Explainable_artificial_intelligence#Interpretability")[#emph[interpretability]]
into #emph[how] or #emph[why] they arrive at these results. This opacity is especially
problematic in high-stakes domains like healthcare or autonomous systems, where
#link("https://en.wikipedia.org/wiki/Explainable_artificial_intelligence#Explainability")[#emph[explainability]]
--- often referred to as
#link("https://www.ibm.com/think/topics/explainable-ai")[#strong[Explainable AI]]
#strong[(XAI)] --- is critical.

#callout[
  #strong[⚠️ Limitations of Mechanistic Interpretability] \
  Researchers study #link("https://arxiv.org/pdf/2604.21691")[the mechanics of learning]
  to uncover how models internalize patterns. Yet, as we explore in
  #link("https://davidjuhasz.dev/blog/brute-force-illusion-why-bigger-ai-models-arent-smarter")[Part 2], even mechanistic interpretability has limits: it reveals #emph[what] a model
  learned, but not #emph[why] or #emph[how] to generalize beyond its training data.
]

The issue isn\'t just technical; it\'s inherent to their design. ANNs prioritize
performance, trading interpretability for capability. Structures like
#link("https://papers.nips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf")[attention mechanisms] or #link("https://arxiv.org/abs/1312.6034")[saliency maps] add partial
explainability, but these are tools to #emph[steer] the statistical process, not true
explanations.

For engineers: ANNs deliver #emph[what] works, not #emph[why]. Use them for pattern
recognition when data is abundant, but pair them with symbolic systems if transparency
is critical.

= The AI Marketing Term
\"AI\" is no longer just a technical term for Artificial Intelligence --- it\'s a brand. The shift from laboratory to marketplace has transformed the word into a powerful, if often misleading, tool for selling everything from chatbots to toasters.

== How \"AI\" Became a Buzzword
The term \"AI\" has been stretched thin by marketing. In the 1950s, it was a bold vision
--- machines that could reason, learn, and solve problems. But as computing power grew,
so did the hype.

By the 2010s, \"AI\" became a shorthand for innovation, often slapped onto products
regardless of their actual sophistication. Startups and corporations latched onto the
term to attract investors and customers, using a vague, general label even when their
systems relied on specific, narrow applications. The result? #strong[\"AI\" now signals modernity --- not precision.] It\'s a label slapped on everything, reducing a diverse
field into a marketable buzzword.

== What the Hype Obscures
The marketing of \"AI\" obscures critical distinctions. It conflates narrow applications
with the grand ambition of
#link("https://en.wikipedia.org/wiki/Artificial_general_intelligence")[#strong[Artificial General Intelligence]] #strong[(AGI)]. It hides the limitations of current systems ---
ANNs, for instance, excel at pattern recognition but lack true understanding or
reasoning. Worse, it sidelines alternatives like symbolic AI, which offers transparency
and reliability in domains where black-box models fail.

By framing everything as \"AI,\" we lose sight of the tools\' unique strengths and
trade-offs. Engineers risk choosing the wrong approach for their problems, seduced by
the allure of a label rather than the merits of the method.

= Symbolic AI: The Unsung Hero
While ANNs dominate modern AI discussions, symbolic AI and rule-based systems remain
vital for tasks requiring logic, transparency, and explicit reasoning.

== Logic Over Learning
Symbolic AI, rooted in logic and explicit rules, offers a stark contrast to the
statistical nature of ANNs. Unlike ANNs --- which learn patterns from data --- symbolic
AI relies on predefined symbols and rules to represent knowledge and perform reasoning.

This approach excels in domains where interpretability, precision, and logical
consistency are critical, such as expert systems, formal verification, or rule-based
decision-making. While neural networks dominate tasks like image recognition or natural
language processing, symbolic AI shines in scenarios requiring transparent, explainable
logic. For engineers, this means choosing symbolic AI when the problem demands clarity
over pattern recognition, ensuring that decisions are traceable and reproducible.

== Real-World Hybrids
In practice, real-world systems often combine symbolic AI and statistical methods to
leverage the strengths of both. Symbolic AI provides the logical framework and
interpretability, while ANNs handle pattern recognition and adaptability.

Examples include:

- #strong[Autonomous vehicles]: ANNs handle perception; symbolic AI ensures rule-based decision-making.

- #strong[Healthcare diagnostics]: Statistical models analyze medical images; symbolic rules interpret results using clinical guidelines.

- #strong[Formal verification]: Transformers generate candidate proofs; symbolic systems verify them.

This hybrid approach ensures robustness, efficiency, and clarity --- proving that the
future of AI lies in integration, not exclusivity.

#callout[
  #strong[Neurosymbolic AI: Bridging the Gap] \
  The idea of combining neural networks with symbolic reasoning is gaining traction as
  #emph[neurosymbolic AI]. For a deeper dive into why agentic systems need ontologies and
  how neurosymbolic AI can address current limitations, check out this insightful talk
  from #link("https://www.frank-coyle.ai")[Frank Coyle]:
  #link("https://youtu.be/Sir59K8ZDPU")[Why Agentic Systems Need Ontologies].
]

#horizontalrule

#strong[AI is a toolkit, not a tool.] Use neural networks for patterns, symbolic AI for
logic --- and always match the method to the problem.

#strong[Next:] In
#link("https://davidjuhasz.dev/blog/brute-force-illusion-why-bigger-ai-models-arent-smarter")[Part 2], we explore why scaling alone can't deliver true reasoning and what might.
