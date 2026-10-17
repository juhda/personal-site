#let (blog-img, callout, horizontalrule) = eval(read("../_preamble.typ"), mode: "code")

Large Language Models (LLMs) are transforming how we work --- if you know #emph[how] to
use them. The hype calls them near-experts, but the truth is simpler: #strong[they mimic expertise, not possess it]. This post will help you leverage LLMs effectively, cut
through the AI hype, and avoid the pitfalls of AI slop.

You\'ll learn:

- Why LLMs #emph[seem] authoritative (even when they\'re wrong)

- Where they excel (and where they don\'t)

- How to use them as #strong[force multipliers], not replacements

By the end, you\'ll have a #strong[practical framework] to match LLMs to tasks --- and
#strong[avoid the Expert Illusion].

= The Expert Illusion: Why LLMs Aren\'t What They Seem
The tech world is abuzz with claims that LLMs are the next big leap --- tools so
advanced they #strong[seem] border on expertise. And yes, LLMs #emph[are] a leap:
they\'ve revolutionized how we process and generate text. But the unfounded buzz is that
they provide real expertise and will even leap into general intelligence. Beneath the
hype lies a fundamental truth: #strong[Their strength lies in pattern-matching, not reasoning]. They are brute-force statistical engines, trained to predict the next word
in a sequence, not to reason, understand, or judge.

Trained on vast datasets, they excel at mimicking confident, coherent responses --- even in domains where they lack knowledge. #strong[They store knowledge but don\'t truly understand it], reflecting syntactic patterns and hollow semantic matches, not true comprehension.

This disconnect between perception and reality is what I call the #emph[Expert Illusion]
--- the fallacy of assuming LLMs understand like humans do. This illusion isn\'t unique
to LLMs. As I\'ve
#link("https://davidjuhasz.dev/blog/brute-force-illusion-why-bigger-ai-models-arent-smarter")[written in Part 2], the AI industry\'s obsession with scaling models bigger has hit a wall:
brute-force approaches excel at pattern matching but fail at true reasoning, logic, and
efficiency. LLMs are a prime example.

Consider a high-stakes scenario: you ask an LLM, #emph[\"Can I mix these two household cleaners?\"] It replies confidently, #emph[\"Sure, it\'ll make them more effective.\"]
You combine them, toxic fumes fill the room, and you end up in the hospital. Later, you
confront the model. Its apology --- #emph[\"Oh, sorry. You\'re right, that\'s dangerous\"] --- reveals the harsh truth: the LLM never #emph[knew]. It mimicked
confidence, but there was no understanding, no accountability.

This dynamic also explains the rise of #emph[AI slop] --- content that looks polished
but lacks depth or originality. LLMs are trained to mimic confident, coherent responses,
even in domains where they lack true knowledge. Without human oversight, their outputs
can be #strong[syntactically perfect but semantically hollow], lulling users into a
false sense of comprehension. After all, #strong[confidence, whether human or artificial, is no substitute for competence].

This isn\'t to dismiss LLMs entirely. They #emph[are] powerful tools, but their power
lies in their ability to process and generate text at scale, not in their judgment. The
illusion persists because LLMs are designed to #emph[sound] authoritative, regardless of
accuracy. Their fluency masks their lack of true comprehension, and their confidence can
lull users into a false sense of security.

The takeaway? #strong[They are tools, not judges] --- useful, yes, but only when wielded
by those who understand their limits.

= LLM Use Cases: Where They Excel and Where They Fail
To use LLMs effectively, #strong[treat them as collaborators, not oracles]. The
framework below helps you do just that: a #strong[2x2 matrix] based on #strong[data availability] (how much relevant information the LLM has seen) and #strong[task complexity] (how much reasoning or nuance the task requires).

#blog-img(
  "LLM_Usage-ChatGPT.png",
  alt: "A 2×2 matrix illustrating how to use large language models (LLMs) based on data availability and task complexity. The horizontal axis represents task complexity (low to high), and the vertical axis represents data availability (low to high). The four quadrants are: Automation (high data, low complexity), Collaboration (high data, high complexity), Cautious Assistance (low data, low complexity), and Expert-Guided Support (low data, high complexity). Each quadrant includes example tasks and recommended levels of human involvement, emphasizing that LLMs are most effective when their role is matched to the characteristics of the task.",
)

This matrix reveals four distinct ways to use LLMs effectively:

+ #strong[Automation]: In #strong[high-data, low-complexity] tasks, use LLMs autonomously for efficiency as they deliver consistent and reliable outputs with minimal oversight.

+ #strong[Collaboration]: For #strong[high-data, high-complexity] tasks, use LLMs collaboratively to generate ideas or drafts that humans then refine and validate.

+ #strong[Cautious Assistance]: In #strong[low-data, low-complexity] scenarios, use LLMs with careful validation where knowledge gaps may affect reliability.

+ #strong[Expert-Guided Support]: In #strong[low-data, high-complexity] tasks, use LLMs as a supporting tool while relying on human expertise for judgment and decision-making.

