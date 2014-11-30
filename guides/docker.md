---
layout: page
title: "Docker: Getting Started Guide"
permalink: /guides/docker/
---

jclouds-docker is a local cloud provider modelled on [docker](http://www.docker.io). Similar to other jclouds supported
providers, it supports the same portable abstractions offered by jclouds.

![jclouds docker architecture](/img/jclouds-docker.png)

In order to mimic the behavior of the nodes that jclouds is able to manage, we need to make the Docker containers similar to any other VM.
Fortunately, to have that is not much work: the only prerequisite is that the node needs to be ssh’able. 
This involves [dockerizing an SSH daemon service](https://docs.docker.com/examples/running_ssh_service/).

### Give it a try!

* Install [Docker](http://docs.docker.com/installation/)
* Ensure you are using a recent JDK 7
* Setup your project to include `docker`
	* Get the dependency `org.apache.jclouds.labs/docker` using jclouds [Installation](/start/install).
* Start coding

{% highlight java %}
// get a context with docker that offers the portable ComputeService api
ComputeServiceContext context = ContextBuilder.newBuilder("docker")
                      .credentials(email, password)
                      .modules(ImmutableSet.<Module> of(new Log4JLoggingModule(),
                                                        new SshjSshClientModule()))
                      .buildView(ComputeServiceContext.class);
ComputeService client = context.getComputeService();

String sshableImageId = "your-sshable-image-id"; // this can be obtained using `docker images --no-trunc` command
Template template = client.templateBuilder().imageId(sshableImageId).build();

// run a couple nodes accessible via group container
Set<? extends NodeMetadata> nodes = client.runNodesInGroup("container", 2, template);

// release resources
context.close();
{% endhighlight %}

As for any other jclouds API, this code will create for you 2 nodes in the group `container` using the provided template.
The only (big) difference is that jclouds-docker will spin up 2 docker containers for you, instead of being 2 plain-old virtual machines, as it generally happens for the other cloud providers.
