---
layout: post
title: "Ruby on Rails MVC is not the same as Ember.js MVC"
date: 2014-01-27 02:17:52 -0200
comments: true
categories: ember-cli ember-cli-addons ember
---

One of the most confusing parts for people coming from Rails (or any
other backend web application framework) it's that what Ember.js
calls MVC is very different to what other frameworks call MVC.

To understand what MVC is in both frameworks I recommend watching
Yehuda Katz presentation:
[A tale of two MVC's](http://www.youtube.com/watch?v=s1dhXamEAKQ).

<iframe width="853" height="480" src="//www.youtube.com/embed/s1dhXamEAKQ" frameborder="0" allowfullscreen></iframe>

Instead of talking about MVC, Yehuda proposes an unified model for GUI programming which is composed by a series of steps and then explains how different frameworks handle each step.

The following are the steps mention by Yehuda and the components in
charge of each in both Ruby on Rails and Ember.js.

## Step 1: Bootstrap Object
Setup the initial state, bootstrap objects that you will require in
the future. e.g. Current User, Blog Posts.

* Ruby on Rails: Router and Controller
* Ember.js: Route.

## 2. Draw Initial UI
With the objects you setup on step 1 you will draw whatever the initial
UI is for your system.

* Ruby on Rails: View
* Ember.js: Template

** Views in Ember are not the same as Views in Rails, the
   equivalent are the templates, you will learn later what views are for.


## 3. Translate Raw Input into User intent
Once the user start to use the app, we want to interpret their intend,
for example clicking somewhere, pressing a key.

* Ruby on Rails: Template/Browser
* Ember.js: Template or View.

## 4. Update application state
As user starts to interact with the system, we need to update the
state of the app, for example we have an option box which is always in
the head, if the user click "hide options", we need to
update the state of the app to reflect that and remember during the
rest of the user's session.

* Ruby on Rails: Controller (In the Session)
* Ember.js: Route

## 5. Update Domain Objects
If I remove a tweet for example, then I want to remove it from the system.

* Ruby on Rails: Controller
* Ember.js: Controller

## 6. Notify UI Changes
When there is something new, the UI needs to know somehow about it,
for example, there are new comments or the value for a field changed.

* Ruby on Rails: HTTP.
* Ember.js: Data Binding.

## 7. Update the UI.
New changes or whatever needs to be drawn is drawn.

* Ruby on Rails: Browser
* Ember.js: Template


The next time you are struggling to decide where to put something just look at the steps above and see where it belongs.


P.S I'm [writing a series of post on working with Ember.js and Ruby on Rails](http://blog.abuiles.com/ember-rails/), subscribe to my list and I will let you know every time I publish an article on Ember.js and Ruby on Rails.


<form action="http://emberenos.us7.list-manage.com/subscribe/post?u=103dd05cb2005f7b5485df96d&amp;id=25604cee1d" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate><label for="mce-EMAIL">Subscribe.</label><input type="email" value="" name="EMAIL" class="email" id="mce-EMAIL" placeholder="email address" required><!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups--> <div style="position: absolute; left: -5000px;"><input type="text" name="b_103dd05cb2005f7b5485df96d_25604cee1d" value=""></div><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div></form>