---
layout: archive
title: "Curriculum Vitae"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
scholar:
  style: _bibliography/Unified-Stylesheet_DV-noyear.csl
---

<!-- Page-wide TODO -->
<!--
- "Sticky" headings (remain at top desipite scroll), up to heading 2
-->

{% include base_path %}

<details open markdown="block">
  <summary style="cursor: pointer;">
    Table of contents
  </summary>
1. TOC
{:toc}
</details>

<!-- TODO: Only down to heading level 2 -->

## Education

{% assign degrees = site.data.cv.education | where_exp: "item", "item.degree" %}
{% assign experiences = site.data.cv.education | where_exp: "item", "item.experience" %}

<table id="educ-degrees" class="cv-table">
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

<!--
{%- capture exp -%}
{%- for item in experiences -%}
{{ item.location | state_abbr }} ({{ item.date }}){% unless forloop.last %}; {% endunless %}
{%- endfor -%}
{%- endcapture -%}

{{ experiences[0].experience }}: {{ exp }}
-->

## Academic positions

{% assign acad_pos = site.data.cv.academic-positions %}

<table id="acad-pos" class="cv-table">
{% for item in acad_pos %}
<tr id="acad-pos-{{ item.key }}">
<td>{{ item.startdate | date: "%Y" }}&ndash;{% if item.enddate == "present" %}{{ item.enddate }}{% else %}{{ item.enddate | date: "%Y" }}{% endif %}</td>
<td>
<p><b>{{ item.title }}</b></p>
<p>{{ item.department }}; {{ item.university }}</p>
</td>
</tr>
{% endfor %}
</table>

## Research

<!-- TODO -->
<!-- 
- Standardize year column widths across sections (probably just CSS on .cv-table.cite-table)
- Remove repeated years
- Remove NA from cites (Open Methods, works in progress, comm gap)
- Add tooltips to author asterisks
- Add tooltips for authnotes
- Make literal URLs links
-->

### Works in progress

{% assign pubs = site.data.all-pubs | where: "heading", "Works in progress" %}
{% include cv-research-section.liquid publications=pubs %}


### Peer-reviewed publications

{% assign pubs = site.data.all-pubs | where: "heading", "Peer-reviewed publications" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


### Open research tools

{% assign pubs = site.data.all-pubs | where: "heading", "Open research tools" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


### Publications in edited volumes

{% assign pubs = site.data.all-pubs | where: "heading", "Publications in edited volumes" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


### Publications in conference proceedings

{% assign pubs = site.data.all-pubs | where: "heading", "Publications in conference proceedings" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


### Book reviews

{% assign pubs = site.data.all-pubs | where: "heading", "Book reviews" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


## Honors and awards

<!-- TODO -->
<!--
- Add commas to dollar amounts above $999
-->

{% assign honors_pitt = site.data.cv.honors-awards | where: "location", "University of Pittsburgh" %}
{% assign honors_ucd = site.data.cv.honors-awards | where: "location", "University of California, Davis" %}

#### University of Pittsburgh

{% for honor in honors_pitt %}
- **{{ honor.honor }}:** {{ honor.description }}
{%- if honor.exclusivity -%}&#32;[{{ honor.exclusivity }}]{%- endif -%}
. {{ honor.startdate }}--{{ honor.enddate }}.
{%- if honor.amount -%}&#32;${{ honor.amount | remove: "$" }}.{%- endif -%}
{% endfor %}

#### University of California, Davis (graduate school)

{% for honor in honors_ucd %}
- **{{ honor.honor }}:** {{ honor.description }}
{%- if honor.exclusivity -%}&#32;[{{ honor.exclusivity }}]{%- endif -%}
.&#32;
{%- if honor.startdate and honor.enddate -%} {{ honor.startdate }}--{{ honor.enddate }}.
{%- else if honor.date -%} {{ honor.date }}.
{%- endif -%}
{%- if honor.amount -%}&#32;${{ honor.amount | remove: "$" }}.{%- endif -%}
{% endfor %}


## Teaching


## Graduate mentorship


## Professional service


## Press


## Skills


## Professional society memberships


## References

