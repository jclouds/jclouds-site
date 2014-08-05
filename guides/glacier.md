---
layout: page
title: "Glacier: In Depth"
permalink: /guides/glacier/
---

Amazon Glacier is a cold storage service which can be used as an alternative to traditional storage services for data archiving and backup. It is optimized for data infrequently accessed and offers nice scalability and an extremely low cost. There is no limit to the amount of data you can store, and you only pay for what you use.

The main downside of Glacier is its very long retrieval time. Once you've requested your data, it will take several hours until it's ready to be downloaded.

You can find more information in the Amazon Glacier [documentation](https://aws.amazon.com/glacier/).

Terminology
-----------
The following resources are defined by the Glacier API:

##### Vault
A vault defines a container in a region for a collection of archives and is associated to an account. Each vault can store an unlimited amount of archives but cannot contain other vaults.

##### Archive
Archives are the basic storage unit in Glacier. An archive has an unique identifier and an optional description. The identifier is both set and returned by Amazon Glacier when the archive is uploaded.

**Note**: When uploading a blob to a Glacier provider using the BlobStore interface, the blob name will be ignored. When retrieving a blob using the BlobStore interface, the blob name will be the archive identifier.

##### Multipart upload
In order to upload an archive in parts, we need to create a new multipart upload. Each multipart upload is associated with a single vault.

##### Job
A Job represents a request we send to Glacier to read data. When a job finishes it produces an output
that we can read. The estimated time to finish a job is ~4 hours.

There are two different kinds of jobs:
* Inventory retrieval: Used to list the archives within a vault.
* Archive retrieval: Used to read an archive.

**Note**: Inventories are updated only once every 24 hours. The archive list in an inventory may be outdated.

There are also two different ways to discover if a job has finished: by polling or setting a Notification-Configuration to the vault. This Notification-Configuration will notify Amazon SNS when is the data ready to be retrieved. Only one Notification-Configuration can be set per Vault.

At the time of writing only polling is supported by the jclouds Glacier provider.

BlobStore View
--------------
Due to the Glacier's nature, many of the BlobStore view methods are will be very slow. Many Glacier users maintain their own application index of Glacier archives to this. In addition, you can interrupt long-running Glacier operations by sending an interrupt to the thread and catching the resulting exception.

Using Glacier
-------------
These snippets are taken from the jclouds-examples repository, you will find the full code in it.

### Basic usage of the BlobStore view
{% highlight java %}
// get a context with amazon that offers the portable BlobStore API
BlobStoreContext context = ContextBuilder.newBuilder("glacier")
      .credentials(accesskeyid, secretkey)
      .buildView(BlobStoreContext.class);

try {
   // create a container in the default location
   BlobStore blobstore = context.getBlobStore();
   blobstore.createContainerInLocation(null, containerName);

   // add blob
   ByteSource payload = ByteSource.wrap("data".getBytes(Charsets.UTF_8));
   Blob blob = blobstore.blobBuilder("ignored") // The blob name is ignored in Glacier
         .payload(payload)
         .contentLength(payload.size())
         .build();
   String key = blobstore.putBlob(containerName, blob);
} finally {
   context.close();
}
{% endhighlight %}

### Basic usage of the provider API
{% highlight java %}
// get a context with amazon that offers the portable BlobStore API
BlobStoreContext context = ContextBuilder.newBuilder("glacier")
      .credentials(accesskeyid, secretkey)
      .buildView(BlobStoreContext.class);

try {
   // When you need access to glacier specific features,
   // use the provider context
   GlacierClient client = context.unwrapApi(GlacierClient.class);

   JobRequest archiveRetrievalJobRequest = ArchiveRetrievalJobRequest.builder()
         .archiveId(key)
         .description("retrieval job")
         .build();
   String jobId = client.initiateJob(containerName, archiveRetrievalJobRequest);

   // Retrieve output when the job is done
   Payload payload = client.getJobOutput(containerName, jobId);
   byte[] data = ByteStreams2.toByteArrayAndClose(payload.openStream());
} finally {
   context.close();
}
{% endhighlight %}

Known Issues
------------
* Only the us-east-1 region is supported by our signer.  [JCLOUDS_659](https://issues.apache.org/jira/browse/JCLOUDS-659)
* Due to an issue with java 6 only archives up to 1GB are supported using uploadArchive operation. You still can download bigger files using multipart upload. This will be fixed in jclouds 2.0.

Resources
---------
* [Glacier information](https://aws.amazon.com/glacier/)
* [API reference](http://docs.aws.amazon.com/amazonglacier/latest/dev/amazon-glacier-api.html)
* [About Inventories](http://aws.amazon.com/glacier/faqs/#data-inventories)
* [Job options](http://docs.aws.amazon.com/amazonglacier/latest/dev/api-initiate-job-post.html)
