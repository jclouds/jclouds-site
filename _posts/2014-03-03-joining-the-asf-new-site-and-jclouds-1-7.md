---
layout: post
title: Joining the ASF, new site, and jclouds 1.7!
author: Ignasi Barrera
comments: true
---

It's been a while since our last blog post, and lots has happened since then. There have been many things that have kept us busy, and finally, all the hard work is starting to show up. During this time, we've:

* Moved the project to [The Apache Software Foundation](http://www.apache.org) and consolidated our community processes.
* Rebranded the entire site.
* Released [1.6](/releasenotes/1.6.3/) bugfix versions.
* Released jclouds [1.7.0](/releasenotes/1.7/) and [1.7.1](/releasenotes/1.7.1/) with important features and bugfixes.

## Moving to the Apache Software Foundation

Moving to the ASF has been one of the most important steps we've taken regarding the project structure. This change has given us better legal support, more infrastructure tools, has helped us formalize and improve our workflows, and helped us focus on properly managing and building the community.

We'll never be thankful enough to [Adrian](https://twitter.com/adrianfcole) for his hard work on the project, and for kindly helping, mentoring and welcoming us to participate in it. There have been many years of hard work that have put jclouds where it is right now, and moving to the ASF has been just a natural step towards the maturity of the project and the need to properly manage the community growth.

After a relatively short period in the [Incubator](https://incubator.apache.org) learning a lot from our [mentors](https://incubator.apache.org/projects/jclouds.html), and with the valuable guidance from [Andrew Bayer](https://twitter.com/abayer) and his help making the first releases, we graduated as a top level project... and here we are!

## New design for the main site

Another important change that has kept us busy has been the rebranding of the main site. We've tried to improve it so:

* Documentation is easier to find.
* Pages look cleaner and are easier to read.
* The entire style and structure of the pages is more consistent.

We have focused on the design and on making the important documentation more accessible. An upcoming effort to improve the contents is coming, and we'd love your feedback, or even better, [your help](https://cwiki.apache.org/confluence/display/JCLOUDS/How+to+Contribute+Documentation)!.

## jclouds 1.7.0 and 1.7.1 released!

The jclouds 1.7 releases include many new features and some major changes that will be completed in upcoming major releases. Here is a summary of the notable changes, but make sure to check the [release notes](/releasenotes/):

* Removed the async interfaces from most of the compute providers. Starting from jclouds 1.7.0, the async interfaces have been deprecated. They provided little value to the project and added considerable complexity to its maintenance. Current users of the async features can configure and use their own executors to handle concurrent requests. See e.g. [MultiFileUploaderC.java](https://github.com/jclouds/jclouds-cloud-storage-workshop/blob/master/exercise2/src/main/java/org/jclouds/labs/blobstore/exercise2/MultiFileUploaderC.java) for an example of carrying out an async blobstore request.
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

Want to see all this in action? [Download](/start/install) and start using the latest jclouds version!

## Special thanks

These have been very busy months and many things have been going on. We'd especially like to thank all [providers that are helping](https://cwiki.apache.org/confluence/display/JCLOUDS/Test+Provider+Thanks) us improve the quality of the project by giving us testing accounts. This is helping us a lot and allows us to perform better testing of supported providers before every release.

We also want to thank [everyone that helped](http://www.ohloh.net/p/jclouds/contributors?query=&sort=latest_commit) by contributing code, documentation, or participating in the [mailing lists](/community). We love having your feedback and contributions!

**Thank you all!**
