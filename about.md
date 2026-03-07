---
layout: page
title: About
permalink: /about/
---

{% capture about %}{% include about.md %}{% endcapture %}
{{ about | markdownify }}
