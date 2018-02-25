---
author: <a href="https://twitter.com/IgnasiBarrera">Ignasi Barrera</a>
comments: true
date: 2018-02-06 07:00:00+00:00
layout: post
slug: nova-neutron
title: Introducing context linking & Neutron support for Nova
---

One of the limitations of some jclouds APIs and Providers is that they are isolated libraries that cannot directly interact between them. There are scenarios where this would be desirable, such as letting OpenStack Nova (compute) use the OpenStack Neutron API (networking) to perform all networking related operations. There was no direct way to implement this in the jclouds APIs code, and users were left with the responsibility of invoking both APIs to have the desired behavior.

Apache jclouds 2.1.0 comes with a **context linking** feature, where APIs and providers that have dependencies between them can be *linked* so they can call each other where needed.

<!-- more -->

## Context Linking

Linking one API or Provider to another is something that has to be defined in the API or Provider itself. It is a mechanism that allows users to inject an API or Provider *inside* a given jclouds context, so the API that *receives* the linked context can use it internally. Linking is not supposed to be used to link arbitrary APIs and Providers (that would have no effect), but APIs that are *prepared* to receive linked contexts and call its API methods.

For example, in jclouds 2.1.0, OpenStack Nova has been integrated with Neutron, and users will be able to link the `openstack-nova` context to an `openstack-neutron` one so the Nova API can use the Neutron features to manage all networking stuff. On the other hand, linking other APIs or providers together may have no effect, as the code for those APIs and providers may not expect any linked context. When thinking about linking two contexts together, please refer to the docs.

Linking is done at *context* level, and links are specified in the *using* context and point to the context(s) that it uses. This isolates each individual context and allows users to configure an independent set of properties for each one without overlapping issues. The `ContextLinking.linkContext` and `ContextLinking.linkView` helper methods can be used to easily link one context or view to another.

## Linking OpenStack Nova to Neutron

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

## Writing code that accepts a linked context

When writing an API or Provider that needs to use another jclouds API, you can easily leverage the context linking feature by injecting the target API as follows:

{% highlight java %}
@Inject(optional = true)
@Named("openstack-neutron")
private Supplier<Context> neutronContextSupplier;
{% endhighlight %}

* You must use the **Provider or API id** in the `@Named` annotation.
* If the linked context is optional you can declare an optional injection.

Then you can access the portble abstraction view or provider-specific API from the injected context.
