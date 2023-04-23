# {{ ansible_managed }}

{% for source in chrony_sources %}
{{ source }}
{% endfor %}
