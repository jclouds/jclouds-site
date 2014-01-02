---
layout: post
title: New toys in 1.5.0-alpha.6
author: Adrian Cole
comments: true
tumblr_url: http://jclouds.tumblr.com/post/22267128043/new-toys-in-1-5-0-alpha-6
---

We are very near beta, I promise! In the mean time, we just cut a new codebase with a bunch of cool new toys. Here's a few. Thanks to Adam Lowe, we are getting even deeper into OpenStack with more Keystone support than ever. Setup your code to pull *org.jclouds.labs/openstack-keystone*, and you can do stuff like this.

{% highlight java %}
ContextBuilder contextBuilder = ContextBuilder.newBuilder("openstack-keystone");
RestContext keystone = contextBuilder
    .credentials("tenantId:user", "password")
    .endpoint("https://keystone:35357")
    .build();

for (String regionId : keystone.getApi().getConfiguredRegions()) {
    AdminClient adminClient = keystone.getApi().getAdminClientForRegion(regionId);
    for (Tenant tenant : adminClient.listTenants()) {
        // ...
    }
}
{% endhighlight %}

Also pro, is our new Amazon CloudWatch support from Jeremy Whitlock. This is our first complete renovation of an AWS api to have the same look/feel as our new OpenStack stuff. Just add a dependency on *org.jclouds.providers/aws-cloudwatch* and you can do this!

{% highlight java %}
ContextBuilder contextBuilder = ContextBuilder.newBuilder("aws-cloudwatch");
RestContext cloudwatch = contextBuilder
    .credentials("accessKey", "secretKey")
    .build();

for (String regionId : cloudwatch.getApi().getConfiguredRegions()) {
    MetricClient metricClient = cloudwatch.getApi().getMetricClientForRegion(regionId);
    for (Metric metric : metricClient.listMetrics()) {
        // ...
    }
}
{% endhighlight %}

And for the jenkins users, we also have an api for remote job and computer control, at *org.jclouds.labs/jenkins*!

{% highlight java %}
ContextBuilder contextBuilder = ContextBuilder.newBuilder("jenkins");
RestContext localhost = contextBuilder.build();

Node master = localhost.getApi().getMaster();
localhost.getJobClient().createFromXML("newJob", xmlAsString);
{% endhighlight %}


This is especially helpful with the new [jclouds-plugin](https://github.com/jenkinsci/jclouds-plugin), which uses jclouds to spin up new slaves and publish artifacts to BlobStore. Tons more in there, too.

Definitely play around, and let us know how it works!
