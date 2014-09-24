---
author: <a href="http://gaul.org/">Andrew Gaul</a>
comments: true
date: 2014-09-23 14:00:00+00:00
layout: post
slug: google-summer-of-code-2014-results
title: Google Summer of Code 2014 results
---

Google Summer of Code 2014 has concluded and both Apache jclouds students have successfully completed their projects, [Amazon Glacier](http://jclouds.apache.org/guides/glacier/) and [Google Cloud Storage](https://github.com/jclouds/jclouds-labs-google/tree/master/google-cloud-storage) support.

<!--more-->

[Roman Coedo](https://github.com/rcoedo) implemented [Amazon Glacier](http://aws.amazon.com/glacier/) support.  Implementation of this provider presented challenges due to its long retrieval times and archive storage semantics.  jclouds 1.8.0 includes Glacier support.

[Bhathiya Supun](https://github.com/hsbhathiya) implemented [Google Cloud Storage](https://cloud.google.com/storage/) support.  This provider has long been requested by the community and completes jclouds support for all major object stores.  jclouds 1.8.1 will include GCS support.

It was my pleasure to mentor both students this summer and look forward to working with Roman and Bhathiya in the future.  Special thanks to [Andrew Phillips](https://github.com/demobox) and [Ignasi Barrera](https://github.com/nacx) who helped with code reviews and troubleshooting and to Google for running the Summer of Code.  We hope to participate next year!
