---
layout: page
title: Report a Bug
permalink: /reference/report-a-bug/
---

If you run into a bug while using jclouds, we encourage you to report it. To help us help you, please collect as much of the following information as possible. If you can't get everything, that's okay. Send what you can.

Bugs can be reported in [JIRA](https://issues.apache.org/jira/browse/JCLOUDS) or via the [jclouds user mailing list](/community/).

When possible, try to include the following information in the bug report:

<table class="table table-striped table-hover">
<tbody>
<tr>
    <td><strong>jclouds version</strong></td>
    <td>The version of jclouds can be found in the name of the JAR files you are using in your application or the pom.xml file of your application if you're using Maven.<br/>
        <em>e.g. 1.7.1</em></td>
</tr>
<tr>
    <td><strong>Provider or API version</strong></td>
    <td>If you are using a private cloud such as OpenStack, CloudStack, or vCloud, you might be able to report the Cloud and API version.<br/>
        <em>e.g. Cloud and API Version: OpenStack Havana, Cinder API v2</em></td>
</tr>
<tr>
    <td><strong>Operating system</strong></td>
    <td>The Operating System Version you're using.<br/>
        <em>e.g. Operating System Version: Mac OS X 10.7.5</em></td>
</tr>
<tr>
    <td><strong>Java version</strong></td>
    <td>The Java version you're using.<br/>
        <em>e.g. "1.7.0_51"</em></td>
</tr>
</tbody>
</table>

<div class="alert alert-danger">
<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
Please remember to <strong>remove all credentials and other sensitive information</strong> from anything you share!
</div>

## <a id="logs"></a>Collecting logs

Sending us the stack trace from the exception is helpful but often the root cause of the problem can be revealed by examining what's being sent over the wire. Please read [Logging](/reference/logging/) to install, configure, and enable logging.

If you are reporting the bug in JIRA, you can simply attach the `jclouds-wire.log` and other logs to the issue. If you are sending the report to the user mailing list, please put the logs into a [gist](https://gist.github.com/) or [pastie](http://pastie.org/) and include the link in the email.

## <a id="code"></a>Providing relevant code

If you can isolate the problem within a single Java file, send us that file so we can attempt to immediately reproduce the error. If you can't isolate the problem, send us as large a code snippet as possible around the problem code.

If you are reporting the bug in JIRA, you can simply attach the code to the issue. If you are sending the report to the user mailing list, please put the code into a [gist](https://gist.github.com/) or [pastie](http://pastie.org/) and include the link in the email.

## <a id="doc"></a>Reporting documentation issues

If you find a bug in the documentation, you can report that via JIRA or the user mailing list too. However it is quite easy to fix the documentation (this website) and we encourage you to do so by reading [How to Contribute Documentation](https://cwiki.apache.org/confluence/display/JCLOUDS/How+to+Contribute+Documentation).
