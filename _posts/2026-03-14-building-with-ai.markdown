---
layout: post
title: "Building with AI"
date: 2026-03-14 11:33:36 -0500
x_embeds: true
---

I sent this to my team yesterday. I'm sharing it here because I think many of us are still trying to figure out how to best adopt AI into our workflows. This is meant to be more of a manifesto than a prescriptive recipe. A lot of this might apply only to my specific situation. Your org might be at a different stage and ready to go fully agentic, in which case some of these points might not apply.

<hr/>

*Code is getting cheaper. Judgment is not.*

AI changes how fast we can build. It does not remove the need to think.

One day the loop will be fully automated. That is not our reality today. Humans still decide what to build, review the code, approve the merge, operate the system, and answer for the outcome.

That means human understanding is still the standard. Best practices are not relics from a slower era. They are how we move faster without creating a mess.

### 1. Build from intent, not momentum

We do not start with code. We start with the problem, the user, the constraint, the tradeoff, and the desired outcome.

When implementation gets cheaper, building the wrong thing becomes more expensive than building slowly.

### 2. Planning gets more important as building gets cheaper

Planning is not anti-speed. It is how we reduce rework, sequence work well, and decide what deserves a prototype versus a discussion.

Good planning does not always mean more documents. Often it means designing the fastest experiment that can answer the real question.

{% capture chintan_building_with_ai_tweet %}
knowing what to ship is more important than just shipping.

we finally have an opportunity to get off the coding hamster wheel, and shift left to focus on upstream intent.

those that act on this and grow the discipline and restraint across their teams will come out ahead.
{% endcapture %}
{% include tweet.html
  url="https://twitter.com/chintanturakhia/status/2031490205463830640"
  author_name="Chintan Turakhia"
  author_handle="chintanturakhia"
  published_at="March 10, 2026"
  media_url="https://t.co/XQPtOH9CTA"
  media_label="pic.x.com/XQPtOH9CTA"
  text=chintan_building_with_ai_tweet
%}

### 3. The reviewer is the customer of the pull request

The first audience for a change is the human reviewer. The second is the engineer who will maintain it later.

Our pull requests should be built for comprehension: clear context, clear scope, clear rationale, examples or screenshots when useful, test notes.

Do not make reviewers reconstruct your thinking from the diff. Reviewer attention is scarce. Respect it.

When useful, capture the reasoning in compound docs.

### 4. Small diffs are a quality strategy

Bigger changes increase cognitive load, hide bugs, slow merges, and reduce review quality.

Break work into small, mergeable steps. Incremental delivery can help us keep changes understandable and safe.

### 5. Reviewers become more valuable as builders scale

As code generation gets faster, review quality matters more.

Product review, design review, and engineering review are how faster builders stay out of trouble. Review is not a rubber stamp. Its job is to catch what the author missed and improve what ships.

### 6. The author owns quality

QA is a safety net, not a transfer of ownership.

The engineer making the change owns correctness, edge cases, failure modes, observability, and confidence in production behavior. We do not outsource thinking to QA.

### 7. QA starts before the code is "done"

Quality is not something we add at the end.

Acceptance criteria, test strategy, support impact, monitoring, and rollback thinking should be part of the plan from the beginning. The later we find problems, the more expensive they are.

### 8. AI should help us produce better code

We use AI to explore options, accelerate routine work, generate tests, improve documentation, and refactor more aggressively.

We do not use AI to justify vague thinking, lower standards, or unreadable code. AI-assisted output must still be explainable, reviewable, and maintainable by humans.

### 9. Knowing what to ship matters more than just shipping

Output is not the same as progress.

When implementation becomes cheaper, the differentiator shifts upstream to judgment: what to build, what not to build, what to sequence first, and what to validate with real users.

We are not optimizing for more code. We are optimizing for better decisions and faster learning.

### 10. Optimize the process, not just the individual

AI can make one engineer faster without making the organization better.

The bigger gain comes from compressing the full loop: idea -> plan -> build -> review -> QA -> production -> learning.

We care about reducing waiting, handoffs, ambiguity, and rework.

### 11. Production is the only real test

A change is not done because it works locally or in staging.

It is done when it is safely live in production.

### 12. Preserve enough senior judgment

Smaller teams can be powerful, but only if review capacity and judgment keep pace with output.

We should not generate more code than experienced engineers can thoughtfully review, validate, and maintain. Faster building without enough senior judgment is a trap.

### 13. Leave the system better than you found it

Cheaper change should let us simplify, rename, document, refactor, and delete unnecessary complexity.

Speed is good. Compounding quality is better.

<hr/>

We do not optimize for code volume. We optimize for clarity, judgment, reviewability, quality, and reliable outcomes.

The cost of producing code may fall. The cost of bad decisions, unclear changes, and broken production systems does not.

Every change should make five things obvious:

1. What problem is this solving?
2. Why this approach?
3. What should the reviewer focus on?
4. How was this tested?
5. What could still go wrong in production?

Default expectation: if a change cannot be fully understood in one sitting, it is probably too large.
