---
layout: post
title: Catching exceptions with fewer keystrokes
author: Adrian Cole
comments: true
tags: jclouds design exception generics typeerasure
tumblr_url: http://jclouds.tumblr.com/post/107464443/catching-exceptions-with-less-keystrokes
---

Some of us hate checked exceptions, but still use them for one reason or another. A common problem we have is unnecessary exception nesting, or runtime swallowing. This often leads to the all to familiar and crufty code with a million catch blocks. jclouds has a slightly different approach that strikes a balance, allowing checked exceptions to be dealt with, but without the pain of so many lines of repetitious code.

{% highlight java %}
try {
} catch (Exception e) {
    Utils.<ApplicationException>rethrowIfRuntimeOrSameType(e);
    throw new ApplicationException("Error applying stuff", e);
}
{% endhighlight %}

This code does what it says, preventing us from unnecessarily nesting application exceptions or swallowing runtimes.

Now, this code shouldn't work, as current versions of java hava a generic type erasure problem. The reason it does work is a somewhat hackish line in the rethrowIfRuntimeOrSameType method:

{% highlight java %}
if (e instanceof RuntimeException) {
    throw (RuntimeException) e;
} else {
    try {
        throw (E) e;
    } catch (ClassCastException throwAway) {
        // using cce as there's no way to do instanceof E in current java
    }
}
{% endhighlight %}

The trick is that we try to force the exception we caught into the generic type. If that fails, we know it wasn't that type and that we should wrap, log, etc.

If nothing else, I hope you enjoy the perspective!
