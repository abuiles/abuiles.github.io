---
layout: post
title: "Vibe Listing: Vibe Coding Your Shopify App Listing"
date: 2026-03-08 12:09:53 -0500
---

I run a Shopify app that I'm trying to grow organically. Every other week I look at App Store traffic and adjust the listing based on the patterns I see in Google Analytics.

My typical flow is something like this:

1. Download report of last 90 days of traffic.
2. Run a prompt to analyze the report.
3. Adjust listing and landing page based on what I'm seeing.

The App Store workflow has no good revision history, no easy way to see what I changed last time, and no safe rollback flow. So I asked myself: what if I just built a better workflow for managing the listing itself?

So I built and open-sourced Vibe Listing.

Vibe Listing is an agent-assisted publishing workspace to vibe-code your Shopify App Store in a secure* way. It captures the current listing into local structured files, keeps the state in a private local Git repo, lets the LLM make the changes, and gives me a local workspace to review the current version, the draft, the diff, and the history before anything gets published. It is like GitHub for your Shopify App Store listing, but meant to be used with an LLM.

My actual flow is to do the work with the LLM and use the UI mainly to confirm the diff and the final changes. When I am ready, an agent can apply the approved changes back in Shopify.

What I wanted from the workflow was:

- Quickly modify and experiment with the listing based on the traffic report.
- Version your listing changes like any other important artifact.
- Run safer experiments on copy and metadata.
- Review diffs before publishing.
- Restore a previous release back into draft before republishing.
- Keep the listing data private and backed up with Git.

In other words, I wanted to vibe code my Shopify app listing, but with guardrails. If that sounds useful, the repo is here: [abuiles/shopify-listing](https://github.com/abuiles/shopify-listing).

Here's a quick video showing my workflow:

<figure class="post-demo">
  <video controls playsinline preload="auto">
    <source src="/assets/demo-vibe.mp4" type="video/mp4">
    Your browser does not support embedded video. You can watch it here:
    <a href="/assets/demo-vibe.mp4">demo-vibe.mp4</a>
  </video>
  <figcaption>A quick tour of the local capture, diff, history, and publish workflow.</figcaption>
</figure>

If you want to try it, open Codex or Claude Code and paste this prompt:

```
Clone https://github.com/abuiles/shopify-listing and set up this repo for my Shopify app listing workflow.

Guide me through the setup.
If app config is missing, ask me for Shopify links and fill in .local/shopify-listing/config.json before trying capture.
Use a headed browser only for the first Shopify login, then run the rest headless with the repo-local browser profile in .local/shopify-listing/browser-profile.
```

### Technical details

Under the hood this uses `agent-browser` to authenticate into Shopify, navigate to the right listing pages, and apply the changes. The listing itself gets captured into local structured files first, then the LLM updates those local files, and finally the browser automation uses that local state to push the approved changes back to Shopify.

\* You are still running this at your own risk, and if you want more guardrails you can ask the LLM to show extra confirmation steps before it actually changes your listing.
