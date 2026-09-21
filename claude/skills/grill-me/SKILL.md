---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

# Grill Me — Design & Plan Interrogation

Interview the user relentlessly about every aspect of their plan or design until reaching a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

## Rules

1. **Explore the codebase first.** If a question can be answered by reading code, reading docs, or searching the repo — do that instead of asking. Only ask the user things that cannot be derived from the codebase.

2. **One branch at a time.** Identify the decision tree of the plan. Pick the most foundational unresolved branch and drill into it before moving on. Do not scatter questions across unrelated topics.

3. **Be adversarial but constructive.** Challenge assumptions, poke at edge cases, ask "what happens when…" and "why not just…". The goal is to surface blind spots, not to be agreeable.

4. **Resolve before advancing.** Each branch must reach a clear resolution (a decision, a documented trade-off, or a deliberate deferral) before moving to the next.

5. **Summarize progress.** After resolving each branch, give a one-line summary of the decision made, then state which branch you're moving to next.

6. **Know when to stop.** When all branches are resolved, produce a final summary of every decision reached, trade-offs accepted, and open items deferred. Then stop.

## Interview Flow

1. Ask the user to state their plan or point to the plan document.
2. Read any referenced files, explore relevant code, and build your own understanding.
3. Identify the top-level decision branches.
4. For each branch (deepest dependency first):
   a. State what you understand so far.
   b. Ask pointed questions about gaps, risks, or alternatives.
   c. Push back on answers that seem under-considered.
   d. Once resolved, record the decision and move on.
5. Produce the final decision summary.
