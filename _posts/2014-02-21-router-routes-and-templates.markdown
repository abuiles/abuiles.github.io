---
layout: post
title: "Router, Routes and Templates"
date: 2014-02-21 10:01:26 -0300
comments: true
categories: [Ember.js, Ruby on Rails]
---
**This post is part of my series about [learning Ember.js with Ruby on Rails](http://blog.abuiles.com/ember-js-with-ruby-on-rails).**

We have now the basic skeleton to [start building an app for my
mom](http://blog.abuiles.com/blog/2014/02/07/building-an-app-for-my-mom-with-ember-appkit-rails/),
today we are going to talk about 3 important concepts in Ember.js: The
`Router`, `Routes` and `Templates`.

Grab the application from where we left last:

      $ git clone git@github.com:abuiles/ember-rails-week-1.git
      $ git reset --hard week-1
      $ bundle install
      $ rails s

Go to `http://localhost:3000/` and you should see "Welcome to Ember on Rails!".

## Creating the Application Template.

Ember's equivalent of Ruby on Rails Application layout is called application too.

Create the file `app/templates/application.hbs` and put the following content there.

{% raw %}
```html
<h1>Hi Ember.js</h1>
{{outlet}}
```
{% endraw %}


Refresh your browser and you will see `Hi Ember.js`.

\{\{outlet}} is similar to `yield` on the application
template in Ruby on Rails **but is not the same, there is also the
word `yield` on Ember.js we'll cover later**

Let's add something into the outlet, create the file
`app/templates/index.hbs` with the following

```html
<h1>I'm the Index!</h1>
```

Refresh your browser and you will see "Hi Ember.js" follow by "I'm the Index".


## Under the hood.

To understand why the previous stuff worked without requiring us to
add any extra code we'll have to talk about the concept of `Routes`.

In Ember.js there is a `Router` and many `Routes`.

`Router` is where we specify the entry points for our application,
this is similar to `routes.rb`.

In Rails `router.rb` every entry matches to an `action` in a
controller, this is not the case in Ember.js, we mentioned previously
that a `controller` in Ember acts more as decorators for our views.

In Ember every entry in the `Router` matches to a `Route`, if we have
in the `router.es6` an entry like:

```javascript
this.route("about", { path: "/about" });
```

Then it will look for `app/routes/about.es6` and the template `app/templates/about.hbs`.

If Ember doesn't find the `route` it will create one automatically and
if we need to do any kind of processing before showing our template
like fetch data from a server or render a different template, then we
can do that on the `route` file.

With this in mind, the reason why putting `index.hbs` works without
doing anything extra is that Ember.js creates by default an
`IndexRoute`, which matches to `/`.

When we visit `/`, it tries to find `app/routes/index.es6`, if it is not there it
creates one by default and then renders the template under `templates/index.hbs`.

## A first Route

Let's create a simple route for `index`, put the following under `/app/routes/index.es6`.

```javascript
export default Ember.Route.extend({
  model: function() {
    return { date: Date() };
  }
});
```

Replace the `index` template with

{% raw %}
```html
<h1>I'm the Index! {{date}}</h1>
```
{% endraw %}

After refreshing you will see `I'm the Index` follow by a date, we
just write our first route, bootstrapped the required stuff for our
template and then rendered it into the template!

## Task

We want to have an `/about` page, add the necessary entry to the
`Router` and template.


## Resources

I suggest going to the official Ember.js guides and check the section for Routing and Templates.

* [Routing guide](http://emberjs.com/guides/routing/)
* [Templates guide](http://emberjs.com/guides/templates/the-application-template)

#### Want to learn more about  Ember.js with Ruby on Rails? Subscribe


<form action="http://emberenos.us7.list-manage.com/subscribe/post?u=103dd05cb2005f7b5485df96d&amp;id=25604cee1d" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate><label for="mce-EMAIL">Subscribe.</label><input type="email" value="" name="EMAIL" class="email" id="mce-EMAIL" placeholder="email address" required><!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups--> <div style="position: absolute; left: -5000px;"><input type="text" name="b_103dd05cb2005f7b5485df96d_25604cee1d" value=""></div><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div></form>
