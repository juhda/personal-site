#let (blog-img, callout, horizontalrule) = eval(read("../_preamble.typ"), mode: "code")

= Why Most Software Ships With Unproven Assumptions
Most software teams face a #strong[correctness paradox]: they need the rigor of
#link("https://en.wikipedia.org/wiki/Formal_verification")[formal verification] but
can't afford its cost.
#link("https://martinfowler.com/bliki/TestDrivenDevelopment.html")[Test-Driven Development] (TDD) offers a middle path --- #strong[a pragmatic bridge] that translates
requirements into executable specifications #emph[before] coding begins. Formal
verification --- the mathematical proof that a system behaves as intended --- remains a
luxury reserved for railways, medical devices, and cryptographic protocols. For the rest
of us, it's simply #strong[too expensive, too rigid, or too slow] for real-world
development. This creates a #strong[correctness gap:] teams ship software with unproven
assumptions and treat bugs as an inevitable tax.

But here's the reality: #strong[most bugs aren't coding errors --- they're undeclared requirements]. A missed edge cases in a payment flow. An ambiguous error-handling
specification. A mismatch between what users #emph[need] and what developers
#emph[build]. These aren't execution failures; they're #strong[failures of clarity].

The data backs this up:

- #strong[60‒80% of production defects] trace back to ambiguous or incomplete requirements (figures widely cited across industry reports, including IBM's #link("https://www.techonline.com/tech-papers/reducing-rework-through-effective-requirements-management")[Reducing Rework Through Effective Requirements Management]).

- #strong[Late-stage bug fixes] cost #strong[10--100x more] than catching issues during design (NASA JSC's study: #link("https://ntrs.nasa.gov/api/citations/20100036670/downloads/20100036670.pdf")[Error Cost Escalation Through the Project Life Cycle]).

Yet teams are forced into a #strong[false dichotomy]:

- #strong[Formal verification]: Rigorous but impractical --- confined to #strong[safety-critical domains] where failure means life, not downtime (#link("https://dl.acm.org/doi/abs/10.1145/1592434.1592436")[Formal methods: Practice and experience. ACM Comput. Surv. 41, 4, Article 19]).

- #strong[Ad-hoc testing]: Fast but reckless --- #strong[the default for many teams], where verification is #strong[an afterthought] until something breaks.

#strong[No wonder we accept bugs.] The alternatives demand a choice: #emph[grind to a halt] or #emph[ship and pray].

#strong[TDD breaks the stalemate.] It's verification that scales --- not a replacement for
formal methods, but a #strong[pragmatic bridge] between untested code and mathematical
proofs. It doesn't promise perfection. Instead, it offers something #strong[far more practical]:

- A way to #strong[turn requirements into executable examples] #emph[before] writing implementation code.

- A focus on #strong[reducing ambiguity] --- because correctness isn't about perfection; it's about #strong[clarity under constraints].

#callout[
  ⚠️ #strong[A Note on Quality and Collaboration]

  TDD is a powerful tool for delivering quality results, but #strong[quality starts with collaboration and shared understanding]. Even the best tools can't compensate for
  misaligned teams. The right people and tech setup make quality #emph[possible] --- but
  remember: #strong[software is only ever free from #emph[known] bugs]. For absolute
  certainty, formal methods can deliver 100% correctness --- at enormous cost. And that's a
  tradeoff few can afford.
]

= TDD: The Pragmatic Bridge Between Chaos and Formal Proofs
#strong[TDD disciplines developers to translate requirements into code] --- not through
proofs, but through #emph[executable examples]. The process follows a
#strong[deceptively simple] cycle:

#blog-img(
  "Red-Green-Refactor.png",
  alt: "Diagram of the TDD cycle showing three phases: Red (write failing test), Green (make test pass), and Refactor (improve code). Arrows indicate the iterative flow between phases.",
)

+ #strong[Red]: Write a test for a single behavior (e.g., #emph[\"User can undo last action\"]). It fails because the functionality doesn't exist yet.

+ #strong[Green]: Write the #strong[minimal code] to pass the test. No more, no less.

+ #strong[Refactor]: Improve the code's structure #emph[while keeping tests passing] --- #strong[preserving behavior].

This cycle #strong[mirrors formal verification] in key ways:

- Tests encode #strong[preconditions/postconditions] into #emph[setup/assertions].

- Refactoring with passing tests #strong[preserves behavior], akin to #emph[proof preservation].

== How TDD Enforces SOLID Principles --- Without You Noticing
TDD isn't just about testing --- it's about #strong[designing for testability], which
naturally enforces SOLID principles. For example:

- #strong[Single Responsibility]: A hard-to-write test often signals a class doing too much.

