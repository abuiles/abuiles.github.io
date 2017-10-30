---
# You don't need to edit this file, it's empty on purpose.
# Edit theme's home layout instead if you wanna make some changes
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: default
---

<div class="home">
  <h3>Directive like notes from the books I read</h3>
  <ul class="post-list">
    {% directory path: reading-feed exclude: index %}
    <li>
      <a href="{{ file.slug }}">{{ file.slug }}</a>
    </li>
    {% enddirectory %}
  </ul>
</div>
