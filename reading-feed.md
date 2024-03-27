---
# You don't need to edit this file, it's empty on purpose.
# Edit theme's home layout instead if you wanna make some changes
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: page
---

<div class="home">
  <p>Directive like notes from the books I read. Notes extracted and edited with <a href="https://kintrospect.com">Kintrospect</a></p>
  <ul class="">
    {% for book in site.reading_feed %}
      <li>
        <a href="{{ book.url | relative_url }}">{{ book.title | escape }}</a>
      </li>
    {% endfor %}
  </ul>
</div>