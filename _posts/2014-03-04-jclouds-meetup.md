---
layout: post
title: jclouds Meetup
author: <a href="https://twitter.com/everett_toews">Everett Toews</a>
comments: true
---

Last night we held a jclouds meetup at Cloudera offices in San Francisco. It was a well attended meetup and there were a number of new faces along with our more regular group of attendees. We recorded the whole thing with Google Hangouts on Air and you can get to know everyone in the first 5 minutes!

<iframe width="640" height="360" src="//www.youtube.com/embed/8nuON0zGVJI?rel=0" frameborder="0" allowfullscreen></iframe>

## Presentations

I kicked things off with an introduction to jclouds at [0:04 of the meetup](http://www.youtube.com/watch?v=8nuON0zGVJI&t=3m50s). I'll be giving this presentation at ApacheCon on April 7, 2014 and wanted to take this opportunity to practice it in front of a captive audience. You can find my presentation slides at [Introduction to Apache jclouds](http://www.slideshare.net/phymata/introduction-to-apache-jclouds).

Next up was Andrew Gaul from Maginatics with an informative presentation at [0:40 of the meetup](http://www.youtube.com/watch?v=8nuON0zGVJI&t=40m00s) on [Apache jclouds at Maginatics](http://www.slideshare.net/Maginatics/apache-jclouds-atmaginatics). I personally learned a lot from Andrew's presentation like the wide variety of differences amongst object storage providers. The engineering work that Gaul and the team from Maginatics have done around the BlobStore portable API in jclouds is impressive.

At [1:09 of the meetup](http://www.youtube.com/watch?v=8nuON0zGVJI&t=69m0s) we made a toast to Ignasi Barrera for his work in kicking off the jclouds website redesign. Thanks Ignasi! And thanks to everyone who helped make it a reality!

## Discussion

Then we had a good talk about the future of jclouds. A few interesting points came out of the discussion.

1. It's time to seriously considering dropping support for Java 6. Java 6 is officially end-of-life and has been a security bug ridden mess for Java. It's time to move on. We agreed on a rough plan of action to move forward.
    1. Reach out to users. A blog post dedicated to the topic and sending out an email and tweets to get user feedback.
    1. The last branch to have support for Java 1.6 will be a long lived branch, effectively indefinite. We will backport crucial bug fixes and do releases on the branch but no new features will be added to it.
    1. The exact timing and releases in which these things happen have yet to be decided on.
1. There was concern expressed by the Maginatics team over the performance impact of the RestAnnotationProcessor for BlobStore intensive work.
    1. In his presentation, Gaul mentioned that Maginatics had discovered that the overhead of reflection call in the RestAnnotationProcessor were causing what should have been I/O intensive work to also be CPU bound.
    1. The Maginatics team was interested in experimenting with alternatives to the RestAnnotationProcessor.
    1. This experimentation could be achieved by supporting a new BlobStore provider or altering a seldom used BlobStore provider with a new way of making the HTTP calls.
1. There was also some interest in creating a compatibility matrix of what features cloud providers offer and what subset of those features jclouds supported.
    1. Andrew Gaul offered to create such a matrix for BlobStore providers.
    1. Andrew Bayer offered to create such a matrix for ComputeService providers.

## Next

Next up, you can find jclouds at SXSW Interactive at the [Cloud Portability Workshop with Multi-Cloud Toolkits](https://sup.sxsw.com/schedule/IAP17712). You can also find us at ApacheCon in the [Introduction to Apache jclouds](http://apacheconnorthamerica2014.sched.org/event/50669b4904135c2ee7c755b923120ab3), [Taming the Cloud Database with Apache jclouds](http://apacheconnorthamerica2014.sched.org/event/7a27f693d6c64f946568eb3ee4fd6354), and [Enabling Walkup Contributions to Your Project Documentation](http://apacheconnorthamerica2014.sched.org/event/8032b496d174c581fbf8f43dd3526e1e) sessions. Hope to see you there!

## Conclusion

Thanks to Cloudera for hosting the meetup and supplying the food and drinks. Join the [jclouds community](/community/) or sign up at the [jclouds meetup](http://www.meetup.com/jclouds/) to get automatic notifications for our next meetup.
