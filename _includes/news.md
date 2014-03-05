{% assign newspresent = false %}
<div id="quicknews" class="alert alert-info">
{% for page in site.pages %}
    {% if page.quicknew %}
    {% if newspresent == true %}<br/>{% endif %}
    {% assign newspresent = true %}
    <a class="text-primary" href="{{ page.permalink }}"><strong>{{ page.title }}</strong>: {{ page.quicknew }}</a>
    {% endif %}
{% endfor %}
</div>
{% if newspresent == false %}
<script type="text/javascript">
    $('#quicknews').hide();
</script>
{% endif %}
