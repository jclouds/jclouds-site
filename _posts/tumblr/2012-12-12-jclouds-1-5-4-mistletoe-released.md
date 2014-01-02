---
layout: post
title: jclouds 1.5.4 "Mistletoe" released
author: Adrian Cole
comments: true
tumblr_url: http://jclouds.tumblr.com/post/37796834043/jclouds-1-5-4-mistletoe-released
---

jclouds community is an international group with over [100](https://www.ohloh.net/p/jclouds) contributors since we started in early 2009. The idea of holidays vary, but we decided **Mistletoe** as an appropriate codename for jclouds 1.5.4. Here's why.

## Chef and Karaf

We've noticed an attraction between systems that use [chef](http://www.getchef.com/) and those that use [karaf](https://karaf.apache.org/). For example, it isn't uncommon to have a [deployment pipeline](https://jclouds-dev.googlegroups.com/attach/2155fd6ba2a80939/Comm%20Cloud%20IOC.png?view=1&part=4) that incorporates the two. Since jclouds has subproject for both chef and karaf, it seemed natural to cozy them together. Thanks to [Ioannis](https://twitter.com/iocanel) and [Ignasi](https://twitter.com/IgnasiBarrera), karaf and chef are now a couple!

For example, the following syntax can be used in karaf directly, or via the [jclouds cli](https://github.com/jclouds/jclouds-cli) to start a node in any supported cloud and bootstrap chef recipes.

{% highlight bash %}
karaf@root>node-create --adminAccess --recipe chef/java::openjdk karaf
{% endhighlight %}

## What else is in 1.5.4?

We've a number of other highlights in jclouds 1.5.4. Many thanks to the code contributors [jclouds](https://github.com/jclouds/jclouds/compare/jclouds-1.5.3...jclouds-1.5.4), [jclouds-chef](https://github.com/jclouds/jclouds-chef/compare/jclouds-chef-1.5.3...jclouds-chef-1.5.4), [jclouds-karaf](https://github.com/jclouds/jclouds-karaf/compare/jclouds-karaf-1.5.3...jclouds-karaf-1.5.4), and [jclouds-cli](https://github.com/jclouds/jclouds-cli/compare/jclouds-cli-1.5.3...jclouds-cli-1.5.4) for putting them together. Also to our review team for helping ensure quality: [Andrew Gaul](https://github.com/andrewgaul) and [Matt](https://github.com/mattstep) for code, and [Becca](https://github.com/silkysun) on docs.

### Rackspace Cloud Load Balancers

[Everett](https://github.com/everett-toews) modernized support for **rackspace-cloudloadbalancers-us** and **uk** is now available. This includes syntactic sugar such as auto-pagination and easy transforms.

{% highlight java %}
FluentIterable<HostAndPort> sockets = clb.getLoadBalancerApiForZone(zone).list().concat().transform(converter);
{% endhighlight %}

### Nova Server Diagnostics
Some implementations of Nova have diagnostic information available. Thanks to [Leander](https://github.com/LeanderBB), you can now discover this capability at runtime.

{% highlight java %}
Optional<Map> diagnosticInfo = novaApi.getServerApiForZone("az-1.region-a.geo-1").getDiagnostics(serverId);
{% endhighlight %}

### S3 Multi-Object delete

[Maginatics](http://maginatics.com/) have BlobStore containers with over a billion objects in them. S3 containers (buckets) can now be cleared with 1/1000 the requests, thanks to [Andrei](https://twitter.com/andreisavu)'s additional support of S3 multi-delete.

{% highlight java %}
DeleteResult result = s3Api.deleteObjects(container, keys);
assertEquals(result.size(), keys.size());
{% endhighlight %}

## What's next

We are working on 1.6, an effort more efficient and resilient. One tool we are evaluating for this is [Netflix Hystrix](https://groups.google.com/forum/?fromgroups=#!topic/jclouds-dev/fVILfUoW_zg). We are also working on 1.5.x releases, which are likely to include google compute engine and virtualization support. If interested in helping us out, hop onto IRC freenode #jclouds or join our dev group.
