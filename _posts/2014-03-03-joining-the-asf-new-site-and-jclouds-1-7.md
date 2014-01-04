---
layout: post
title: Joining the ASF, new site, and jclouds 1.7!
author: Ignasi Barrera
comments: true
---

It's been a while since our last blog post, and many things happened since then. There have been many things that have kept us busy, and finally, all the hard work is starting to show up. During this time, we've:

* Moved the project to [The Apache Software Foundation](http://www.apache.org) and consolidated our community processes.
* Rebranded the entire site.
* Released 1.6 bugfix versions.
* Released jclouds [1.7.0](/releasenotes/1.7/) and [1.7.1](/releasenotes/1.7.1/) with important features and bugfixes.

In this blog post we'll try to summarize the details of all those things.

## The Apache Software Foundation

Moving to the ASF has been one of the most important steps we've taken regarding the project structure. This change has given us better legal support, more infrastructure tools, has helped us formalize and improve our workflows, and helped us focus on properly managing and building the community.

We'll never be thankful enough to [Adrian](https://twitter.com/adrianfcole) for his hard work on the project, and for kindly helping, mentoring and welcoming us to participate in it. There have been many years of hard work that have put jclouds where it is right now, and moving to the ASF has been just a natural step towards the maturity of the project and the need to properly manage the community growth.

After a relatively short period in the [Incubator](https://incubator.apache.org) learning a lot from our [mentors](https://incubator.apache.org/projects/jclouds.html), and with the valuable guidance from [Andrew Bayer](https://twitter.com/abayer) and his help making the first releases, we graduated as a top level project... And here we are!

## New design for the main site

Another important change that has kept us busy has been the rebranding of the main site. We've tried to improve it so:

* Documentation is easier to find.
* Pages look cleaner and are easier to read.
* The entire style and structure of the pages is more consistent.

We have focused on the design and on making the important documentation more accessible. An upcoming effort to improve the contents is coming, and we'd love to receive your feedback, or even better, [your help](http://wiki.apache.org/jclouds/How%20to%20Contribute%20Documentation)!.

## jclouds 1.7.0 and 1.7.1 released!

The jclouds 1.7 releases include many new features and some major changes that will be completed in upcoming releases. Here is a summary of the notable changes, but make sure to check the [release notes](/releasenotes/):

* Removed the async interfaces from most of the compute providers. Starting from jclouds 1.7.0, the async interfaces have been deprecated. They provided little value to the project and added a considerable complexity to its maintenance. Users willing to use async features should better configure their own executors and properly handle concurrency in their applications.
* Added support for the [CloudSigma v2 API](https://cloudsigma-docs.readthedocs.org/en/2.10/).
* Added the [DigitalOcean](https://www.digitalocean.com) provider.
* Added the [OkHttp](http://square.github.io/okhttp/) HTTP driver for improved HTTP connections.
* Properly support HTTP PATCH methods.
* Added Rackspace Autoscale support.
* Added OpenStack Databases (Trove) and Rackspace Cloud Databases support.
* Added OpenStack Queuing (Marconi) and Rackspace Cloud Queues support.
* Added OpenStack Networking (Neutron) v2.0 support.
* Added support for full Google Compute Engine v1beta16 API
* Allow `jclouds-chef` to manage custom environments.
* ... and many more!

Want to see all this in action? [Download](/start/install) and start usignt the latest jclouds version!

## Special thanks

These have been very busy months and many things have been going on. We'd like to specially thank all [providers that are helping](http://wiki.apache.org/jclouds/Test%20Provider%20Thanks) us improve the quality of the project by giving us testing accounts. This is helping us a lot and make us able to better test the providers before every release.

We also want to thank [everyone that helped](http://www.ohloh.net/p/jclouds/contributors?query=&sort=latest_commit) by contributing code, documentation, or participating in the [mailing lists](/community). We love having your feedback and contributions!

**Thank you all!**
