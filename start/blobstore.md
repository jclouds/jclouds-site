---
layout: page
title: BlobStore Guide
permalink: /start/blobstore/
---

The BlobStore API is a portable means of managing key-value storage providers such as Microsoft
Azure Blob Service, Amazon S3, or OpenStack Object Storage. It offers a synchronous API to your data.

Our APIs are dramatically simplified from the providers, yet still offer enough sophistication to
perform most work in a portable manner.

Like other components in jclouds, you always have means to gain access to the provider-specific
interface if you need functionality that is not available in our abstraction.

## Features  
---  

### Location Aware

Our location API helps you to portably identify a container within context, such as "Americas" or "Europe".

We use the same model across the [ComputeGuide](/start/compute/) which allows you to facilitate collocation of processing and data.

### Integration with non-Java Clients

Using our `BlobRequestSigner`, you can portably generate HTTP requests that can be passed to
external systems for execution or processing. Use cases include JavaScript client-side loading, and
curl based processing on the bash prompt. Be creative!

### Transient Provider

Our **_in-memory_** provider allows you to test your storage code without credentials or a credit card!

### Filesystem Provider

Our **_filesystem_** provider allows you to use the same API when persisting to disk, memory, or a
remote `BlobStore`.


## Supported Providers
---
jclouds supports a wide range of blobstore providers that can be used equally in any `BlobStore`.

