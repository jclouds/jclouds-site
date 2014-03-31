---
layout: page
title: Configuration
permalink: /reference/configuration/
---

## Enterprise
Enterprise configuration attempts to make the best choices for you, with regards to which components to use to power your connections to the cloud. Specifically, this chooses `joda` dates, `bouncycastle` encryption, and `apache HTTP Client 4.0` connection pools.

You can also add further configuration, by passing it in the set of modules to configure.  For example, here's how to change the default connection and thread limits, and add log4j.

{% highlight java %}
import static org.jclouds.Constants.*;

...

Properties overrides = new Properties();
overrides.setProperty(PROPERTY_MAX_CONNECTIONS_PER_CONTEXT, 20 + "");
overrides.setProperty(PROPERTY_MAX_CONNECTIONS_PER_HOST, 0 + "");
overrides.setProperty(PROPERTY_CONNECTION_TIMEOUT, 5000 + "");
overrides.setProperty(PROPERTY_SO_TIMEOUT, 5000 + "");
overrides.setProperty(PROPERTY_IO_WORKER_THREADS, 20 + "");
// unlimited user threads
overrides.setProperty(PROPERTY_USER_THREADS, 0 + "");


Set<Module> wiring =  ImmutableSet.of(new EnterpriseConfigurationModule(), new Log4JLoggingModule());

// same properties and wiring can be used for many services, although the limits are per context
blobStoreContext = ContextBuilder.newBuilder("s3")
        .credentials(account, key)
        .modules(wiring)
        .overrides(overrides)
        .buildView(BlobStoreContext.class);
computeContext = ContextBuilder.newBuilder("ec2")
        .credentials(account, key)
        .modules(wiring)
        .overrides(overrides)
        .buildView(ComputeServiceContext.class);
{% endhighlight %}

### Timeout

Aggregate commands will take as long as necessary to complete, as controlled by `FutureIterables.awaitCompletion`. If you need to increase or decrease this, you will need to adjust the property `jclouds.request-timeout` or `Constants.PROPERTY_REQUEST_TIMEOUT`.  This is described in the Advanced Configuration section.

## *NULL* Return values

All API methods, either provider or API specific, must return _null_ when a requested object is not found.
Throwing exceptions is only appropriate when there is a state problem. For example, when requesting an object from a container that does not exist.

