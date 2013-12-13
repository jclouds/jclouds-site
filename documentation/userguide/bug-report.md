---
layout: jclouds
title: Documentation
---

# How to Report a Bug to Apache jclouds&reg;

If you run into a bug while using jclouds, we encourage you to report it. To help you please collect as much of the following information as possible. If you can't get everything, that's okay. Send what you can.

Bugs can be reported in [JIRA](https://issues.apache.org/jira/browse/JCLOUDS) or the [jclouds user mailing list](/documentation/community).

1. [jclouds Version](#jclouds-version)
1. [Cloud and API Version](#cloud-version)
1. [Operating System Version](#os-version)
1. [Java Version](#java-version)
1. [Logs](#logs)
1. [Code](#code)
1. [Documentation](#doc)

## <a id="jclouds-version"></a>jclouds Version

The version of jclouds can be found in the name of the JAR files you are using in your application or the pom.xml file of your application if you're using Maven.

E.G. jclouds Version: 1.6.3

## <a id="cloud-version"></a>Cloud and API Version

If you are using a private cloud such as OpenStack, CloudStack, or vCloud, you might be able to report the Cloud and API version.

E.G. Cloud and API Version: OpenStack Grizzly, Cinder API v2

## <a id="os-version"></a>Operating System Version

The Operating System Version you're using.

E.G. Operating System Version: Mac OS X 10.7.5

## <a id="java-version"></a>Java Version

The Java Version you're using.

E.G. java version "1.7.0_17"

## <a id="logs"></a>Logs

Sending us the stack trace from the exception is helpful but often the root cause of the problem can be revealed by examining what's being sent over the wire.

### Get Logging

[SLF4J](http://www.slf4j.org/) is the logging facade for jclouds. To use SLF4J you need the jclouds-slf4j-X.X.X.jar and the implementation logback-*.jar ([download](http://logback.qos.ch/download.html)) files on your classpath. To get them via Maven add the following dependencies to your pom.xml file.

{% highlight xml %}
<dependencies>
  <dependency>
    <groupId>org.apache.jclouds.driver</groupId>
    <artifactId>jclouds-slf4j</artifactId>
    <version>${jclouds.version}</version>
  </dependency>
  <dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.0.13</version>
  </dependency>
</dependencies>
{% endhighlight %}

### Configure Logging

You'll also need a logback.xml ([example](https://github.com/jclouds/jclouds/blob/master/compute/src/test/resources/logback.xml)) configuration file on your classpath. It's the appender named WIREFILE that we need.

### Enable Logging

Here is some example code of how to enable your components to use SLF4J:

{% highlight java %}
    Iterable<Module> modules = ImmutableSet.<Module> of(
        new SLF4JLoggingModule());
    
    ComputeServiceContext context = ContextBuilder.newBuilder("a-compute-provider")
        .credentials("myUsername", "myPasswordOrApiKey")
        .modules(modules)
        .buildView(ComputeServiceContext.class);
{% endhighlight %}

### Send Logs

If you are reporting the bug in JIRA, you can simply attach the WIREFILE and other logs to the issue. If you are sending the report to the user mailing list, please put the logs into a [gist](https://gist.github.com/) or [pastie](http://pastie.org/) and include the link in the email.

## <a id="code"></a>Code

If you can isolate the problem within a single Java file, send us that file so we can attempt to immediately reproduce the error. If you can't isolate the problem, send us as large a code snippet as possible around the problem code. 

If you are reporting the bug in JIRA, you can simply attach the code to the issue. If you are sending the report to the user mailing list, please put the code into a [gist](https://gist.github.com/) or [pastie](http://pastie.org/) and include the link in the email.

## <a id="doc"></a>Documentation

If you find a bug in the documentation, you can report that via JIRA or the user mailing list too. However it is quite easy to fix the documentation (this website) and we encourage you to do so by reading [How to Contribute Documentation](https://wiki.apache.org/jclouds/How%20to%20Contribute%20Documentation).
