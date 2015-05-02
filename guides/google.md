---
layout: toc
title: "Google Cloud Platform: Getting Started Guide"
permalink: /guides/google/
---

## <a id="intro"></a>Introduction
This guide helps you to get started with [Google Cloud Platform](https://cloud.google.com/) development using jclouds.

Currently, [Google Compute Engine](https://developers.google.com/compute/) is covered. This is a [compute service](http://jclouds.apache.org/start/compute/) that allows you to run vitual machines on Google's infrastructure. There is also an implementation of the [blob store](http://jclouds.apache.org/start/blobstore/) abstraction for managing key-value storage.

Working with the Google Cloud Platform requires a project. If you do not have a project yet, you can sign up via the [Developer Console](https://console.developers.google.com/). There is a free trial availible [here](https://cloud.google.com/free-trial/).

## <a id="examples"></a>Running examples
A great starting point for using jclouds on GCE is to run the examples provided on [github](https://github.com/jclouds/jclouds-examples).

Important Setup

  * Create a project on the [Developer Console](https://console.developers.google.com/) (instruction availible [here](https://developers.google.com/console/help/#creatingdeletingprojects))
  * Go to the [Developer Console](https://console.developers.google.com/) and choose your project.
  * Enable the Google Compute Engine API under APIs & auth > APIs
  * Create a service account under APIs & auth > Credentials > Create new Client ID and download the Json key. This is described more throughly below under Authentication.

Once you have completed the setup, checkout the [jclouds-examples](https://github.com/jclouds/jclouds-examples) repository and look at either [compute-basic](https://github.com/jclouds/jclouds-examples/tree/master/compute-basics) for an example of using the compute service abstraction or [google-lb](https://github.com/jclouds/jclouds-examples/tree/master/google-lb) for an example of using the GCE api directly.

If you are having trouble feel free to [reach out](https://jclouds.apache.org/community/).

## <a id="auth"></a>Authentication
Google Cloud Platform uses OAuth2 which gives a variety of choices how to authenticate:

1. You can ask a user for consent to perform operations in their name.
2. You can create a service account and authenticate using its private key.
3. Unless configured otherwise, programs running on a GCE instance can perform operations as the project's default service account ([documentation](https://cloud.google.com/compute/docs/authentication)).

You can find all the details in [the documentation](https://developers.google.com/accounts/docs/OAuth2), in the jclouds-examples repository we focus on option 2: service accounts.

To create a new service account:

  * Go to the [Developer Console](https://console.developers.google.com/).
  * Choose your project.
  * Choose API & auth > Credentials.
  * Click "Create new Client ID".
  * Select "Service account" and click "Create Client ID".
  * Details of the new service account will be displayed.
  * Download a JSON key for a service account by clicking Generate new JSON key. JSON keys are used for authentication when running jclouds on GCE. Make a note of the service account email address - this is the identity that goes with the key.

If you are having trouble feel free to [reach out](https://jclouds.apache.org/community/).