---
layout: post
title: jclouds 1.3 released!
author: Adrian Cole
comments: true
tags: cloud jclouds
tumblr_url: http://jclouds.tumblr.com/post/16217483394/jclouds-1-3-released
---

The 1.3 release of jclouds includes results of 3-months effort by our contributors. A total of 57 Issues were addressed between jclouds 1.2.0 and the current revision of jclouds 1.3 (1.3.1).

Notable updates include:

* Support for Citrix CloudStack 2.2.13+
* Support for vCloud Director 1.5 endpoints
* Support for OpenStack Nova via our eucalyptus support

This release also supports more locations than ever including:

* Introduction of Ninefold compute in Sydney and HP Cloud Object Storage in SuperNAP (vegas)
* New aws-ec2 regions in Oregon and Sao Paulo
* New ElasticHosts zones in Toronto and Los Angeles

We also have a few new tricks for power users:

* image-id and login-user properties allow you to customize the default ComputeService template.
* Support for adding/removing nodes from Rackspace Cloud Load Balancers
* [Solid state drive (SSD) support](https://github.com/jclouds/jclouds/blob/master/providers/cloudsigma-zrh/src/test/java/org/jclouds/cloudsigma/compute/CloudSigmaZurichComputeServiceLiveTest.java) for Cloudsigma
* Support for aws-s3 Reduce Redundancy Storage
* New property to automatically assign elastic IP addresses (handy for OpenStack Nova).

As always, we keep our [examples site](https://github.com/jclouds/jclouds-examples) up to date so you can see how to work this stuff. Also, check out recent [jclouds integrations](/documentation/reference/apps-that-use-jclouds) including [Abiquo 2.0](http://www.abiquo.com), [Apache Camel](http://camel.apache.org/jclouds.html), [ElasticInbox](http://www.elasticinbox.com/), and [GigaSpaces Cloudify](http://www.gigaspaces.com/cloudify).

Please submit your own ideas and let us know if there are features you'd like to see, need help on, or are interested in contributing. Make sure you follow us on [Twitter](https://twitter.com/jclouds) for updates. If you are interested in learning about jclouds 1.3 IRL, come to our [training in Stockholm](http://www.citerus.se/post/591574-learn-portable-cloud-development-from-founder) or our next [meetup](http://www.meetup.com/jclouds/events/48534352/) at [Jfokus](http://www.meetup.com/jclouds/events/48534352/).

## Credits

Special thanks to Alcatel Lucent for sponsoring the majority of our CloudStack implementation, and the CloudStack community for answering hundreds of questions over the last year! Additional thanks to Jeremy Daggett from HP for contributing HP Cloud Object Storage support, and setting stage for further OpenStack improvements in future releases. Also thanks to Jesse Wilson from Gson, who took time with us to hone our use of Gson to the point where we no longer require patches.

Finally, thanks to everyone who contributed their time and effort in order to make this release happen. Check out who's been busy [here](http://www.ohloh.net/p/jclouds/contributors?query=&sort=latest_commit).

## More info?

Check out the [release notes](/documentation/releasenotes/1.3) for more info on this release!
