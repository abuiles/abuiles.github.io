---
layout: post
title: "Getting started with Ember.js and Ruby on Rails: Ember Appkit Rails"
date: 2014-01-31 09:46:28 -0200
comments: true
categories:
---
**This is the second post of my series about [learning Ember.js
with Ruby on Rails](http://blog.abuiles.com/ember-rails/).**

### Ember App Kit

[Ember App Kit](https://github.com/stefanpenner/ember-app-kit) is project started by Embereño [Stefan Penner](http://twitter.com/stefanpenner), from its page:

> Ember App Kit (EAK) is a robust starter kit for developing
applications in Ember.js. EAK makes it easy to develop, build, test,
and deploy applications independent of any back-end build process.

Getting an Ember project started is really easy thanks to EAK, it
already puts the basic structure of our apps so we can focus on
what we like the most, developing.

But what if I want to use Ruby on Rails and Ember? How can I get all
this stuff to play nicely?.

There are three options:

1. Keep two separate projects, a Rails app (probably using rails-api) and an EAK app.
2. Use the `ember-rails` which basically puts Ember's source files in your project and compiles your templates.
3. Use Ember Appkit Rails :).


### Introducing Ember Appkit Rails.
[Ember Appkit Rails](https://github.com/dockyard/ember-appkit-rails)
is a [DockYard's](http://dockyard.com) project which aims to port
Ember App Kit to the Asset Pipeline.

Different to the `ember-rails`'s gem, EAKR brings the same level of
importance to your Ember.js files as your Rails files (plus some other
goodies), and this has a huge impact on how we are used to look at Rails apps.

EAKR (Ember Appkit Rails) puts by default all your ember application
code under `app/` and configuration files under `config/`, it also
removes `app/assets/javascripts` from the assets load path and ignores
files put in that directory. All this can be configurable and
and could change for 1.0.

You also get some Rails generators and if you pass
`--ember`, it will create the equivalent files for Ember.

As an example let's look at the output of `rails g scaffold posts --ember`

    $rails g scaffold user first_name:string last_name:string --ember
          invoke  active_record
          create    db/migrate/20140131134237_create_users.rb
          create    app/models/user.rb
          invoke    rspec
          create      spec/models/user_spec.rb
          invoke      factory_girl
          create        spec/factories/users.rb
          create  config/serializers/user_serializer.rb
          invoke  ember:resource
          create    app/models/user.es6
          create    test/models/user_test.es6
          create    app/routes/users/edit.es6
          create    app/routes/users/index.es6
          create    app/routes/users/new.es6
          create    app/routes/users/show.es6
          insert    config/router.es6
          create    app/templates/users/edit.hbs
          create    app/templates/users/index.hbs
          create    app/templates/users/new.hbs
          create    app/templates/users/show.hbs
          create    app/templates/users.hbs
          create    app/templates/users/form.hbs
          invoke  scaffold_controller
          create    app/controllers/api/v1/users_controller.rb
          invoke    rspec


It creates our Ruby on Rails models, controllers, Ember files and test.

Some important things to notice here are

1. Ember.js files are located under app, e.g. `app/models/user.es6`

2. Note the extension for JavaScript files: `.es6`. It means that
they are written using ECMAScript 6 syntax which then is compiled to
AMD (Hopefully GitHub will [start to highlight this file](https://github.com/github/linguist/pull/910))

3. Your controller is namespaced under `api/vX`, you can change the version with `config.ember.api_version`, also your controller is optimized to be a `json` end-point.

4. `test/models/user_test.es6` this is actually not part of the
   official version but might be integrated any time soon (I'm using a
   development branch), you will also get test for other parts of your
   Ember app like Routes, Controller, and Integration.

All this is still under heavy development and some things might change
(I'll keep this post updated).

In the next post we will start to work on an application and also get
into some of Ember.js concepts as we start to come across them.

**Subscribe to the Ember.js with Ruby on Rails list to stay updated.**


<form action="http://emberenos.us7.list-manage.com/subscribe/post?u=103dd05cb2005f7b5485df96d&amp;id=25604cee1d" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate><label for="mce-EMAIL">Subscribe.</label><input type="email" value="" name="EMAIL" class="email" id="mce-EMAIL" placeholder="email address" required><!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups--> <div style="position: absolute; left: -5000px;"><input type="text" name="b_103dd05cb2005f7b5485df96d_25604cee1d" value=""></div><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div></form>
