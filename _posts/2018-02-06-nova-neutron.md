---
author: <a href="https://twitter.com/IgnasiBarrera">Ignasi Barrera</a>
comments: true
date: 2018-02-06 07:00:00+00:00
layout: post
slug: nova-neutron
title: OpenStack Nova and Neutron
---

One of the limitations of the jclouds implementation of the OpenStack Nova API is that is was not able to directly talk to the Neutron service. It used legacy security group APIs to manage access to instances, and there was no proper support for custom networking.

Starting from Apache jclouds 2.1.0, an integration with OpenStack Neutron will be provided and users will be able to configure their Nova APIs to interact with a custom Neutron deployment.
<!-- more -->

To achieve this, users will be able to use the recent **context linking** feature, where APIs and providers that have dependencies between them can be *linked* so they can call each other where needed.

## Linking OpenStack Nova to Neutron

Links between APIs and providers are done at *context* level. This isolates each individual context and allows users to configure an independent set of properties for each one without overlapping issues. The `ContextLinking.linkContext` and `ContextLinking.linkView` helper methods can be used to easily link one context or view to another.

The following example shows how to link an OpenStack Nova API to a Neutron API context, to leverage Neutron features when provisioning instances with Nova:

{% highlight java %}
// Create the connection to OpenStack Neutron
ApiContext<NeutronApi> neutronCtx = ContextBuilder.newBuilder("openstack-neutron")
   .endpoint("http://localhost/identity/v3/")
   .credentials("domain:user", "password")
   .overrides(neutronProperties)
   .modules(ImmutableSet.of(new SLF4JLoggingModule()))
   .build();

// Create the connection to OpenStack nova and link it to Neutron
NovaApi nova = ContextBuilder.newBuilder("openstack-nova")
   .endpoint("http://localhost/identity/v3/")
   .credentials("domain:user", "password")
   .overrides(novaProperties)
   .modules(ImmutableSet.of(
               ContextLinking.linkContext(neutronCtx),
               new SLF4JLoggingModule()))
   .buildApi(NovaApi.class);
{% endhighlight %}

With this configuration the `nova` API is configured to use the linked `neutron` for all networking operations.
