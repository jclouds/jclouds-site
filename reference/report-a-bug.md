---
layout: page
title: Report a Bug
permalink: /reference/report-a-bug/
---

If you run into a bug while using jclouds, we encourage you to report it. To help us help you, please collect as much of the following information as possible. If you can't get everything, that's okay. Send what you can.

Bugs can be reported in [JIRA](https://issues.apache.org/jira/browse/JCLOUDS) or via the [jclouds user mailing list](/community/).

1. [jclouds Version](#jclouds-version)
1. [Cloud and API Version](#cloud-version)
1. [Operating System Version](#os-version)
1. [Java Version](#java-version)
1. [Logs](#logs)
1. [Code](#code)
1. [Documentation](#doc)

## <a id="jclouds-version"></a>jclouds Version

The version of jclouds can be found in the name of the JAR files you are using in your application or the pom.xml file of your application if you're using Maven.

e.g. jclouds Version: 1.7.1

## <a id="cloud-version"></a>Cloud and API Version

If you are using a private cloud such as OpenStack, CloudStack, or vCloud, you might be able to report the Cloud and API version.

e.g. Cloud and API Version: OpenStack Havana, Cinder API v2

## <a id="os-version"></a>Operating System Version

The Operating System Version you're using.

e.g. Operating System Version: Mac OS X 10.7.5

## <a id="java-version"></a>Java Version

The Java Version you're using.

e.g. java version "1.7.0_51"

## <a id="logs"></a>Logs

Sending us the stack trace from the exception is helpful but often the root cause of the problem can be revealed by examining what's being sent over the wire. Please read [Logging](/reference/logging/) to install, configure, and enable logging.

If you are reporting the bug in JIRA, you can simply attach the jclouds-wire.log and other logs to the issue. If you are sending the report to the user mailing list, please put the logs into a [gist](https://gist.github.com/) or [pastie](http://pastie.org/) and include the link in the email.

## <a id="code"></a>Code

If you can isolate the problem within a single Java file, send us that file so we can attempt to immediately reproduce the error. If you can't isolate the problem, send us as large a code snippet as possible around the problem code.

If you are reporting the bug in JIRA, you can simply attach the code to the issue. If you are sending the report to the user mailing list, please put the code into a [gist](https://gist.github.com/) or [pastie](http://pastie.org/) and include the link in the email.

Please remember to __remove all credentials and other sensitive information__ from anything you share!

## <a id="doc"></a>Documentation

If you find a bug in the documentation, you can report that via JIRA or the user mailing list too. However it is quite easy to fix the documentation (this website) and we encourage you to do so by reading [How to Contribute Documentation](https://wiki.apache.org/jclouds/How%20to%20Contribute%20Documentation).
