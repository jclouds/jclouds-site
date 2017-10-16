---
author: <a href="http://blog.xebialabs.com/author/aphillips/">Andrew Phillips</a>
comments: true
date: 2014-10-25 07:00:00+00:00
layout: post
slug: poole-jclouds
title: About POODLE and jclouds
---

[POODLE](http://googleonlinesecurity.blogspot.com.au/2014/10/this-poodle-bites-exploiting-ssl-30.html) is a recently discovered attack against SSLv3. If the endpoints you are communicating with do not support this version of the SSL protocol, this attack is not relevant.

<!--more-->

### How does this relate to jclouds?

In all but the three exceptional cases described below, jclouds uses the default SSL configuration inherited from the JVM. If you are communicating with endpoints that support SSLv3, you can change the SSL configuration inherited by jclouds by creating an appropriate [SSLContext](http://docs.oracle.com/javase/7/docs/api/javax/net/ssl/SSLContext.html) for [HttpsURLConnection](http://docs.oracle.com/javase/7/docs/api/javax/net/ssl/HttpsURLConnection.html#setSSLSocketFactory\(javax.net.ssl.SSLSocketFactory\)).

#### jclouds.trust-all-certs

If you are running with `jclouds.trust-all-certs=true`, jclouds will configure SSL connection settings explicitly, rather than inheriting them from the JVM. This setting is inherently not secure and should not be used if you are running in a secure environment.

#### Apache HC HTTP driver

If you are using the [Apache HC HTTP driver](https://github.com/jclouds/jclouds/blob/master/drivers/apachehc/), jclouds will not inherit the SSL configuration from the JVM. See [JCLOUDS-759](https://issues.apache.org/jira/browse/JCLOUDS-759) for details or contact the [dev list](/community/) in case of questions.

#### Azure Compute and FGCP

If you are using the [Azure Compute provider](https://github.com/jclouds/jclouds-labs/tree/master/azurecompute) or one of the [FGCP](https://github.com/jclouds/jclouds-labs/tree/jclouds-labs-1.8.1/fgcp-de) [providers](https://github.com/jclouds/jclouds-labs/tree/jclouds-labs-1.8.1/fgcp-au) in jclouds-labs, jclouds will not inherit the SSL configuration from the JVM, in order to support these providers' key authentication schemes. Please contact the [dev list](/community/) in case of questions.

#### More information

* Discussion on the potential impact of POODLE on your applications: [https://www.netmeister.org/blog/poodle.html](https://www.netmeister.org/blog/poodle.html)
* Question about Java HTTP clients and POODLE: [https://stackoverflow.com/questions/26429751/java-http-clients-and-poodle](https://stackoverflow.com/questions/26429751/java-http-clients-and-poodle)
* Umbrella jclouds JIRA issue: [JCLOUDS-753](https://issues.apache.org/jira/browse/JCLOUDS-753)
* Apache HC HTTP driver issue: [JCLOUDS-759](https://issues.apache.org/jira/browse/JCLOUDS-759)
