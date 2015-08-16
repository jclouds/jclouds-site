---
layout: page
title: "JDBC: Getting Started Guide"
permalink: /guides/jdbc/
---

1. Setup your project to include jdbc
	* Get the dependency `org.apache.jclouds.labs/jdbc`.
2. Start coding

{% highlight java %}
// setup the container name used by the provider (like bucket in S3)
String containerName = "test-container";

// get a context with jdbc that offers the portable BlobStore api. Pass
// the jpa persistence unit name in the modules.
BlobStoreContext context = ContextBuilder.newBuilder("jdbc")
            .modules(ImmutableSet.<Module> of(new JpaPersistModule(jpaModuleName)))
            .build(BlobStoreContext.class);

// create a container in the default location
BlobStore blobStore = context.getBlobStore();
blobStore.createContainerInLocation(null, containerName);

// add blob
Blob blob = blobStore.newBlob("test");
blob.setPayload("test data");
blobStore.putBlob(containerName, blob);

// retrieve blob
Blob blobRetrieved = blobStore.getBlob(containerName, "test");

// delete blob
blobStore.removeBlob(containerName, "test");

//close context
context.close();
{% endhighlight %}

### Configuring the persistence unit in persistence.xml

The JDBC Blobstore uses the standard jpa configuration file `persistence.xml`. It must be placed
in `resources/META-INF`. Here is an example of `persistence.xml`:

```
<?xml version="1.0" encoding="UTF-8" ?>
<persistence xmlns="http://java.sun.com/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://java.sun.com/xml/ns/persistence http://java.sun.com/xml/ns/persistence/persistence_1_0.xsd"
             version="1.0">
  <persistence-unit name="jclouds-test-hsqldb" transaction-type="RESOURCE_LOCAL">
    <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>

    <class>org.jclouds.jdbc.entity.ContainerEntity</class>
    <class>org.jclouds.jdbc.entity.BlobEntity</class>
    <class>org.jclouds.jdbc.entity.ChunkEntity</class>
    <class>org.jclouds.jdbc.entity.PayloadEntity</class>
    <exclude-unlisted-classes>true</exclude-unlisted-classes>

    <properties>
      <property name="hibernate.dialect" value="org.hibernate.dialect.HSQLDialect" />
      <property name="hibernate.connection.driver_class" value="org.hsqldb.jdbcDriver" />
      <!-- Hsqldb must be set to multiversion concurrency control to run the tests correctly -->
      <property name="hibernate.connection.url" value="jdbc:hsqldb:file:target/testdb;shutdown=true;sql.enforce_strict_size=true;hsqldb.tx=mvcc" />
      <property name="hibernate.connection.user" value="sa" />
      <!-- Allow hibernate to generate our schema -->
      <property name="hibernate.hbm2ddl.auto" value="create" />
    </properties>
  </persistence-unit>
</persistence>
```

  * The persistence configuration depends on the database.
  * You must provide an object mapper. The persistence configuration also depends on the object mapper
	used.
