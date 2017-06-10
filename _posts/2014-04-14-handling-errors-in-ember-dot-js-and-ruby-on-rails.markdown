---
layout: post
title: "Handling Errors in Ember.js and Ruby on Rails"
date: 2014-04-14 23:39:22 -0300
comments: true
categories: [Ember.js, Ruby on Rails]
---

Ember.js has built-in support to handle errors returned by the backend through the computed property `errors`, to get it working with the `ActiveModelAdapter` you payload's root key has to be called `errors` and your status code should be `422`.


Suppose you want to create a post and you get an error like the following:

    { errors: { body: ['can't be blank'] } }


Once the requests has been completed you can check if you model is valid or not with `model.get('isValid')` and then the  `errors` with:


     post.get('errors').get('body')
     [
       Object
       attribute: "body"
       message: "can't be blank"
       __proto__: Object
     ]

Notice that a record becomes `isInvalid` only if `DS.InvalidError` can be created, on the `ActiveModelAdapter` case that is if the status code is `422` and `errors` is the root of your payload, otherwise it becomes `isError`.

If you want a validation library checkout [DockYard's ember-validations](https://github.com/dockyard/ember-validations)


P.S I'm [writing a series of post on working with Ember.js and Ruby on Rails](http://blog.abuiles.com/ember-rails/), subscribe to my list and I will let you know every time I publish an article on Ember.js and Ruby on Rails.


<form action="http://emberenos.us7.list-manage.com/subscribe/post?u=103dd05cb2005f7b5485df96d&amp;id=25604cee1d" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate><label for="mce-EMAIL">Subscribe.</label><input type="email" value="" name="EMAIL" class="email" id="mce-EMAIL" placeholder="email address" required><!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups--> <div style="position: absolute; left: -5000px;"><input type="text" name="b_103dd05cb2005f7b5485df96d_25604cee1d" value=""></div><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div></form>