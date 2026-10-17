#let (blog-img, callout, horizontalrule) = eval(read("../_preamble.typ"), mode: "code")

#strong[Your best work disappears --- along with your recognition.]

Consider an aircraft's flight system: triple redundancy, failover protocols, seamless
operation. No heroic rescues. That's how #strong[proactive engineering work]
operates --- until someone asks, #emph[\"Why fund what never fails?\"]

You write tests, harden systems, design fallbacks --- all to ensure #strong[nothing goes wrong]. The result? Silence. No incidents. No proof you were needed at all.

#strong[That's the Visibility Paradox:] The more you prevent failure, the more you must prove you were even there. The engineer who averted the disaster? Invisible. The team that fixed last month's outage? Celebrated.

#strong[The litmus test:] If you spend #strong[more than 20% of your time #emph[proving] your work instead of #emph[doing] it], the system is misaligned. Not in a
\"fixable-by-you\" way --- in a #emph[structural] way.

This isn't a cultural quirk. It's #strong[how control systems work]: Visibility isn't a
byproduct of good work --- it's the #strong[price of entry]. That is #strong[the legibility tax.]

This post will help you:

- #strong[Diagnose the root cause]: Why organizations hide your highest-impact work.

- #strong[Spot the divide]: Are you a Hero (firefighter) or an Architect (preventer)? And which does your team #emph[actually] reward?

- #strong[Pull the right levers]: Tactics to reframe your work, automate proof, and make the system carry the burden of visibility.

- #strong[Decide your next move]: Recalibrate your environment --- or find one that values prevention over heroics.

= Organizations as Control Systems
#emph[Every meeting, report, or KPI isn\'t bureaucracy --- it's the price of control.]

Imagine your organization as an #strong[aircraft]:

- Executives = pilots

- Teams = subsystems (navigation, propulsion)

- Metrics = cockpit displays

#strong[The question]: #emph[How much of those readings is signal, and how much is noise?]

In engineering, instrumentation exists to observe and adjust. In organizations, the same
logic applies --- but the \"sensors\" (reports, dashboards) often feel like drag.

== Why Your Work Gets Buried
Hierarchies aren't arbitrary; they're control systems answering two questions:

- #strong[Are we on course?] (Observability)

- #strong[How do we correct if we're not?] (Steerability)

#strong[Observability isn't free.] Every sensor adds weight; every report adds friction. The trade-off is baked in:

- #emph[Startups] operate like #strong[gliders]: minimal instrumentation, high trust. A single Slack message reroutes priorities.

- #emph[Enterprises] resemble #strong[airliners]: layered redundancy, rigid protocols. A 10-page document precedes trivial changes.

== How Control Systems Fail Engineers
- #strong[Legibility traps]: Systems prioritize #emph[easy-to-track] proxies (meetings held, docs filed) over #emph[meaningful] outcomes (risks mitigated).

- #strong[Human sensor problem]: If the system can't #emph[see] your work, it assumes it isn't happening --- so it adds more \"sensors\" (reports, approvals) until it can.

- #strong[Signal vs. noise]: In startups, a senior engineer tweaks design at will; in enterprises, the same decision requires a 10-page doc.

#strong[The system's question isn't #emph[\"Are you doing great work?\"] --- it's #emph[\"Can we see you doing great work?\"]] And if the answer is no, it will keep adding sensors.

== Is Your Organization Measuring the Wrong Things?
Your frustration isn't with #emph[control] --- it's with #strong[inefficient instrumentation] that fixates on the wrong details.

The goal isn't to eliminate overhead --- it's to #strong[calibrate it]. Ask:

- Which metrics actually correlate with #emph[stability]?

- Where can we automate observability?

- How much legibility tax is too much?

The misalignment isn't random. It follows predictable laws that turn metrics into
targets, replacing purpose with process and creating the #emph[illusion] of control.
Those laws explain why your organization feels optimized for #emph[documenting] work,
not #emph[doing] it.

= 3 Laws That Sabotage Your Impact
#emph[Large organizations follow predictable laws --- like physics.] Most organizational
friction stems from #strong[incentive misalignment]: the gap between what the
organization says it wants and what it actually rewards. Recognize these laws to work
with the system, not against it.

== Goodhart's Law: When Metrics Become the Mission
#callout[
  When a measure becomes a target, it ceases to be a good measure.
]

--- #strong[Charles Goodhart]

