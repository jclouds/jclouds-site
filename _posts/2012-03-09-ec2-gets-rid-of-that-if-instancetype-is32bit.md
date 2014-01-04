---
layout: post
title: EC2 gets rid of that "if instancetype.is32bit" statement
author: Adrian Cole
comments: true
tumblr_url: http://jclouds.tumblr.com/post/19009661244/ec2-gets-rid-of-that-if-instancetype-is32bit
---

2 weeks ago, I started a bit of a rant on EC2's 32bit-only vms.

>*32bit vms make me angry*

>*hey, #ec2! deprecate m1.small for a new 64bit t1.small #cloud*

>*@jeffbar any chance of a future blog titled: m1.small is dead. long live t1.small!*

This occurred on freenode and twitter, mainly due to pent-up frustration, set off by needing a separate if statement in our JDK installer just to accommodate the lame 32bit m1.small instance.

I'm not (quite) self-absorbed enough to think Jeff Barr's latest announcement was in response to this. Even if I was, my mention never reached him! (my tweet went to the less interested jeffbar, yeah the only one 'r' one). Nevertheless, our prayers were answered, and reported by the real [@jeffbar](https://twitter.com/#!/jeffbarr):

>*[EC2 Updates: New Medium Instance, 64-bit Ubiquity, SSH Client](http://aws.typepad.com/aws/2012/03/ec2-updates-new-instance-64-bit-bit-ubiquity-ssh-client.html)*

Here's the jist: Instead of deprecating the old m1.small, they updated it to support 64bit images (and also the c1.medium). To sweeten the deal, they also threw in a new m1.medium size, which is roughly a 2x m1.small.

Now, all users producing images don't have to make a 32bit option just cause they need more ram than t1.micro. In fact, many will probably drop the maintenance entirely.

For jclouds users, action is simple, update to version 1.3.2 which removes the restriction of m1.small's only being able to use 32bit AMIs.
