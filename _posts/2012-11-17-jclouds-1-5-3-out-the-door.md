---
layout: post
title: jclouds 1.5.3 out the door
author: Adrian Cole
comments: true
tags: jclouds cloud openstack rackspace ec2 buildhive cloudbees java
tumblr_url: http://jclouds.tumblr.com/post/35922275965/jclouds-1-5-3-out-the-door
---

Released on 2012-11-14, jclouds 1.5.3 includes minor fixes, and a few important updates.

* New [openstack-cinder](https://github.com/jclouds/jclouds-examples/tree/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudblockstorage) and [rackspace-cloudblockstorage-us/uk](/documentation/quickstart/rackspace/#volumes) providers
* Add new Asia Pacific (Sydney) Region [ap-southeast-2]
* New [TagApi](https://github.com/jclouds/jclouds/blob/master/apis/ec2/src/main/java/org/jclouds/ec2/features/TagApi.java) for ec2, in a revised syntax similar to openstack-nova
* Handle network failures in large container (1M+) deletes in blobstore
* jclouds-cli and jclouds-karaf now provide a more intuitive file-based interface for reading and writing blobs.

Many thanks to the contributors in this release of [jclouds](https://github.com/jclouds/jclouds/compare/jclouds-1.5.2...jclouds-1.5.3), [jclouds-chef](https://github.com/jclouds/jclouds-chef/compare/jclouds-chef-1.5.2...jclouds-chef-1.5.3), [jclouds-karaf](https://github.com/jclouds/jclouds-karaf/compare/jclouds-karaf-1.5.2...jclouds-karaf-1.5.3), and [jclouds-cli](https://github.com/jclouds/jclouds-cli/compare/jclouds-cli-1.5.2...jclouds-cli-1.5.3). Also many thanks for the diligence of our review team: [Andrew Gaul](https://github.com/andrewgaul) and [Matt](https://github.com/mattstep) for code, and [Becca](https://github.com/silkysun) on docs.

Moreover, we're indebted to [BuildHive](http://blog.cloudbees.com/2012/11/500-jclouds-builds-on-buildhive-and.html) for checking over 500 pull requests to date! On a build side, we currently validate both JDK6 and JDK7 on each pull, thanks to [Andrew Phillips](https://github.com/demobox).

Please [update](/documentation/userguide/install/) to jcloud 1.5.3 and check the new features. Particularly, try things out using JDK7. If you have questions, ping our user group or tag your question with *jclouds* on [stackoverflow](http://stackoverflow.com/tags/jclouds).

We are working on 1.6 now, which includes a lot of cleanup and mechanisms to make less api calls when starting groups of machines. If interested in helping us out, hop onto IRC freenode #jclouds or join our dev group.
