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
<p>{{ item.department }}</p>
<p>{{ item.university }}</p>
</td>
</tr>
{% endfor %}
</table>

## Research

<!-- TODO -->
<!-- 
- Remove repeated years
- Add tooltips to author asterisks
- Add tooltips for authnotes
- Make literal URLs links
- Fix dangling unicode in abstract (in "Modeling social meanings of phonetic variation amid variable co-occurrence: A machine-learning approach")
-->



\* = graduate student co-author

\*\* = undergraduate co-author


### Works in progress

{% assign pubs = site.data.all-pubs | where: "heading", "Works in progress" %}
{% include cv-research-section.liquid publications=pubs %}


### Peer-reviewed publications

{% assign pubs = site.data.all-pubs | where: "heading", "Peer-reviewed publications" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


### Open research tools

{% assign pubs = site.data.all-pubs | where: "heading", "Open research tools" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


### Publications in conference proceedings

{% assign pubs = site.data.all-pubs | where: "heading", "Publications in conference proceedings" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


### Publications in edited volumes

{% assign pubs = site.data.all-pubs | where: "heading", "Publications in edited volumes" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


### Invited talks

{% assign invited_talks = site.data.cv.invited-talks %}

<table id="invited-talks" class="cv-table cite-table">
{% for item in invited_talks %}
<tr>
<td>{{ item.date | date: "%Y" }}</td>
<td>{{ item.title }}. {{ item.university }}: {{ item.department }}. {{ item.date | date: "%B %e" }}.</td>
</tr>
{% endfor %}
</table>


### Organized sessions

{% assign org_sessions = site.data.cv.organized-sessions %}

<table id="org-sessions" class="cv-table cite-table">
{% for item in org_sessions %}
<tr>
<td>{{ item.date | date: "%Y" }}</td>
<td>{% include cv-authorlist.liquid authorlist=item.organizer %}. {{ item.title }} {{ item.location | capitalize }}. {{ item.date | date: "%B %e" }}.</td>
</tr>
{% endfor %}
</table>


### Book reviews

{% assign pubs = site.data.all-pubs | where: "heading", "Book reviews" | reverse %}
{% include cv-research-section.liquid publications=pubs %}


### Conference presentations

{% assign conf_presentations = site.data.cv.conference-presentations %}


<table id="conf-presentations" class="cv-table cite-table">
{% for item in conf_presentations %}
<tr>
<td>{%- if item.startdate -%} {{ item.startdate | date: "%Y" }}
{%- else -%} {{ item.date | date: "%Y" }}
{%- endif -%}</td>
<td>{% include cv-authorlist.liquid authorlist=item.author %}. {{ item.title }}. {{ item.conference }}, {{ item.location }}.&#32;
{%- if item.session -%} {{ item.session | capitalize }}.&#32;{%- endif -%}
{%- if item.startdate and item.enddate -%}
{{ item.startdate | date: "%B" }} {{ item.startdate | date: "%e" }}--{{ item.enddate | date: "%e" }}
{%- else -%}
{{ item.date | date: "%B %e" }}
{%- endif -%}.</td>
</tr>
{% endfor %}
</table>

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
{%- elsif honor.date -%} {{ honor.date }}.
{%- endif -%}
{%- if honor.amount -%}&#32;${{ honor.amount | remove: "$" }}.{%- endif -%}
{% endfor %}


## Teaching

### Teaching experience


#### University of Pittsburgh

Graduate courses in **bold**; combined undergraduate/graduate courses in _italics_.

{% assign teaching_pitt = site.data.cv.teaching | where: "university", "University of Pittsburgh" %}
{% include cv-teaching-section.liquid classes=teaching_pitt rev=true %}


#### Prior to University of Pittsburgh (primary instructor unless otherwise noted)

{% assign teaching_unr = site.data.cv.teaching | where: "university", "University of Nevada, Reno" %}
{% assign teaching_ucd = site.data.cv.teaching | where: "university", "University of California, Davis" | where: "role", nil %}
{% assign teaching_dtcc = site.data.cv.teaching | where: "university", "Delaware Technical and Community College" %}
{% assign teaching_ucd_ta = site.data.cv.teaching | where: "university", "University of California, Davis" | where: "role", "teaching assistant" %}


##### University of Nevada, Reno

{% include cv-teaching-section.liquid classes=teaching_unr %}

##### University of California, Davis

{% include cv-teaching-section.liquid classes=teaching_ucd %}

##### Delaware Technical and Community College

{% include cv-teaching-section.liquid classes=teaching_dtcc %}

##### University of California, Davis (teaching assistant)

{% include cv-teaching-section.liquid classes=teaching_ucd_ta %}


### Open teaching tools

{% assign open_teaching = site.data.cv.open-teaching-tools %}

<table id="open-teaching" class="cv-table">
{% for item in open_teaching %}
<tr>
<td>{{ item.date }}</td>
<td>{{ item.title | markdownify | remove: "<p>" | remove: "</p>" | strip }}.
{%- if item.url -%}<a href="{{ item.url }}" target="_blank">{{ item.url }}</a>{%- endif -%}
</td>
</tr>
{% endfor %}
</table>


### Guest lectures

{% assign guest_lect = site.data.cv.guest-lectures %}

\* = graduate class

<table id="guest-lect" class="cv-table">
{% for item in guest_lect reversed %}
<tr>
<td>{{ item.date | date: "%Y" }}</td>
<td>"{{ item.title }}". {{ item.university }}: {{ item.course }}
{%- if item.level == "graduate" -%}*{%- endif -%}.
{{ item.date | date: "%B %e" }}.
</td>
</tr>
{% endfor %}
</table>

## Graduate mentorship

### Advising

#### University of Pittsburgh

##### PhD

- Jack Rechsteiner, 2023--present.


#### University of Canterbury

##### Masters of Linguistics

- Merten Wiltshire (co-advised with Jen Hay), _Experiences and expectations in the perception of speech_. March--September 2019.


### Committees

##### PhD dissertation committees

- Joe Patrick, _Constructing Montenegrin identity(ies) through language ideology and semiotic differentiation_. August 2022--present.
- Angela Krak, _Cross-dialectal phonetic variation and lexical encoding: Evidence from /s/ perception in Seville capital_. April 2022--August 2023.


##### PhD comprehensive paper committees

- Joe Patrick, PhD comprehensive paper 2, _Multilingual Wikipedia domains as ground for dialect variation in Serbian and Croatian_. April--June 2022.
- Dominique Branson, PhD comprehensive paper 2, _'Why isn't our word enough?': Situating raciolinguistics and critical discourse analysis for understanding Black girls' racialization in school_. April--November 2021.


### Other

- Alexus Brown, Humanities Engage Curricular Development grant (University of Pittsburgh). Supervised development of new collections-based module in Linguistic Variation and Change course; provided mentorship on teaching skills and techniques. May--November 2021.


## Professional service

### Departmental and university service

{% assign service_dept_uni = site.data.cv.service | where: "category", "departmental and university" %}

#### University of Pittsburgh

{% assign service_pitt = service_dept_uni | where: "university", "University of Pittsburgh" %}

{% for item in service_pitt %}
- **{{ item.title }}{%- if item.role -%}&#32;[{{ item.role }}]{%- endif -%}:** {{ item.description }}.
{%- if item.startdate and item.enddate -%}&#32;{{ item.startdate }}--{{ item.enddate }}.
{%- elsif item.date -%}&#32;{{ item.date }}.
{%- endif -%}
{% if item.url %}<a href="{{ item.url }}" target="_blank">{{ item.url }}</a>{% endif %}
{% endfor %}


#### University of California, Davis

{% assign service_ucd = service_dept_uni | where: "university", "University of California, Davis" %}

{% for item in service_ucd %}
- **{{ item.title }}{%- if item.role -%}&#32;[{{ item.role }}]{%- endif -%}:** {{ item.description }}.
{%- if item.startdate and item.enddate -%}&#32;{{ item.startdate }}--{{ item.enddate }}.
{%- elsif item.date -%}&#32;{{ item.date }}.
{%- endif -%}
{% if item.url %}<a href="{{ item.url }}" target="_blank">{{ item.url }}</a>{% endif %}
{% endfor %}


### Service to the profession

{% assign service_prof = site.data.cv.service | where_exp: "item", "item.category != 'departmental and university'" %}

##### Committee service

{% assign service_cmte = service_prof | where: "category", "committee" %}

{% for item in service_cmte %}
- {{ item.committee }}{%- if item.organization -%}&#32;({{ item.organization }}){%- endif -%}
{%- if item.startdate and item.enddate -%}: {{ item.startdate }}--{{ item.enddate }}.
{%- elsif item.date -%}: {{ item.date }}.
{%- endif -%}
{% endfor %}


##### Grant review

{% assign service_grant = service_prof | where: "category", "grant review" %}

{% for item in service_grant %}
- {{ item.agency }}:&#32;{%- if item.dates.first -%}{{ item.dates | join: ", " }}{%- else -%}{{ item.dates }}{%- endif -%}
{% endfor %}


##### Journal review

{% assign service_journal = service_prof | where: "category", "article review" %}

{% for item in service_journal %}
- _{{ item.journal }}_:&#32;{%- if item.dates.first -%}{{ item.dates | join: ", " }}{%- else -%}{{ item.dates }}{%- endif -%}
{% endfor %}


##### Abstract review

{% assign service_conf = service_prof | where: "category", "abstract review" %}

{% for item in service_conf %}
- {{ item.conference }}:&#32;{%- if item.dates.first -%}{{ item.dates | join: ", " }}{%- else -%}{{ item.dates }}{%- endif -%}
{% endfor %}


##### External thesis examination

{% assign service_ext_thesis = service_prof | where: "category", "external thesis examination" %}

{% for item in service_ext_thesis %}
- {{ item.university }} ({{ item.degree }}):&#32;{%- if item.dates.first -%}{{ item.dates | join: ", " }}{%- else -%}{{ item.dates }}{%- endif -%}
{% endfor %}



## Press

{% assign press = site.data.cv.press %}

<table id="press" class="cv-table">
{% for item in press reversed %}
<tr>
<td>{{ item.date | date: "%Y" }}</td>
<td>"{{ item.title }}". {{ item.venue }}, {{ item.date | date: "%B %e" }}.
{% if item.url %}<a href="{{ item.url }}" target="_blank">{{ item.url }}</a>{% endif %}
{% if item.note %}[N.B. {{ item.note }}]{% endif %}
</td>
</tr>
{% endfor %}
</table>


## Skills


## Professional society memberships


## References


<script type="module">
//Make abstract links pop open abstract
//From https://people.cs.georgetown.edu/nschneid/me.js
$(".abstract-link").click(function () {
	$(this).nextAll(".abstract").toggle();
	$(this).toggleClass("selected");
})
</script>
