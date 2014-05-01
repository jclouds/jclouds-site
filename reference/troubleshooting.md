---
layout: page
title: Troubleshooting
permalink: /reference/troubleshooting/
---

This reference will give you some tips on general jclouds troubleshooting as well as solutions to specific classes of problems. If you have a tip or solution to add, please click the "Fix This Page" link at the bottom of this page!

* [General Tips](#general)
  * [Logging](#logging)
  * [Classpath](#classpath)
  * [Source Code](#source)
* [Specific Solutions](#specific)
  * [NoSuchElementException](#NoSuchElementException)
  * [ConfigurationException](#ConfigurationException)

## <a id="general"></a>General Tips

### <a id="logging"></a>Logging

[Enabling logging](/reference/logging/) in jclouds will give you a lot of insight into what jclouds is doing.

### <a id="classpath"></a>Classpath

Check your classpath to ensure you're using the JARs you think you are and that your jclouds JARs are all of the same version.

In the directory with your Maven pom.xml file run the command

`mvn dependency:tree`

This will tell you exactly what all of your dependencies are and all of their versions.

To determine what JARs are actually being loaded when your application runs, read the answers to [How to find which jars and in what order are loaded by a classloader?](http://stackoverflow.com/questions/2179858/how-to-find-which-jars-and-in-what-order-are-loaded-by-a-classloader)

If you're using Java 8, you can use the [jdeps](http://docs.oracle.com/javase/8/docs/technotes/tools/unix/jdeps.html) to analyze dependencies.

### <a id="source"></a>Source Code

Having a look a the source code will tell you exactly what jclouds is doing. The source code can be viewed directly on [GitHub](https://github.com/jclouds/jclouds) or [downloaded](http://www.apache.org/dyn/closer.cgi/jclouds) from an ASF mirror repository.

## <a id="specfic"></a>Specific Solutions

### <a id="NoSuchElementException"></a>NoSuchElementException

```
java.util.NoSuchElementException: key [openstack-nova] not in the list of providers or apis:
{apis=[transient, openstack-cinder, openstack-glance, openstack-keystone, openstack-marconi, openstack-neutron, openstack-trove, swift, swift-keystone]}
```

This can be caused by a missing dependency (JAR file) on your classpath. In the exception above, the cloud provider name being used is openstack-nova but the openstack-nova-X.X.X.jar is not on the classpath. Run through the [Classpath](#classpath) tip to determine how and why that JAR is missing.

This can also be caused by a misspelling of the cloud provider name. Read the name after "key" very carefully, it must match the prefix of the name of the JAR file exactly. The "key" is inputted when creating a view or api.

{% highlight java %}
NovaApi novaApi = ContextBuilder.newBuilder("openstack-nova")
        .credentials(USERNAME, API_KEY)
        .buildApi(NovaApi.class);
{% endhighlight %}

### <a id="ConfigurationException"></a>ConfigurationException
```
com.google.inject.ConfigurationException: Guice configuration errors:

1) No implementation for org.jclouds.rackspace.cloudfiles.v1.CloudFilesApi was bound.
  while locating org.jclouds.rackspace.cloudfiles.v1.CloudFilesApi
  ...
```

This is caused by a misconfiguration when creating a view or api.

{% highlight java %}
CloudFilesApi cloudFilesApi = ContextBuilder.newBuilder("openstack-swift")
      .credentials(username, apiKey)
      .buildApi(CloudFilesApi.class);
{% endhighlight %}

The provider String you pass to `ContextBuilder.newBuilder(String)` must match the view or api you are creating.

{% highlight java %}
CloudFilesApi cloudFilesApi = ContextBuilder.newBuilder("rackspace-cloudfiles-us")
      .credentials(username, apiKey)
      .buildApi(CloudFilesApi.class);
{% endhighlight %}
