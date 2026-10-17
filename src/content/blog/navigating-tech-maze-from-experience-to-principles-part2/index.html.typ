#let (blog-img, callout, horizontalrule) = eval(read("../_preamble.typ"), mode: "code")

In
#link("https://davidjuhasz.dev/blog/navigating-tech-maze-strong-opinions-constructive-discontent-part1")[#strong[Part 1]], we established that navigating a software engineering career requires a robust
#strong[adaptive GPS system] --- where #strong[principles act as routing preferences]
and #strong[experience fuels real-time adjustments]. Recall: #emph[Strong opinions, weakly held] = your GPS; #emph[constructive discontent] = your map updates.

A GPS is useless without calibration. In software development, that means turning
experiences into #strong[evidence-based principles] --- your routing preferences for the
tech maze.

In this second part, we'll focus on #strong[how to distill experiences into principles],
distinguish them from rigid processes, and apply them across varied terrain --- whether
that's different problem domains, team dynamics, or organizational constraints.

= Recap: Core Components of Our Navigation System
From #strong[Part 1], our system relies on:

+ #strong[Strong opinions, weakly held] → #strong[The core GPS algorithm], making #strong[turn-by-turn decisions] based on real-time data while staying open to rerouting.

+ #strong[Constructive discontent] → Your cartography team, constantly scouting for better routes #emph[without rejecting functional ones].

Now, let's #strong[calibrate this system] for real-world use.

#strong[🔄 The Calibration Cycle]

#blog-img(
  "Calibration_Cycle-ChatGPT.png",
  alt: "Diagram showing the adaptive development cycle: Experience feeds into Evidence, which distills into Principles, guiding Decisions. A feedback loop from Decisions back to Experience emphasizes continuous improvement. The flow visualizes how real-world work informs better practices over time.",
)

This cycle ensures your navigation system stays responsive to real-world conditions.

= From Experience to Evidence-Based Principles
Your GPS relies on accurate data. In software development, that data comes from
#strong[systematic reflection] --- not just what you've tried, but what you've
#emph[learned]. Evidence trumps stubbornness.

== Building Valid Evidence
Evidence comes from four sources:

+ #strong[Production-proven Projects] #emph[(even small or incidental)]

  - What worked under real-world conditions (not just theory).

  - Unexpected detours and tradeoffs made.

+ #strong[Failed Experiments] #emph[(yours and others\')]

  - Dead ends, roadblocks, and why approaches failed.

  - Common failure patterns and warning signs.

+ #strong[Performance Metrics] #emph[(often elusive)]

  - Real-time traffic data: customer success measures, system behavior under load, and long-term maintenance costs.

+ #strong[Peer Feedback] #emph[(context matters)]

  - Crowdsources route updates: colleagues\' pain points and usability observations.

== From Evidence to Conviction
This evidence-based approach is what makes our opinions \"strong\" rather than just
stubborn. Your #strong[strong opinions] gain strength when they're:

- Grounded in multiple real-world observations,

- Validated across different contexts,

- Open to revision as new evidence emerges,

- Free from personal biases #emph[wherever] possible.

#strong[Important:] Others may not yet have encountered the experiences that shaped your
convictions. People develop their own principles through lived work --- #strong[not by adopting yours secondhand]. Maintain open dialogue, but recognize that alignment takes
time and varied exposure.

= Principles Over Processes
Principles are #strong[routing preferences] (e.g., \"avoid highways\" or \"prioritize
scenic routes\"), while processes are #strong[turn-by-turn directions] (e.g., \"take
Exit 42\"). These preferences aren't just guesswork --- they're #strong[evidence-backed defaults], honed by experience into something closer to muscle memory for seasoned
engineers. That muscle memory lets you assess a situation quickly, without re-examining
every variable, because the underlying principles have been validated repeatedly.
Processes, by contrast, demand rigid adherence to predefined steps, assuming the path
ahead is fully charted. Principles recalculate when conditions change; processes fail
when the road isn't in the system.

