---
layout: page
title: What is jclouds?
permalink: /start/what-is-jclouds/
---

Apache jclouds&reg; is an open source library that helps you get started in the cloud and utilizes your [Java](http://www.oracle.com/technetwork/java/index.html)
or [Clojure](http://clojure.org) development skills. The jclouds API gives you the freedom to use portable abstractions or cloud-specific features.

jclouds tests support of 30 cloud providers and cloud software stacks including Amazon, Azure, GoGrid, OpenStack, Rackspace, and Google.  Please see the
complete list of [jclouds supported providers](/reference/providers) that are supported by the jclouds API.

jclouds offers several API abstractions as Java and Clojure libraries. The most mature of these are BlobStore and ComputeService.

<table class="table table-striped table-hover">
<tbody>
<tr>
    <td><a href="/start/compute"><strong>ComputeService</strong></a></td>
    <td>ComputeService streamlines the task of managing instances in the cloud by enabling you to start multiple machines at once and install software on them.</td>
</tr>
<tr>
    <td><a href="/start/blobstore"><strong>BlobStore</strong></a></td>
    <td>BlobStore is a simplified and portable means of managing your key-value storage providers.  BlobStore presents you with a straightforward Map view of a container to access your data.</td>
</tr>
<tr>
    <td><strong>LoadBalancer</strong></td>
    <td>The Load Balancer abstraction provides a common interface to configure the load balancers in any cloud that supports them. Just define the load balancer and the nodes that should join it, and it will be ready for the action.</td>
</tr>
</tbody>
</table>

# Why should I use jclouds?

Programming against cloud environments can be challenging. jclouds focuses on the following areas so that you can get started in the cloud sooner.

<table class="table table-striped table-hover">
<tbody>
<tr>
    <td><span class="glyphicon glyphicon-ok green"></span></td>
    <td><strong>SIMPLE INTERFACE</strong></td>
    <td>Get started without dealing with REST-like APIs or WebServices. Instead of creating new object types, jclouds reuses concepts like maps so that the programming model is familiar. </td>
</tr>
<tr>
    <td><span class="glyphicon glyphicon-ok green"></span></td>
    <td><strong>RUNTIME PORTABILITY</strong></td>
    <td>jclouds drivers enable you to operate in restricted environments like Google App Engine. There are very few required dependencies, so jclouds is unlikely to clash with your app.</td>
</tr>
<tr>
    <td><span class="glyphicon glyphicon-ok green"></span></td>
    <td><strong>DEALS WITH WEB COMPLEXITY</strong></td>
    <td>jclouds handles issues such as transient failures and redirects that traditional network based computing introduces.</td>
</tr>
<tr>
    <td><span class="glyphicon glyphicon-ok green"></span></td>
    <td><strong>UNIT TESTABILITY</strong></td>
    <td>Write your unit tests without mocking complexity or the brittleness of remote connections. Writing tests for cloud endpoints is difficult. jclouds provides you with Stub connections that simulate a cloud without creating network connections.</td>
</tr>
<tr>
    <td><span class="glyphicon glyphicon-ok green"></span></td>
    <td><strong>PERFORMANCE</strong></td>
    <td>Customize configuration to match your performance needs. jclouds provides you with asynchronous commands, tunable http, date, and encryption modules.</td>
</tr>
<tr>
    <td><span class="glyphicon glyphicon-ok green"></span></td>
    <td><strong>LOCATION</strong></td>
    <td>jclouds provides location-aware abstractions. For example, you can get ISO-3166 codes to tell which country or province a cloud runs in.</td>
</tr>
<tr>
    <td><span class="glyphicon glyphicon-ok green"></span></td>
    <td><strong>QUALITY</strong></td>
    <td>Every provider is tested with live scenarios before each release. If the provider doesn't pass, it goes back into the sandbox.</td>
</tr>
</tbody>
</table>
