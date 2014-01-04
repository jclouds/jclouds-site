---
layout: post
title: 500 jclouds builds on BuildHive and counting...
author: Adrian Cole
comments: true
tumblr_url: http://jclouds.tumblr.com/post/35355758760/500-jclouds-builds-on-buildhive-and-counting
---

At jclouds, we've been running our Jenkins continuous integration jobs in CloudBees' [DEV@cloud](http://www.cloudbees.com/dev) for a while now (CloudBees has a [FOSS](http://www.cloudbees.com/foss) programme). We also have an active and ever-increasing contributor community, which amongst others means... lots of pull requests.

So we were very interested to hear about [BuildHive](https://buildhive.cloudbees.com/), another CloudBees initiative that integrates with your GitHub account to automatically trigger build jobs for pull requests, and quickly signed up.

We did not regret it. BuildHive has served as a crucial initial filter to allow us to concentrate precious reviewing time on working changes and to remain confident, as pull requests are updated, that we are not going to break the build.

Of the last 100 builds, we've had 7 with errors, 2 with warnings, and 1 incomplete, so a roughly 10% efficiency gain in terms of focussing pull request review time. In future, we may also use BuildHive to provide *style feedback* and similar metrics for pull requests - most likely some feature suggestions for CloudBees to come here!

**Thanks, BuildHive!**
