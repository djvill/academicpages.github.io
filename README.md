# Dan's notes

## A lot of stuff is built from other stuff.


### Example 1: Publications page

Take the publications page: https://academicpages.github.io/publications/.
That's built off `publications.md`, as you'd expect, which is within `_pages/` (the nicer URL comes from a YAML field: `permalink: /publications/`).
In turn, `publications.md` is mostly just [Liquid](https://shopify.github.io/liquid/) tags.
The main content comes from this Liquid block:

```
{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
```

The Liquid variable `site.publications` is an array: the `.md` files in `_publications/`.
These files are mostly a YAML header defining tags like `title` and `venue`.
The file `archive-single.html`, which is in `_includes/`, is a template that pulls info from each respective element of `site.publications` and fills in variables;
for example (simplified):

```
{% if post.collection == 'publications' %}
  <p>Published in <i>{{ post.venue }}</i>, {{ post.date | default: "1900-01-01" | date: "%Y" }} </p>
{% endif %}
```

But! The `.md` files are themselves generated---from `markdown_generator/publications.tsv` by `markdown_generator/publications.ipynb`.
(There's another Jupyter notebook in that folder that promises to convert BibTeX files to `publications.tsv`.)
Presumably I could do this via an R script too.

So to review:

- https://academicpages.github.io/publications/, generated by GH Pages from
	- `_pages/publications.md`, which gets data from
		- `_includes/archive-single.html` to format data that comes from
		- `_publications/**.md`, which is generated by
			- `markdown_generator/publications.ipynb` and
			- `markdown_generator/publications.tsv`, which is presumably supplied by-hand


### Example 2: Stylesheets

The main CSS stylesheet is `assets/css/main.css`, but it doesn't actually exist in the repo; 
it's built on-the-fly from `assets/css/main.scss` with [SASS](https://sass-lang.com/).
`main.scss`, in turn, is built from a whole ton of [SASS partials](https://sass-lang.com/guide#topic-4) that are in `_sass/`.


## Slow slow slow

It regularly takes > 10 seconds to rebuild the site with _every_ modification.
That definitely doesn't work for my super-incremental workflow.
I suspect that that's partially thanks to all the SASS templates, and the fact that it uses the Ruby SASS compiler that was [deprecated in 2019 for being too slow](https://sass-lang.com/ruby-sass).
There's also just a bunch of bells and whistles I don't need.


## Good templates

Claire Duvallet's [homepage](https://cduvallet.github.io/) ([repo](https://github.com/cduvallet/cduvallet.github.io)) is a fork that is continually updated, and is itself highly forked.

I also like Jeremy Calder's [projects page](http://jeremy-calder.squarespace.com/projects).


## Repo contents

See docs for [Jekyll](https://jekyllrb.com/docs/), [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/docs/configuration/).

Any file or folder that starts with `_` won't be user-visible.
But they can create pages that **are** user-visible;
for example, `_publications/2009-10-01-paper-title-number-1.md` eventually turns into https://academicpages.github.io/publication/2009-10-01-paper-title-number-1 (thanks to the `permalink` YAML parameter), and its data gets used to build https://academicpages.github.io/publications/.

\*: Added by me

### Site metadata

- _config.yml: Main config file. Editing this file while serving locally (i.e., with `bundle exec jekyll serve`) won't change the site.


### Site data

- _bibliography/\*: Output bibliography data that forms the input for jekyll-scholar
- _data/: Custom data to insert elsewhere in the site, which "allows you to avoid repetition in your templates and to set site specific options without changing \_config.yml" (https://jekyllrb.com/docs/datafiles/). Use `site.data` to access in Liquid templates; for example, data in file `_data/lab-members.yml` can be used in `{% for member in site.data.lab-members %}`. Can be YAML, JSON, CSV, or TSV.
	- comments/: Blog comments?
	- authors.yml: Not sure
	- navigation.yml: Top navbar links
	- ui-text.yml: Link labels w/ translations (e.g., "Powered by")
- Also the `defaults:` key in _config.yml (https://jekyllrb.com/docs/configuration/front-matter-defaults/)


#### Data manipulation

- _data-manip/\*\*:
	- publications/: Convert Zotero's output (BibTeX file and PDFs) to something more usable (bibfiles in `_bibliography/`, PDFs and public-facing bibfile in `pubs/`)
	- talkmap.py, talkmap.ipynb: Both versions of the same script, which scrapes location data from _talks/ files and makes a map.


### Site formatting/layout

- _includes/: Bits of reusable code in HTML and (extensionless) Liquid files, which can be used over and over in different pages. Insert code into pages with `{% include <filename> %}` (https://jekyllrb.com/docs/includes/).
- _layouts/: From [Jekyll docs](https://jekyllrb.com/docs/layouts/): "Layouts are templates that wrap around your content. They allow you to have the source code for your template in one place so you don’t have to repeat things like your navigation and footer on every page." In other words, they format user-visible pages. To use, specify (e.g.) `layout: talk` in the page's YAML header; this will inject any code below the header into that layout's `{{ content }}` tag. These layouts rely heavily on code in _includes/.
- _sass/: SASS stylesheets


### Individual pages

- _pages/: Single user-visible pages as. Either Markdown (no Liquid) or HTML (Liquid allowed). Make sure to include `permalink` in YAML header, otherwise the page won't be built at the right URL. Converted to HTML on build. 
- talkmap/: Map of talks


### Collections of pages

Written as Markdown files with YAML headers.
Parameters in headers are used to help format the pages, and can also be variables.
For example, `_teaching/2014-spring-teaching-1.md`'s variable `collection: teaching` is used by `archive-single.html` to format the venue, and `type: "Undergraduate course"` is part of what's displayed on the page;
these parameters are also used by `_pages/teaching.html` to format text and display info.

- _portfolio/
- _posts/
- _publications/
- _talks/
- _teaching/


### Static files

- _plugins/: Needed for jekyll-scholar (https://github.com/inukshuk/jekyll-scholar#usage)
- files/
- images/
- assets/
- pubs/\*\*
- favicon.ico\*\*


### Computational guts

- .gitignore
- node_modules/: Node.JS modules
- banner.js
- Gemfile, Gemfile.lock: For Ruby gems
- package.json, package-lock.json: Minimal Mistakes package info


### Info for site coders

- CHANGELOG.md, CONTRIBUTING.md, README.md, LICENSE


### Other

- _site/: Built by Jekyll when serving the site, it's the actually-visible part. Not version-controlled by Git.
- Scratchpads/


# Original repo README

A Github Pages template for academic websites. This was forked (then detached) by [Stuart Geiger](https://github.com/staeiou) from the [Minimal Mistakes Jekyll Theme](https://mmistakes.github.io/minimal-mistakes/), which is © 2016 Michael Rose and released under the MIT License. See LICENSE.md.

I think I've got things running smoothly and fixed some major bugs, but feel free to file issues or make pull requests if you want to improve the generic template / theme.

### Note: if you are using this repo and now get a notification about a security vulnerability, delete the Gemfile.lock file. 

# Instructions

1. Register a GitHub account if you don't have one and confirm your e-mail (required!)
1. Fork [this repository](https://github.com/academicpages/academicpages.github.io) by clicking the "fork" button in the top right. 
1. Go to the repository's settings (rightmost item in the tabs that start with "Code", should be below "Unwatch"). Rename the repository "[your GitHub username].github.io", which will also be your website's URL.
1. Set site-wide configuration and create content & metadata (see below -- also see [this set of diffs](http:/archive.is/3TPas) showing what files were changed to set up [an example site](https://getorg-testacct.github.io) for a user with the username "getorg-testacct")
1. Upload any files (like PDFs, .zip files, etc.) to the files/ directory. They will appear at https://[your GitHub username].github.io/files/example.pdf.  
1. Check status by going to the repository settings, in the "GitHub pages" section
1. (Optional) Use the Jupyter notebooks or python scripts in the `markdown_generator` folder to generate markdown files for publications and talks from a TSV file.

See more info at https://academicpages.github.io/

## To run locally (not on GitHub Pages, to serve on your own computer)

1. Clone the repository and made updates as detailed above
1. Make sure you have ruby-dev, bundler, and nodejs installed: `sudo apt install ruby-dev ruby-bundler nodejs`
1. Run `bundle clean` to clean up the directory (no need to run `--force`)
1. Run `bundle install` to install ruby dependencies. If you get errors, delete Gemfile.lock and try again.
1. Run `bundle exec jekyll liveserve` to generate the HTML and serve it from `localhost:4000` the local server will automatically rebuild and refresh the pages on change.

# Changelog -- bugfixes and enhancements

There is one logistical issue with a ready-to-fork template theme like academic pages that makes it a little tricky to get bug fixes and updates to the core theme. If you fork this repository, customize it, then pull again, you'll probably get merge conflicts. If you want to save your various .yml configuration files and markdown files, you can delete the repository and fork it again. Or you can manually patch. 

To support this, all changes to the underlying code appear as a closed issue with the tag 'code change' -- get the list [here](https://github.com/academicpages/academicpages.github.io/issues?q=is%3Aclosed%20is%3Aissue%20label%3A%22code%20change%22%20). Each issue thread includes a comment linking to the single commit or a diff across multiple commits, so those with forked repositories can easily identify what they need to patch.