Please refer to the [Supported BlobStore Providers](/guides/providers/#blobstore-providers) page for
more information.


## Concepts
---
A **_blobstore_** is a key-value storage service, such as Amazon S3, where your account exists, and
where you can create containers and blobs. A **_container_** is a namespace for your data, and you
can have many of them. Inside your container, you store data as a **_blob_** referenced by a name. In all
blobstores, the combination of your account, container, and blob relates directly to an HTTP URL.

Here are some key points about blobstores:

* Globally addressable
* Key/value data storage with metadata
* Accessed via HTTP
* Provisioned on demand through an API
* Unlimited scaling
* Most are billed on a usage basis

### Container

A **_container_** is a namespace for your objects.

Depending on the service, the scope can be **_global_**, **_region_**, **_account_**, or **_sub-account_**
scoped. For example, in Amazon S3, containers are called **_buckets_**, and they must be uniquely named such
that no-one else in the world conflicts.

Everything in a BlobStore is stored in a **_container_**, which is an HTTP accessible location
(similar to a website) referenced by a URL.

For example, using Amazon S3, creating a container named `jclouds` would be referenced as
`http://jclouds.s3.amazonaws.com`.  Storing a photo with the key `mymug.jpg`, will be accessible
through `http://jclouds.s3.amazonaws.com/mymug.jpg`

In other blobstores, the naming convention of the container is less strict. All blobstores allow you
to list your containers and also the contents within them. These contents can either be **_blobs_**,
**_folders_**, or a **_virtual path_**.

### Blob

A **_blob_** is unstructured data that is stored in a container.

Some blobstores refer to them as **_objects_**, **_blobs_**, or **_files_**.  You access a blob in a
container by a text key, which often relates directly to the HTTP URL used to manipulate it.  Blobs
can be zero length or larger, with some providers limiting blobs to a maximum size, and others not
restricting at all.

Finally, blobs can have metadata in the form of text key-value pairs you can store alongside the
data. When a blob is container in a folder, its name is either relative to that folder, or its full
path.

### Folder

A **_folder_** is a subcontainer and can contain blobs or other folders.

The names of items in a folder are `basenames`. Blob names incorporate folders via a path separator
`"/"` and is similar to accessing a file in a typical filesystem.

### Virtual Path

A **_virtual path_** can either be a marker file or a prefix.

In either case, they are purely used to give the appearance of a hierarchical structure in a flat
blobstore. When you perform a list at a virtual path, the blob names returned are absolute paths.

### Access Control

By default, every item you put into a container is _private_, if you are interested in giving access
to others, you will have to explicitly configure that. Exposing public containers is provider-specific.

### Limitations

Each blobstore has its own limitations. Please see the provider guides for blobstore-specific 
limitations and tips.

## Usage
---

### Connecting to a BlobStore

A connection to a `BlobStore` in jclouds is called a `BlobStoreContext`. It is thread-safe and
should be reused for multiple requests to the service.

A `BlobStoreContext` associates an identity for a provider to a set of network connections.

At a minimum, you need to specify an _identity_ and _credential_ when creating a `BlobStoreContext`.
In the case of Amazon S3, your identity is the **Access Key ID** and credential is the **Secret
Access Key**.

Once you have this information, connecting to your `BlobStore` service is easy:


{% highlight java %}
BlobStoreContext context = ContextBuilder.newBuilder("aws-s3")
                  .credentials(identity, credential)
                  .buildView(BlobStoreContext.class);
{% endhighlight %}

This will give you a connection to the blobstore, and if it is remote, it will be SSL unless
unsupported by the provider. Everything you access from this context will use the same credentials.

### Disconnecting

When you are finished with a `BlobStoreContext`, you should close it accordingly:

{% highlight java %}
context.close();
{% endhighlight %}

There are many options available for creating a `Context`.  Please see the
[ContextBuilder](http://javadocs.jclouds.cloudbees.net/org/jclouds/ContextBuilder.html) Javadocs for
a detailed description.


### BlobStore API
<!-- TODO The difference between BlobStore/Introduction -->

Here is an example of the synchronous `BlobStore` interface:

{% highlight java %}
// Initialize the BlobStoreContext
context = ContextBuilder.newBuilder("aws-s3")
             .credentials(accesskeyid, secretaccesskey)
             .buildView(BlobStoreContext.class);

// Access the BlobStore
blobStore = context.getBlobStore();

// Create a Container
blobStore.createContainerInLocation(null, "mycontainer");

// Create a Blob
ByteSource payload = ByteSource.wrap("blob-content".getBytes(Charsets.UTF_8));
blob = blobStore.blobBuilder("test") // you can use folders via blobBuilder(folderName + "/sushi.jpg")
    .payload(payload)
    .contentLength(payload.size())
    .build();

// Upload the Blob
blobStore.putBlob(containerName, blob);

// Don't forget to close the context when you're done!
context.close()
{% endhighlight %}

#### Creating a Container  
If you don't already have a container, you will need to create one.

First, get a `BlobStore` from your context:

{% highlight java %}
BlobStore blobstore = context.getBlobStore();
{% endhighlight %}

Location is a region, provider, or another scope in which a container can be created to ensure data
locality. If you don't have a location concern, pass `null` to accept the default.

{% highlight java %}
boolean created = blobStore.createContainerInLocation(null, container);
if (created) {
   // the container didn't exist, but does now
} else {
   // the container already existed
}
{% endhighlight %}

### Multipart Upload

Providers may implement multipart upload for large or very large files. Here's an example of multipart
upload, using `aws-s3` provider, which allows [uploading files as large as
5TB](http://docs.amazonwebservices.com/AmazonS3/latest/dev/index.html?qfacts.html).

{% highlight java %}
import static org.jclouds.blobstore.options.PutOptions.Builder.multipart;

// Initialize the BlobStoreContext
context = ContextBuilder.newBuilder("aws-s3")
                 .credentials(accesskeyid, secretaccesskey)
                 .buildView(BlobStoreContext.class);

// Access the BlobStore
BlobStore blobStore = context.getBlobStore();

// Create a Container
blobStore.createContainerInLocation(null, "mycontainer");

// Create a Blob
ByteSource payload = Files.asByteSource(new File(fileName));
Blob blob = blobStore.blobBuilder(objectName)
    .payload(payload)
    .contentDisposition(objectName)
    .contentLength(payload.size())
    .contentType(MediaType.OCTET_STREAM.toString())
    .build();

// Upload the Blob 
String eTag = blobStore.putBlob(containerName, blob, multipart());

// Don't forget to close the context when you're done!
context.close()
{% endhighlight %}

### Logging

Please refer to the [logging](http://jclouds.apache.org/reference/logging/) page for more information
on how to configure logging in jclouds.


# Clojure  
---  

<!-- TODO: update this to latest clojure -->
The above examples show how to use the `BlobStore` API in Java. The same API can be used from Clojure!

## Setup
  * Install [leiningen](http://leiningen.org/)
  * Execute `lein new mygroup/myproject`
   
In the `myproject` directory, edit the `project.clj` to include the following:

{% highlight clojure %}
(defproject mygroup/myproject "1.0.0"
  :description "FIXME: write description"
  :dependencies [[org.clojure/clojure "1.3.0"]
                 [org.clojure/core.incubator "0.1.0"]
                 [org.clojure/tools.logging "0.2.3"]
                 [org.apache.jclouds/jclouds-allcompute "1.7.1"]]
  :repositories {"apache-snapshots" "https://repository.apache.org/content/repositories/snapshots"})
{% endhighlight %}

Execute `lein deps` to download the specified dependencies.


## Usage

Execute `lein repl` to get a repl, then paste the following or write your own code. Clearly, you
need to substitute your accounts and keys below.

{% highlight clojure %}
(use 'org.jclouds.blobstore2)

(def *blobstore* (blobstore "azureblob" account encodedkey))
(create-container *blobstore* "mycontainer")
(put-blob *blobstore* "mycontainer" (blob "test" :payload "testdata"))
{% endhighlight %}
  

# Advanced Concepts
---

This section covers advanced topics typically needed by developers of clouds.

## Signing Requests

### Java Example
{% highlight java %}

HttpRequest request = context.getSigner().signGetBlob("adriansmovies", "sushi.avi");
{% endhighlight%}

### Clojure Example
{% highlight clojure %}

(let [request (sign-blob-request "adriansmovies" "sushi.avi" {:method :get})])

{% endhighlight %}

## Multipart Upload Strategies

There are two multipart upload implementations of that jclouds employs for uploading objects to a
BlobStore service. Amazon S3 and OpenStack Swift both support these strategies.

###_ParallelMultipartUploadStrategy_
By default, jclouds uses a parallel upload strategy that will split an object up in to individual
parts and upload them in parallel to the BlobStore. There are two configurable properties for this strategy:

  `jclouds.mpu.parallel.degree` the number of threads (default is 4)
  `jclouds.mpu.parts.size` the size of a part (default is 32MB)

###_SequentialMultipartUploadStrategy_
Similar to the parallel strategy, the sequential strategy will split an object up into parts and upload
them to the BlobStore sequentially.

## Large Lists

A listing is a set of metadata about items in a _container_.  It is normally associated with a
single GET request against your container.

Large lists are those who exceed the default or maximum list size of the blob store.  In S3, Azure,
and Swift, this is 1000, 5000, and 10000 respectively.  Upon hitting this threshold, you need to
continue the list in another HTTP request.

For continued iteration of large lists, the BlobStore `list()` API returns a `PageSet` that allows
to access the next marker identifier. The `getNextMarker()` method will either return the next
marker, or `null` if the page size is less than the maximum.

The marker object can then be used as input to `afterMarker` in the `ListContainerOptions` class.


### Marker Files

Marker files allow you to establish presence of directories in a flat key-value store. Azure, S3,
and OpenStack Swift all use pseudo-directories, but in a different ways.  For example, some tools
look for a content type of `application/directory`, while others look for naming patterns such as a
trailing slash `/` or the suffix `_$folder$`.

In jclouds, we attempt to detect whether a blob is pretending to be a directory, and if so, type it
as `StorageType.RELATIVE_PATH`. Then, in a `list()` command, it will appear as a normal directory.
The two strategies responsible for this are `IfDirectoryReturnNameStrategy` and `MkdirStrategy`.

The challenge with this approach is that  there are multiple ways to suggest presence of a
directory. For example, it is entirely possible that _both_ the trailing slash `/` and `_$folder$`
suffixes exist. For this reason, a simple remove, or `rmdir` will not work, as it may be the case that
there are multiple tokens relating to the same directory.

For this reason, we have a `DeleteDirectoryStrategy` strategy. The default version of this used for
flat trees removes all known types of directory markers.

## Content Disposition

You may be using jclouds to upload some photos to the cloud, show thumbnails of them to the user via
a website, and allow to download the original image.

When the user clicks on the thumbnail, a download dialog appears. To control the name of the file in
the "Save As" dialog, you must set [Content
Disposition](http://www.iana.org/assignments/cont-disp/cont-disp.xhtml).  Here's how you can do it with
the BlobStore API:

{% highlight java %}
ByteSource payload = Files.asByteSource(new File("sushi.jpg"));
Blob blob = context.getBlobStore().blobBuilder("sushi.jpg")
    .payload(payload)  // or InputStream
    .contentDisposition("attachment; filename=sushi.jpg")
    .contentMD5(payload.hash(Hashing.md5()).asBytes())
    .contentLength(payload.size())
    .contentType(MediaType.JPEG.toString())
    .build();
{% endhighlight %}

## Return Null on Not Found

All APIs, provider-specific or abstraction, must return null when an object is requested, but not
found. Throwing exceptions is only appropriate when there is a state problem. For example, requesting
an object from a container that does not exist is a state problem, and should throw an exception.

## Large File Support
<!--update to use ByteSource -->

### Uploading 
As long as you use either `InputStream` or `File` as the payload for your blob, you should
be fine. Note that in S3, you must calculate the length ahead of time, since it doesn't support
chunked encoding.

Our integration tests ensure that we don't rebuffer in memory on upload: 
[testUploadBigFile](http://github.com/jclouds/jclouds/blob/master/core/src/test/java/org/jclouds/http/BaseHttpCommandExecutorServiceIntegrationTest.java).

This is verified against all of our HTTP clients, conceding that it isn't going to help limited
environments such as Google App Engine.

### Downloading

A blob you've downloaded via `blobstore.getBlob()` can be accessed via
`blob.getPayload().getInput()` or `blob.getPayload().writeTo(outputStream)`.  Since these are
streaming, you shouldn't have a problem with memory unless you rebuffer the payload.
