---
layout: page
title: "ProfitBricks: Getting Started Guide"
permalink: /guides/profitbricks/
---

[jclouds](http://jclouds.apache.org/) is an open source multi-cloud toolkit for the Java platform that gives you the freedom to create applications that are portable across clouds while giving you full control to use cloud-specific features.

This guide will show you how to programmatically use the ProfitBricks provider in jclouds to perform common management tasks available in the ProfitBricks Data Center Designer.

## Table of Contents

* [Concepts](#concepts)
* [Getting Started](#getting-started)
* [Portable Abstraction Usage](#portable-abstraction-usage)
* [How to: Create a Data Center](#how-to-create-a-data-center)
* [How to: Delete a Data Center](#how-to-delete-a-data-center)
* [How to: Create a Server](#how-to-create-a-server)
* [How to: List Available Disk and ISO Images](#how-to-list-available-disk-and-iso-images)
* [How to: Create a Storage Volume](#how-to-create-a-storage-volume)
* [How to: Update Cores, Memory, and Disk](#how-to-update-cores-memory-and-disk)
* [How to: Attach and Detach a Storage Volume](#how-to-attach-and-detach-a-storage-volume)
* [How to: List Servers, Volumes, and Data Centers](#how-to-list-servers-volumes-and-data-centers)
* [Example](#example)
* [Support and Feedback](#support-and-feedback)

--------------

## Concepts

The jclouds library wraps the [ProfitBricks API](https://devops.profitbricks.com/api/soap/). All operations are performed over SSL and authenticated using your ProfitBricks portal credentials. The API can be accessed within an instance running in ProfitBricks or directly over the Internet from any application that can send an HTTPS request and receive an HTTPS response.


## Getting Started

Before you begin you will need to have [signed-up](https://www.profitbricks.com/signup) for a ProfitBricks account. The credentials you setup during sign-up will be used to authenticate against the API.
 
### Installation

jclouds has some pre-requisities before you're able to use it. You will need to: 

* Ensure you are using the [Java Development Kit (JDK)](http://www.oracle.com/technetwork/java/javase/downloads/index.html) version 6 or later. You can check this by running:

```java
    javac -version
```

* Ensure you are using [Maven version 3](http://maven.apache.org/guides/getting-started/maven-in-five-minutes.html) or later. You can check this by running:

```java
    mvn -version
```

Now that you have validated the pre-requisities, you will want to do the following: 

* Create a directory to try out jclouds. This can be done by doing: 

```
    mkdir jclouds

    cd jclouds
```

* Make a local copy of the pom.xml file below in the jclouds directory.

```
    mvn dependency:copy-dependencies "-DoutputDirectory=./lib"
```

You should now have a directory with the following structure:

```
    jclouds/
        pom.xml
        lib/		
            *.jar
```

The ProfitBricks provider is currently available as part of the jclouds labs project [here](https://github.com/jclouds/jclouds-labs).


### Authentication

Connecting to ProfitBricks can be done by creating a compute connection with the ProfitBricks provider.


{% highlight java %}
    pbApi = ContextBuilder.newBuilder("profitbricks")
            .credentials(username, apiKey)
            .buildApi(ProfitBricksApi.class);
{% endhighlight %}


**Caution:** You will want to ensure you follow security best practices when using credentials within your code or stored in a file.

##Portable Abstraction Usage

### Terms
Like any cloud provider, ProfitBricks has its own set of terms in cloud computing. To abstract this into jclouds' Compute interface, these terms were associated:

- Node - composite instance of `Server` and `Storage`
- Image - both *user-uploaded* and *provided* `Images`; and `Snapshots`
- Location - `DataCenters` and `Region` (Las Vegas, Frankfurt, etc.)
- Hardware - number of cores, RAM size and storage size

### Getting Started

Assuming that there's **atleast one** datacenter existing in your account, the provider needs only an *identity* (your ProfitBricks email), and *credentials* (password) to provision a `Node`, by using a ProfitBricks-provided ubuntu-12.04 image as a template. 


{% highlight java %}
    ComputeService compute = ContextBuilder.newBuilder( "profitbricks" )
                             .credentials( "profitbricks email", "password" )
                             .buildView( ComputeServiceContext.class )
                             .getComputeService();
{% endhighlight %}                             


This works well; however, we won't be able to use jclouds' ability to execute *scripts* on a remote node. This is because, ProfitBricks' default images require users to change passwords upon first log in.

To enable jclouds to execute script, we need to use a custom image. The easiest way to do this is via ProfitBricks snapshot:

-  Go to your [DCD](https://my.profitbricks.com/dashboard/).
-  Provision a server + storage, and connect it to the internet. Upon success, you will receive an email containing the credentials needed to login to your server.
-  Login to your server, and change the password, as requested.

```
    ~ ssh root@<remote-ip>
    ...
    Changing password for root.
    (current) UNIX password: 
    Enter new UNIX password: 
    Retype new UNIX password: 
    ~ root@ubuntu:~# exit
```

- Go back to the DCD, and *make a snapshot* of the storage. Put a descriptive name.
- Configure jclouds to use this *snapshot*.


{% highlight java %}
    Template template = compute.templateBuilder()
        .imageNameMatches( "<ideally-unique-snapshot-name>" )
        .options( compute.templateOptions()
				.overrideLoginUser( "root" ) // unless you changed the user
				.overrideLoginPassword( "<changed-password>" ))
	            // more options, as you need
	    .build();
	
    compute.createNodesInGroup( "cluster1", 1, template );
{% endhighlight %}


> If no `locationId` is specified in the template, jclouds will look for a `DataCenter` that is of same scope as the `Image`.

### Limitations

- There's no direct way of specifying arbitrary number of cores, RAM size, and storage size via the compute interface, at least until after [JCLOUDS-482](https://issues.apache.org/jira/browse/JCLOUDS-482) is resolved. The adapter uses a predefined list hardware profiles instead.

> Take note that these features are still accessible by *unwraping* the ProfitBricks API, but this'll reduce portability of your code. See [Concepts](https://jclouds.apache.org/start/concepts/).

# How To's
## How to: Create a Data Center

ProfitBricks introduces the concept of Virtual Data Centers. These are logically separated from one another and allow you to have a self-contained environment for all servers, volumes, networking, snapshots, and so forth. The goal is to give you the same experience as you would have if you were running your own physical data center.

The following code example shows you how to programmatically create a data center: 


{% highlight java %}
     DataCenter dc = api.dataCenterApi().createDataCenter(
              DataCenter.Request.CreatePayload.create("JClouds", Location.DE_FKB)
      );
{% endhighlight %}


This responds with the datacenter object once created.

## How to: Delete a Data Center

You will want to exercise a bit of caution here. Removing a data center will **destroy** all objects contained within that data center -- servers, volumes, snapshots, and so on.

The code to remove a data center is as follows. This example assumes you want to remove previously datacenter: 


{% highlight java %}
    api.dataCenterApi().deleteDataCenter(dc.id());
{% endhighlight %}


## How to: Create a Server

The server create method has a list of required parameters followed by a hash of optional parameters. The optional parameters are specified within the "options" hash and the variable names match the [SOAP API](https://devops.profitbricks.com/api/soap/) parameters.

The following example shows you how to create a new server in the virtual datacenter created above:


{% highlight java %}
	String serverId = api.serverApi().createServer(Server.Request.creatingBuilder()
			.dataCenterId(dc.id())
			.name("jclouds-node")
			.cores(1)
			.ram(1024)
			.build());
{% endhighlight %}


The server can take time to provision. The "waitUntilAvailable" server object method will wait until the server state is available before continuing. This is useful when chaining requests together that are dependent on one another.


{% highlight java %}
    waitUntilAvailable = Predicates2.retry(
        new ProvisioningStatusPollingPredicate(api, ProvisioningStatusAware.SERVER, ProvisioningState.AVAILABLE),
        2l * 60l, 2l, TimeUnit.SECONDS);
{% endhighlight %}


## How to: List Available Disk and ISO Images

A list of disk and ISO images are available from ProfitBricks for immediate use. These can be easily viewed and selected. The following shows you how to get a list of images. This list represents both CDROM images and HDD images.


{% highlight java %}
    List<Image> images = api.imageApi().getAllImages();
{% endhighlight %}


## How to: Create a Storage Volume

ProfitBricks allows for the creation of multiple storage volumes that can be attached and detached as needed. It is useful to attach an image when creating a storage volume. The storage size is in gigabytes.


{% highlight java %}
    String storageId = api.storageApi().createStorage(
        Storage.Request.creatingBuilder()
        .dataCenterId(dc.id())
        .name("hdd-1")
        .size(2f)
        .build());
{% endhighlight %}


## How to: Update Cores, Memory, and Disk

ProfitBricks allows users to dynamically update cores, memory, and disk independently of each other. This removes the restriction of needing to upgrade to the next size available size to receive an increase in memory. You can now simply increase the instances memory keeping your costs in-line with your resource needs.

**Note:** The memory parameter value must be a multiple of 256, e.g. 256, 512, 768, 1024, and so forth.

The following code illustrates how you can update cores and memory: 


{% highlight java %}
	api.serverApi().updateServer(
			Server.Request.updatingBuilder()
			.id(serverId)
			.name("apache-node")
			.cores(2)
			.ram(2 * 1024)
			.build());
{% endhighlight %}


The server object may need to be refreshed in order to show the new configuration.


{% highlight java %}
    Server server = api.serverApi().getServer(createdServerId);
{% endhighlight %}


 This is how you would update the storage volume size:


{% highlight java %}
	api.storageApi().updateStorage(
			Storage.Request.updatingBuilder()
			.id(storageId)
			.name("hdd-2")
			.build());
{% endhighlight %}


## How to: Attach and Detach a Storage Volume

ProfitBricks allows for the creation of multiple storage volumes. You can detach and reattach these on the fly. This allows for various scenarios such as re-attaching a failed OS disk to another server for possible recovery or moving a volume to another location and spinning it up. 

The following illustrates how you would attach and detach a volume from a server:


{% highlight java %}
    String requestId = api.storageApi().disconnectStorageFromServer(storageId, serverId);
{% endhighlight %}


## How to: List Servers, Volumes, and Data Centers

jclouds provides standard functions for retrieving a list of volumes, servers, and datacenters. 

The following code illustrates how to pull these three list types: 


{% highlight java %}
    List<Storage> storages = api.storageApi().getAllStorages();

    List<Server> servers = api.serverApi().getAllServers();
 
    List<DataCenter> dataCenters = api.dataCenterApi().getAllDataCenters();
{% endhighlight %}


## Example:


{% highlight java %}
	package com.profitbricks.example;

	import com.google.common.base.Predicate;
	import java.util.List;
	import java.util.concurrent.TimeUnit;
	import org.jclouds.ContextBuilder;
	import org.jclouds.profitbricks.ProfitBricksApi;
	import org.jclouds.profitbricks.compute.internal.ProvisioningStatusAware;
	import org.jclouds.profitbricks.compute.internal.ProvisioningStatusPollingPredicate;
	import org.jclouds.profitbricks.domain.DataCenter;
	import org.jclouds.profitbricks.domain.Image;
	import org.jclouds.profitbricks.domain.Location;
	import org.jclouds.profitbricks.domain.ProvisioningState;
	import org.jclouds.profitbricks.domain.Server;
	import org.jclouds.profitbricks.domain.Storage;
	import org.jclouds.util.Predicates2;

	public class App {

		private static Predicate<String> waitUntilAvailable;
		private static final String provider = "profitbricks";
		private static final String username = "username";
		private static final String apikey = "apikey";

		public static void main(String[] args) {

			ProfitBricksApi api = ContextBuilder.newBuilder(provider)
					.credentials(username, apikey)
					.buildApi(ProfitBricksApi.class);

			/*
			 * CreateDataCenterRequest. 
			 * The only required field is DataCenterName. 
			 * If location parameter is left empty data center will be created in the default region of the customer
			 */
			DataCenter dc = api.dataCenterApi().createDataCenter(
					DataCenter.Request.CreatePayload.create("JClouds", Location.DE_FKB)
			);

			/*  
			 * DataCenterId: Defines the data center wherein the server is to be created.
			 * AvailabilityZone: Selects the zone in which the server is going to be created (AUTO, ZONE_1, ZONE_2).
			 * Cores: Number of cores to be assigned to the specified server. Required field.
			 * InternetAccess: Set to TRUE to connect the server to the Internet via the specified LAN ID.
			 * OsType: Sets the OS type of the server.
			 * Ram: Number of RAM memory (in MiB) to be assigned to the server.
			 */
			String serverId = api.serverApi().createServer(Server.Request.creatingBuilder()
					.dataCenterId(dc.id())
					.name("jclouds-node")
					.cores(1)
					.ram(1024)
					.build());

			/*
			 * The "waitUntilAvailable" server object method will wait until the server state is available before continuing
			 */
			waitUntilAvailable = Predicates2.retry(
					new ProvisioningStatusPollingPredicate(api, ProvisioningStatusAware.SERVER, ProvisioningState.AVAILABLE),
					2l * 60l, 2l, TimeUnit.SECONDS);

			/*
			 * Get list of all images.
			 */
			List<Image> images = api.imageApi().getAllImages();

			/* dataCenterId: Defines the data center wherein the storage is to be created. If left empty, the storage will be created in a new data center
			 * name: names the new volume.
			 * Size: Storage size (in GiB). Required Field.
			 */
			String storageId = api.storageApi().createStorage(
					Storage.Request.creatingBuilder()
					.dataCenterId(dc.id())
					.name("hdd-1")
					.size(2f)
					.build());

			/*
			 * ServerId: Id of the server to be updated.
			 * ServerName: Renames target virtual server
			 * Cores: Updates the amount of cores of the target virtual server
			 * Ram: Updates the RAM memory (in MiB) of the target virtual 
			 */
			api.serverApi().updateServer(
					Server.Request.updatingBuilder()
					.id(serverId)
					.name("apache-node")
					.cores(2)
					.ram(2 * 1024)
					.build());

			/*
			 * id: identifier of a storage to be updated
			 * name: changes the name of the storage
			 */
			api.storageApi().updateStorage(
					Storage.Request.updatingBuilder()
					.id(storageId)
					.name("hdd-2")
					.build());

			/*
			 * Disconnects storage from the server.
			 */
			api.storageApi().disconnectStorageFromServer(storageId, serverId);

			/*
			 * Fetches list of all DataCenters
			 */
			List<DataCenter> dataCenters = api.dataCenterApi().getAllDataCenters();

			/*
			 * Fetches list of all Volumes
			 */
			List<Storage> storages = api.storageApi().getAllStorages();

			/*
			 * Fetches list of all Servers
			 */
			List<Server> servers = api.serverApi().getAllServers();

			api.dataCenterApi().deleteDataCenter(dc.id());
		}
	}
{% endhighlight %}


## Support and Feedback
Your feedback is welcome! If you have comments or questions regarding using ProfitBricks via jclouds, please reach out to us at [DevOps Central](https://devops.profitbricks.com).
