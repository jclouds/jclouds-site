---
layout: page
title: "HP Helion Public Cloud: Getting Started Guide"
permalink: /guides/hpcloud/
---
![HP Helion](/img/logos/hp-helion.png)

This page helps you get started using the jclouds API with HP Helion Public Cloud (Formerly HP Cloud).

# About HP Helion Public Cloud
HP Helion Public Cloud is an OpenStack® based public cloud provider offering on-demand, pay-as-you-go cloud services for computing and storage infrastructure as well as platform services.

## Getting Started
1. Sign up for [HP Helion Public Cloud](http://www.hpcloud.com/cloud-credit).
2. Get your Project ID, Access Key, and Secret Key:
    - Sign in to your [HP Cloud Console](https://horizon.hpcloud.com)
    - Click on your userid (drop down in the top right of the page)
    - Click on "Manage Access Keys"
3. Ensure you are using a recent version of Java 6.
4. Setup your project to include `hpcloud-objectstorage` and `hpcloud-compute`.
	* Get the dependencies `org.apache.jclouds.provider/hpcloud-objectstorage` and `org.apache.jclouds.provider/hpcloud-compute` using jclouds [Installation](/start/install).
5. Start coding.

** Note: As of 1.8.0, the HP Cloud provider uses tenantName:accessKey as identity and secretKey as credentials. Previous 
versions of the HP Cloud provider (prior to 1.8.0) default to using tenantName:userid as identity and password as credentials. 

## HP Cloud Object Storage

{% highlight java %}
// Get a context with hpcloud that offers the portable BlobStore API
BlobStoreContext context = ContextBuilder.newBuilder("hpcloud-objectstorage")
                 .credentials("tenantName:accessKey", "secretKey")
                 .buildView(BlobStoreContext.class);

// Create a container in the default location
context.getBlobStore().createContainerInLocation(null, container);

// Use the map interface for easy access to put/get things, keySet, etc.
context.createInputStreamMap(container).put("blob.txt", inputStream);

// When you need access to hpcloud specific features, use the provider-specific context
HPCloudObjectStorageClient hpcloudClient =
	HPCloudObjectStorageClient.class.cast(context.getProviderSpecificContext().getApi());

// Create a container with public access
boolean accessibleContainer = hpcloudClient.createContainer("public-container", withPublicAccess());

ContainerMetadata cm = hpcloudClient.getContainerMetadata("public-container");
if (cm.isPublic()) {
	...
}

// When you want to use CDN features with a container, use the provider-specific CDN client
HPCloudCDNClient cdnClient = hpcloudClient.getCDNExtension().get();

// Get a CDN URL for the container
URI uri = cdnClient.enableCDN(container);

// Get the CDN Metadata for the container
ContainerCDNMetadata cdnMetadata = cdnClient.getCDNMetadata(container)
if (cdnMetadata.isCDNEnabled()) {
    ...
}

// Be sure to close the context when done
context.close();
{% endhighlight %}

## HP Cloud Compute

{% highlight java %}
// Get a context with hpcloud-compute that offers the portable ComputeService API
ComputeServiceContext ctx = ContextBuilder.newBuilder("hpcloud-compute")
                      .credentials("tenantName:accessKey", "secretKey")
                      .modules(ImmutableSet.<Module> of(new Log4JLoggingModule(),
                                                        new SshjSshClientModule()))
                      .buildView(ComputeServiceContext.class);

ComputeService cs = ctx.getComputeService();

// List availability zones
Set<? extends Location> locations = cs.listAssignableLocations();

// List nodes
Set<? extends ComputeMetadata> nodes = cs.listNodes();

// List hardware profiles
Set<? extends Hardware> hardware = cs.listHardwareProfiles();

// List images
Set<? extends org.jclouds.compute.domain.Image> image  = cs.listImages();

// Create nodes with templates
Template template = cs.templateBuilder().osFamily(OsFamily.UBUNTU).build();
Set<? extends NodeMetadata> groupedNodes = cs.createNodesInGroup("myGroup", 2, template);

// Reboot images in a group
cs.rebootNodesMatching(inGroup("myGroup"));

// When you need access to HP Cloud Compute features, use the provider-specific context
RestContext<NovaClient, NovaAsyncClient> context = ctx.getProviderSpecificContext();
NovaClient client = context.getApi();

// From the provider-specific context, you can access servers, flavors, and images through their respective clients
// Get the server client for a particular availability zone
ServerClient serverClient = client.getServerClientForZone(zone);

// List all available servers for an account
Set<Server> servers = serverClient.listServersInDetail()

// Get the flavor client for a particular availability zone
FlavorClient flavorClient = client.getFlavorClientForZone(zone);

// List all available flavors
Set<Flavor>flavors = flavorClient.listFlavorsInDetail();

// Get the details of a particular flavor
Flavor flavor = flavorClient.getFlavor(flavorId);

// Get the image client for a particular availability zone
ImageClient imageClient = client.getImageClientForZone(zone);

// List all available images
Set<Image> images = imageClient.listImagesInDetail();

// Get the details of a particular image
Image image = imageClient.getImage(images.iterator().next().getId());

// From the provider-specific context, you can also retrieve the optional extensions related to key pair, security
// group, and floating IP address management
// Get the optional keypair client for a particular availability zone
KeyPairClient keyPairClient = client.getKeyPairExtensionForZone(zone).get();

// Create a new keypair
KeyPair keyPair = keyPairClient.createKeyPair("exampleKeyPair");

// Get the optional security groups client for a particular availability zone
SecurityGroupClient securityGroupClient = client.getSecurityGroupExtensionForZone(zone).get();

// List all available security groups
Set<SecurityGroup> securityGroups = securityGroupClient.listSecurityGroups();

// Create a new security group
SecurityGroup exampleSecurityGroup = securityGroupClient
    .createSecurityGroupWithNameAndDescription("exampleSecurityGroup", "an example security group");

// Create a rule for an existing security group
Ingress ingress = Ingress.builder().ipProtocol(IpProtocol.TCP).fromPort(80).toPort(8080).build();
SecurityGroupRule rule = securityGroupClient
        .createSecurityGroupRuleAllowingSecurityGroupId(exampleSecurityGroup.getId(), ingress, "0.0.0.0/0");

// Get the optional floating IP client for a particular availability zone
FloatingIPClient floatingIPClient = client.getFloatingIPExtensionForZone(zone).get();

// List all available floating ip addresses
Set<FloatingIP> addresses = floatingIPClient.listFloatingIPs();

// Create/allocate a new address
FloatingIP exampleAddress = floatingIPClient.allocate();

// Associate a server to an existing address
floatingIPClient.addFloatingIPToServer(exampleAddress.getIp(), server.getId());

// Be sure to close the context when done
context.close();
{% endhighlight %}
