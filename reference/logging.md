---
layout: page
title: Logging
permalink: /reference/logging/
---

1. [Install](#install)
1. [Configure](#configure)
1. [Enable](#enable)
1. [HTTP(S) Proxy](#proxy)

Logging in jclouds can save you time and effort when developing your code or looking for help. If your code is not behaving how you expect it to, enabling and configuring logging in jclouds can quickly give you valuable insight into the root cause of the issue. If you need help from the [community](/community/), the logs can help the people there assist you. The logs can be verbose so it's often best to simply copy and paste them into a [gist](https://gist.github.com/) or [pastie](http://pastie.org/) and just post the link on the mailing list.

By default, jclouds does no logging whatsoever for maximum performance.

## <a id="install"></a>Install Logging

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

## <a id="configure"></a>Configure Logging

You'll also need a logback.xml configuration file on your classpath. Here's an example.

{% highlight xml %}
<?xml version="1.0"?>
<configuration scan="false">
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%m%n</pattern>
        </encoder>
    </appender>

    <appender name="FILE" class="ch.qos.logback.core.FileAppender">
        <file>log/jclouds.log</file>

        <encoder>
            <Pattern>%d %-5p [%c] [%thread] %m%n</Pattern>
        </encoder>
    </appender>

    <appender name="WIREFILE" class="ch.qos.logback.core.FileAppender">
        <file>log/jclouds-wire.log</file>

        <encoder>
            <Pattern>%d %-5p [%c] [%thread] %m%n</Pattern>
        </encoder>
    </appender>

    <appender name="COMPUTEFILE" class="ch.qos.logback.core.FileAppender">
        <file>log/jclouds-compute.log</file>

        <encoder>
            <Pattern>%d %-5p [%c] [%thread] %m%n</Pattern>
        </encoder>
    </appender>

    <appender name="SSHFILE" class="ch.qos.logback.core.FileAppender">
        <file>log/jclouds-ssh.log</file>

        <encoder>
            <Pattern>%d %-5p [%c] [%thread] %m%n</Pattern>
        </encoder>
    </appender>

    <root>
        <level value="info" />
    </root>

    <logger name="org.jclouds">
        <level value="DEBUG" />
        <appender-ref ref="FILE" />
    </logger>

    <logger name="jclouds.compute">
        <level value="DEBUG" />
        <appender-ref ref="COMPUTEFILE" />
    </logger>

    <logger name="jclouds.wire">
        <level value="DEBUG" />
        <appender-ref ref="WIREFILE" />
    </logger>

    <logger name="jclouds.headers">
        <level value="DEBUG" />
        <appender-ref ref="WIREFILE" />
    </logger>

    <logger name="jclouds.ssh">
        <level value="DEBUG" />
        <appender-ref ref="SSHFILE" />
    </logger>

    <logger name="net.schmizz">
        <level value="DEBUG" />
        <appender-ref ref="SSHFILE" />
    </logger>
</configuration>
{% endhighlight %}

## <a id="enable"></a>Enable Logging

Below is some example code of how to enable your code to use SLF4J. The `SLF4JLoggingModule` needs to be added to the `modules` collection that is passed into the `ContextBuilder.modules(Iterable)` method of whatever Context or Api you're building.

{% highlight java %}
Iterable<Module> modules = ImmutableSet.<Module> of(
    new SLF4JLoggingModule());

MyContext context = ContextBuilder.newBuilder("my-cloud-provider")
    .credentials("myIdentity", "myCredential")
    .modules(modules)
    .buildView(MyContext.class);

// Or

MyApi myApi = ContextBuilder.newBuilder("my-cloud-provider")
    .credentials("myIdentity", "myCredential")
    .modules(modules)
    .buildApi(MyApi.class);
{% endhighlight %}

## <a id="proxy"></a>HTTP(S) Proxy

This is optional and not necessary for regular jclouds logging.

There may be times when you need to see every bit and byte being sent with jclouds to/from a cloud provider. To do this you can use an HTTP(S) proxy to capture all traffic that's being transmitted, like [Charles Proxy](http://www.charlesproxy.com/) or [Fiddler](http://www.telerik.com/fiddler).

For example, to work with an HTTPS endpoint of a cloud provider using Charles you need to enable SSL Proxying:

1. Proxy > Proxy Settings > SSL tab
1. Check Enable SSL Proxying
1. Add Locations, e.g.
    1. *.rackspacecloud.com
    1. *.clouddrive.com

jclouds also requires some configuration to use a proxy.

{% highlight java %}
import static org.jclouds.Constants.*;

// snip

Properties overrides = new Properties();
overrides.setProperty(PROPERTY_PROXY_HOST, "localhost");
overrides.setProperty(PROPERTY_PROXY_PORT, "8888");
overrides.setProperty(PROPERTY_TRUST_ALL_CERTS, "true");

Iterable<Module> modules = ImmutableSet.<Module> of(
    new SLF4JLoggingModule());

MyContext context = ContextBuilder.newBuilder("my-cloud-provider")
    .credentials("myIdentity", "myCredential")
    .modules(modules)
    .overrides(overrides)
    .buildView(MyContext.class);

// Or

MyApi myApi = ContextBuilder.newBuilder("my-cloud-provider")
    .credentials("myIdentity", "myCredential")
    .modules(modules)
    .overrides(overrides)
    .buildApi(MyApi.class);
{% endhighlight %}

When you make requests to an API through Charles, you'll see that all request/response information has been captured in one of it's sessions.