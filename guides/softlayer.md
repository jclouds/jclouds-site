---
layout: page
title: "SoftLayer: Getting Started Guide"
permalink: /guides/softlayer/
---
This page helps you get started using the jclouds API with SoftLayer.

Currently, *SoftLayer* offers 3 main “cloud” flavours:

- `Bare Metal Server` (*BMS*): SoftLayer dedicated servers give you options from entry-level single processor servers to quad proc, hex-core, and even GPU-powered workhorses.
- `Virtual Server` (*BMI*): Single-tenant environment with SoftLayer managed hypervisor, ideal for applications with stringent resource requirements. It can be considered as a specialized configuration of Bare Metal Servers with limited options.
- `Public Cloud Instances` (*CCI*): Multi-tenant environment with SoftLayer managed hypervisor, ideal for rapid scalability and higher-cost effectiveness.

Starting from 1.8.0, Jclouds supports officially only Public Cloud Instances (CCI).

## Getting Started
1. Sign up for [SoftLayer Cloud](https://www.softlayer.com/cloud-servers/).
2. Log in to the
2. Get your Username and API Key:
    - Sign in to [SoftLayer Customer Portal](https://control.softlayer.com)
    - Navigate to [Users](https://control.softlayer.com/account/users)
    - Click on "View" under `API Key` to see the API credential.
3. Ensure you are using a recent version of Java 6.
4. Setup your project to include `softlayer`.
	* Get the dependencies `org.jclouds.provider/softlayer` using jclouds [Installation](/start/install).
5. Start coding.

## SoftLayer Compute

{% highlight java %}
// Get a context with softlayer that offers the portable ComputeService API
ComputeServiceContext computeServiceContext = ContextBuilder.newBuilder("softlayer")
                      .credentials("username", "apiKey")
                      .modules(ImmutableSet.<Module> of(new Log4JLoggingModule(),
                                                        new SshjSshClientModule()))
                      .buildView(ComputeServiceContext.class);

ComputeService computeService = computeServiceContext.getComputeService();

// List availability zones
Set<? extends Location> locations = computeService.listAssignableLocations();

// List nodes
Set<? extends ComputeMetadata> nodes = computeService.listNodes();

// List hardware profiles
Set<? extends Hardware> hardware = computeService.listHardwareProfiles();

// List images
Set<? extends org.jclouds.compute.domain.Image> image  = computeService.listImages();
{% endhighlight %}

NB: "computeService.listImages()" returns `operatingSystems` from [SoftLayer_Container_Virtual_Guest_Configuration](http://sldn.softlayer.com/reference/datatypes/SoftLayer_Container_Virtual_Guest_Configuration).

{% highlight java %}
// Create nodes with templates
Template template = computeService.templateBuilder().osFamily(OsFamily.UBUNTU).build();
Set<? extends NodeMetadata> groupedNodes = computeService.createNodesInGroup("myGroup", 2, template);

// Reboot images in a group
computeService.rebootNodesMatching(inGroup("myGroup"));
{% endhighlight %}

### TemplateOptions and SoftLayerTemplateOptions
In jclouds, the standard mechanism to specify template options is by using the TemplateBuilder. This supports a number of configuration supported by all the api/provider jclouds

For example, the location id is used to specify the "region" provider where to spin your VM:
{% highlight java %}
TemplateBuilder templateBuilder = context.getComputeService().templateBuilder();
templateBuilder.locationId("ams01");
{% endhighlight %}

If you need to specify a public image supported by SoftLayer can be referenced as follows:
{% highlight java %}
templateBuilder.imageId("CENTOS_6_64");
{% endhighlight %}

If you want instead to specify a `private` image, you need to set the `globalIdentifier` of a VirtualGuestBlockDeviceTemplateGroup, like:
{% highlight java %}
templateBuilder.imageId("3d7697d8-beef-437a-8921-5a2a18bc116f");
{% endhighlight %}

Notice, if you don't know the globalIdentifier upfront you can use the following curl command:
{% highlight java %}
curl -uusername:apiKey https://api.softlayer.com/rest/v3/SoftLayer_Account/getBlockDeviceTemplateGroups?objectMask=children.blockDevices.diskImage.softwareReferences.softwareDescription
{% endhighlight %}

and use the globalIdentifier desired

jclouds is able to leverage SoftLayer CCI specific-options described at [createObject](http://sldn.softlayer.com/reference/services/SoftLayer_Virtual_Guest/createObject) by doing the following:
{% highlight java %}
SoftLayerTemplateOptions options = template.getOptions().as(SoftLayerTemplateOptions.class);
// domain
options.domainName("live.org");
// multi-disk
options.blockDevices(ImmutableList.of(25, 400, 400));
// disk type (SAN, LOCAL)
options.diskType("SAN");
//tags
options.tags(ImmutableList.of("jclouds"));
// primaryNetworkComponent.networkVlan.id
options.primaryNetworkComponentNetworkVlanId(vlanId);
// primaryBackendNetworkComponent.networkVlan.id
options.primaryBackendNetworkComponentNetworkVlanId(backendVlanId);
{% endhighlight %}
NB: notice, vlandId and backendVlanId should be the internal IDs and not the vlan number! One can easily retrieve it from the SoftLayer web UI by clicking on VLAN number link of `https://control.softlayer.com/network/vlans`
The url will show something like `https://control.softlayer.com/network/vlans/1234567` where the vlanId is *1234567*

### Provider-specific APIs
When you need access to SoftLayer features, use the provider-specific context
{% highlight java %}
SoftLayerApi api = computeServiceContext.unwrapApi(SoftLayerApi.class);
// and then get access to the delegate API groups
api.getVirtualGuestApi();
api.getDatacenterApi();
api.getSoftwareDescriptionApi();
api.getVirtualGuestBlockDeviceTemplateGroupApi();
api.getAccountApi();

// Be sure to close the context when done
computeServiceContext.close();
{% endhighlight %}

## SoftLayer Object Storage
SoftLayer Object Storage is an OpenStack® based blobstore storage system.

{% highlight java %}
// Get a context with softlayer that offers the portable BlobStore API
BlobStoreContext context = ContextBuilder.newBuilder("swift")
                 .credentials("tenantName:accessKey", "apiKey)
                 .endpoint("https://<locationId>.objectstorage.softlayer.net/auth/v1.0")
                 .buildView(BlobStoreContext.class);

// Create a container in the default location
context.getBlobStore().createContainerInLocation(null, container);

// Be sure to close the context when done
context.close();
{% endhighlight %}

For more examples, see <a href="/guides/openstack/">Openstack</a> documentation.
