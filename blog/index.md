---
layout: jclouds
title: Blog & News
---

# Blog & News

{% for post in site.posts %}
## <a href="{{ post.url }}">{{ post.title }}</a>
*{{ post.date | date: "%-d %B %Y"}}, by {{ post.author }}*
{{ post.excerpt }}
{% endfor %}
