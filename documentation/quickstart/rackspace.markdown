---
layout: jclouds
title: Getting Started - The Rackspace Cloud
---

# Getting Started: The Rackspace Cloud

1. [Introduction](#intro)
2. [Get a Username and API Key](#account)
3. [Get jclouds](#install)
4. [Terminology](#terminology)
5. [Your First Cloud Files App](#files)
6. [Your First Cloud Servers App](#servers)
7. [Working with Cloud Block Storage](#volumes)
8. [Working with Cloud Load Balancers](#loadbalancers)
9. [Working with Cloud Databases](#databases)
10. [Working with Cloud Auto Scale](#autoscale)
11. [Working with Cloud Queues](#queues)
12. [Next Steps](#next)
13. [Rackspace Cloud Providers](#providers)
14. [Support and Feedback](#support)

## <a id="intro"></a>Introduction
The [Rackspace Cloud](http://www.rackspace.com/cloud/public/) platform includes everything you need to build websites and applications that scale servers, storage, networking, APIs, and more. The Rackspace Cloud is based on OpenStack, which is a global collaboration of developers and cloud computing technologists producing the ubiquitous open source cloud computing platform for public and private clouds.

This guide assumes you're familiar with Java and its technologies. To get started you'll need access to the Rackspace cloud and jclouds.

## <a id="account"></a>Get a Username and API Key
1. Sign up for free for the [Rackspace Cloud (US)](https://cart.rackspace.com/cloud/).
1. Login to the [Cloud Control Panel (US)](https://mycloud.rackspace.com/).
1. In the top right corner click on your username and then click Settings & Contacts to locate your API Key.

Likewise you can go to the [Rackspace Cloud (UK)](https://buyonline.rackspace.co.uk/cloud/userinfo?type=normal) and login to the [Cloud Control Panel (UK)](https://mycloud.rackspace.co.uk/).

## <a id="install"></a>Get jclouds

1. Ensure you are using the [Java Development Kit (JDK) version 6 or later](http://www.oracle.com/technetwork/java/javase/downloads/index.html).
    * `javac -version` 
1. Ensure you are using [Maven version 3 or later](http://maven.apache.org/guides/getting-started/maven-in-five-minutes.html).
    * `mvn -version` 
1. Create a directory to try out jclouds.
    * `mkdir jclouds`
    * `cd jclouds`
1. Make a local copy of this [pom.xml](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/pom.xml) file in the jclouds directory.
    * mvn dependency:copy-dependencies "-DoutputDirectory=./lib"
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `pom.xml`
        * `lib/`
            * `*.jar`

## <a id="terminology"></a>Terminology
There are some differences in terminology between jclouds and Rackspace/OpenStack that should be made clear.

| jclouds | Rackspace/OpenStack |
|---------|---------------------|
| Compute | Cloud Servers (Nova)
| Node | Server
| Location/Zone | Region
| Hardware | Flavor
| NodeMetadata | Server details
| UserMetadata | Metadata
| BlobStore | Cloud Files (Swift)
| Blob | File (Object)

## <a id="files"></a>Your First Cloud Files App
### <a id="files-intro"></a>Introduction

[Cloud Files](http://www.rackspace.com/cloud/public/files/) is an easy to use online storage for files and media which can be delivered globally over Akamai's content delivery network (CDN).

### <a id="files-apis"></a>APIs

Cloud Files works with a portable layer in jclouds that is used to access features common to all cloud object storage systems. Cloud Files also works with the OpenStack layer in jclouds that is used to access features common to all OpenStack Swift object storage systems. Finally, Cloud Files works with the Rackspace layer in jclouds that is used to access features specific to the Rackspace object storage system.

1. The portable API for Cloud Files is org.jclouds.blobstore.BlobStore.
1. The OpenStack API for Cloud Files is org.jclouds.openstack.swift.CommonSwiftClient.
1. The Rackspace API for Cloud Files is org.jclouds.cloudfiles.CloudFilesClient. 
1. You can find these APIs in the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).

### <a id="files-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudfiles/ in your jclouds directory.
1. Create Java source files called CloudFilesPublish.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `pom.xml`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/cloudfiles/`
            * `CloudFilesPublish.java`
            * `Constants.java`
1. Open CloudFilesPublish.java for editing.
1. Go to the example code [CloudFilesPublish.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudfiles/CloudFilesPublish.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudfiles/Constants.java), read it over, and copy the code into your file.

### <a id="files-compile"></a>Compile and Run

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudfiles/CloudFilesPublish.java

    java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudfiles.CloudFilesPublish myUsername myApiKey

    Create Container
      jclouds-example-publish
    Create Object From File
      createObjectFromFile.html
    Enable CDN Container
      Go to http://blah.rackcdn.com/createObjectFromFile.html

## <a id="servers"></a>Your First Cloud Servers App
### <a id="servers-intro"></a>Introduction

[Cloud Servers](http://www.rackspace.com/cloud/public/servers/) is an easy to use service that provides on-demand servers that you can use to to build dynamic websites, deliver mobile apps, or crunch big data.

### <a id="servers-apis"></a>APIs

Cloud Servers works with a portable layer in jclouds that is used to access features common to all cloud compute systems. Cloud Servers also works with the OpenStack layer in jclouds that is used to access features common to all OpenStack Nova compute systems.

1. The portable API for Cloud Servers is org.jclouds.compute.ComputeService.
1. The OpenStack API for Cloud Servers is the org.jclouds.openstack.nova.v2_0.features.ServerApi. It's accessible via the org.jclouds.openstack.nova.v2_0.NovaApi.
1. You can find these APIs in the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).

### <a id="servers-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudservers/ in your jclouds directory.
1. Create Java source files called CloudServersPublish.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `pom.xml`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/cloudservers/`
            * `CloudServersPublish.java`
            * `Constants.java`
1. Open CloudServersPublish.java for editing.
1. Go to the example code [CloudServersPublish.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/CloudServersPublish.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/Constants.java), read it over, and copy the code into your file.

### <a id="servers-compile"></a>Compile and Run

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudservers/CloudServersPublish.java
    
    java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudservers.CloudServersPublish myUsername myApiKey

    Create Server
      {id=IAD/4d560...}
      Configure And Start Webserver
      (a lot of ssh output)
        Login: ssh root@123.123.123.123
        Password: a1b2c3d4
        Go to http://123.123.123.123

## <a id="volumes"></a>Working with Cloud Block Storage
### <a id="volumes-intro"></a>Introduction

[Cloud Block Storage](http://www.rackspace.com/cloud/public/blockstorage/) allows you to create volumes on which to persistently store your data from your servers, even when those servers have been deleted. It delivers consistent performance for your I/O-intensive applications.

### <a id="volumes-apis"></a>APIs

Cloud Block Storage works with the OpenStack layer in jclouds that is used to access features common to all OpenStack Cinder block storage systems.

1. The OpenStack API for Cloud Block Storage is the org.jclouds.openstack.cinder.v1.CinderApi. All other APIs for working with block storage are accessible via the CinderApi.
1. You can find these APIs in the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).

### <a id="volumes-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudblockstorage/ in your jclouds directory.
1. Create Java source files called CreateVolumeAndAttach.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `pom.xml`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/cloudblockstorage/`
            * `CreateVolumeAndAttach.java`
            * `Constants.java`
1. Open CreateVolumeAndAttach.java for editing.
1. Go to the example code [CreateVolumeAndAttach.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudblockstorage/CreateVolumeAndAttach.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudblockstorage/Constants.java), read it over, and copy the code into your file.

### <a id="volumes-compile"></a>Compile and Run

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudblockstorage/CreateVolumeAndAttach.java
    
    java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudblockstorage.CreateVolumeAndAttach myUsername myApiKey

    Create Server
      {id=DFW/8814...}
      Login: ssh root@123.123.123.123
      Password: a1b2c3d4
    Create Volume
      Volume{id=53d9...}
    Create Volume Attachment
      VolumeAttachment{id=53d9...}
    Mount Volume and Create Filesystem
      Exit Status: 0
    List Volumes
      ...

## <a id="loadbalancers"></a>Working with Cloud Load Balancers
### <a id="loadbalancers-intro"></a>Introduction

[Cloud Load Balancers](http://www.rackspace.com/cloud/public/loadbalancers/) distributes workloads across two or more servers, network links, and other resources to maximize throughput, minimize response time, and avoid overload. Rackspace Cloud Load Balancers allow you to quickly load balance multiple Cloud Servers for optimal resource utilization.

### <a id="loadbalancers-apis"></a>APIs

Cloud Load Balancers works with the Rackspace layer in jclouds that is used to access features specific to the Rackspace load balancer system.

1. The Rackspace API for Cloud Load Balancers is org.jclouds.rackspace.cloudloadbalancers.CloudLoadBalancersApi.  All other APIs for working with load balancers are accessible via the CloudLoadBalancersApi.
1. You can find these APIs in the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).

### <a id="loadbalancers-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudloadbalancers/ in your jclouds directory.
1. Create Java source files called CreateLoadBalancerWithExistingServers.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `pom.xml`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/cloudloadbalancers/`
            * `CreateLoadBalancerWithExistingServers.java`
            * `Constants.java`
1. Open CreateLoadBalancerWithExistingServers.java for editing.
1. Go to the example code [CreateLoadBalancerWithExistingServers.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudloadbalancers/CreateLoadBalancerWithExistingServers.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudloadbalancers/Constants.java), read it over, and copy the code into your file.

### <a id="loadbalancers-compile"></a>Compile and Run

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudloadbalancers/CreateLoadBalancerWithExistingServers.java
    
    java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudloadbalancers.CreateLoadBalancerWithExistingServers myUsername myApiKey

    Create Cloud Load Balancer
      LoadBalancer{id=85901...}
      Go to http://166.78.34.87

## <a id="databases"></a>Working with Cloud Databases
### <a id="databases-intro"></a>Introduction

[Cloud Databases](http://www.rackspace.com/cloud/databases/) provides easily managed cloud MySQL instances with built-in data replication for speed and reliability.

### <a id="databases-apis"></a>APIs

You can access Cloud Databases with the jclouds openstack-trove API by specifying the rackspace clouddatabases providers "rackspace-clouddatabases-us" and "rackspace-clouddatabases-uk". The -us one can be used to access the United States regions, and the -uk one is for the United Kingdom regions. The examples use the -us provider, but the providers are interchangeable (but regions will differ).

1. The Rackspace compatible API for Cloud Databases is org.jclouds.openstack.trove.v1.TroveApi - All other APIs for working with Cloud Databases are accessible via the TroveApi.
1. You can find these APIs in the latest [Javadoc](http://javadocs-labs-openstack.jclouds.cloudbees.net/).

### <a id="databases-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/clouddatabases/ in your jclouds directory.
1. Create Java source files called CreateInstance.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `pom.xml`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/clouddatabases/`
            * `CreateInstance.java`
            * `Constants.java`
1. Open CreateInstance.java for editing.
1. Go to the example code [CreateInstance.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/clouddatabases/CreateInstance.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/clouddatabases/Constants.java), read it over, and copy the code into your file.

### <a id="databases-compile"></a>Compile and Run

Note: When providing a java classpath in Windows, the path separator is ';' instead of ':'

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/clouddatabases/CreateInstance.java
    
    java -classpath ".:lib/*" org.jclouds.examples.rackspace.clouddatabases.CreateInstance myUsername myApiKey

### <a id="databases-advanced"></a>Advanced work with Cloud Databases

In addition to the create database instance example, by going through the clouddatabases example code, you will learn to create instances, databases, and database users as well as delete and modify them. You will also learn how to set up and access a database from the public internet over JDBC. You can find the examples documentation here: [Examples Documentation](https://github.com/jclouds/jclouds-examples/tree/master/rackspace)

## <a id="autoscale"></a>Working with Cloud Auto Scale
### <a id="autoscale-intro"></a>Introduction

[Cloud Auto Scale](http://www.rackspace.com/cloud/auto-scale/) takes the work out of capacity planning, allowing Rackspace Cloud Monitoring alerts or scheduled events to create and delete servers. Through the use of webhooks, Auto Scale can be integrated into countless deployment scenarios. Read the dev blog [here](http://developer.rackspace.com/blog/rackspace-autoscale-is-now-open-source.html).

### <a id="autoscale-apis"></a>APIs

You can access Cloud Auto Scale with the jclouds rackspace-autoscale API by specifying the Auto Scale provider "rackspace-autoscale-us". There is no -uk provider at this time.

1. The Rackspace compatible API for Auto Scale is org.jclouds.rackspace.autoscale.v1.AutoscaleApi - All other APIs for working with Auto Scale are accessible via the [AutoscaleApi](http://javadocs-labs-openstack.jclouds.cloudbees.net/org/jclouds/rackspace/autoscale/v1/AutoscaleApi.html).
1. You can find these APIs in the latest [Javadoc](http://javadocs-labs-openstack.jclouds.cloudbees.net/).

### <a id="autoscale-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/autoscale/ in your jclouds directory.
1. Create Java source files called CreatePolicy.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `pom.xml`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/autoscale/`
            * `CreatePolicy.java`
            * `Constants.java`
1. Open CreatePolicy.java for editing.
1. Go to the example code [CreatePolicy.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/autoscale/CreatePolicy.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/autoscale/Constants.java), read it over, and copy the code into your file.

### <a id="autoscale-compile"></a>Compile and Run

Note: When providing a java classpath in Windows, the path separator is ';' instead of ':'
Note: This uses the API key, not the password.

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/autoscale/CreatePolicy.java
    
    java -classpath ".:lib/*" org.jclouds.examples.rackspace.autoscale.CreatePolicy myUsername myApiKey

### <a id="autoscale-advanced"></a>Advanced work with Rackspace Auto Scale

In addition to the CreatePolicy example, by going through the Auto Scale example code, you will learn to create and execute webhooks, and delete and modify groups, policies, and webhooks. You can find the examples documentation [here](https://github.com/jclouds/jclouds-examples/tree/master/rackspace).

## <a id="queues"></a>Working with Cloud Queues
### <a id="queues-intro"></a>Introduction

[Cloud Queues](http://www.rackspace.com/cloud/queues/) easily connect distributed applications without installing complex software. Create unlimited queues quickly and send unlimited messages.

### <a id="queues-apis"></a>APIs

Cloud Queues works with the OpenStack layer in jclouds that is used to access features common to all OpenStack Marconi queuing systems.

1. The OpenStack API for Cloud Queues is the org.jclouds.openstack.marconi.v1.MarconiApi. All other APIs for working with queues are accessible via the MarconiApi.
1. You can find these APIs in the latest [Javadoc](http://javadocs-labs-openstack.jclouds.cloudbees.net).

### <a id="queues-source"></a>The Source Code

1. Create the directory hierarchy org/jclouds/examples/rackspace/cloudqueues/ in your jclouds directory.
1. Create Java source files called ProducerConsumer.java and Constants.java in the directory above.
1. You should now have a directory with the following structure:
    * `jclouds/`
        * `pom.xml`
        * `lib/`
            * `*.jar`
        * `org/jclouds/examples/rackspace/cloudqueues/`
            * `ProducerConsumer.java`
            * `Constants.java`
1. Open ProducerConsumer.java for editing.
1. Go to the example code [ProducerConsumer.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudqueues/ProducerConsumer.java), read it over, and copy the code into your file.
1. Open Constants.java for editing.
1. Go to the example code [Constants.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudqueues/Constants.java), read it over, and copy the code into your file.

### <a id="queues-compile"></a>Compile and Run

    javac -classpath ".:lib/*" org/jclouds/examples/rackspace/cloudqueues/ProducerConsumer.java

    java -classpath ".:lib/*" org.jclouds.examples.rackspace.cloudqueues.ProducerConsumer myUsername myApiKey

    Producer Consumer
      Producer 1 Message 1:0
      Producer 1 Message 1:1
      Consumer 1 Message 1:0 (Queue This Way)
      Consumer 2 Message 1:1 (Queue This Way)
      Producer 1 Message 1:2
      Consumer 1 Message 1:2 (Queue This Way)
      Producer 1 Message 1:3
      Consumer 1 Message 1:3 (Queue This Way)
      Producer 1 Message 1:4
      Producer 1 Message 1:5
      Consumer 2 Message 1:4 (Queue This Way)
      ...
      

## <a id="jee"></a>jclouds in a Managed Container

Setting up jclouds to work in a managed container is easy. You simply need to ensure that jclouds won't spawn any of its own threads. You can do this by using the ExecutorServiceModule when building your Context.

An example code snippet:

{% highlight java %}
import static com.google.common.util.concurrent.MoreExecutors.sameThreadExecutor; 

import org.jclouds.compute.ComputeService;
import org.jclouds.compute.ComputeServiceContext;
import org.jclouds.concurrent.config.ExecutorServiceModule;

public class MyJEEClass {
  ...
  
  private void init() {
    Iterable<Module> modules = ImmutableSet.<Module> of(
      new ExecutorServiceModule(sameThreadExecutor(), sameThreadExecutor()));

      ComputeServiceContext context = ContextBuilder.newBuilder("rackspace-cloudservers-us")
            .credentials("myUsername", "myApiKey")
            .modules(modules)
            .buildView(ComputeServiceContext.class);
      ComputeService compute = context.getComputeService();
  }
  
  ...
} 
{% endhighlight %}

## <a id="next"></a>Next Steps

1. Try the rest of the [examples](https://github.com/jclouds/jclouds-examples/tree/master/rackspace#the-examples) and the [Logging example](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/Logging.java).
1. When you're ready to publish some web pages on the internet, try the [CloudFilesPublish.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudfiles/CloudFilesPublish.java), [CloudServersPublish.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/CloudServersPublish.java), or [CreateLoadBalancerWithNewServers.java](https://github.com/jclouds/jclouds-examples/blob/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudloadbalancers/CreateLoadBalancerWithNewServers.java) examples.
1. Change the examples to do different things that you want to do.
1. After running some examples, compare the output with what you see in the [Cloud Control Panel](https://mycloud.rackspace.com/).
1. Browse the [documentation](/documentation) and have a look at the latest [Javadoc](http://demobox.github.com/jclouds-maven-site/latest/apidocs).
1. Return to the [Installation Guide](/documentation/userguide/installation-guide) and have a look at the different ways to integrate jclouds with your project.
1. Join the [jclouds mailing list](https://groups.google.com/forum/?fromgroups#!forum/jclouds) or maybe even the [jclouds developer mailing list](https://groups.google.com/forum/?fromgroups#!forum/jclouds-dev).

## <a id="providers"></a>Rackspace Cloud Providers

This is a list of providers that work with the Rackspace Cloud that you can use to build your Context.

* `"cloudfiles-us"`
* `"cloudfiles-uk"`
* `"rackspace-cloudservers-us"`
* `"rackspace-cloudservers-uk"`
* `"rackspace-cloudblockstorage-us"`
* `"rackspace-cloudblockstorage-uk"`
* `"rackspace-cloudloadbalancers-us"`
* `"rackspace-cloudloadbalancers-uk"`
* `"rackspace-clouddatabases-us"`
* `"rackspace-clouddatabases-uk"`

## <a id="support"></a>Support and Feedback

Your feedback is appreciated! If you have specific issues with Rackspace support in jclouds, we'd prefer that you file an issue via [JIRA](https://issues.apache.org/jira/browse/JCLOUDS).

For general feedback and support requests, send an email to:

[sdk-support@rackspace.com](mailto:sdk-support@rackspace.com)
