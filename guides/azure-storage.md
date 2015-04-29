---
layout: page
title: "Azure Storage Service: Getting Started Guide"
permalink: /guides/azure-storage/
---

1. Sign up for an [Azure Account](http://www.microsoft.com/windowsazure/offers/)
2. Get your account and key
	* Login to the [Microsoft Azure Portal](https://manage.windowsazure.com). The [new portal](https://portal.azure.com) is in preview stage and hence instructions are not aligned with it.
	* Click 'New', 'Data Servies', 'Storage' and 'Quick Create'.
	* Enter the Storage Account Name. Make sure the account is available and then click _Create_
		* This is your Storage account name you use in jclouds.
	* Under the main Azure screen, you should see Cloud Storage and the service you setup; Click on that.
	* Click on 'Manage Access Keys' at bottom of the page and copy Primary Access Key.
		* Primary Access Key is the key you use in jclouds
3. Ensure you are using a recent JDK 6
4. Setup your project to include `azureblob`
	* Get the dependency `org.apache.jclouds.provider/azureblob` using jclouds [Installation](/start/install).
5. Setup your project to include 'guava'. Include following dependency to jclouds [Installation](/start/install). Update the version mentioned in dependency below to the latest available version.
	<dependency>
		<groupId>com.google.guava</groupId>
		<artifactId>guava</artifactId>
		<version>16.0</version>
	</dependency>
6. Start coding. Replace values in angular brackets <> with actual values.

{% highlight java %}
import org.jclouds.blobstore.*;
import org.jclouds.ContextBuilder;
import org.jclouds.blobstore.domain.*;
import org.jclouds.azureblob.*;
import com.google.common.io.*;
import java.io.*;

String storageAccountName = "<Your storage account name>";
String storageAccountKey = "<Your storage account primary access key>";
String containerName = "<Your container name>";
String blobFullyQualifiedFileName = "<Fully qualified filename>";
String blobName = "<Your blob name>";

// Get a context with amazon that offers the portable BlobStore api
BlobStoreContext context = ContextBuilder.newBuilder("azureblob")
				 .credentials(storageAccountName, storageAccountKey)
				 .buildView(BlobStoreContext.class);

// Access the BlobStore
BlobStore blobStore = context.getBlobStore();

// Create a Container
blobStore.createContainerInLocation(null, containerName);

// Create a blob. 
ByteSource payload = Files.asByteSource(new File(blobFullyQualifiedFileName));
Blob blob = context.getBlobStore().blobBuilder(blobName)
	.payload(payload)  // or InputStream
	.contentLength(payload.size())
	.build();

// Upload the Blob
blobStore.putBlob(containerName, blob);

// When you need access to azureblob-specific features, use the provider-specific context
AzureBlobClient azureBlobClient = context.unwrapApi(AzureBlobClient.class);
Object object = azureBlobClient.getBlobProperties(containerName, blobName);

System.out.println("Object: " + object);
context.close();
{% endhighlight %}