== Why This Framework Works
#link("https://openai.com/index/scaling-laws-for-neural-language-models/")[#strong[Scaling laws]] established that the more data and training, the better model performance,
aligning with a brute-force approach to improvement. However, recent studies have shown
that
#link("https://deepmind.google/blog/an-empirical-analysis-of-compute-optimal-large-language-model-training/")[it can be more efficient to train smaller models], and that
#link("https://aclanthology.org/2025.acl-long.1163/")[the quality of the dataset is also critical for performance]. Both observations make intuitive sense: overprovisioning
compute resources involves waste beyond a certain point, and random or repetitive data
does not contribute to learning meaningful patterns.

This brute-force approach also has its limits when it comes to #strong[task complexity].
#link("https://machinelearning.apple.com/research/illusion-of-thinking")[Recent research from Apple] demonstrated that both LLMs and Large Reasoning Models (LRMs) struggle under
high-complexity tasks. Curiously, LRMs can even underperform on low-complexity tasks due
to \"overthinking\" --- a reasonable outcome if a reasoning model is trained to approach
every problem with depth, regardless of its simplicity.

These insights validate the 2x2 matrix: #strong[LLMs excel in high-data, low-complexity tasks but falter when data is scarce or reasoning is required.] By categorizing your use
case, you can leverage their strengths while mitigating their weaknesses.

= The AI Expertise Paradox: Why LLMs Shine In Ignorance
The 2x2 matrix helps you #emph[match LLMs to tasks], but it doesn\'t fully explain #emph[why] they #emph[appear] so differently across domains. Here\'s the paradox: #strong[LLMs are fascinatingly brilliant in everything you #emph[don\'t] understand, and fascinatingly vague in everything you #emph[do].]

This isn\'t a bug --- it\'s a #strong[feature of their statistical nature]. In areas
where you lack expertise, LLMs can #emph[appear] impressively knowledgeable because
they\'ve ingested vast amounts of data and can mimic the patterns of confident, coherent
responses. Yet, in your own field, their outputs often feel shallow or generic because
they lack true comprehension. They\'re reflecting back #strong[syntactic patterns, not semantic depth].

#strong[The asymmetry:]

- #strong[Unfamiliar domains:] Use LLMs as #strong[exploratory tools] --- but validate rigorously.

- #strong[Familiar domains:] Use them as #strong[sounding boards] --- but never as final arbiters.

#blog-img(
  "LLM_Impressiveness-ChatGPT.png",
  alt: "A conceptual diagram showing how the perceived impressiveness of LLM output changes with a user's familiarity with a domain. As familiarity increases from low to high, perceived impressiveness steadily declines. Three stages are highlighted: “Brilliant in Ignorance,” where outputs feel insightful but are difficult to evaluate; “The Sweet Spot,” where moderate familiarity allows users to recognize both value and limitations; and “Vague in Expertise,” where experts readily identify omissions, inaccuracies, and superficial reasoning. The key message is that while LLM outputs may seem less impressive to experts, moderate familiarity provides the best balance between learning and critical evaluation.",
)

= Reasonable Use Cases and Best Practices
LLMs are not magic, but their versatility is undeniable. Their value lies in tasks where
their strengths --- pattern recognition, memorization, and linguistic fluency --- align
with your needs. The key is to use them as collaborators, not oracles.

== Where LLMs Add Value
LLMs excel in tasks that leverage their strengths in #strong[language, knowledge, and pattern recognition]. Here\'s how to use them effectively in practical scenarios:

+ #strong[Language Tasks] \
  LLMs excel at processing and generating text. Use them to:

  - #strong[Summarize] dense documents, saving time without sacrificing understanding.

  - #strong[Refine prose]: Fix grammar, adjust tone, or rewrite for clarity. They\'re like a tireless copy editor, but always double-check their suggestions against your intent.

  - #strong[Translate or localize] content, though nuanced or idiomatic text may require human review --- especially in low-data scenarios (e.g., rare languages or niche domains).

+ #strong[Knowledge Augmentation]

  - #strong[Quick research]: Surface relevant concepts, frameworks, or prior art to jumpstart your thinking. Verify their outputs against trusted sources.

  - #strong[Synthesis]: Combine insights from multiple documents or threads into a cohesive overview. Cross-reference critical details to avoid hallucinations.

+ #strong[Data Preparation]

  - #strong[Extract key details] from unstructured or semi-structured text like invoices, contracts, or emails. #emph[Use for non-critical tasks; supervise for exact results.]

  - #strong[Categorize or tag] unstructured text (e.g., support tickets, survey responses). #emph[Use for exploration; validate for accuracy.]

