---
layout: page
---

<div class="home">
  <ul class="post-list">
    {% assign sorted = site.notes | sort: 'date' | reverse %}

    {% for post in sorted %}
    <li>
      {% assign date_format = site.minima.date_format | default: "%b %-d, %Y" %}
      <span class="post-meta">{{ post.date | date: date_format }}</span>

      <h2>
        <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title | escape }}</a>
      </h2>
    </li>
    {% endfor %}
  </ul>
</div>