#strong[The Core Issue:] Goodhart's Law is about the #strong[loss of information]. Once
a metric is used for control, it loses its ability to signal the truth about the system.

- #strong[Where you've seen this:] Teams measured by \"tickets closed\" split work into atomic, meaningless tasks. The dashboard glows green, but the information regarding \"system health\" is lost as technical debt explodes.

- #strong[The behavior:] Organizations gravitate toward #emph[legible] proxies that are easy to track and easy to corrupt. Simple metrics create simple behaviors --- often at the expense of quality.

- #strong[The Countermeasure:]

  - If you control the metrics, replace activity with outcomes (e.g., \"post-deploy incident rate\").

  - If you don't, hit the target and #strong[redefine success] by tying results to outcomes. #emph[\"We met our PR goal and cut returning support tickets by 30% by addressing root causes.\"] This steers the conversation toward better metrics.

== Campbell's Law: Metrics Corrupt What They Measure
#callout[
  The more any quantitative social indicator is used for social decision-making, the more
  subject it will be to corruption pressures…
]

--- #strong[Donald T. Campbell]

#strong[The Core Issue:] While Goodhart focuses on the signal, Campbell focuses on the
#strong[corruption of the process]. The harder you push a metric, the faster the culture
degrades to meet it.

- #strong[Where you've seen this:] Sales representatives graded on \"customer visits\" pack calendars with low-value meetings. The activity metric soars; actual deals stagnate.

- #strong[The behavior:] If \"uptime\" is the sole KPI, teams over-provision infrastructure or under-report failures. The dashboard stays green; the system degrades.

- #strong[The Countermeasure:] #emph[Balance metrics]. Pair \"uptime\" with \"cost per request.\" For every metric, ask: \"What behavior does this reward?\" If the answer isn't the outcome you want, complement it with a counter-metric.

== Parkinson's Law: The Self-Perpetuating Process
#callout[
  Work expands so as to fill the time available for its completion.
]

--- #strong[C. Northcote Parkinson]

#strong[The Core Issue:] Organizations suffer from #strong[\"The Law of Triviality\" (or Bike-Shedding)] --- the tendency to spend disproportionate time on trivialities (like the
color of a bike shed) because they are easy to grasp, while complex issues go
unexamined.

- #strong[Where you feel it:] A quick sync bloats into a 60-minute session with 12 attendees. A trivial change requires a \"pre-meeting\" to align on a document before work begins.

- #strong[The behavior:] You spend 2 hours documenting a 10-minute fix because \"visibility\" is used as a shield against risk. This is risk aversion disguised as diligence.

- #strong[The Countermeasure:]

  - #emph[Default to async] written updates --- writing forces precision; reading forces engagement.

  - #emph[Set artificial deadlines]: \"This decision moves forward by Friday --- silence equals consent.\" Deadlines don't just create urgency; they reveal what's truly necessary.

  - #emph[Tune processes] so that every step adds actual value.

== The Tax of Visibility
Together, these laws ensure a predictable decay:

+ #strong[Information Loss:] Work bends toward what is easy to measure, rendering the metrics \"blind\" (Goodhart's).

+ #strong[System Corruption:] What is measured is gamed, distorting the actual work (Campbell's).

+ #strong[Process Bloat:] The gaming and the \"visibility\" of the work become more important than the work itself (Parkinson's).

In this context, #strong[visibility isn't a byproduct of good work --- it's the currency].
The question shifts from #emph[\"How do we eliminate friction?\"] to #emph[\"Where do we choose to spend it?\"]

This visibility tax doesn\'t just distort metrics --- it creates a cultural fault line:
the gap between the #strong[heros] who get promoted for #emph[fixing] visible crises and
the #strong[architects] who are ignored for #emph[preventing] them.

= Hero vs. Architect: Which Culture Dominates Your Team?
Every team sits on a spectrum:

- #strong[Heroes] are the firefighters --- the engineers who thrive in chaos and are celebrated because they directly avert disaster or deliver immediate results in crises. The organization #emph[sees] their impact because the alternative (failure) is tangible.

- #strong[Architects] are the preventers --- the engineers who mitigate chaos and are overlooked because nothing breaks when they succeed. No fires. No escalations. Just a system that quietly hums along.

