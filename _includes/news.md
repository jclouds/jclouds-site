{% assign newspresent = false %}

<div id="quicknews" class="alert alert-info">
{% for page in site.pages %}{% if page.quicknews %}{% assign newspresent = true %}
    <p>
    <span class="label label-{% if page.labelstyle %}{{ page.labelstyle }}{% else %}primary{% endif %}">{{ page.label }}</span>
    <a class="quicknew text-primary" href="{{ page.permalink }}">{{ page.quicknews }}</a>
    </p>
{% endif %}{% endfor %}
{% for post in site.posts %}{% if post.quicknews %}{% assign newspresent = true %}
    <p>
    <span class="label label-{% if page.labelstyle %}{{ page.labelstyle }}{% else %}primary{% endif %}">{{ page.label }}</span>
    <a class="quicknew text-primary" href="{{ post.url }}">{{ post.quicknews }}</a>
    </p>
{% endif %}{% endfor %}
</div>

{% if newspresent == false %}
<script type="text/javascript">
    $('#quicknews').hide();
</script>
{% endif %}
