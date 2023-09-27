---
layout: archive
title: "Curriculum Vitae"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

## Education

<table id="educ-degrees">

{% assign degrees = site.data.cv.education | where_exp: "item", "item.degree" %}
{% assign experiences = site.data.cv.education | where_exp: "item", "item.experience" %}

{% for item in degrees %}
<tr>
<td>{{ item.date | date: "%Y" }}</td>
<td>

<p><b>{{ item.degree }} in {{ item.concentration | join: " & " | capitalize_all }}</b></p>

<p>{{ item.university }} ({{ item.location | state_abbr }})</p>

<p>{{ item.thesis.type | capitalize_all }}: <em>{{ item.thesis.title }}</em> 
{%- if item.thesis.award -%}
&nbsp;[{{ item.thesis.award | capitalize_all }}]
{%- endif -%}</p>

<p>{% if item.committee.members %}
Committee: {{ item.committee.advisor }} (advisor), {{ item.committee.members | join: ", " }}
	{% else %}
Thesis advisor: {{ item.committee.advisor }}
{% endif %}</p>

{%- if item.awards -%}
<p>{{ item.awards | join: ", " | markdownify }}</p>
{%- endif -%}
</td>
</tr>
{% endfor %}
</table>

{% capture exp %}
{%- for item in experiences -%}
{{ item.location | state_abbr }} ({{ item.date }}){% unless forloop.last %}; {% endunless %}
{%- endfor -%}
{% endcapture %}

{{ experiences[0].experience }}: {{ exp }}


## Academic positions


## Research


## Honors and awards


## Teaching


## Graduate mentorship


## Professional service


## Press


## Skills


## Professional society memberships


## References