#strong[How the Cultures Compare]

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Trait], [Heroes], [Architects]),
    table.hline(),
    [#strong[Visibility]], [High (crises are public)], [Low (success is silent)],
    [#strong[Recognition]], [Celebrated (saved the day!)], [Overlooked (nothing broke)],
    [#strong[Risk Tolerance]], [Thrives in chaos], [Mitigates chaos],
    [#strong[Work Style]], [Reactive (fixes fires)], [Proactive (prevents fires)],
    [#strong[Org's Perception]], [\"Indispensable\"], [\"Invisible\"],
    [#strong[Career Growth]], [Promoted for heroics], [Stagnates without advocacy],
    [#strong[Key Metric]], [\"Incidents resolved\"], [\"Incidents #emph[avoided]\"],
    [#strong[Legibility Tax]], [Low (work is obvious)], [High (must prove value)],
  ),
  kind: table,
)

The Hero-Architect spectrum isn\'t just about work styles --- it exposes deeper #strong[cultural principles] at play. Misalignment between personal principles and team culture leads to frustration, burnout, and stalled growth. #link("https://davidjuhasz.dev/blog/navigating-tech-maze-from-experience-to-principles-part2")[Understanding your team\'s shared principles] can help you determine whether your work style aligns with the culture --- or if you\'re fighting an uphill battle against entrenched norms.

#blog-img(
  "Hero-Architect_Spectrum-ChatGPT.png",
  alt: "The Hero-Architect Spectrum: Where does your team sit? Heroes (firefighters) thrive on visible crises; Architects (preventers) build invisible resilience. The gap between them reveals your culture’s true priorities — and whether your work is being recognized or overlooked. Arrow annotations: Visibility ≠ Impact. The left rewards urgency; the right demands advocacy.",
)

== The Startup-Enterprise Reality
The irony: Startups #emph[act] like they need Heroes (speed! hustle!) but survive via
Architect work (scalable systems, automation). Enterprises #emph[claim] to want
Architects (stability! process!) but reward Heroics.

#strong[The real question isn't about company size] --- it's about:

+ #strong[Where your team sits] on the Hero-Architect spectrum

+ #strong[Whether they\'re willing to shift] and how much #strong[you] can influence that

#strong[Your move] --- not the organization's type --- determines whether you thrive or burn
out.

= How to Rewire Recognition
The problem isn't that proactive work is invisible --- it's that organizations are wired
to #emph[react to] what's urgent, not #emph[invest in] what's important. Fixing this
requires recalibrating feedback loops at both the systemic and individual levels.

== Systemic Fixes: Make Prevention Visible at Scale
Large organizations drown in #emph[activity metrics] (tickets closed, meetings attended)
while starving for #emph[outcome metrics] (system reliability, risk reduced).

#strong[How Metrics Shape Culture:]

#figure(
  table(
    columns: 4,
    align: (auto, auto, auto, auto),
    table.header(
      [Aspect],
      [#strong[Activity Metrics (Hero Culture)]],
      [#strong[Outcome Metrics (Architect Culture)]],
      [How to Shift],
    ),
    table.hline(),
    [#strong[Focus]],
    [What you #emph[do]],
    [What you #emph[achieve]],
    [Replace \"tasks completed\" with \"problems solved\"],
    [#strong[Example Metrics]],
    [Tickets closed],
    [Customer-impacting incidents reduced],
    [Track \"risks mitigated\" not \"tasks done\"],
    [], [Meetings attended], [System reliability improved], [Measure \"reliability gains\" not \"attendance\"],
    [], [Lines of code written], [Technical debt reduced], [Count \"complexity reduced\" not \"lines added\"],
    [], [PRs merged], [Deployment failure rate], [Monitor \"quality\" not \"quantity\"],
    [#strong[Behavior Rewarded]],
    [Firefighting],
    [Fire prevention],
    [Celebrate \"crises avoided\" not just \"crises solved\"],
    [#strong[Organizational Impact]],
    [Creates dependency on heroes],
    [Builds self-healing systems],
    [Ask: \"Did this make the system better or just busier?\"],
    [#strong[Long-term Effect]],
    [Technical debt accumulates],
    [Operational resilience improves],
    [Measure \"future work avoided\" not \"current work done\"],
    [#strong[Cultural Message]],
    [\"We handle the chaos\"],
    [\"We design out the chaos\"],
    [Change narratives from \"who fixed it\" to \"who prevented it\"],
  ),
  kind: table,
)

The metrics you choose don\'t just #emph[measure] culture --- they #emph[create] it. Hero
cultures emerge when you track activity; Architect cultures develop when you measure
outcomes.

#strong[Three Levers to Pull Immediately:]

- #strong[Automate observability] \
  Replace manual status reports with dashboards that highlight:

  - #strong[System health trends] (e.g., error budgets, uptime).

  - #strong[Prevented issues] (e.g., \"faults avoided due to proactive fixes\").

  - #strong[Efficiency gains] (e.g., \"time saved by automation\").

- #strong[Measure outcomes] \
  Stop rewarding busywork. Track #emph[value creation] instead:

  - ❌ #emph[\"Resolved 50 Jira tickets\"] → ✅ #emph[\"Reduced customer-impacting incidents by 30%.\"]

  - ❌ #emph[\"Attended 10 meetings\"] → ✅ #emph[\"Shipped a zero-defect feature.\"]

  Tie engineering work to business results --- like cost savings or customer satisfaction --- to make it visible.

- #strong[Reward simplification] \
  Celebrate #strong[\"negative work\"] --- the effort to #emph[remove] complexity. For example, \"deleted 3 deprecated configs\" yields fewer failure modes and simpler onboarding.

== Personal Tactics: Prove Your Impact Without Burning Out
When the system ignores your work, #strong[translate it into a language it understands]:

- #strong[Create artifacts] \
  Document risks you avoided:

  - #emph[\"Pre-mortems\"] for potential failures you mitigated (e.g., #emph[\"We found X in staging; here\'s the fix and why it would\'ve taken down prod\"]) --- clarifying \"what could go wrong\" like #link("https://davidjuhasz.dev/blog/tdd-pragmatic-correctness-guide")[TDD clarifies requirements early].

  - #emph[\"Anti-incident reports\"] (e.g., #emph[\"Averted a 3-hour outage by catching X in staging\"]).

  - #strong[Architecture decision records (ADRs)] explaining #emph[why] you prioritized resilience over speed.

- #strong[Speak business] \
  Leaders care about impact, not technical details. Frame your work as outcome:

  - #strong[Cost saved] (e.g., #emph[\"This optimization reduces cloud spend by \$250K/year\"]).

  - #strong[Time reclaimed] (e.g., #emph[\"This tooling change cuts debugging time by 20%\"]).

  - #strong[Risk reduced] (e.g., #emph[\"This refactor eliminates a single point of failure\"]).

- #strong[Use visuals] \
  A before/after graph of #emph[\"deployment failures\"] tells a stronger story than a bullet point about #emph[\"improved reliability.\"]

= Stay or Go?
Not all organizations value prevention equally. Before deciding whether to adapt or move
on, ask:

- #strong[Does your organization reward stability or heroics?] \
  Are promotions tied to firefighting, while quiet wins go unnoticed? If crises drive recognition, you're in a hero-worshipping culture.

- #strong[Can you reduce the \"legibility tax\" locally?] \
  If streamlining reporting or shifting to outcome-based metrics feels like rebellion, the misalignment runs deep in the system.

#strong[The 20% Rule:] \
If you spend over 20% of time #emph[proving] rather than #emph[doing] work, the system
is misaligned.

#strong[Your options:]

+ #strong[Adapt:] Automate busywork and reframe your contributions in terms the system understands.

+ #strong[Influence:] Introduce outcome-based metrics.

+ #strong[Leave:] If resistance is default, the culture won't change.

#strong[Evaluating your next opportunity:] \
Ask decision-makers:

- #emph[\"How is performance measured here?\"]

- #emph[\"What did the last person promoted from this role actually achieve?\"]

Listen for #strong[results], not activity. A culture that can't articulate impact won't
recognize your strengths.

#horizontalrule

Overhead isn't the enemy --- #emph[misaligned] overhead is. #strong[The friction is either fuel for improvement or a sign to move on].
#link("https://davidjuhasz.dev/blog/navigating-tech-maze-strong-opinions-constructive-discontent-part1")[Constructive discontent] --- the gap between current reality and potential --- only works in systems
capable of change.

The best systems #strong[design their trade-offs with purpose]. A well-built team shouldn't need heroes --- but it #emph[does] need architects: those who build resilience so quietly that the only drama is in the stories of #emph[what didn't happen].

#strong[Your 20% audit this week:]

+ #strong[Measure:] Track time spent proving vs. doing.

+ #strong[Act:] Fix one thing --- automate, eliminate, or document.

+ #strong[Share:] Present results as experiments, not criticism.

The goal isn't zero friction --- it's friction that #emph[pays dividends].