- #strong[Dependency Inversion]: Testing through interfaces (not implementations) forces cleaner abstractions.

== Formal Verification vs. TDD: When to Use Each
#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Aspect], [Formal Verification], [Test-Driven Development]),
    table.hline(),
    [Basis], [Abstract mathematical proofs], [Concrete executable examples],
    [Cost], [High (experts, tools)], [Low (developer time, standard tools)],
    [Flexibility], [Rigid (specifications must be complete upfront)], [Adaptive (tests evolve with code)],
    [Coverage], [Complete (for specs)], [Sample-based (key behaviors)],
    [Tooling],
    [Specialized (e.g., #link("https://lamport.azurewebsites.net/tla/tla.html")[TLA+], #link("https://rocq-prover.org/")[Rocq], #link("https://isabelle.in.tum.de/")[Isabelle], #link("https://www.atelierb.eu/en/")[Atelier B])],
    [Mainstream (e.g., #link("https://junit.org/")[JUnit], #link("https://docs.pytest.org/en/stable/")[pytest], #link("https://github.com/google/googletest")[gtest])],
    [Best For], [Safety-critical logic (e.g., aerospace, medical)], [Business logic, APIs, and workflows],
  ),
  kind: table,
)

TDD is the #strong[sketch to formalism's blueprint] --- less rigorous, but far more practical. It won't guarantee perfection, but it #strong[eliminates the majority of costly misunderstandings] with minimal overhead. The tradeoff isn't rigor vs. sloppiness; it's #strong[upfront clarity vs. late-stage fire drills].

== Design by Contract (DbC): Runtime Guards, Not Test Replacements
TDD verifies behavior through #strong[executable examples],
#link("https://en.wikipedia.org/wiki/Design_by_contract")[DbC] enforces
#strong[invariants]. They're complementary:

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Aspect], [Design by Contract], [Test-Driven Development]),
    table.hline(),
    [#strong[Focus]], [Declarative rules (#emph[what must be true])], [Executable examples (#emph[what should happen])],
    [#strong[Verification]], [Static analysis + runtime checks], [Dynamic test execution],
    [#strong[Tooling]],
    [Language-specific (e.g., #link("https://www.eiffel.org/")[Eiffel], #link("https://learn.microsoft.com/en-us/dotnet/framework/debug-trace-profile/code-contracts")[Code Contracts] for C\#, #link("https://pypi.org/project/icontract/")[`icontract`] for Python)],
    [Framework-agnostic (e.g., #link("https://junit.org/")[JUnit], #link("https://docs.pytest.org/en/stable/")[pytest], #link("https://github.com/google/googletest")[gtest])],
    [Strength], [Catches violations #emph[dynamically]], [Validates #emph[examples] before deployment],
    [Limitation], [#strong[Runtime cost] (contract checks)], [#strong[Misses invariants] not in tests],
    [Mindset], [#emph[\"Define rules that must always hold.\"]], [#emph[\"Show me examples of correct behavior.\"]],
    [#strong[Best For]], [Critical safety nets, API boundaries], [Business logic, workflow validation],
  ),
  kind: table,
)

#strong[Key Insight]: DbC isn't a replacement for testing --- it's an #strong[extra layer of defense].

- #strong[TDD] asks: #emph[\"Does this code behave correctly for these inputs?\"]

- #strong[DbC] asks: #emph[\"Does this code violate any rules --- no matter the input?\"]

- #strong[Together], they cover #emph[examples] (TDD) and #emph[universal rules] (DbC).

= The Hidden Cost of Late-Stage Bugs --- and How TDD Cuts It
Software development has a #strong[hidden tax]: the later a bug is found, the more it costs. A typo fixed during coding takes minutes. The same typo discovered in production? #strong[Emergency patches, rollbacks, reputational damaged]. These costs aren't linear --- they're #strong[exponential] (NASA JSC's study: #link("https://ntrs.nasa.gov/api/citations/20100036670/downloads/20100036670.pdf")[Error Cost Escalation Through the Project Life Cycle]).

== TDD's ROI: Fail Early, Save 100x
TDD #strong[shifts debugging left] --- from production to design --- by turning requirements
into executable examples #emph[before] implementation. This creates a
#strong[design-time feedback loop] that:

+ #strong[Exposes ambiguities early]

  - Writing tests first forces clarity #emph[before] coding.

  - Example: A vague requirement like #emph[\"Handle payment errors gracefully\"] becomes a concrete test case: `test_payment_error_shows_user_friendly_message()`.

+ #strong[Replaces \"code-deploy-debug\" with \"test-code-verify\"]

  - Traditional workflow: Code → Deploy → Discover Bug → Debug → Fix → Re-deploy

  - TDD workflow: #strong[Write Test → Code → Verify → Refactor]

  - #strong[Difference]: TDD surfaces issues when they\'re cheap to fix.

+ #strong[Acts as static analysis for requirements]

  - Each test is a \"breakpoint\" for understanding

  - Failing tests reveal logic gaps #emph[before] they become bugs

#strong[TDD is static debugging for requirements] --- it catches misunderstandings before
you code, not after you ship.

= Behavior-Driven TDD: Write Tests That Survive Refactoring
A common complaint about TDD isn\'t that it doesn\'t improve quality --- it\'s that the tests keep breaking. But brittle tests don't reflect a flaw in TDD; they signal that #strong[you're testing the wrong things]. The root cause? #strong[Coupling tests to implementation instead of behavior].

== The Root Cause of Brittle Tests
Tests break during refactoring when they're coupled to #strong[implementation], not
behavior. Brittle tests assume details like

- Internal structure (e.g., private methods, class names)

- Implementation details (e.g., \"Cart has 5 methods\")

- Specific algorithms (e.g., \"Uses binary search\")

The fix? #strong[Test #emph[what] the code should do, not #emph[how] it does it.]

== Test Behavior, Not Implementation: A Rule to Live By
Focus on outputs and collaborations, not internals.

✅ #strong[Do]:

- #strong[Test outputs]: Verify visible behavior, not internal state

  ```python
  # ✅ Behavior-focused: tests outcome, not implementation
  def test_user_can_add_items_to_cart():
      cart = Cart()
      cart.add(item)
      assert item in cart.contents
  ```

- #strong[Test collaborations]: Use interfaces, not concrete classes

  ```python
  # ✅ Mock the interface, not the implementation
  def test_payment_processes(PaymentProcessor: Protocol):
      processor = Mock(PaymentProcessor)
      cart.checkout(processor)
      processor.charge.assert_called_once()
  ```

❌ #strong[Avoid]:

- Mocking concrete classes ( `Mock(StripeGateway)`)

- Asserting on private methods ( `assert _calculate_tax()`)

- Testing framework internals ( `assert model.save()`)

✅ #strong[Green Flags]:

- Test names describe #strong[user goals] (e.g., `test_user_can_undo_action`)

- Tests survive #strong[refactoring] (e.g., changing `Cart` to `ShoppingBasket`)

- Each test answers: #emph[\"What behavior does this enable?\"]

== How to Turn Requirements Into Executable Tests
Requirements must be #strong[actionable and specific] to convert into test cases. Vague
requirements like #emph[\"the system should be user-friendly\"] are difficult to test.

#strong[Requirements Smell Test]: \
✅ #strong[Testable]: Can you write a failing test for it? \
✅ #strong[Specific]: Defines #emph[what], not #emph[how]. \
✅ #strong[Measurable]: Clear success/failure criteria.

Well-defined requirements convert directly into test cases.

Robust tests are #strong[executable specifications] --- they document #emph[what] the
system should do, not #emph[how] it does it. This makes them:

- #strong[Resilient to refactoring] (implementation can change)

- #strong[Valuable as documentation] (clear purpose)

- #strong[User-focused] (not technical concerns)

= TDD Workflow: Red-Green-Refactor Done Right
TDD isn't a theoretical ideal; it's a #strong[practical workflow] that adapts to
real-world constraints. Here's how to make it work for your team --- without dogma.

== Red-Green-Refactor: The TDD Rhythm Explained
TDD's rhythm is simple but #strong[powerful in its discipline]:

#blog-img(
  "Red-Green-Refactor-Workflow.png",
  alt: "TDD cycle diagram showing three states (Red/Green/Refactor) connected by arrows labeled with developer actions: 'Write a failing test' → Red, 'Write minimal code to pass' → Green, and 'Refactor with tests as safety net' → Refactor. The cycle loops back to Red to emphasize iteration.",
)

+ #strong[Red]: Define #strong[user-centric behavior] (not methods/classes).

  - ❌ #emph[\"Test] `Cart.addItem()`\" (implementation-focused).

  - ✅ #emph[\"User can add an item to their cart and see the updated total\"] (behavior-focused).

+ #strong[Green]: Solve it #strong[the simplest way possible] (hardcode if needed).

  - #emph[Why?] Forces focus on the #emph[interface] before implementation.

+ #strong[Refactor]: Improve code #strong[with tests as a safety net].

  - Now that tests guard the behavior, clean up the code:

    - Apply SOLID principles (e.g., extract interfaces for mocking).

    - Remove duplication.

    - Consider parametrization and performance if relevant.

  - #strong[Rule]: If a test breaks during refactoring, it was testing implementation.

== CI/CD for TDD: Automate Your Test Reviews
#strong[Problem]: Engineers skip manual test runs because #strong[waiting breaks flow].

#strong[Solution]: #strong[Automation that enforces verification] without human
intervention.

#strong[Structure test automation for speed and relevance:]

#figure(
  table(
    columns: 3,
    align: (auto, auto, auto),
    table.header([Test Type], [CI Trigger], [Purpose]),
    table.hline(),
    [Unit tests], [Every commit], [Catch logic errors fast],
    [Integration tests], [Pull request], [Verify component interactions],
    [End-to-end tests], [Nightly/staged], [Validate user journeys],
  ),
  kind: table,
)

#strong[This works because]:

- Fast feedback keeps developers in flow, with unit tests completing before they switch tasks.

- Fail-fast policies block merges on any failure, ensuring the test suite remains a trusted gatekeeper.

- The full test suite runs automatically, eliminating gaps from manual \"spot checking.\"

- Parallel execution and tiered triggers prevent CI from becoming the bottleneck.

== Lean Test Suites: Prune Like a Garden
A healthy test suite #strong[grows and shrinks] with your system:

- #strong[Add tests] for new behaviors.

- #strong[Remove tests] when behaviors are deprecated.

#strong[Prune with purpose]:

- #strong[Deprecated feature?] Delete #emph[both] the code #strong[and] its tests.

- #strong[Low coverage?] Ask:

  - #emph[Is the untested code required?] → #strong[Test it].

  - #emph[Is it dead weight?] → #strong[Delete it].

- #strong[Every test should verify behavior that delivers user value.]

#strong[Why?] Tests are #strong[executable documentation] --- they should reflect
#emph[current] requirements, not historical debris.

#strong[Result]: A lean suite that's #strong[faster, more focused, and trusted] by the
team.

= Pragmatic TDD: Start Small, Scale Smart
TDD isn't an all-or-nothing proposition. Its value lies in #strong[pragmatic application], not rigid adherence. Here's how to adopt it incrementally while preserving
its core value.

== Where to Start
Apply TDD #strong[selectively] where it delivers the most value:

- #strong[High-risk areas]: Payment processing, state machines, or safety-critical logic.

- #strong[New features]: Write tests #emph[before] implementing to clarify requirements.

- #strong[Bug fixes]: Write a test to reproduce the issue, which ensures it stays fixed and prevents regressions.

Even in legacy systems, #strong[new code = new opportunity]. Start with the next feature
or fix.

== Sell It to Your Team
Frame TDD as #strong[design insurance], not extra work:

- #strong[For developers]: #emph[\"Tests are living documentation --- they force clarity on what the code should do, not just how it works.\"]

- #strong[For managers]: #emph[\"TDD shifts debugging left, where fixes are 100x cheaper.\"]

- #strong[For skeptics]: #emph[\"It's not about 100% coverage --- it's about] #emph[#strong[targeted correctness]] #emph[where it counts.\"]

This might be a useful metaphor: #emph[\"TDD is like a seatbelt: You don't wear it for the smooth ride, but for when things go wrong.\"]

= TDD's Blind Spots: 3 Cases Where You Need More
TDD provides a #strong[floor for correctness], but its sample-based nature misses
critical gaps. Address them with these targeted supplements:

#figure(
  table(
    columns: 4,
    align: (auto, auto, auto, auto),
    table.header([Area of Risk], [Why TDD Falls Short], [What It Misses], [How to Supplement]),
    table.hline(),
    [#strong[Implementation]],
    [Focuses on #emph[behavior], not internals.],
    [Type/memory safety, performance bottlenecks.],
    [Static analysis + instrumentation + profiling.],
    [#strong[Complex Behavior]],
    [Assumes deterministic execution.],
    [Race conditions, state transitions, external dependencies.],
    [Model checking + chaos engineering.],
    [#strong[Mathematical Guarantees]],
    [Tests #emph[samples], not universals.],
    [Infinite inputs, invariants, edge cases.],
    [Property-based testing + Design by Contract + formal methods.],
  ),
  kind: table,
)

#strong[Rule of Thumb:] Start with TDD for #strong[core logic], then layer in
supplements based on your system's #strong[risk profile].

#horizontalrule

TDD doesn't require all-or-nothing adoption --- it's about #strong[failing cheaply on the code that matters]. Pick #emph[one] high-risk component (a payment flow, a state transition, a recurring bug), and #strong[write the test you wish you'd had last time it broke]. Measure the difference. That's how pragmatic correctness begins.
