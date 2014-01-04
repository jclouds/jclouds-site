---
layout: page
title: "S3: In Depth"
permalink: /guides/aws-s3/
---

Some providers such as Google Cloud Storage and RiakCS and many private providers expose an S3-compatible interface.  Commonly, users install clones on non-https, or self-signed servers.  If you do so, make sure you set the following properties:

<pre>
jclouds.trust-all-certs=true
jclouds.relax-hostname=true
</pre>

Here are a few configuration examples of common s3 clones:

### Google Cloud Storage
You must configure your account for [interoperability](https://developers.google.com/storage/docs/interoperability) and [generate HMAC keys](https://developers.google.com/storage/docs/reference/v1/getting-startedv1#keys).  Note that you must create containers via jclouds, not the web console.  Finally set these properties:

<pre>
jclouds.provider=s3
jclouds.endpoint=https://storage.googleapis.com
jclouds.s3.virtual-host-buckets=false
jclouds.strip-expect-header=true
</pre>

### RiakCS
You must set these properties:

<pre>
jclouds.provider=s3
jclouds.endpoint=http://data.riakcs.net:8080
</pre>

### Walrus
The following properties should help use the `s3` provider on a walrus install:

<pre>
jclouds.regions=walrus
jclouds.s3.service-path=/services/Walrus
jclouds.s3.virtual-host-buckets=false
s3.endpoint=http://host:8773/services/Walrus
</pre>

