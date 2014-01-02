---
layout: post
title: Take a peek at vCloud Director 1.5, OpenStack, and VirtualBox
author: Adrian Cole
comments: true
tumblr_url: http://jclouds.tumblr.com/post/19773099764/take-a-peek-at-vcloud-director-1-5-openstack-and
---

The jclouds team have been working very hard lately, particularly on a few new apis. We've decided to cage them no longer and cut jclouds 1.5.0-alpha.1. Most notably, we've added the openstack-nova api, and three new providers, all of which discovered via [OpenStack Keystone v2.0](http://docs.openstack.org/api/openstack-identity-service/2.0/content/).

* trystack-nova
* hpcloud-compute
* hpcloud-objectstorage

Here's how to boot up a new machine and add your login using the new [hpcloud-compute](https://hpcloud.com/) provider in clojure:

{% highlight clojure %}
(use ''org.jclouds.compute2)
(import ''org.jclouds.scriptbuilder.statements.login.AdminAccess)
(def compute  (compute-service "hpcloud-compute" "tenantId:ACCESSKEY" "SECRETKEY"    :slf4j :sshj))
(create-node compute "test"   (build-template compute { :run-script (AdminAccess/standard) } ))
{% endhighlight %}

Here's an example of how to do the same on [TryStack](https://trystack.org/), authenticating w/ user & pass as opposed to key, via our [java example](https://github.com/jclouds/jclouds-examples/tree/master/compute-basics):

{% highlight bash %}
java -jar target/compute-basics-jar-with-dependencies.jar trystack-nova tenantId:user password mygroup add
{% endhighlight %}

In the group org.jclouds.labs, you'll find two more new and notable members of the jclouds family:

* **vcloud-director:** supports 250 user and admin operations defined in the [vCloud Director](http://www.vmware.com/products/vcloud-director/overview.html) 1.5 ReST API
* **virtualbox:** start a group of vms on your laptop, provided an iso location for Ubuntu

You can try out virtualbox like any other api. For example, you can use the clojure above, only changing how you create the connection slightly:

{% highlight clojure %}
(def compute (compute-service "virtualbox" "administrator" "12345" :sshj :slf4j))
{% endhighlight %}

The code in labs will certainly change before we release a beta, but feel free to check them out. Meanwhile, you can try them out and give us feedback on #jclouds irc freenode or jclouds-dev google group!

Finally, many thanks to the [dozen contributors](https://github.com/jclouds/jclouds/compare/1.4.x...1.5.x) who's work is in this alpha, and particularly HP and VMware for sponsoring substantial effort.

Oh, and don't forget to clean up your nodes :)

{% highlight clojure %}
(destroy-nodes-matching compute (constantly true))
{% endhighlight %}
