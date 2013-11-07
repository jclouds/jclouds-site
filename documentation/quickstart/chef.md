---
layout: jclouds
title: Quick Start - Chef
---

# Quick Start: Chef

1. Setup a Chef Server or register for [Opscode Enterprise Chef](https://getchef.opscode.com/signup).
2. Ensure you are using a recent JDK 6 version.
3. Setup your project to include `chef`, or `enterprisechef`, depending on the Chef flavor you are going to connect to.
    * Get the dependencies `org.jclouds.api/chef` using jclouds [Installation](/documentation/userguide/installation-guide).
    * Get the dependencies `org.jclouds.provider/enterprisechef` using jclouds [Installation](/documentation/userguide/installation-guide).
4. Start coding

## About Enterprise Chef

The Enterprise Chef API is still not complete. The User and Organization APIs are still a work in progress, so please, be patient.
The core Chef API, however, provides access to all Chef features in all Chef flavors, so you can use that API to connect to your favorite endpoint.

## Using the Chef Server API

You can easily access the Chef Server API to manage the different components of your Chef Server.  
The following example shows several calls to the API and the creation of the context, so you can get an idea of how jclouds-chef works.

Note that you can use `chef` or `enterprisechef` to create the context.

{% highlight java %}
String client = "clientName";
String organization = "organization"
String pemFile = System.getProperty("user.home") + "/.chef/" + client + ".pem";
String credential = Files.toString(new File(pemFile), Charsets.UTF_8);

ChefContext context = ContextBuilder.newBuilder("enterprisechef") //
    .endpoint("https://api.opscode.com/organizations/" + organization) //
    .credentials(client, credential) //
    .buildView(ChefContext.class);

// The raw API has access to all chef features, as exposed in the Chef REST API
EnterpriseChefApi api = context.unwrapApi(EnterpriseChefApi.class);
Set<String> databags = api.listDatabags();

// ChefService has helpers for common commands
String nodeName = "chef-example";
List<String> runlist = new RunListBuilder().addRecipe("apache2").build();
Node node = context.getChefService().createNodeAndPopulateAutomaticAttributes(nodeName, runlist);

// Release resources
context.close();
{% endhighlight %}

## Bootstrap nodes with Chef and the ComputeService

You can also combine the jclouds compute portable API with the Chef API to bootstrap nodes using Chef. The example below shows how you can combine both APIs to achieve this.

### Relationship between compute groups and run lists

Jclouds compute-chef integration is facilitated by the Chef concept of databags. We use a databag to store the relationships between Chef nodes and jclouds compute groups. By default these relationships are stored in a databag named "bootstrap", however, you can change this by adjusting the property `chef.bootstrap-databag`.  
We also provide a couple of utilities to help manage the data in this special bag. The two methods are named `updateRunListForGroup` and `getRunListForGroup` in java, and `update-run-list` and `run-list` in clojure at the moment.

{% highlight java %}
// Get the credentials that will be used to authenticate to the Chef server
String client = "clientName";
String organization = "organization"
String pemFile = System.getProperty("user.home") + "/.chef/" + client + ".pem";
String credential = Files.toString(new File(pemFile), Charsets.UTF_8);

// Provide the validator information to let the nodes to auto-register themselves
// in the Chef server during bootstrap
String validator = organization + "-validator";
String validatorPemFile = System.getProperty("user.home") + "/.chef/" + validator + ".pem";
String validatorCredential = Files.toString(new File(validatorPemFile), Charsets.UTF_8);

Properties chefConfig = new Properties();
chefConfig.put(ChefProperties.CHEF_VALIDATOR_NAME, validator);
chefConfig.put(ChefProperties.CHEF_VALIDATOR_CREDENTIAL, validatorCredential);

// Create the connection to the Chef server
ChefContext context = ContextBuilder.newBuilder("enterprisechef") //
    .endpoint("https://api.opscode.com/organizations/" + organization) //
    .credentials(client, credential) //
    .overrides(chefConfig) //
    .buildView(ChefContext.class);
        
// Create the connection to the compute provider. Note that ssh will be used to bootstrap chef
ComputeServiceContext computeContext = ContextBuilder.newBuilder("<the compute provider name>") //
    .endpoint("<the compute endpoint>") //
    .credentials("<identity>", "<credential>") //
    .modules(ImmutableSet.<Module> of(new SshjSshClientModule())) //
    .buildView(ComputeServiceContext.class);

// Group all nodes in both Chef and the compute provider by this group
String group = "jclouds-chef-example";

// Set the recipe to install and the configuration values to override
String recipe = "apache2";
String attributes = "{\"apache\": {\"listen_ports\": \"8080\"}}";

// Check to see if the recipe you want exists
List<String> runlist = null;
Iterable< ? extends CookbookVersion> cookbookVersions =
    chefContext.getChefService().listCookbookVersions();
if (any(cookbookVersions, containsRecipe(recipe))) {
    runlist = new RunListBuilder().addRecipe(recipe).build();
}

// Update the chef service with the run list you wish to apply to all nodes in the group
// and also provide the json configuration used to customize the desired values
BootstrapConfig config = BootstrapConfig.builder().runList(runlist).attributes(attributes).build();
chefContext.getChefService().updateBootstrapConfigForGroup(group, config);

// Build the script that will bootstrap the node
Statement bootstrap = chefContext.getChefService().createBootstrapScriptForGroup(group);

// Run a node on the compute provider that bootstraps chef
Set< ? extends NodeMetadata> nodes =
    computeContext.getComputeService().createNodesInGroup(group, 1, runScript(bootstrap));

// Release resources
chefContext.close();
computeContext.close();
{% endhighlight %}

### What does the generated bootstrap script do?

The methods named `createBootstrapScriptForGroup` in java and `create-bootstrap` in clojure do all the heavy lifting required to create a valid bootstrap script for chef.  
Here is the overall process:

1. Grab the run-list associated with the group from the bootstrap databag.
2. Write a single shell script that does the following:
    1. Installs Ruby and Chef Gems using the same process as [Knife Bootstrap](http://docs.opscode.com/knife_bootstrap.html)
    2. mkdir /etc/chef
    3. Write /etc/chef/client.rb, which sets the nodename as group-ip_address Ex. hadoop-175.2.2.3 (note that the ip address comes from ohai).
    4. Write /etc/chef/validation.pem associated with the provided validator.
    5. Write /etc/chef/first-boot.json with the run-list from step 1 above.
    6. Execute chef-client -j /etc/chef/first-boot.json

## Customize how Chef is installed

There are two different ways to install Chef: Using the Opscode Omnibus installer (`1.7` only), or manually installing the Chef gems.

When using the Omnibus installer (the default option in jclouds `1.7`), the installer itself will download and install an entire Ruby and RubyGems distribution with the Chef gems preinstalled. All will be installed in an isolated directory so it does not affect any existing Ruby version. This is the preferred way to install Chef.

If you need more control on what versions of Chef are installed, you can make jclouds install the appropriate gems. The following additional properties can be configured when creating the context to customize how Chef is installed:

| *Property* | *Description* |
|------------|---------------|
| ChefProperties.USE_OMNIBUS | Boolean property to enable/disable the Omnibus installer. By default is `true`.
| ChefProperties.CHEF_VERSION | The version of the Chef gem to install. It accepts concrete versions, and also ranges like '>= 0.10.8', etc. If the property is not set, the latest available version of the gem will be installed.
| ChefProperties.CHEF_GEM_SYSTEM_VERSION | The version of Rubygems to install (if not yet installed). By default will install version `1.8.10`, to keep compatibility with previous jclouds-chef versions. However, this property can now be used to install the desired version of Rubygems.
| ChefProperties.CHEF_UPDATE_GEM_SYSTEM | Boolean property to force a `gem update --system` (or a `gem update --system <version>` if the previous property is set. By default is `false`.
| ChefProperties.CHEF_UPDATE_GEMS | Boolean property to force a general update of the existing gems. By default is `false`.

