---
layout: post
title: jclouds 1.2 released!
author: Adrian Cole
comments: true
tumblr_url: http://jclouds.tumblr.com/post/11630642075/jclouds-1-2-released
---

The 1.2 release of jclouds includes results of almost 2 months effort by our [community](/documentation/reference/apps-that-use-jclouds). A total of 55 Issues were addressed between jclouds 1.1 and 1.2, stabilizing the cloud so you don't have to!

* We now support 33 cloud providers and reach 8 new data centers from [CloudSigma](http://www.cloudsigma.com/), [Go2Cloud](http://www.go2cloud.co.za/), and [SoftLayer](http://www.softlayer.com/cloudlayer/build-your-own-cloud).
* We've made sysadminy tasks more programmable, and feel more like Java. Using *submitScriptOnNode*, you can use java concurrent semantics for bash scripts!

{% highlight java %}
future = client.submitScriptOnNode(node.getId(), 
                AdminAccess.builder().adminUsername("foo").build(),
                nameTask("adminUpdate"));
{% endhighlight %}

As always, we keep our [examples site](https://github.com/jclouds/jclouds-examples) up to date so you can see how to work this stuff. Next release will be in approximately 1-months time. Look out for progress including [vCloud 1.5](http://www.vmware.com/products/vcloud-director/overview.html), [Voxel](http://voxel.net/voxcloud), and [VirtualBox](https://www.virtualbox.org/).

For full details on the jclouds 1.2.1 release, check out our [release notes](/documentation/releasenotes/1.2).

Catch up with us on [twitter](https://twitter.com/jclouds), irc, the mailing-list, or IRL at one of the many upcoming [events](http://www.meetup.com/jclouds/).

Great job, team!
