---
layout: page
title: Core Concepts
permalink: /start/concepts/
---

1. [Views or "portable abstractions"](#views)
1. [APIs](#apis)
1. [Providers](#providers)
1. [Contexts](#contexts)

## <a id="views"></a>Views

[**Views**](http://jclouds-javadocs.elasticbeanstalk.com/org/jclouds/View.html) are portable abstractions that are designed to allow you to write code that uses cloud services without tying yourself to a specific vendor. Take [JDBC](http://docs.oracle.com/javase/7/docs/technotes/guides/jdbc/index.html) as an example: rather than writing code directly for a specific type of database, you can make generic database requests, and the JDBC specification and drivers translate these into specific commands and statements for a certain type of database.

Views generally make sense only once a reasonably broad set of functionality is supported by multiple vendors. In the cloud space, jclouds currently supports three such views:

 * [BlobStore](/start/blobstore/)
 * [ComputeService](/start/compute/)
 * [LoadBalancerService](http://jclouds-javadocs.elasticbeanstalk.com/org/jclouds/loadbalancer/LoadBalancerService.html)

## <a id="apis"></a>APIs

An **API** in jclouds describes the actual calls (often, but not always, HTTP requests) that can be executed against a specific cloud service to "do stuff". In the case of popular APIs, such as the [EC2 compute API](http://jclouds-javadocs.elasticbeanstalk.com/org/jclouds/ec2/EC2Api.html), or the [S3 storage API](http://jclouds-javadocs.elasticbeanstalk.com/org/jclouds/s3/S3Client.html), there may be multiple vendors with cloud services that support that particular API. For example, EC2 is supported by [Amazon](/guides/aws-ec2/) and [OpenStack](/guides/openstack/), amongst others.

A vendor may also support an API in multiple geographic locations. For example, [Rackspace](/guides/rackspace/)'s Cloud Servers API is available both in the [US](/reference/providers/#compute-providers) and the [UK](/reference/providers/#compute-providers).

## <a id="providers"></a>Providers

A **provider** in jclouds represents a particular vendor cloud service that supports one or more APIs. For example, Amazon offers EC2 through the [`aws-ec2` provider](/guides/aws-ec2/), and Rackspace's Cloud Servers instance in the UK is available via the [`rackspace-cloudservers-uk` provider](/reference/providers/#compute-providers).

Often, a jclouds provider is simply the appropriate [API](#apis) together with service-specific instantiation values, such as the endpoint URL. In some cases, the vendor offers additional functionality that goes _beyond_ the API. For example, AWS EC2 supports various calls and options that are not offered by other providers implementing the ''standard'' EC2 API.

[Views](#views), [APIs](#apis) and [providers](#providers) work together in jclouds in the following way:

#### APIs describe the calls that can be executed against a particular type of cloud service

By looking at the API defintion in jclouds, you can see the actual calls that are available if you talk directly to this API.

#### APIs support views

Depending on the functionality provided by a particular API, it can be used to implement a particular jclouds view. For instance, EC2 provides the right functionality to support the [ComputeService](/start/compute/) view, but is not useful for the [BlobStore](/start/blobstore/) or LoadBalancer views.

For some cloud services, one API can support multiple views.

#### Providers implement APIs, and describe calls that can be executed against a specific vendor cloud service

Each provider in jclouds implements one or more APIs, which is why the provider classes generally extend the API classes. As discussed [above](#providers), some providers support calls in addition to those offered by the API.

These additional calls may be available only optionally. For example, Rackspace installations in different locations may support different sets of extensions.

By implementing APIs, providers also support views. For instance, AWS EC2 supports the ComputeService view because it implements the EC2 API.

### What does this mean for you?

#### You can write highly portable code

If you code only using views, you will be able to run the same application against a large variety of different clouds, each with potentially a different API. For example, if you're using only the ComputeService, you could switch from AWS EC2 to [vCloud](/guides/vcloud) without changing your code.

It's like writing your database layer purely against the JDBC specification: you should be able to move from PostgreSQL to MariaDB without code changes.

#### You can use API-specific calls where needed

If the particular views you are working with do not allow you to do exactly what you want, but the API supports the desired functionality, you can ["unwrap"](http://jclouds-javadocs.elasticbeanstalk.com/org/jclouds/View.html#unwrap(\)) the view to access the underlying API. This reduces the portability of your code, but you can still move between providers that support this API.

For example, if you unwrap the EC2 API from a ComputeService view and talk directly to EC2, you will not be able move to vCloud without code changes any more. You will still be able to switch to a different provider that also supports the EC2 API, however.

#### You can use provider-specific calls if you really have to

If you really need to use calls or options offered only by a certain _provider_, you can even unwrap the view to access the provider itself. Some of the features of AWS EC2, for example, are _only_ available on AWS EC2 and are not supported by other providers that implement the standard EC2 API.

Obviously, this means your code is now tied to that specific provider, but that may be an acceptable tradeoff in your situation.

Finally, we have...

## <a id="contexts"></a>Contexts

A context represents a specific connection to a particular provider. From the perspective of our database analogy, this would be broadly similar to a database connection against a specific DB.

Once you have created a context via the [ContextBuilder](http://jclouds-javadocs.elasticbeanstalk.com/org/jclouds/ContextBuilder.html) and are "connected" to a particular cloud service, you can either get any of the views that are supported by that provider, or go straight to the API or even to the provider level.

Creating a context is an expensive operation, so in general it is a good idea to create one context per credential and target cloud when the application starts and close it when it terminates. Contexts are thread-safe, so can be shared across your application.

It is important to [close a context](http://jclouds-javadocs.elasticbeanstalk.com/org/jclouds/Context.html) when you no longer need it, to free its associated resources.

You can also get a view back from the ContextBuilder and _later_ unwrap it to access the underlying API or provider.
