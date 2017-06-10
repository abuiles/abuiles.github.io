---
layout: post
title: "Lightning Fast Deployments with Rails (in the wild)."
date: 2014-07-08 14:30:18 -0700
comments: true
categories: ember-cli, Rails, Ember.js
---
**[Getting started with Ember.js? I cover different deploying strategies in my Ember.js book](https://leanpub.com/ember-cli-101)**

A couple of months ago I wrote an article about deploying ember-cli
apps to heroku. Looking back, it was more a dirty hack to get things
working than a long term solution.

During Ember Conf  I had the opportunity to talk with some of the @yapplabs folks
about the method they were using to deploy their apps and
then Luke Melia gave an interesting talk on Rails Conf [1] about it.

Then, there was a blog post by Feifan Wang [2] implementing Luke's concepts, and I used
that as the backbone for my current solution.

Instead of prefixing the current deploy with timestamps, we put all
the files on the same dir to avoid cache busting. By default when
accessing the app in Rails, we'll serve serve the latest stable
release which is stored in Redis as "release:index.html", or if the
user asks for the "canary" version (?version=canary) then serve the
latest known deployment.

The reason for including a 'canary' release [3] is that I can test stuff
in production before making it available to the public, also being
able to serve other versions, means we can develop different features
and share the same "staging" app, and then just test by passing as
param the feature's shortSHA.

There are more advantages about this approach, check out Luke's video
for more enlightment!

# Generating the build.

First let's examine the Brocfile, we just tell Broccoli to fingerprint our assets preprending our cloudfront url to all of them.
the final result would look something like `https://d29bb5msqib8gy.cloudfront.net/assets/vendor-6673dc1e2f6a7bece01002d43fae1b5b.js`.

```
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

var app = new EmberApp({
  // broccoli-asset-rev is now an ember-cli addon.
  fingerprint: {
    prepend: 'https://d29bb5msqib8gy.cloudfront.net/'
  },
  minifyCSS: {
    enabled: true,
    options: {}
  }
});

module.exports = app.toTree();
```

With that we get our desired 'dist' output. Next we need to upload it
to S3 (we might be able to do this directly with ember-cli soon)

## Gruntfile

Next we tell grunt to upload to S3 and push the generated index to
Redis. The default task publish the index as a canary release (meaning
it doesn't get served by default) just if the user explicitly requires
`?version=canary`. If we want to make the current version the
one that the users get served then we run `grunt
publish-release`.

Normally we'll run the default task on our CI server against staging,
and then when things get merged into production run the release task,
optionally we can run always the default task against production, in that way your
clients can try the latest version of the app before making it
available to everyone else.

```
module.exports = function(grunt) {
  grunt.initConfig({
    env: grunt.file.readJSON('.env'),
    s3: {
      options: {
        key: '<%= env.AWS_ACCESS_KEY_ID %>',
        secret: '<%= env.AWS_SECRET_ACCESS_KEY %>',
        bucket: '<%= env.AWS_BUCKET %>',
        access: 'public-read',
        headers: {
          "Cache-Control": "max-age=630720000, public",
          "Expires": new Date(Date.now() + 630720000).toUTCString()
        },
      },
      dev: {
        upload: [
          {
            src: 'dist/assets/**/*',
            dest: 'assets/',
            rel: 'dist/assets',
            options: { verify: true }
          }
        ]
      }
    },
    redis: {
      options: {
        manifestKey: 'releases',
        manifestSize: 10,
        host: '<%= env.REDISTOGO.host %>',
        port: '<%= env.REDISTOGO.port %>',
        connectionOptions: {
          auth_pass: '<%= env.REDISTOGO.password %>'
        }
      },
      canary: {
        options: {
          prefix: '<%= gitinfo.local.branch.current.shortSHA %>:',
          currentDeployKey: '<%= gitinfo.local.branch.current.shortSHA %>',
        },
        files: {
          src: ["dist/index.html"]
        }
      },
      release: {
        options: {
          prefix: 'release:'
        },
        files: {
          src: ["dist/index.html"]
        }
      }
    },
  });
  grunt.loadNpmTasks('grunt-gitinfo');
  grunt.loadNpmTasks('grunt-s3');
  grunt.loadNpmTasks('grunt-redis');

  grunt.registerTask('release', ['gitinfo', 'redis:release']);
  grunt.registerTask('canary', ['gitinfo', 'redis:canary']);
  grunt.registerTask('publish-release', ['default', 'release']);
  return grunt.registerTask('default', ['gitinfo', 's3:dev', 'canary']);
};
```

# Rails
In rails we will need to have `redis` gem installed and then
in our root action just serve the index.html from Redis.

```
class LandingController < ApplicationController
  def index
    render text: index_html
  end

  private

  def index_html
    redis.get "#{deploy_key}:index.html"
  end

  # By default serve release, if canary is specified then the latest
  # known release, otherwise the requested version.
  def deploy_key
    params[:version] ||= 'release'
    case params[:version]
    when 'release' then 'release'
    when 'canary'  then  redis.lindex('releases', 0)
    else
      params[:version]
    end
  end

  def redis
    if Rails.env.development?
      redis = Redis.new()
    else
      Redis.new(:url => ENV['REDISTOGO_URL'])
    end
  end
end
```

And voilá! You have separated your Ember.js and Rails app with super fast deployments!

Dealing with CSRF can be done injecting the csrf token in your header
and then telling Ember to pick it up for you, or use my
[rails-csrf](https://github.com/abuiles/rails-csrf) plugin which will
take care of everything, it just requires and end-point for
fetching the csrf token.

If you want to see this in a real app check the client-side part in
[facturas-client](https://github.com/abuiles/facturas-client/blob/master/Gruntfile.js)
and the Rails part in [facturas Rails](https://github.com/abuiles/facturas/commit/391fcfad81ba8afcabf33bd349d05ba19e3073da)

## Standing on the shoulder of giants.

Thanks Luke, for your Rails Conf talk!

![Luke Melia](http://cl.ly/image/1Z3M2B1Q2X2a/Screen%20Shot%202014-07-08%20at%202.12.20%20PM.png)

Thanks Feifan Wang for you blog post and `grunt-redis-manifest`.


#### Pair with me.
If you are looking for help with Ember.js/ember-cli/Rails, I do a free hour of
pairing every week, shoot me an email to <builes.adolfo@gmail.com>.

**[Get my Ember.js book and to learn how to write apps with Ember.js, Ruby on Rails and ember-cli](https://leanpub.com/ember-cli-101)**



- [1] [RailsConf 2014 - Lightning Fast Deployment of Your Rails-backed JavaScript app](https://www.youtube.com/watch?v=QZVYP3cPcWQ)
- [2] [Framework agnostic, fast zero-downtime Javascript app deployment](https://medium.com/@feifanw/framework-agnostic-fast-zero-downtime-javascript-app-deployment-df40cf105622)
- [3] [Canary Release](http://martinfowler.com/bliki/CanaryRelease.html)
