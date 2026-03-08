---
layout: post
title: "The Human Bottleneck in the Age of AI Agents"
date: 2026-03-07 21:00:25 -0500
---

I remember when the coding flip happened for me and I stopped writing most code by hand. It was September 2024. I had long uninterrupted stretches to tinker with AI tools.

I was playing with Cursor, turned on YOLO mode, and I haven't really looked back since. I've since moved to Codex, but that was the moment the shift became real for me. A few months earlier I had heard Sam Schillace describe a future where we tell the computer our intent and it translates that intent into working software. By September, that no longer felt theoretical.

That was exactly what I was experiencing. As an engineering lead, I spent the beginning of 2025 pushing hard to get my team using AI-assisted coding.

Today the question is different. It's no longer "are you using AI?" It's "how agentic is your workflow?"

The tools have moved fast:

- Chat-based coding assistants made you copy and paste context between sessions.
- IDE agents started handling multi-step work without leaving the editor.
- CLI agents made the same work headless, scriptable, and easy to run in the background.
- Agent swarms pushed it further: multiple agents investigating, changing code, and reporting back at the same time.

Each step gives the model more autonomy. In the long run, humans might not be involved, but for now we very much still are.

The challenge is how we stay sane as the agents get more capable, and how we help people learn to work this way without burning out.

## More output, more human bottlenecks

[![Agent review bottleneck doodle](/assets/agent-review-bottleneck-doodle.png)](/assets/agent-review-bottleneck-doodle.png)

An agent can read a lot of code, inspect logs, follow stack traces, trace network requests, and propose a fix faster than most humans can do the same work manually. A swarm of agents can multiply that output again.

The impressive part is easy to see. The hard part is what comes next.

Who decides whether the proposed fix is actually right?

Who notices when the model solved the ticket literally but missed the real product intent?

Who tells the agent which customer state matters, which internal constraint is non-negotiable, or which "obvious cleanup" is actually a dangerous regression?

Once you start running several agents in parallel, the bottleneck shifts from typing code to coordinating work. Humans stop being limited by implementation speed and start being limited by attention, review capacity, and context management.

That's the part I think many agent demos still underplay.

The headline is usually that one person can now produce much more software. That's true. But it also means one person can now generate much more surface area to review, validate, explain, and shepherd to completion.

For demos or greenfield projects where the stakes are still low, you can YOLO mode all you want. The stakes are different when a small bug in production can have real dollar signs attached to it.

## The real enemy is context starvation

In most software teams, the biggest failure mode is that the right context is in the wrong place at the wrong time.

One person figured out the root cause yesterday, but the next agent does not know it.

An agent discovered a useful clue at 2am, but that knowledge never made it back to the people touching the feature the next morning.

Someone in product, support, or QA knows the exact user behavior that matters, but the engineering conversation never pulled them in. This is one of the reasons I believe in small, tightly knit product engineering teams.

When that happens, work gets repeated. Investigations restart from zero. The same bug gets rediscovered three times. Humans burn energy reconstructing state instead of moving the work forward.

The enemy is not just the bug. The enemy is context starvation.

That's why I've started thinking about these systems less like traditional automation and more like a text-based MMORPG.

I don't know if this is the metaphor I'll still be using two months from now, but right now it helps me build a shared narrative around what is changing.

## A text-based MMORPG for work

[![Party chat MMORPG doodle](/assets/party-chat-mmorpg-doodle.png)](/assets/party-chat-mmorpg-doodle.png)

In a good multiplayer game, the party is stronger than any one player because information moves quickly.

Someone spots the trap.
Someone else knows the map.
Another player has the right tool for the fight.

No single person holds the whole world state in their head, but the group still makes progress because context keeps flowing through the party.

That framing has helped me reason about human-and-agent collaboration much more than the usual factory metaphors.

Your product and engineering teams are the party. Humans and agents have different abilities, different memory, different blind spots, and different levels of access. They all contribute to the same quest, but they are only effective when they can see enough of what the rest of the party has learned.

