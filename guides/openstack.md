---
layout: page
title: "OpenStack: Getting Started Guide"
permalink: /guides/openstack/
---

1. [Introduction](#intro)
1. [Get OpenStack](#openstack)
1. [Get jclouds](#install)
1. [Terminology](#terminology)
1. [Keystone v2-v3 authentication](#keystone)
1. [Nova: List Servers](#nova)
1. [Swift: Use Containers](#swift)
1. [Next Steps](#next)
1. [OpenStack Dependencies](#pom)

## <a id="intro"></a>Introduction
[OpenStack](http://www.openstack.org/) is a global collaboration of developers and cloud computing technologists producing the ubiquitous open source cloud computing platform for public and private clouds. The project aims to deliver solutions for all types of clouds by being simple to implement, massively scalable, and feature rich. The technology consists of a series of interrelated projects delivering various components for a cloud infrastructure solution.

## <a id="openstack"></a>Get OpenStack
You can either install a private OpenStack cloud for yourself or use an existing OpenStack public cloud.

### <a id="private"></a>Private Clouds
If you don't have a private OpenStack cloud but still want to try it out, you can use [DevStack](http://devstack.org/) to create your own mini-OpenStack cloud.

### <a id="public"></a>Public Clouds
Because the OpenStack API is also open, the jclouds APIs that talk to private OpenStack clouds work just as well with public OpenStack clouds. OpenStack is used by several large public clouds, both the [HP Cloud](https://www.hpcloud.com/) ([HP Cloud Getting Started Guide](/guides/hpcloud)) and [Rackspace Cloud](http://www.rackspace.com/cloud/) ([Rackspace Getting Started Guide](/guides/rackspace)) are based on it. If you don't want to sign up for a paid public cloud, you can use [TryStack](http://trystack.org/).

## <a id="install"></a>Get jclouds

1. Ensure you are using the [Java Development Kit (JDK) version 6 or later](http://www.oracle.com/technetwork/java/javase/downloads/index.html).
    * `javac -version`
1. Ensure you are using [Maven version 3 or later](http://maven.apache.org/guides/getting-started/maven-in-five-minutes.html).
    * `mvn -version`
1. Create a directory to try out jclouds.
    * `mkdir jclouds`
    * `cd jclouds`
1. Make a local copy of the [pom.xml](#pom) file below in the jclouds directory.
    * `mvn dependency:copy-dependencies "-DoutputDirectory=./lib"`
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `pom.xml`
        * `lib/`
            * `*.jar`

## <a id="terminology"></a>Terminology
There are some differences in terminology between jclouds and OpenStack that should be made clear.

<div class="row clearfix">
  <div class="col-md-4 column">
    <table class="table table-striped table-hover">
      <thead>
        <tr>
          <th>jclouds</th>
          <th>OpenStack</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Compute</td>
          <td>Nova</td>
        </tr>
        <tr>
          <td>Node</td>
          <td>Server</td>
        </tr>
        <tr>
          <td>Location/Region</td>
          <td>Region</td>
        </tr>
        <tr>
          <td>Hardware</td>
          <td>Flavor</td>
        </tr>
        <tr>
          <td>NodeMetadata</td>
          <td>Server details</td>
        </tr>
        <tr>
          <td>UserMetadata</td>
          <td>Metadata</td>
        </tr>
        <tr>
          <td>BlobStore</td>
          <td>Swift</td>
        </tr>
        <tr>
          <td>Blob</td>
          <td>File</td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

## <a id="keystone"></a>Keystone v2-v3 authentication

OpenStack Keystone (aka: [OpenStack Identity Service](https://docs.openstack.org/keystone/latest/)) has major changes between v2 and v3 (detail. [Identity API v2.0 and v3 History](https://docs.openstack.org/keystone/latest/contributor/http-api.html)).

To login, provide:

* On v2: *tenant*, *user*, *password*.
* On v3: a *project* (new name for *tenant*), an authentication *domain* for this *project*, a *user*, an authentication *domain* for this *user* (the two domains can be different).

jclouds provides backward compatibility between Keystone v2 and v3, but you should keep the following in mind to fully understand authentication against your OpenStack platform (See also the recent [OpenStack Keystone v3 Support](https://jclouds.apache.org/blog/2018/01/16/keystone-v3/) blog post).

### v2

This snippet:
{% highlight java %}
final Properties overrides = new Properties();
overrides.put(KeystoneProperties.KEYSTONE_VERSION, "2");

ContextBuilder.newBuilder("openstack-nova")
   .endpoint("https://host:5000/v2.0")
   .credentials("myTenant:foo", "bar")
   .overrides(overrides)
   .buildApi(NovaApi.class);
{% endhighlight %}

or 

{% highlight java %}
final Properties overrides = new Properties();
overrides.put(KeystoneProperties.KEYSTONE_VERSION, "2");
overrides.put(KeystoneProperties.TENANT_NAME, "myTenant");

ContextBuilder.newBuilder("openstack-nova")
   .endpoint("https://host:5000/v2.0")
   .credentials("foo", "bar")
   .overrides(overrides)
   .buildApi(NovaApi.class);
{% endhighlight %}

Will produce when authentication needed: 

    POST https://host:5000/v2.0/tokens HTTP/1.1
    {
        "auth": {
            "passwordCredentials": {
                "username": "foo",
                "password": "bar"
            },
            "tenantName": "myTenant"
        }
    }    

### v3: Default (unscoped) 

Keystone v3 requires at min a user authentication domain (generally the one you are using to login through UI console), so this snippet: 
{% highlight java %}
final Properties overrides = new Properties();
overrides.put(KeystoneProperties.KEYSTONE_VERSION, "3");

ContextBuilder.newBuilder("openstack-nova")
   .endpoint("https://host:5000/v3")
   .credentials("ldap:foo", "bar")
   .overrides(overrides)
   .buildApi(NovaApi.class);
{% endhighlight %}

Will produce when authentication needed: 

    POST https://host:5000/v3/auth/tokens HTTP/1.1
    {
        "auth": {
            "identity": {
                "methods": ["password"],
                "password": {
                    "user": {
                        "name": "foo",
                        "domain": {
                            "name": "ldap"
                        },
                        "password": "bar"
                    }
                }
            },
            "scope": "unscoped"
        }
    }

In this case, no *project* (previously *tenant* in OpenStack keystone v2) is provided.

### v3: Project-scoped

A common usage of OpenStack keystone v3 is to provide the [project scope](https://docs.openstack.org/keystone/latest/api_curl_examples.html#project-scoped), this snippet:
{% highlight java %}
final Properties overrides = new Properties();
overrides.put(KeystoneProperties.KEYSTONE_VERSION, "3");
overrides.put(KeystoneProperties.SCOPE, "project:myTenant");

ContextBuilder.newBuilder("openstack-nova")
   .endpoint("https://host:5000/v3")
   .credentials("ldap:foo", "bar")
   .overrides(overrides)
   .buildApi(NovaApi.class);
{% endhighlight %}

Will produce when authentication needed: 

    POST https://host:5000/v3/auth/tokens HTTP/1.1
    {
        "auth": {
            "identity": {
                "methods": ["password"],
                "password": {
                    "user": {
                        "name": "foo",
                        "domain": {
                            "name": "ldap"
                        },
                        "password": "bar"
                    }
                }
            },
            "scope": {
                "project": {
                    "name": "myTenant",
                    "domain": {
                        "name": "ldap"
                    }
                }
            }
        }
    }

If the project domain is different than the user domain (Use case when 'default' is used for projects and a third-part IAM like ldap is use for user authentication), use this snippet:
{% highlight java %}
final Properties overrides = new Properties();
overrides.put(KeystoneProperties.KEYSTONE_VERSION, "3");
overrides.put(KeystoneProperties.SCOPE, "project:myTenant");
overrides.put(KeystoneProperties.PROJECT_DOMAIN_NAME, "default"); // Since jclouds > v2.1.0 (see PROJECT_DOMAIN_ID as complement)

ContextBuilder.newBuilder("openstack-nova")
   .endpoint("https://host:5000/v3")
   .credentials("ldap:foo", "bar")
   .overrides(overrides)
   .buildApi(NovaApi.class);
{% endhighlight %}

Will produce when authentication needed: 

    POST https://host:5000/v3/auth/tokens HTTP/1.1
    {
        "auth": {
            "identity": {
                "methods": ["password"],
                "password": {
                    "user": {
                        "name": "foo",
                        "domain": {
                            "name": "ldap"
                        },
                        "password": "bar"
                    }
                }
            },
            "scope": {
                "project": {
                    "name": "myTenant",
                    "domain": {
                        "name": "default"
                    }
                }
            }
        }
    }

### v3: Domain-scoped

If your authentication is [domain-scoped](https://docs.openstack.org/keystone/latest/api_curl_examples.html#domain-scoped), this snippet:
{% highlight java %}
final Properties overrides = new Properties();
overrides.put(KeystoneProperties.KEYSTONE_VERSION, "3");
overrides.put(KeystoneProperties.SCOPE, "domain:default");

ContextBuilder.newBuilder("openstack-nova")
   .endpoint("https://host:5000/v3")
   .credentials("ldap:foo", "bar")
   .overrides(overrides)
   .buildApi(NovaApi.class);
{% endhighlight %}

Will produce when authentication needed: 

    POST https://host:5000/v3/auth/tokens HTTP/1.1
    {
        "auth": {
            "identity": {
                "methods": ["password"],
                "password": {
                    "user": {
                        "name": "foo",
                        "domain": {
                            "name": "ldap"
                        },
                        "password": "bar"
                    }
                }
            },
            "scope": {
                "domain": {
                    "name": "default"
                }
            }
        }
    }

## <a id="nova"></a>Nova: List Servers
### <a id="nova-intro"></a>Introduction

[OpenStack Compute](http://www.openstack.org/software/openstack-compute/) (aka Nova) is an easy to use service that provides on-demand servers that you can use to to build dynamic websites, deliver mobile apps, or crunch big data.

### <a id="nova-source"></a>The Source Code

1. Create a Java source file called JCloudsNova.java in the jclouds directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `JCloudsNova.java`
        * `pom.xml`
        * `lib/`
            * `*.jar`
1. Open JCloudsNova.java for editing, read the code below, and copy it in.

{% highlight java %}
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Closeables;
import com.google.inject.Module;
import org.jclouds.ContextBuilder;
import org.jclouds.logging.slf4j.config.SLF4JLoggingModule;
import org.jclouds.openstack.nova.v2_0.NovaApi;
import org.jclouds.openstack.nova.v2_0.domain.Server;
import org.jclouds.openstack.nova.v2_0.features.ServerApi;

import java.io.Closeable;
import java.io.IOException;
import java.util.Set;

public class JCloudsNova implements Closeable {
    private final NovaApi novaApi;
    private final Set<String> regions;

    public static void main(String[] args) throws IOException {
        JCloudsNova jcloudsNova = new JCloudsNova();

        try {
            jcloudsNova.listServers();
            jcloudsNova.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            jcloudsNova.close();
        }
    }

    public JCloudsNova() {
        Iterable<Module> modules = ImmutableSet.<Module>of(new SLF4JLoggingModule());

        // Please refer to 'Keystone v2-v3 authentication' section for complete authentication use case
        String provider = "openstack-nova";
        String identity = "demo:demo"; // tenantName:userName
        String credential = "devstack";

        novaApi = ContextBuilder.newBuilder(provider)
                .endpoint("http://xxx.xxx.xxx.xxx:5000/v2.0/")
                .credentials(identity, credential)
                .modules(modules)
                .buildApi(NovaApi.class);
        regions = novaApi.getConfiguredRegions();
    }

    private void listServers() {
        for (String region : regions) {
            ServerApi serverApi = novaApi.getServerApi(region);

            System.out.println("Servers in " + region);

            for (Server server : serverApi.listInDetail().concat()) {
                System.out.println("  " + server);
            }
        }
    }

    public void close() throws IOException {
        Closeables.close(novaApi, true);
    }
}
{% endhighlight %}

In the constructor note that

* `String provider = "openstack-nova";`
  * This ones pretty self explanatory, we're using the OpenStack Nova provider in jclouds
* `String identity = "demo:demo"; // tenantName:userName`
  * Here we use the tenant name and user name with a colon between them instead of just a user name
* `String credential = "devstack";`
  *  The demo account uses ADMIN_PASSWORD too
* `.endpoint("http://xxx.xxx.xxx.xxx:5000/v2.0/")`
  * This is the Keystone endpoint that jclouds needs to connect with to get more info (services and endpoints) from OpenStack
  * When a DevStack installation completes successfully, one of the last few lines will read something like "`Keystone is serving at http://xxx.xxx.xxx.xxx:5000/v2.0/`"
  * Set the endpoint to this URL depending on the method used to get OpenStack above.

### <a id="nova-compile"></a>Compile and Run

    $ javac -classpath ".:lib/*" JCloudsNova.java

    $ java -classpath ".:lib/*" JCloudsNova

    Servers in RegionOne
      Server{id=...}
      ...

    # You'll see a lot of logging in the output

## <a id="swift"></a>Swift: Use Containers
### <a id="swift-intro"></a>Introduction

[OpenStack Object Storage](http://www.openstack.org/software/openstack-storage/) (aka Swift) provides redundant, scalable object storage using clusters of standardized servers capable of storing petabytes of data.

### <a id="swift-source"></a>The Source Code

1. Create a Java source file called JCloudsSwift.java in the jclouds directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `JCloudsSwift.java`
        * `pom.xml`
        * `lib/`
            * `*.jar`
1. Open JCloudsSwift.java for editing, read the code below, and copy it in.

{% highlight java %}
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Closeables;
import com.google.inject.Module;
import org.jclouds.ContextBuilder;
import org.jclouds.io.Payload;
import org.jclouds.logging.slf4j.config.SLF4JLoggingModule;
import org.jclouds.openstack.swift.v1.SwiftApi;
import org.jclouds.openstack.swift.v1.domain.Container;
import org.jclouds.openstack.swift.v1.features.ContainerApi;
import org.jclouds.openstack.swift.v1.features.ObjectApi;
import org.jclouds.openstack.swift.v1.options.CreateContainerOptions;
import org.jclouds.openstack.swift.v1.options.PutOptions;

import java.io.Closeable;
import java.io.IOException;
import java.util.Set;

import static com.google.common.io.ByteSource.wrap;
import static org.jclouds.io.Payloads.newByteSourcePayload;

public class JCloudsSwift implements Closeable {
   public static final String CONTAINER_NAME = "jclouds-example";
   public static final String OBJECT_NAME = "jclouds-example.txt";

   private SwiftApi swiftApi;

   public static void main(String[] args) throws IOException {
      JCloudsSwift jcloudsSwift = new JCloudsSwift();

      try {
         jcloudsSwift.createContainer();
         jcloudsSwift.uploadObjectFromString();
         jcloudsSwift.listContainers();
         jcloudsSwift.close();
      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         jcloudsSwift.close();
      }
   }

   public JCloudsSwift() {
      Iterable<Module> modules = ImmutableSet.<Module>of(
            new SLF4JLoggingModule());

      // Please refer to 'Keystone v2-v3 authentication' section for complete authentication use case
      String provider = "openstack-swift";
      String identity = "demo:demo"; // tenantName:userName
      String credential = "devstack";

      swiftApi = ContextBuilder.newBuilder(provider)
            .endpoint("http://xxx.xxx.xxx.xxx:5000/v2.0/")
            .credentials(identity, credential)
            .modules(modules)
            .buildApi(SwiftApi.class);
   }

   private void createContainer() {
      System.out.println("Create Container");

      ContainerApi containerApi = swiftApi.getContainerApi("RegionOne");
      CreateContainerOptions options = CreateContainerOptions.Builder
            .metadata(ImmutableMap.of(
                  "key1", "value1",
                  "key2", "value2"));

      containerApi.create(CONTAINER_NAME, options);

      System.out.println("  " + CONTAINER_NAME);
   }

   private void uploadObjectFromString() {
      System.out.println("Upload Object From String");

      ObjectApi objectApi = swiftApi.getObjectApi("RegionOne", CONTAINER_NAME);
      Payload payload = newByteSourcePayload(wrap("Hello World".getBytes()));

      objectApi.put(OBJECT_NAME, payload, PutOptions.Builder.metadata(ImmutableMap.of("key1", "value1")));

      System.out.println("  " + OBJECT_NAME);
   }

   private void listContainers() {
      System.out.println("List Containers");

      ContainerApi containerApi = swiftApi.getContainerApi("RegionOne");
      Set<Container> containers = containerApi.list().toSet();

      for (Container container : containers) {
         System.out.println("  " + container);
      }
   }

   public void close() throws IOException {
      Closeables.close(swiftApi, true);
   }
}
{% endhighlight %}

### <a id="swift-compile"></a>Compile and Run

    $ javac -classpath ".:lib/*" JCloudsSwift.java

    $ java -classpath ".:lib/*" JCloudsSwift

    Create Container
      jclouds-example
    Upload Object From String
      jclouds-example.txt
    List Containers
      Container{name=...}
      ...

    # You'll see a lot of logging in the output

## <a id="next"></a>Next Steps

* Try the List Servers example above with one of the public clouds. For the Rackspace Cloud the constructor becomes:

{% highlight java %}
import org.jclouds.Constants;
import org.jclouds.openstack.keystone.v2_0.config.CredentialTypes;
import org.jclouds.openstack.keystone.v2_0.config.KeystoneProperties;

// snip

public JCloudsNova() {
    Iterable<Module> modules = ImmutableSet.<Module>of(new SLF4JLoggingModule());

    Properties overrides = new Properties();
    overrides.setProperty(KeystoneProperties.CREDENTIAL_TYPE, CredentialTypes.PASSWORD_CREDENTIALS);
    overrides.setProperty(Constants.PROPERTY_API_VERSION, "2");

    // Please refer to 'Keystone v2-v3 authentication' section for complete authentication use case
    String provider = "openstack-nova";
    String identity = "username";
    String credential = "password";

    novaApi = ContextBuilder.newBuilder(provider)
            .endpoint("https://identity.api.rackspacecloud.com/v2.0/")
            .credentials(identity, credential)
            .modules(modules)
            .overrides(overrides)
            .buildApi(NovaApi.class);
    regions = novaApi.getConfiguredRegions();
}
{% endhighlight %}

* Try using the `"openstack-cinder"` provider to list volumes (hint: see [VolumeAndSnapshotApiLiveTest.testListVolumes()](https://github.com/jclouds/jclouds/blob/master/apis/openstack-cinder/src/test/java/org/jclouds/openstack/cinder/v1/features/VolumeAndSnapshotApiLiveTest.java)).
* Have a look at how the optional extensions are handled (hint: see [FloatingIPApiLiveTest.testListFloatingIPs()](https://github.com/jclouds/jclouds/blob/master/apis/openstack-nova/src/test/java/org/jclouds/openstack/nova/v2_0/extensions/FloatingIPApiLiveTest.java#L42)).
* Change the example to do different things that you want to do.
* Browse the [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).
* Join the [jclouds community](/community/) as either a developer or user.

## <a id="pom"></a>OpenStack Dependencies

This pom.xml file specifies all of the dependencies you'll need to work with OpenStack.

{% highlight xml %}
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <properties>
    <jclouds.version>{{ site.latest_version }}</jclouds.version>
  </properties>
  <groupId>org.apache.jclouds.examples</groupId>
  <artifactId>openstack-examples</artifactId>
  <version>1.0</version>
  <dependencies>
    <!-- jclouds dependencies -->
    <dependency>
      <groupId>org.apache.jclouds.driver</groupId>
      <artifactId>jclouds-slf4j</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.jclouds.driver</groupId>
      <artifactId>jclouds-sshj</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <!-- jclouds OpenStack dependencies -->
    <dependency>
      <groupId>org.apache.jclouds.api</groupId>
      <artifactId>openstack-keystone</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.jclouds.api</groupId>
      <artifactId>openstack-nova</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.jclouds.api</groupId>
      <artifactId>openstack-swift</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.jclouds.api</groupId>
      <artifactId>openstack-cinder</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.jclouds.api</groupId>
      <artifactId>openstack-trove</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.jclouds.labs</groupId>
      <artifactId>openstack-glance</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.jclouds.labs</groupId>
      <artifactId>openstack-marconi</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.jclouds.labs</groupId>
      <artifactId>openstack-neutron</artifactId>
      <version>${jclouds.version}</version>
    </dependency>
    <!-- 3rd party dependencies -->
    <dependency>
      <groupId>ch.qos.logback</groupId>
      <artifactId>logback-classic</artifactId>
      <version>1.0.13</version>
    </dependency>
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>5.1.25</version>
    </dependency>
  </dependencies>
</project>
{% endhighlight %}
