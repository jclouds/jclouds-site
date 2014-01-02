---
layout: post
title: Fluency for paginated api lists
author: Adrian Cole
comments: true
tags: aws s3 guava java clojure cloud jclouds
tumblr_url: http://jclouds.tumblr.com/post/27338079498/fluency-for-paginated-api-lists
---

The problem of large result sets is something cloud providers want you to have. For example, what better sign of cloud life is there than Amazon S3 having a trillion objects stored so far. The way most cloud apis deal with listing your million (or even thousand) things is to paginate the response.

For example, you get a first page with maybe 500 records in it, and a *marker* you can use to get the next. Sounds pretty straightforward, and most jclouds abstractions do this dance for you. For example, our BlobStore api has an interface [PageSet](https://github.com/jclouds/jclouds/blob/master/blobstore/src/main/java/org/jclouds/blobstore/domain/PageSet.java) which holds a bunch of results and the underlying marker. This also deals with the fact that sometimes *[marker](http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGET.html)* is called *[nextToken](http://docs.amazonwebservices.com/AmazonCloudWatch/latest/APIReference/API_ListMetrics.html)* or other unnecessarily different names :)

3 years since the birth of *PageSet*, you can imagine folks could get a better idea of what they *really* want. Here's a few comments:

* **Marker isn't necessarily a String!** - [Andrew Gaul](http://gaul.org/) notes that especially in native implementations, it isn't the case that Marker will always be a String. Imagine you are making an in-memory store. It is very likely the marker will be an Object in this case.
* **Set is the wrong type for results!** - [Tim Peierls](http://tembrel.blogspot.com/) notes that uniqueness isn't a fundamental concern of API results. In fact, it can get in the way of streaming.
* **Iterating through a bunch of pages is monkey-work!** - [Jeremy Whitlock](http://www.thoughtspark.org/) found dancing through each page to get a complete view of metrics was tiring, and made a CloudWatch function for that.
* **Ensure it is possible to opt-out!** - [Toni Batchelli](http://tbatchelli.org/) notes that iterating across network calls can lead to inconsistent state. Particularly clojure users will want the option to manually control pagination.

This feedback underscored jclouds general concern to make things easier, yet still allow control. The status was tracked in issue 1011 and our jclouds-dev google group.

Through several iterations and many thanks to Tim P. for the design, we have a new type: [PagedIterable](https://github.com/jclouds/jclouds/blob/master/core/src/main/java/org/jclouds/collect/PagedIterable.java), which extends Guava's fantastic *FluentIterable*. Here are a few examples of how it can be used:

### Lazy advance through all your metrics:

{% highlight java %}
FluentIterable<Metric> allMetrics = cloudwatch.getMetricApi().list().concat();
{% endhighlight %}

### Advance only until we find the load balancer we want:

{% highlight java %}
Optional<LoadBalancer> firstInterestingLoadBalancer = elb
   .getLoadBalancerApi().list()
   .concat()
   .firstMatch(isInterestingLB());
{% endhighlight %}

### Get only the first page of database instances

{% highlight java %}
IterableWithMarker<Instance> firstPage = rds.getInstanceApi().list().get(0);
{% endhighlight %}

The above syntax is being worked through relevant apis. In order to try it out, grab jclouds 1.5.0-beta.7 (releasing today), and use any of the following methods:

* *cloudwatch/aws-cloudwatch* - MetricApi.list()
* *elb/aws-elb* - LoadBalancerApi.list()
* *iam/aws-iam* - UserApi.list()
* *rds/aws-rds* - InstanceApi.list() SecurityGroupApi.list() SubnetGroupApi.list()

Other apis and abstractions will be caught up while we finish the 1.5 release.

Many thanks to guava for the base class, jclouds folks who participated in the design, as well the [airlift](https://github.com/airlift/airlift) guys who's feedback helped solidify the idea. If you are interested in participating, please reach out on irc freenode #jclouds or @jclouds on twitter!
