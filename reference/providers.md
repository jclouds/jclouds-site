---
layout: page
title: Providers
permalink: /reference/providers/
---

The following is the list of providers that are supported by the jclouds API.

1. [ComputeService](#compute)
    1. [ComputeService Providers](#compute-providers)
    1. [ComputeService APIs](#compute-apis)
1. [BlobStore](#blobstore)
    1. [BlobStore Providers](#blobstore-providers)
    1. [BlobStore APIs](#blobstore-apis)
1. [LoadBalancer](#loadbalancer) (Beta)
    1. [LoadBalancer Providers](#loadbalancer-providers)

## <a id="compute"></a>ComputeService
### <a id="compute-providers"></a>Providers

The Maven Group ID for all supported providers below is [org.apache.jclouds.provider](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.provider). Providers in labs (denoted by \*) are under [org.apache.jclouds.labs](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.labs).

<table class="table table-striped table-hover">
    <thead>
        <tr>
            <th>Provider</th>
            <th>Maven Artifact ID</th>
            <th>ISO 3166 Codes</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><a href="/guides/aws/">AWS</a></td>
            <td>aws-ec2</td>
            <td>US-VA,US-CA,US-OR,BR-SP,IE,DE-HE,SG,AU-NSW,IN-MH,JP-13,KR-11</td>
        </tr>
        <tr>
            <td><a href="/guides/cloudsigma/">CloudSigma HI</a>*</td>
            <td>cloudsigma2-hnl</td>
            <td>US-HI</td>
        </tr>
        <tr>
            <td><a href="/guides/cloudsigma/">CloudSigma NV</a>*</td>
            <td>cloudsigma2-lvs</td>
            <td>US-NV</td>
        </tr>
        <tr>
            <td><a href="/guides/cloudsigma/">CloudSigma FL</a>*</td>
            <td>cloudsigma2-mia</td>
            <td>US-FL</td>
        </tr>
        <tr>
            <td><a href="/guides/cloudsigma/">CloudSigma CA</a>*</td>
            <td>cloudsigma2-sjc</td>
            <td>US-CA</td>
        </tr>
        <tr>
            <td><a href="/guides/cloudsigma/">CloudSigma DC</a>*</td>
            <td>cloudsigma2-wdc</td>
            <td>US-DC</td>
        </tr>
        <tr>
            <td><a href="/guides/cloudsigma/">CloudSigma CH</a>*</td>
            <td>cloudsigma2-zrh</td>
            <td>CH-ZH</td>
        </tr>
        <tr>
            <td>DigitalOcean</td>
            <td>digitalocean</td>
            <td></td>
        </tr>
        <tr>
            <td><a href="/guides/dimensiondata/">Dimension Data</a>*</td>
            <td>dimensiondata-cloudcontrol</td>
            <td></td>
        </tr>
        <tr>
            <td>ElasticHosts HK</td>
            <td>elastichosts-hkg-e</td>
            <td>HK</td>
        </tr>
        <tr>
            <td>ElasticHosts GB</td>
            <td>elastichosts-lon-b</td>
            <td>GB-LND</td>
        </tr>
        <tr>
            <td>ElasticHosts GB</td>
            <td>elastichosts-lon-p</td>
            <td>GB-LND</td>
        </tr>
        <tr>
            <td>ElasticHosts US</td>
            <td>elastichosts-lax-p</td>
            <td>US-CA</td>
        </tr>
        <tr>
            <td>ElasticHosts US</td>
            <td>elastichosts-sat-p</td>
            <td>US-TX</td>
        </tr>
        <tr>
            <td>ElasticHosts US</td>
            <td>elastichosts-sjc-c</td>
            <td>US-CA</td>
        </tr>
        <tr>
            <td>ElasticHosts AU</td>
            <td>elastichosts-syd-v</td>
            <td>AW-NSW</td>
        </tr>
        <tr>
            <td>ElasticHosts US</td>
            <td>elastichosts-tor-p</td>
            <td>CA-ON</td>
        </tr>
        <tr>
            <td>Go2Cloud</td>
            <td>go2cloud-jhb1</td>
            <td>ZA-GP</td>
        </tr>
        <tr>
            <td><a href="/guides/go-grid/">GoGrid</a></td>
            <td>gogrid</td>
            <td>US-CA,US-VA,NL-NH</td>
        </tr>
        <tr>
            <td><a href="/guides/google/">Google Compute Engine</a></td>
            <td>google-compute-engine</td>
            <td></td>
        </tr>
        <tr>
            <td>Microsoft Azure*</td>
            <td>azurecompute</td>
            <td>AU-NSW,AU-VICBR,HK,IE,JP-11,JP-27,NL,US-CA,US-IA,US_IL,US-VA,US_TX,SG</td>
        </tr>
        <tr>
            <td>Microsoft Azure Resource Manager*</td>
            <td>azurecompute-arm</td>
            <td>AU-NSW,AU-VIC,BR,CA-ON,CA-QC,CN-BJ,CN-SH,HK,IE,IN-GA,IN_MH,IN-TN,JP-11,JP-27,NL,US-CA,US-IA,US_IL,US-VA,US_TX,SG</td>
        </tr>
        <tr>
            <td>OpenHosting</td>
            <td>openhosting-east1</td>
            <td>US-VA</td>
        </tr>
        <tr>
            <td><a href="/guides/profitbricks/">ProfitBricks</a></td>
            <td>profitbricks</td>
            <td>DE-BW,DE-HE,US-NV</td>
        </tr>
        <tr>
            <td>Packet*</td>
            <td>packet</td>
            <td>US-CA,US-NJ,NL,JP</td>
        </tr>
        <tr>
            <td>ProfitBricks REST v3*</td>
            <td>profitbricks-rest</td>
            <td>DE-BW,DE-HE,US-NV</td>
        </tr>
        <tr>
            <td>Rackspace UK (<a href="http://www.rackspace.com/knowledge_center/article/next-gen-vs-first-gen-feature-comparison">First Gen</a>)</td>
            <td>cloudservers-uk</td>
            <td>GB-SLG</td>
        </tr>
        <tr>
            <td>Rackspace US (<a href="http://www.rackspace.com/knowledge_center/article/next-gen-vs-first-gen-feature-comparison">First Gen</a>)</td>
            <td>cloudservers-us</td>
            <td>US-IL,US-TX</td>
        </tr>
        <tr>
            <td><a href="/guides/rackspace/">Rackspace UK</a> (<a href="http://www.rackspace.com/knowledge_center/article/next-gen-vs-first-gen-feature-comparison">Next Gen</a>)</td>
            <td>rackspace-cloudservers-uk</td>
            <td>GB-SLG</td>
        </tr>
        <tr>
            <td><a href="/guides/rackspace/">Rackspace US</a> (<a href="http://www.rackspace.com/knowledge_center/article/next-gen-vs-first-gen-feature-comparison">Next Gen</a>)</td>
            <td>rackspace-cloudservers-us</td>
            <td>US-IL,US-TX</td>
        </tr>
        <tr>
            <td>ServerLove</td>
            <td>serverlove-z1-man</td>
            <td>GB-MAN</td>
        </tr>
        <tr>
            <td>SkaliCloud</td>
            <td>skalicloud-sdg-my</td>
            <td>MY-10</td>
        </tr>
        <tr>
            <td><a href="/guides/softlayer/">SoftLayer</a></td>
            <td>softlayer</td>
            <td>SG,US-CA,US-TX,US-VA,US-WA,<p/>NL,HK,NSFTW-IL,AU,CA-ON,GB</td>
        </tr>
    </tbody>
</table>

### <a id="compute-apis"></a>APIs

You can also set the context property `[Artifact ID].endpoint` to use the following APIs for your private cloud.

The Maven Group ID for all supported APIs below is [org.apache.jclouds.api](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.api). Providers in labs (denoted by \*) are under [org.apache.jclouds.labs](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.labs).

<table class="table table-striped table-hover">
    <thead>
        <tr>
            <th>Provider</th>
            <th>Maven Artifact ID</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Abiquo*</td>
            <td>abiquo</td>
        </tr>
        <tr>
            <td><a href="/guides/aws-ec2/">AWS</a></td>
            <td>ec2</td>
        </tr>
        <tr>
            <td>Bring Your Own Node</td>
            <td>byon</td>
        </tr>
        <tr>
            <td><a href="/guides/cloudsigma/">CloudSigma</a>*</td>
            <td>cloudsigma</td>
        </tr>
        <tr>
            <td>CloudStack</td>
            <td>cloudstack</td>
        </tr>
        <tr>
            <td><a href="/guides/docker/">Docker</a></td>
            <td>docker</td>
        </tr>
        <tr>
            <td>ElasticStack</td>
            <td>elasticstack</td>
        </tr>
        <tr>
            <td><a href="/guides/openstack/">OpenStack</a></td>
            <td>openstack-nova</td>
        </tr>
        <tr>
            <td>Vagrant*</td>
            <td>vagrant</td>
        </tr>
    </tbody>
</table>


## <a id="blobstore"></a>BlobStore
### <a id="blobstore-providers"></a>Providers

The Maven Group ID for all supported providers below is [org.apache.jclouds.provider](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.provider). Providers in labs (denoted by \*) are under [org.apache.jclouds.labs](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.labs).

<table class="table table-striped table-hover">
    <thead>
        <tr>
            <th>Provider</th>
            <th>Maven Artifact ID</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><a href="/guides/aws-s3/">AWS</a></td>
            <td>aws-s3</td>
        </tr>
        <tr>
            <td>Backblaze B2</td>
            <td>b2</td>
        </tr>
        <tr>
            <td>Google Cloud Storage</td>
            <td>google-cloud-storage</td>
        </tr>
        <tr>
            <td>Microsoft</td>
            <td>azureblob</td>
        </tr>
        <tr>
            <td><a href="/guides/rackspace/">Rackspace US</a></td>
            <td>rackspace-cloudfiles-us</td>
        </tr>
        <tr>
            <td><a href="/guides/rackspace/">Rackspace UK</a></td>
            <td>rackspace-cloudfiles-uk</td>
        </tr>
    </tbody>
</table>

### <a id="blobstore-apis"></a>APIs

You can also set the context property `[Artifact ID].endpoint` to use the following APIs for your private cloud.

The Maven Group ID for all supported APIs below is [org.apache.jclouds.api](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.api). Providers in labs (denoted by \*) are under [org.apache.jclouds.labs](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.labs).

<table class="table table-striped table-hover">
    <thead>
        <tr>
            <th>Provider</th>
            <th>Maven Artifact ID</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Atmos</td>
            <td>atmos</td>
        </tr>
        <tr>
            <td>S3</td>
            <td>s3</td>
        </tr>
        <tr>
            <td>Filesystem</td>
            <td>filesystem</td>
        </tr>
        <tr>
            <td><a href="/guides/openstack/">OpenStack</a></td>
            <td>swift</td>
        </tr>
    </tbody>
</table>

## <a id="loadbalancer"></a>LoadBalancer (Beta)
### <a id="loadbalancer-providers"></a>Providers

The Maven Group ID for all supported providers below is [org.apache.jclouds.provider](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.provider). Providers in labs (denoted by \*) are under [org.apache.jclouds.labs](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.jclouds.labs).

<table class="table table-striped table-hover">
    <thead>
        <tr>
            <th>Provider</th>
            <th>Maven Artifact ID</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><a href="/guides/aws/">AWS Elastic Load Balancer</a>*</td>
            <td>aws-elb</td>
        </tr>
        <tr>
            <td><a href="/guides/rackspace/">Rackspace UK</a></td>
            <td>rackspace-cloudloadbalancers-uk</td>
        </tr>
        <tr>
            <td><a href="/guides/rackspace/">Rackspace US</a></td>
            <td>rackspace-cloudloadbalancers-us</td>
        </tr>
    </tbody>
</table>
