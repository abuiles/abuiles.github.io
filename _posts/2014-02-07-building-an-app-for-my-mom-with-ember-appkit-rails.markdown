---
layout: post
title: "Building an App for my mom with Ember Appkit Rails."
date: 2014-02-07 10:56:18 -0200
comments: true
categories: [Ember.js, Ruby on Rails]
---
**This post is part of my series about [learning Ember.js with Ruby on Rails](http://blog.abuiles.com/ember-js-with-ruby-on-rails).**


In previous post we explored what is
[Ember.js MVC](http://blog.abuiles.com/blog/2014/01/27/ruby-on-rails-mvc-is-not-the-same-as-ember-dot-js-mvc/)
and then did a
[high level overview of Ember Appkit Rails](http://blog.abuiles.com/blog/2014/01/31/getting-started-with-ember-and-ruby-on-rails-using-ember-appkit-rails/),
in this post we'll start to work on a project which we will use as
reference for upcoming posts.


## The Problem
My mother lives in a small town in Colombia where she owns a store,
access to credit cards in Colombia is really really hard, so stores
and people in small towns tend to buy and sell on credit, trusting
that people will come back and pay them (crazy, isn't?).

During my last visit I was really shocked when I saw that she was
keeping all her records on physical invoices in under an A-Z folder.

If `John Smith` takes a t-shirt on credit, they would create an
invoice with his name, add a description (e.g. t-shirt) with the price
`$25` and then throw that into the A-Z in the section for surnames
starting with `S`.

Later John returns to the store and makes a partial payment (e.g.
`$10`) or pays the whole thing.

This approach is horrible, insecure, my mother doesn't know how much
is people really owing her, she can't have insights, etc.

Let's then  build an App for my mother where she can keep her records, the app name will be `facturas` which means `invoices` in Spanish.

## Starting the project.

For this project we will use `Ruby on Rails 4.1.0.beta1` and `Ember.js 1.4.0-beta`.

Install Ruby on Rails `gem install rails --pre`, once it's completed
run `rails new facturas` and we should have the basic structure for
our project.

Let's keep everything under `git` so we can keep track of changes.

      $ git init
      $ git add .
      $ git commit -m 'Getting started!.'

I use [hub](https://github.com/github/hub) so I will just push this to a new repo on GitHub.

      $ hub create ember-rails-week-1
        Updating origin
        created repository: abuiles/ember-rails-week-1
      $ git push origin master


Install `Ember Appkit Rails`, since I want to use a new feature we
have been working on to include testing out of the box, we won't
install from rubygems but directly from GitHub.

Add the following to you Gemfile:

    gem 'ember-appkit-rails', git: 'https://github.com/dockyard/ember-appkit-rails.git'

Run `bundle install`.

Now we can bootstrap our Rails project with Ember Appkit Rails.

      $ rails g ember:bootstrap

For now just focus on this two files:

      create  config/router.es6
      create  config/application.js

`router.es6` would be the main entry point for our Ember App, it's
something similar to `routes.rb`, it will help us defined how users
interact with our application. We will talk more about it later but if
you can't wait, check the awesome [routing
guide](http://emberjs.com/guides/routing/) on Ember.js.

`application.js` is the replacement for `app/assets/javascript/application.js`.

Remove your `app/assets/javascripts` since it will be ignore by EAKR `rm -rf app/assets/javascripts`.

Start your rails server `rails s` and go to `http://localhost:3000`, you will see `"Welcome to Ember!"`.

We are ready to start! In the next post we will create our first
model, talk a bit about testing and keep our journey of mastery of
Ember.js with Ruby on Rails.

### Can't wait?

1. Create an 'Ember' application template

       $ echo {{outlet}} > app/templates/application.hbs

2. In `config/routes.rb` uncomment the last line `get '*foo', :to => 'landing#index'`. It should look like [https://github.com/abuiles/ember-rails-week-1/blob/master/config/routes.rb#L64](https://github.com/abuiles/ember-rails-week-1/blob/master/config/routes.rb#L64)
3. In route.es6 uncomment   `location: 'history'` it should look like [https://github.com/abuiles/ember-rails-week-1/blob/master/config/router.es6#L8](https://github.com/abuiles/ember-rails-week-1/blob/master/config/router.es6#L8)


EAKR also has a scaffold command try the following

       $ rails g scaffold clients first_name:string last_name:string --ember
       $ rake db:migrate

Now navigate to `http://localhost:3000/clients` - Congrats! you have your first Ember app running.


####Don't fall behind subscribe to the Ember.js with Ruby on Rails list and stay updated.

<form action="http://emberenos.us7.list-manage.com/subscribe/post?u=103dd05cb2005f7b5485df96d&amp;id=25604cee1d" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate><label for="mce-EMAIL">Subscribe.</label><input type="email" value="" name="EMAIL" class="email" id="mce-EMAIL" placeholder="email address" required><!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups--> <div style="position: absolute; left: -5000px;"><input type="text" name="b_103dd05cb2005f7b5485df96d_25604cee1d" value=""></div><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div></form>