== Principles vs. Processes
#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([], [#strong[🧭] Principles (Routine Preferences)], [#strong[📋] Processes (Turn-by-Turn Directions)]),
    table.hline(),
    [#strong[Nature]], [Guiding philosophy], [Prescriptive rules],
    [#strong[Application]], [Adaptable to context], [Context-blind],
    [#strong[Scope]], [Broader concepts], [Specific implementations],
    [#strong[Lifespan]], [Long-term], [Short-term],
    [#strong[Focus]], [Inquiry-based (\"What's right here?\")], [Directive (\"Do it this way\")],
  ),
  kind: table,
)

In a broad sense, processes include:

- Specific programming languages and frameworks

- Development workflows and toolchains

- Architectural patterns

- Methodologies

The key distinction: Principles ask #emph[\"What\'s the right approach here?\"] while
processes demand #emph[\"Follow these exact steps.\"] There are no universal
turn-by-turn solutions in software development --- only #strong[adaptive routing preferences] that evolve with the terrain.

#emph[Example:] Agile #emph[principles] endure; forcing Scrum #emph[process] everywhere
often backfires.

== Distilling Effective Principles
#blog-img(
  "Distilling_Principles-ChatGPT.png",
  alt: "A funnel diagram showing how raw experiences, failed experiments, metrics, and peer feedback enter at the top as messy inputs. In the middle, a filtering stage of reflection, testing, and discussion distils them. At the bottom, clear labelled cards emerge as actionable principles. The flow illustrates how chaotic evidence is refined into practical guidance.",
)

#strong[Messy inputs like experiences and feedback are refined through reflection into valuable principles.]

To convert experiences into actionable principles:

+ Identify recurring patterns across projects.

+ Separate enduring concepts from temporary implementations.

+ Focus on #strong[outcomes over tools].

+ Validate through peer discussion and testing.

#emph[Example:] After premature optimization caused maintenance headaches, a principle
emerges: #strong[\"Optimize based on measured bottlenecks, not speculation.\"]

== Strengths of Principle-Guided Navigation
A principle-guided approach offers many advantages over rigid processes, but three core
strengths stand out to me as particularly valuable in software development:

#blog-img(
  "Principle-Guided_Navigation-ChatGPT.png",
  alt: "Diagram titled 'Principle-Guided Navigation' showing a triangular framework with three pillars: 1) Universal adaptability (globe icon) representing cross-context applicability, 2) Outcome-driven empowerment (target icon) representing focus on results over prescriptive methods, and 3) Structured flexibility (cyclical arrow icon) representing adaptive yet guided approaches. The compass at the top symbolizes navigational guidance through principles.",
)

+ #strong[Universal adaptability:] Applies across contexts and technologies, evolves with tech.

+ #strong[Outcome-driven empowerment:] Provides direction without prescription.

+ #strong[Structured flexibility:] Guides practice while allowing creative freedom.

#emph[Example:] #strong[\"Automate validation\"] might mean:

- #emph[Legacy system]: Characterization tests before changes.

- #emph[Greenfield project]: Full CI/CD from day one.

== Maintaining Balance
Principles aren't static --- they evolve as you deepen your understanding of #emph[why]
they work and #emph[how] they apply in new contexts. The key to longevity is
#strong[active calibration]:

+ #strong[Reflect regularly]

  - #emph[Are principles delivering the intended results? What worked --- or didn't --- and why?]

  - #emph[Example:] Quarterly \"Principle Review\" sessions to assess fit with current goals.

+ #strong[Clarify the purpose]

  - Pair principles with their #emph[why] so teams can adapt them intentionally.

  - #emph[Example:] Instead of \"Code reviews required,\" say #emph[\"We do code reviews to share knowledge and catch critical bugs early --- not to slow down small fixes.\"]

+ #strong[Adapt to context]

  - Adjust application when outcomes drift from goals or when the team, technology, or constraints change.

  - #emph[Example:] \"No meetings without agendas\" --- Except for time-boxed brainstorming.

== The Power of Shared Principles
Principles shine when #strong[the entire team uses the same map]. They work best when:

- Used as preferences, not rigid rules.

- Align teams toward shared goals.

- Prevent misalignment by clarifying the #emph[why].

However, #strong[misaligned principles create friction]. When one engineer operates by
#emph[\"perfect is the enemy of done\"] while another insists #emph[\"quality is non-negotiable,\"] every decision becomes a negotiation. The team stalls at crossroads,
debating priorities rather than advancing.

The solution isn\'t uniform thinking --- it\'s #strong[aligned principles and shared situational awareness]. High-performing teams move faster because they agree on core
routing preferences and understand how to apply them in context. #strong[Cultural fit]
isn't about personality --- it's about sharing the same #strong[routing preferences and trusting] each other to navigate with them.

= Adaptability Across Contexts
#strong[Principles bend without breaking] --- like a GPS recalculating after a missed
turn. They maintain their core value while adapting to constraints, whether those come
from different problem domains, team structures, or organizational realities.

== Navigating Different Problem Domains
Principles provide consistent guidance across diverse technical challenges.

#emph[Example:] #strong[\"Deliver functional value early, then incrementally add complexity\"] applies differently but effectively to:

- #strong[Computer Vision:] Basic image ingestion → resizing/conversion → object detection.

- #strong[Compiler Development:] Dummy end-to-end flow → basic instructions → advanced optimizations.

Both implementations share the core principle but adapt to their domain\'s specific
requirements.

== Adapting to Team Dynamics
The effective implementation of principles depends on key team characteristics:

+ Team size and structure

+ Expertise levels

+ Project phase

+ Organizational culture

#emph[Example:] #strong[\"Shared code ownership\"]

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Context], [How the Principle Adapts], [Rationale]),
    table.hline(),
    [10-person startup], [Full repo access, no formal approvals], [High trust; full-system understanding],
    [100-person enterprise], [Subsystem ownership + cross-team reviews], [Maintains quality at scale],
    [#strong[Mixed-seniority team]],
    [Juniors: guided changes; Seniors: mentor + architect],
    [Balances learning and risk management],
    [#strong[Greenfield project]], [Collective ownership of new modules], [Enables rapid iterations in fresh codebases],
    [#strong[Brownfield system]],
    [Ownership tied to domain expertise],
    [Preserves stability through institutional knowledge],
  ),
  kind: table,
)

How the principle is applied changes with context.

== Working Within Constraints
Principles guide incremental progress amid real-world constraints:

#figure(
  table(
    columns: 5,
    align: (auto, auto, auto, auto, auto),
    table.header([Constraint], [Principle], [First Step], [Scaling Up], [Why It Works]),
    table.hline(),
    [#strong[Legacy systems]],
    [#emph[Automated validation]],
    [Characterization tests before changes],
    [Expand to critical paths],
    [Prevents regressions while enabling safe changes],
    [#strong[Compliance needs]],
    [#emph[Transparent processes]],
    [Document decision rationale],
    [Automate compliance checks],
    [Meets requirements efficiently],
    [#strong[Tight deadlines]],
    [#emph[Focused validation]],
    [Test only changed components],
    [Add high-risk areas tests],
    [Preserves quality under time pressure],
    [#strong[Limited resources]],
    [#emph[Smart automation]],
    [Automate most painful tasks first],
    [Gradually automate more],
    [Maximizes impact with minimal effort],
  ),
  kind: table,
)

Each row demonstrates how principles can be applied with the minimal viable application,
then scaled toward the ideal state incrementally.

#horizontalrule

#emph[Key insight:] #strong[Principles aren\'t compromised by adaptation --- they\'re proven by it]. Their durability comes from maintaining core objectives while flexibly
navigating real-world circumstances

= Your Navigation System in Action
Your career isn't a straight path --- it's a dynamic journey. #strong[Principles] set
routing preferences; #strong[strong opinions] guide decisions; #strong[constructive discontent] updates the map. They form an adaptive navigation system that cuts through
noise, balances conviction with flexibility, and turns experience into actionable
direction.

Now it's your turn to build it:

+ #strong[Identify 2-3 key principles] for your work.

+ #strong[Audit their evidence:] Separate battle-tested paths from anecdotes.

+ #strong[Sync with your team:] Ensure shared understanding.

+ #strong[Review and adapt:] Update as the terrain changes.

This isn't about perfection --- it's about #strong[progress with purpose].

The best engineers don't follow a fixed path. They navigate with clarity, adapt with
evidence, and move forward #emph[together].
