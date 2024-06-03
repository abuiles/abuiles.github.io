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
