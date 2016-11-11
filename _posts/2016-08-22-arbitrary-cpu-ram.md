---
author: <a href="https://github.com/ivanlomba">Iván Lomba</a>
comments: true
date: 2016-08-22 07:00:00+00:00
layout: post
slug: arbitrary-cpu-ram
title: Adding support for arbitrary CPU and RAM to ComputeService
---

Through of a [Google Summer of Code](https://developers.google.com/open-source/gsoc/) project, Apache jclouds now allows users to manually set arbitrary values for desired CPU and RAM of compute instances.
<!--more-->

The previous ComputeService abstraction assumed that all providers have hardware profiles: a list of "specs" of available CPU, memory and disk configurations that can be used when creating a node. Some providers, such as [ProfitBricks](https://www.profitbricks.com/) or [ElasticHosts](https://www.elastichosts.com/), do not have the concept of hardware profiles; the previous implementation provided a fixed configuration with a fixed, hard-coded list of "fake" profiles just to conform to the Apache jclouds interface. The new implementation allows  users to create nodes with arbitrary settings or, where supported, to choose between provided hardware profiles or custom settings.

Note that pre-defined hardware profiles can sometimes be more performant and/or cheaper than custom settings.

### How to create a node with custom settings
There are two ways to use the new feature: setting an appropriate value for the `hardwareId` property, or specifying the desired number of cores, amount of RAM and, in some cases, disk size via the `minCores`, `minRam` and `minDisk` properties.

#### Creating a node with custom settings using the `hardwareId`

If the user sets the `hardwareId` property, the Apache jclouds [TemplateBuilder](/reference/javadoc/1.9.x/org/jclouds/compute/domain/TemplateBuilder.html) implementation first checks if the provided ID matches an existing hardware profile. If so, the matching profile is used.

If the provided ID does _not_ match an existing hardware profile, and it has the format of an "automatic" hardware ID, Apache jclouds will create a node with custom settings.

To set CPU and RAM via an automatic hardware ID, [set the  `hardwareId`](https://jclouds.apache.org/reference/javadoc/1.9.x/org/jclouds/compute/domain/TemplateBuilder.html#hardwareId\(java.lang.String\)) property on your `TemplateBuilder` to a value with the format:

```
automatic:cores=<num-cores>;ram=<memory-size>
```

For example:

{% highlight Java %}
Template template = templateBuilder
    .hardwareId("automatic:cores=2;ram=4096")
    .build()
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}

For providers such as ProfitBricks that configure disks based on the volume information provided in the hardware profile, you will also need to specify the desired disk size:

{% highlight Java %}
Template template = templateBuilder
    .hardwareId("automatic:cores=2;ram=4096;disk=100")
    .build()
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}

You can use the `AutomaticHardwareIdSpec` to more easily construct automatic hardware IDs:

{% highlight Java %}
Template template = templateBuilder
    .hardwareId(AutomaticHardwareIdSpec
        .automaticHardwareIdSpecBuilder(2.0, 4096, Optional.<Float>absent())
        .toString()))
    .build()
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}

#### Creating a node with custom settings using `minCores`, `minRam` and `minDisk`

If the user sets the `minCores`, `minRam` and, where required, `minDisk` properties, Apache jclouds first checks if a hardware profile matching the desired values exists. If no such profile can be found, Apache jclouds will create a node with custom settings.

Set the appropriate properties on your `TemplateBuilder`:

{% highlight Java %}
Template template = templateBuilder
    .minCores(2)
    .minRam(4096)
    .build();
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}

For providers that need a disk size specification also set `minDisk`:

{% highlight Java %}
Template template = templateBuilder
    .minCores(2)
    .minRam(4096)
    .minDisk(100)
    .build();
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}

### Supported providers

There are several providers that support arbitrary values of CPU and RAM, such as Docker, ElasticHosts, Google Compute Engine, etc. The first available Apache jclouds providers to support this feature are:

* [Google Compute Engine](/guides/google/)
* [ProfitBricks](/guides/profitbricks/)

To add this feature to other providers, bind the  `ArbitraryCpuRamTemplateBuilderImpl` class in the provider's context module:

{% highlight Java %}
bind(TemplateBuilderImpl.class).to(ArbitraryCpuRamTemplateBuilderImpl.class);
{% endhighlight %}

You will also need to modify the function that converts the representation of a node from the provider's model to the jclouds representation, so that the required automatic `hardwareId` is included.

### Further development

* **Support other providers**: add support for other providers such as [ElasticHosts](https://www.elastichosts.com/) or [Docker](https://www.docker.com/).
* **Improve `AutomaticHardwareSpec`**: add parsers to `AutomaticHardwareSpec` for further properties that can have arbitrary values, such as `bootDisk` or `durable` (part of a volume description).
* **Usage examples of the new features**: add examples of using the new features to the [jclouds-examples](http://github.com/jclouds/jclouds-examples) repo.
* **Custom `TemplateBuilderImpl` for ProfitBricks**: add a custom implementation of the `TemplateBuilderImpl` that fails fast if `minDisk` is not set.

### Special thanks

Special thanks to [Ignasi Barrera](https://github.com/nacx) for all the help, [Andrew Phillips](https://github.com/demobox) for code reviews and the rest of jclouds comunity.

Of course, thanks also to Google for running GSoC.
