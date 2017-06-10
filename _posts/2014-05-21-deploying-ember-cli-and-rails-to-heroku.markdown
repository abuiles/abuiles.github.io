---
layout: post
title: "Deploying ember-cli and Rails to Heroku"
date: 2014-05-21 10:09:55 -0300
comments: true
categories: ember-cli, Rails, Ember.js
---
** this post is out-dated use [Lightning Fast Deployments instead](http://blog.abuiles.com/blog/2014/07/08/lightning-fast-deployments-with-rails) **

I moved the app which I was doing as part of my Ember.js with Rails
series to ember-cli, but just until very recently deployed to heroku.

I want to put my ember-cli output into my `rails/public` and then
include the scripts into my application layout

```html
<!DOCTYPE html>
<html>
  <head>
    <base href="/" />

    <link rel="stylesheet" href="ember-assets/vendor.css">
    <link rel="stylesheet" href="ember-assets/client.css">
    <%= csrf_meta_tags %>
  </head>
  <body>
    <%= yield %>
    <script>
      window.ENV = {"railsCsrf":{"csrfURL":"api/v1/csrf"},"baseURL":"/","locationType":"auto","FEATURES":{"query-params-new":true},"APP":{}};
    </script>
    <script src="ember-assets/client.js"></script>
    <script>
      window.Client = require('client/app')['default'].create(ENV.APP);
    </script>
  </body>
</html>
```

I do it like this because I want to include my `csrf_tags` in the body
and also have the option of preloading any data if I need to.

Out of topic, but since handling csrf-tags is such a common scenario I
wrote [rails-csrf](http://github.com/abuiles/rails-csrf), a plugin
which you can install through bower for handling CSRF for you.


## Building

I came through a script by Jason Madsen(@jason_madsen) which would
take care of building the ember-cli app and putting it under public,
it works great but the final output is under your `public/index.html`
which I don't want.

I modified the script to do a couple of things more.

1. Add `<%= csrf_meta_tags %>` before head (line 40).
2. Add `<%= yield %>` after body (line 43).
3. Replace `application.html.erb` with my final `index.html` (line 46)

The script can be found on the following [gist](https://gist.github.com/abuiles/5c281123fc41e6b988e3)

## Deploying

Now with the desired output, is just a matter of `git commit` and `git push` to heroku.

To make it easier I added the following task to my Rakefile, it:

1. Accepts the "env" I want to deploy and the remote name (heroku end-point).
2. Moves to the specified env and merges master.
3. Runs the `build` script and commit the changes.
4. Push the changes to heroku.

```ruby
task :deploy, :env, :remote do |t, args|
  sh "git checkout #{args[:env]}"
  sh 'git merge master -m "Merging for deployment"'
  sh './build.sh'

  sh 'git add -A'
  sh 'git commit -m "Compile for deployment"'

  sh "git push #{args[:remote]} head:master"
end
```

A standard deployment would be something like `rake deploy[production, heroku]`

It assumes you have a branch called `production` and that your remote is called `heroku`.

## Acknowledgements
Thanks to Jason Madsen for his initial script, he also made a rails template [knomedia/ember-cli-rails]( https://github.com/knomedia/ember-cli-rails).

The rake task was mostly inspired by [DockYard's ember-cli-plus-backend](https://github.com/dockyard/ember-cli-plus-backend).

## Future work

There is still a lot of things to improve which I'll be blogging about as part of my ember-cli + Rails series. Here's a list of things:

1. Deploying to heroku just the Rails files, currently we include the ember-cli app as well.
2. Using cloud front for serving your assets.
3. ~~Fingerprinting~~ is super simple with [broccoli-asset-rev](https://github.com/rickharrison/broccoli-asset-rev) see it in use [here](https://github.com/abuiles/facturas/commit/12b23d5fc36d0906a1e21cae7aed97bdbb8cba9e).
4. Doing lightning fast deployments (see [Luke's Melia talk on Rails Conf](http://www.confreaks.com/videos/3324-railsconf-lightning-fast-deployment-of-your-rails-backed-javascript-app)).


**[Learn how to write apps with Ember.js, ember-cli and Ruby on Rails](http://blog.abuiles.com/ember-rails/), subscribe to my list and I will let you know every time I publish an article. **