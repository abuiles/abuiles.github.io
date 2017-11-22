---
# You don't need to edit this file, it's empty on purpose.
# Edit theme's home layout instead if you wanna make some changes
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: default
title: Reading feed
---

<div class="home">
  <p><a href="https://sivers.org/2do">Directive like notes</a> from the books I read. Notes extracted and edited with <a href="https://kintrospect.com">Kintrospect</a></p>
  <ul class="">
    {% directory path: reading-feed exclude: index %}
    <li>
      <a href="{{ file.slug }}">{{ file.slug }}</a>
    </li>
    {% enddirectory %}
    <li>
      ...more books coming
    </li>
  </ul>
</div>
