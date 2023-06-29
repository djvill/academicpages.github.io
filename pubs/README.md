# `pubs/` folder

For data-fied info about publications.
This includes non-peer-reviewed publications (but not presentations) and publications in progress.
Data will be used for CV page, projects page, and publications page, with slightly different displays for each.
It'll also be used for an output BibTeX file that contains only published works (sans book reviews) and strips extra fields.


## How to use

### Initial setup

In Zotero, create Saved Search called `My-Pubs`:

- Search in main library
- Match all of following:
	- Creator contains Villarreal
	- Item Type is not Presentation
- Don't tick anything


### Update with new publication

Add item to Zotero (pay attention to info in [following section](#bibtex-format)).

Re-export My-Pubs saved search:

- In My-Pubs saved search, select **Export Saved Search...**
	- _Format:_ BibTeX
	- Tick _Export Files_ (nothing else)
	- _Character Encoding:_ UTF-8
- Save as `pubs/My-Pubs`


Better file names and organization:

- Run `format.sh`


## BibTeX format

The usual Zotero export, plus a few changes.

### Date codes

In addition to the usual date processing, dates can also be one of six qualitative values.
These will surface in the BibTeX `year` field.
Anything that's not a date or one of these values will yield a blank `year` field.

- `in prep`: "I'm working on this."
- `under review`: "I've submitted it."
- `revisions in prep`: "I'm working on the R&R."
- `revisions under review`: "I've submitted the R&R."
- `forthcoming`: "It's been accepted, but I don't have the final version yet."
- `in press`: "Everything has been finalized, it just hasn't come out yet."

To use these date codes with Zotero, replace the default `~/Zotero/translators/BibTeX.js` file with [this one](https://github.com/djvill/zotero-translators/blob/master/BibTeX.js) and restart Zotero.

In the future, I want to format citations on my CV to include these in the "Journal" macro (e.g., "in press at _Linguistic Variation and Change_").


### Extra fields

I've added a few extra fields for processing citations.
On the Zotero side, you should input these fields within the `Extra` field (skipping any that don't apply) as `field: value`, separated by newlines.
On the BibTeX side, these show up within the `note` field;
the `format.sh` post-processing script turns newlines into `;;;`.


- `dontinclude`: Use `TRUE` to exclude this publication from BibTeX (useful if there's no other good filter, like for a book review)
- `project`: Larger project(s) containing the publication. If multiple, separate with commas. If blank, project will go in "miscellaneous"
- `repo`: Linked repository (code and optionally data), either URL or BibTeX key
- `data`: URL for open data (only use if there's no `repo`)
- `gradauth`: Graduate student co-author(s): comma-separated last names
- `undergradauth`: Undergraduate co-author(s): comma-separated last names
- `heading`: CV heading to place publication under (only if needed for override; see following section)
- `pubnote`: Other notes about authorship/peer review to put in a footnote (i.e., to motivate credit for counting publications)
- `DOI` (only for item types for which Zotero doesn't provide a DOI field [e.g., chapters]). The BibTeX converter plunks this into the normal `DOI` BibTeX field

Any fields other than these will be discarded by `BibTeX-to-CSV.Rmd`


NOTE: Add an `open-access` field for PDFs that can vs. can't be shared?

### CV heading logic

Publications will be assigned to CV headings according to the following logic.
(Note that the My-Pubs Zotero search excludes presentations.)

```r
##Works in progress overrides other headings
if (!grepl("\\d{4}", year) {
	cvHead <- "Works in progress"

##Manual heading annotation overrides type logic
} else if (!is.null(heading)) {
	headingRecode <- c(
		`peer-reviewed` = "Peer-reviewed publications",
		proceedings = "Publications in conference proceedings",
		`book-review` = "Book reviews",
		`open-tools` = "Open research tools"
	)
	cvHead <- headingRecode[heading]

##Type logic
} else {
	typeRecode <- c(
		article = "Peer-reviewed publications",
		incollection = "Publications in edited volumes",
		inproceedings = "Publications in conference proceedings",
		misc = "Open research tools" ##Dataset, Software
	)
	cvHead <- typeRecode[type]
}
```

### Newlines

The `bib2df` R package doesn't like newlines within fields, so `format.sh` converts field-internal newlines to `;;;`.
So far, these only show up in the `note` field (separating different extra fields) and `abstract` (paragraph breaks).


