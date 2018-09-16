---
layout: page
---

<div class="home">
  <ul class="post-list">
    {% for post in site.notes%}
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