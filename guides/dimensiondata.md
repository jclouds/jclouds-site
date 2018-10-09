---
layout: page
title: "Dimension Data: Getting Started Guide"
permalink: /guides/dimensiondata/
---

[jclouds](http://jclouds.apache.org/) is an open source multi-cloud toolkit for the Java platform that gives you the freedom to create applications that are portable across clouds while giving you full control to use cloud-specific features.

This guide will show you how to programmatically use the Dimension Data CloudControl provider in jclouds to perform common operations available in the CloudControl API.

## Table of Contents

* [Concepts](#concepts)
* [Getting Started](#getting-started)
* [Portable Abstraction Usage](#portable-abstraction-usage)
* [How to: Configure the Dimension Data Cloud Control API](#configure-dimension-data-cloud-control-api)
* [How to: Build the Dimension Data Cloud Control API](#build-dimension-data-cloud-control-api)
* [How to: List a Data Center](#how-to-list-a-data-center)
* [How to: Deploy a Network Domain](#how-to-deploy-a-network-domain)
* [How to: Deploy a Vlan](#how-to-deploy-a-vlan)
* [How to: List Os Images](#how-to-list-available-os-images)
* [How to: Deploy a Server](#how-to-deploy-a-server)
* [How to: Apply a Tag to an Asset](#how-to-apply-a-tag-to-an-asset)
* [Examples](#examples)
* [Support and Feedback](#support-and-feedback)

--------------

## <a id="concepts"></a>Concepts

The jclouds library wraps the [Dimension Data CloudControl API](https://docs.mcp-services.net/display/DEV/Welcome+to+the+CloudControl+documentation+portal). All operations are performed over SSL and authenticated using your Dimension Data CloudControl credentials. The API can be accessed directly over the Internet from any application that can send an HTTPS request and receive an HTTPS response.


## <a id="getting-started"></a>Getting Started

Before you begin you will need to have a Dimension Data CloudControl account for your organization. The credentials will be used to authenticate against the API.

The Dimension Data CloudControl provider supports [API version 2.4](https://docs.mcp-services.net/display/CCD/Understanding+API+v0.9+vs.+API+v2) and [MCP 2.0 datacenters](https://docs.mcp-services.net/display/CCD/Introduction+to+MCP+2.0+Data+Center+Locations) only. 

Upgrading to later versions is planned and in progress, see [here](https://issues.apache.org/jira/issues/?jql=project%20%3D%20JCLOUDS%20AND%20labels%20%3D%20dimensiondata) for further details.

 
### Installation

Please follow the installation guide [here](https://jclouds.apache.org/start/install/).

The Dimension Data CloudControl provider is currently available as part of the jclouds labs project [here](https://github.com/jclouds/jclouds-labs).
The Dimension Data CloudControl provider examples project is currently available as part of jclouds examples [here](https://github.com/jclouds/jclouds-examples).

### Authentication

Connecting to Dimension Data CloudControl can be done by creating a compute connection with the `dimensiondata-cloudcontrol` provider.

To build an unwrapped version of the API do the following.
{% highlight java %}
ContextBuilder contextBuilder = ContextBuilder.newBuilder("dimensiondata-cloudcontrol");
DimensionDataCloudControlApi api = contextBuilder
    .endpoint(endpoint)
    .credentials(username, password)
    .buildApi(DimensionDataCloudControlApi.class);
{% endhighlight %}


**Caution:** You will want to ensure you follow security best practices when using credentials within your code or stored in a file.

## <a id="portable-abstraction-usage"></a>Portable Abstraction Usage

### Terms
Like any cloud provider, Dimension Data CloudControl has its own set of terms in cloud computing. To abstract this into jclouds' Compute interface, these terms were associated:

- Node - a `Server`
- Image - both *user-uploaded* and *provided* `CustomerImage` and `OSImage` are supported
- Location - `Geographic Region` equates to a jclouds Region (AU, NA, EU etc) and `Datacenter` equates to a jclouds Zone (NA9, NA12 etc). There is further information on the Geographic Regions [here](https://docs.mcp-services.net/display/CCD/Introduction+to+Geographic+Regions)
- Hardware - number of cores, RAM size and storage size for a given Image

### Getting Started

The implementation of the jclouds abstraction is incomplete so it is best for now to use the unwrapped `DimensionDataCloudControlApi`. 


# How To's

## <a id="configure-dimension-data-cloud-control-api"></a>How to: Configure the Dimension Data Cloud Control API

In jclouds there are default limits in place for the length of time it takes for operations to run before a timeout occurs. In Dimension Data some of these operations take a longer period of time, so they will need to be adjusted. 

The timeouts are defined in `org.jclouds.compute.reference.ComputeServiceConstants`. 

Two useful settings to apply to avoid a timeout when shutting down and deleting a Server are `-Djclouds.compute.timeout.node-suspended=600000` and `-Djclouds.compute.timeout.node-terminated=600000`.

## <a id="build-dimension-data-cloud-control-api"></a>How to: Build the Dimension Data Cloud Control API

{% highlight java%}
ApiContext<DimensionDataCloudControlApi> ctx = null;
try
{
    ctx = ContextBuilder.newBuilder("dimensiondata-cloudcontrol")
            .endpoint(endpoint)
            .credentials(username, password)
            .modules(ImmutableSet.of(new SLF4JLoggingModule()))
            .build();

    DimensionDataCloudControlApi api = ctx.getApi();

    /*
     * interact with the DimensionDataCloudControlApi
     */
}
finally
{
    if (ctx != null)
    {
        ctx.close();
    }
}
{% endhighlight %}

# How To's
## <a id="how-to-list-a-data-center"></a>How to: List a Data Center

The user account will be associated with one or more [MCP 2.0 Data Centers](https://docs.mcp-services.net/display/CCD/Introduction+to+MCP+2.0+Data+Center+Locations). A Data Center is a container for the assets that will be deployed and created by the jclouds Dimension Data CloudControl Provider.

In jclouds terminology a Zone equates to a Data Center.

The following code example shows you how to programmatically list Data Centers: 

{% highlight java %}
PagedIterable<Datacenter> datacenters = api.getInfrastructureApi().listDatacenters();
{% endhighlight %}

This responds with a paged result set containing the Data Centers visible to your organization.

## <a id="how-to-deploy-a-network-domain"></a>How to: Deploy a Network Domain

For more information on Network Domains see [here](https://docs.mcp-services.net/display/CCD/Introduction+to+Cloud+Network+Domains+and+VLANs).

The code to deploy a Network Domain follows.

{% highlight java %}
/*
 * Deploy Network Domain to the Zone / Datacenter we wish to operate on. The response from this API is the Network Domain Identifier.
 */
String networkDomainId = api.getNetworkApi().deployNetworkDomain(AU9, "jclouds-example", "jclouds-example", "ESSENTIALS");
{% endhighlight %}

A Network Domain deployment is an asynchronous process. We need to wait for it to complete. The Dimension Data provider
has built in google guice predicates that will block execution and check that the Network Domain's State has moved from `PENDING_ADD` to `NORMAL`.

The following is some example code that shows how the to use predicate suitable for asserting a Network Domain state has transitioned to the `NORMAL` state. The predicate uses the Network Domain Identifier we wish to check the state of.
{% highlight java %}
Predicate<String> networkDomainNormalPredicate = api.getNetworkApi().networkDomainNormalPredicate();
networkDomainNormalPredicate.apply(networkDomainId);    
{% endhighlight %}

## <a id="how-to-deploy-a-vlan"></a>How to: Deploy a Vlan

For more information on Vlans see [here](https://docs.mcp-services.net/display/CCD/Introduction+to+Cloud+Network+Domains+and+VLANs).

The code to deploy a Vlan follows.

{% highlight java %}
/*
 * Deploy the Vlan and associate it with the Network Domain that was previously created.
 * The Vlan is deployed with a privateIpv4BaseAddress and privateIpv4PrefixSize
 */
String vlanId = api.getNetworkApi().deployVlan(networkDomainId, "jclouds-example-vlan", "jclouds-example-vlan", "10.0.0.0", 24);
{% endhighlight %}

A Vlan deployment is an asynchronous process. We need to wait for it to complete. The Dimension Data provider has built in predicates that will block execution and check that the Vlan's State has moved from `PENDING_ADD` to `NORMAL`.

Following is some example code that shows how the to use predicate suitable for asserting a Vlan state has transitioned to the `NORMAL` state. The predicate uses the Vlan Identifier we wish to check the state of.
{% highlight java %}
Predicate<String> vlanNormalPredicate = api.getNetworkApi().vlanNormalPredicate();
vlanNormalPredicate.apply(vlanId);
{% endhighlight %}

## <a id="how-to-list-available-os-images"></a>How to: List Os Images

For more information on Os Images see [here](https://docs.mcp-services.net/display/CCD/Introduction+to+MCP+2.0+Data+Center+Locations#IntroductiontoMCP2.0DataCenterLocations-CloudImagesandServers).

An Image Id is required for deploying a server. It contains the hardware configuration that the deployed Server will have.

The code to list Os Images filtering on a datacenter follows.

{% highlight java %}
PaginatedCollection<OsImage> osImages = api.getServerImageApi().listOsImages(DatacenterIdListFilters.Builder.datacenterId("AU9"));
{% endhighlight %}


## <a id="how-to-deploy-a-server"></a>How to: Deploy a Server

For more information on Deploying Servers see [here](https://docs.mcp-services.net/display/CCD/Introduction+to+Cloud+Server+Provisioning%2C+OS+Customization%2C+and+Best+Practices).

The following example shows you how to create a new server in the virtual datacenter created above:
{% highlight java %}
/*
 * The Server that gets deployed will have some network configuration. It gets assigned to the Vlan that was created previously.
 */
NetworkInfo networkInfo = NetworkInfo
    .create(networkDomainId, NIC.builder().vlanId(vlanId).build(), Lists.<NIC>newArrayList());
/*
 * The Server that gets deployed will have some additional disk configuration.
 */
List<Disk> disks = ImmutableList.of(Disk.builder().scsiId(0).speed("STANDARD").build());

/*
 * The Server is deployed using the OS Image we selected,
 * a flag to signal if we want it started or not, an admin pass and the additional configuration we built.
 */
String serverId = api.getServerApi()
    .deployServer("jclouds-server", imageId, true, networkInfo, "P$$ssWwrrdGoDd!", disks, null);

{% endhighlight %}

 A Server deployment is an asynchronous process. We need to wait for it to complete. The Dimension Data provider has built in predicates that will block execution and check that the Server's State has moved from `PENDING_ADD` to `NORMAL`. This piece of sample code also waits for the Server to be started.
{% highlight java %}
static void waitForServerStartedAndNormal(String serverId)
{
    Predicate<String> serverStartedPredicate = api.getServerApi().serverStartedPredicate();
    Predicate<String> serverNormalPredicate = api.getServerApi().serverNormalPredicate();
    // Wait for Server to be started and NORMAL
    serverStartedPredicate.apply(serverId);
    serverNormalPredicate.apply(serverId);
}
{% endhighlight %}

## <a id="how-to-apply-a-tag-to-an-asset"></a>How to: Apply a Tag to an Asset

Dimension Data CloudControl allows for Tags to be applied to assets. There are two parts to the tagging process, first a Tag Key needs to be created, second the Tag Key is applied to an asset. 

The following is code to create a Tag Key. We will use the Tag Key when we are tagging the assets that are created.
{% highlight java %}
String tagKeyId = api.getTagApi().createTagKey("jclouds", "owner of the asset", true, false);
{% endhighlight %}

Follows is the sample code for applying a Tag to the Server. We use AssetType SERVER. Pass in the tagKeyId and a value that we want to associate, in this case jclouds.
{% highlight java %}
api.getTagApi().applyTags(serverId, "SERVER", Collections.singletonList(TagInfo.create(tagKeyId, "jclouds")));
{% endhighlight %}

The full set of `AssetTypes` are `SERVER`, `NETWORK_DOMAIN`, `VLAN`, `CUSTOMER_IMAGE`, `PUBLIC_IP_BLOCK` or `ACCOUNT`.

## <a id="examples"></a>Examples:
See jclouds examples repository [here](https://github.com/jclouds/jclouds-examples/tree/master/dimensiondata/src/main/java/org/jclouds/examples/dimensiondata/cloudcontrol).

## <a id="support-and-feedback"></a>Support and Feedback
Your feedback is welcome! If you have comments or questions regarding using Dimension Data CloudControl via jclouds, please reach out to us at [jclouds community](https://jclouds.apache.org/community/).