+ #strong[Problem Solving] \
  LLMs can generate solutions for specific, well-defined problems --- #strong[but typically require close guidance and strong expertise in the #emph[problem domain].] For example, #link("https://www.anthropic.com/research/claude-code-expertise")[Anthropic\'s study] shows that the better you understand the task, the better the LLM\'s output.

  - #strong[Beware the #emph[solution domain]]: While you may confirm that a solution works for your problem, assessing #emph[how well] it works can be tricky. For instance, an LLM might generate a Python script that solves your immediate data-cleaning task. But without coding expertise, you won\'t know if it\'s inefficient for large datasets or if it introduces subtle bugs.

  - #strong[One-off, disposable solutions]: Use these solutions for the problem at hand if they meet your needs. However, do not expect them to generalize or apply beyond their original context.

+ #strong[Professional Workflows] \
  LLMs can accelerate workflows when used deliberately. For example, in #strong[software engineering]:

  - #strong[Code explanation and troubleshooting]: Ask them to break down complex code --- even assembly --- into plain English or debug tricky logic. This is especially useful for legacy systems or unfamiliar codebases.

  - #strong[Brainstorming]: Need user stories, test cases, or edge cases? LLMs can generate ideas quickly, but treat their output as a #emph[starting point], not a final product.

  - #strong[Automation]: Draft boilerplate, tests, or features, but enforce rigorous validation. Pair LLMs with existing best practices: define interfaces and tests first (e.g., via #link("https://davidjuhasz.dev/blog/tdd-pragmatic-correctness-guide")[TDD]), then let the LLM fill in the gaps --- #emph[never the other way around].

== Specialized LLM Tools
When LLMs are wrapped in #strong[targeted enhancements, guidelines, and guardrails],
they can approach expert-level reliability for specific tasks. These tools force
reasonable use by design --- limiting scope, enforcing validation, and guiding users
toward responsible application. For example:

- #strong[Domain-specific assistants] (e.g., legal document review, report analysis, or policy compliance checks) can deliver consistent results #emph[if] built with strict constraints and oversight.

- #strong[Automated workflows] for natural language tasks, such as categorizing and routing customer support tickets or extracting key details from contracts. Still, don\'t use LLMs for tasks where dedicated, deterministic tools already exist, for example code linting or style checking in software engineering.

- #strong[Agentic systems] that perform actions #emph[on behalf of users], such as automating repetitive tasks. #strong[Never grant unrestricted access] to sensitive systems or data. Responsible use requires strict boundaries and oversight.

#strong[Remember]: Even in these cases, blind trust is unwise. Always match the tool to
the task and validate its output.

== Best Practices for Responsible Use
- #strong[Validate, validate, validate]: LLMs hallucinate and can produce AI slop --- outputs that are syntactically perfect but semantically hollow. Treat their outputs like a junior colleague\'s work: useful, but requiring oversight. For high-stakes decisions (e.g., legal, medical, or safety-critical systems), #emph[always] involve a domain expert.

- #strong[Understand the limits]: LLMs struggle with reasoning, causality, and context. If a task requires deep logic or nuanced judgment, use them as a #emph[sparring partner], not a decision-maker. Without domain knowledge, it\'s nearly impossible to distinguish between a precise explanation and a convincing facade. This is how AI slop spreads.

- #strong[Guide with precision]: The quality of an LLM\'s output depends on your input. Provide clear constraints, examples, and step-by-step instructions. Vague prompts yield vague results.

- #strong[Iterate]: Use LLMs to draft, then refine collaboratively. Their first answer is rarely their best.

#horizontalrule

LLMs are #strong[force multipliers] for the right tasks, but they can\'t replace human
judgement. Use them to handle the mundane, explore possibilities, or augment your skills
--- then apply your own judgment to separate the wheat from the chaff.

= Working Effectively with LLMs
LLMs aren\'t magic --- they\'re #strong[amplifiers of human intent]. Their strengths in
pattern recognition, summarization, and brainstorming only shine when paired with
#strong[your judgment].

#strong[Use them to augment, not replace.] For well-defined tasks, LLMs can automate
steps --- #emph[if] you enforce validation, guardrails, and oversight.
#strong[Confidence ≠ competence.]

#strong[Key Takeaways]

+ #strong[Match the tool to the task]: Use the 2x2 matrix to assess fit.

+ #strong[Validate relentlessly]: Treat outputs as drafts, not truths.

+ #strong[Guide with precision]: Write prompts like job descriptions --- specific and constrained.

+ #strong[Iterate]: Refine collaboratively; the first answer is rarely the best.

#horizontalrule

LLMs amplify your intent --- #strong[for better or worse]. The difference? #strong[Your judgment, your constraints, and your willingness to validate.] The tool is only as smart
as the system around it, and that system starts with #emph[you].

#callout[
  #strong[Related Content:] \
  For a grounded and insightful analysis of the AI hype cycle and its popular history,
  check out the talk #link("https://youtu.be/uWnUnMphmPM")[#emph[Beyond the AI Hype] --- #emph[What\'s Real, and What\'s Next]]. It elaborates on the context and driving forces
  behind LLMs in an easy-to-follow and enjoyable presentation, reinforcing the idea that
  LLMs are tools to be wielded thoughtfully, not oracles to be blindly trusted.
]