That does not mean everyone needs to work in the same tool or at the same time. It means the system needs a resting point where discoveries, decisions, and evidence accumulate in a form the next session can pull back in.

You use the team to expand your mental capacity. Over time, you are not just finishing tickets. You are compounding context.

## The workflow I keep coming back to

The most useful pattern I have found is not a giant autonomous pipeline. It is a simple shared loop.

An agent starts work and posts that it has begun. We do that in Slack.

When it identifies a likely issue or a possible solution, it shares that back to a team thread. That gives other people a chance to add missing context before the system commits to the wrong direction. Product can clarify intent. QA can point out a missing scenario. Another developer can say, "we already tried that two weeks ago" or "this only happens for one class of customer."

Once the direction is clear enough, the implementation can continue.

At the end, the work comes back with evidence: the change itself, supporting verification, and a short written record of what was learned so the next session doesn't start blind. We're also leaning into [compound engineering](https://lethain.com/everyinc-compound-engineering/) so those learnings survive beyond a single thread or session.

I like this pattern because it lets non-technical people participate without forcing them into developer tools. They don't need to open an editor or learn a new interface to contribute the one piece of context that changes everything.

It also keeps the human in the role that matters most: steering, validating, and deciding when the system understands the problem well enough to proceed.

## The immediate future is AI shepherds

I think the role that grows from here is not "prompt engineer" and not exactly "manager" in the traditional sense.

It is closer to an AI shepherd.

A shepherd might have several agents working easy bugs in the background, another agent pushing through a larger feature, and a shared channel where context keeps getting pulled together. The job is to distribute attention, inject missing product knowledge, review the important edges, and keep the whole system pointed at outcomes instead of motion.

That probably does reduce the need for large teams doing routine implementation work. I don't think it's useful to dance around that. If AI produces more output per dollar, organizations will use more AI.

What I find strange is how many teams are delaying serious investment because they're still fixated on token efficiency. Tokens matter, but that's the wrong optimization if the system is already producing better output per dollar than your current alternative. Waiting for the tools to become perfect is often more expensive than the tokens you're trying to save.

The real question is not whether the models are flawless. They are not. The question is whether you're building the human systems around them well enough to absorb their output without burning people out.

That is the bridge between the economic argument and the human one. If AI shepherds really are the near future, then the scarce skill is not just knowing how to invoke the models. It's knowing how to create enough shared context, trust, and review capacity for a growing number of agents to be useful instead of overwhelming.

## Keep the humans sane

That's the human bottleneck I keep coming back to.

Not "how do we remove the human?"

Not even "how do we maximize autonomy?"

But "how do we help the human stay sane while the number of agents, sessions, and parallel workstreams keeps growing?"

For me, the answer starts with shared context, lightweight coordination, visible evidence, and systems that respect how people already work. Again, maybe in a greenfield org or small project, going fully autonomous makes sense. I'm actually experimenting with that approach in one of my own projects: I have a bunch of agents working in parallel or on dependent tasks, and then another agent waiting around to merge pull requests fully autonomously.

Maybe the long-term future is a silent factory where autonomous agents do everything in the dark. But that's not where most of us are today. There's still a bigger shift that needs to happen first.

Today we need a safer way to learn our way there. We need systems that let us become effective with agents while keeping humans oriented, the review surface manageable, and the shared context alive.

For now, that matters more than chasing full autonomy.

If we can't keep humans and agents from fighting blind, none of the rest will scale.

But we also need to lean into it. That's the only way forward. We need to adapt or die.

{% quote cite="Saul Alinsky, Rules for Radicals" url="https://www.amazon.com/Rules-Radicals-Practical-Primer-Realistic/dp/0679721134" %}
In the politics of human life, consistency is not a virtue. To be consistent means, according to the Oxford Universal Dictionary, “standing still or not moving.” Men must change with the times or die.
{% endquote %}

---

*Note: I'm using AI to help me write this post. It started as a draft built from random thoughts and notes I keep on my phone.*
