---
author: <a href="https://github.com/ivanlomba">Iván Lomba</a>
comments: true
date: 2016-08-22 07:00:00+00:00
layout: post
slug: arbitrary-cpu-ram
title: Arbitrary CPU and RAM supported in the ComputeService
quicknews: Read about our <strong>GSoC 2016 project</strong>! Support for arbitrary CPU and RAM has been added to the Compute abstraction
---

As part of a [Google Summer of Code](https://developers.google.com/open-source/gsoc/) project has been added a feature to allow users to set manually specific values of CPU and RAM.
<!--more-->

The previous Compute Service abstraction assumed that all providers had hardware profiles, a list of profiles describing different cpu, memory and disk configurations that can be used to run a node. Some providers, such as [ProfitBricks](https://www.profitbricks.com/) or [ElasticHosts](https://www.elastichosts.com/), do not have the hardware profiles concept and the previous implementation provides a fixed configuration with a fixed (hardcoded) list just to conform the interface. The new implementation allows to use custom hardwares or both (when supported) hardware profiles and custom hardwares.

Note that using hardware profiles provides hardware optimization or in some cases cheaper pricings.

### How to use custom hardwares
There are two ways to use a custom hardware: setting in on the hardwareId or specifying cores and ram values using minCores and minRam.

#### Custom hardware using hardwareId

When user set the hardwareId, the Template Builder first check if the provided hardwareId corresponds with an existent hardware profile, and if it corresponds, it would use it. In case that the provided hardwareId do not match with an existing hardware profile and have the automatic hardwareId format, it would use a custom hardware.

To set CPU and RAM with hardwareId you have to set the hardwareId using template builder with the format:

`automatic:cores=2;ram=4096`

as you can see in the following example:

{% highlight Java %}
Template template = templateBuilder
    .hardwareId("automatic:cores=2;ram=4096")
    .build()
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}

In providers that configure disks based on the volume information provided in the hardware profile you have to specify also the disk size, like in ProfitBricks, where disk is mandatory, you need to specify it to use custom machines:

{% highlight Java %}
Template template = templateBuilder
    .hardwareId("automatic:cores=2;ram=4096;disk=100")
    .build()
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}

To help building the automatic hardwareId, the `automaticHardwareIdSpecBuilder` utility creates an automaticHardwareId string with the provided values of cores, ram and optional disk size.

{% highlight Java %}
Template template = templateBuilder
    .hardwareId(AutomaticHardwareIdSpec
        .automaticHardwareIdSpecBuilder(2.0, 4096, Optional.<Float>absent())
        .toString()))
    .build()
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}



#### Custom hardware using minCores and minRam

When user set minCores and minRam, first the template builder checks if a hardware profile matches with the provided minRam and minCores. If not, the templateBuilder will use the automatic hardware.

To set up custom hardwares using minRam and minCores you have to set them using template builder.

{% highlight Java %}
Template template = templateBuilder
    .minCores(2)
    .minRam(4096)
    .build();
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}

In providers that need to specify disk, set also minDisk:

{% highlight Java %}
Template template = templateBuilder
    .minCores(2)
    .minRam(4096)
    .minDisk(100)
    .build();
compute.createNodesInGroup("jclouds", 1, template);
{% endhighlight %}

### Providers supported
There are several providers that support arbitrary values of CPU and RAM like Docker, ElasticHosts, Google Compute Engine, etc. The first available providers supported by the new feature are:

* [Google Compute Engine](https://cloud.google.com/compute/)
* [ProfitBricks](https://www.profitbricks.com/)

To configure the new feature in other providers add a bind() to the `ArbitraryCpuRamTemplateBuilderImpl` class at the provider's context module:

{% highlight Java %}
bind(TemplateBuilderImpl.class).to(ArbitraryCpuRamTemplateBuilderImpl.class);
{% endhighlight %}

Also is necessary to modify the function that transform a node from the provider model to the portable model of jclouds, to include the new automatic hardwareId (if apply).

### Further development

* **Support other providers**: add support for other providers such as [ElasticHosts](https://www.elastichosts.com/) and [Docker](https://www.docker.com/).
* **Improve AutomaticHardwareSpec**: improve the AutomaticHardwareSpec with specific parsers for every parameter in order to support more custom parameters and some fields, like bootDisk and durable (part of volumes), that are currently hardcoded to true.
* **Usage examples of the new features**: create examples of the new features in the jclouds-examples repo.
* **Custom TemplateBuilderImpl for ProfitBricks**: add a custom implementation of the TemplateBuilderImpl to fail early when users don't set the minDisk.


### Special thanks

Special thanks to [Ignasi Barrera](https://github.com/nacx) for all the help, [Andrew Phillips](https://github.com/demobox) for code reviews and the rest of jclouds comunity.

Of course, also thanks to Google for running GSoC.
