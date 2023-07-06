Process BibTeX file
================
Dan Villarreal
2023-06-29

<style type="text/css">
/* Add scrollbars to long R input/output blocks */
pre {
  max-height: 300px;
  overflow-y: auto;
}
</style>

# Intro

This document contains code that takes a bibfile (in this case,
My-Pubs.bib) and outputs several files for different purposes:

- **All-Pubs.Rds**: An Rds file that has info needed to organize
  citations & links for the website (CV, “Research themes” page, etc.).
  This will take the place of `publications.tsv` in the
  publication-data-processing workflow
- **All-Pubs.csv**: A fallback csv file with the info in All-Pubs.Rds
- **All-Pubs.bib**: A bibfile that contains the info that will be turned
  into formatted citations, but doesn’t have the info from the “extra”
  field in My-Pubs.bib
- **../../pubs/Villarreal-Pubs.bib**: A ‘nice’ bibfile, meant for folks
  who want to download my bibliography, that excludes book reviews,
  works in progress, and any publications marked with `exclude: bibtex`.

# Parse input bibfile as dataframe

Read BibTeX file as df (suppress inaccurate “NAs introduced by coercion”
warning)

``` r
pubs <- bib2df(params$inbib)
```

    Column `YEAR` contains character strings.
                  No coercion to numeric applied.

Handle extra fields

``` r
##Permissible extra fields
extraFields <- c("themes", "repo", "data", "gradauth", 
                 "undergradauth", "heading", "pubnote", "exclude")

##Parse vector of extras into list of dataframes
parse_extra <- function(x, permissible=extraFields) {
  library(dplyr)
  library(stringr)
  library(purrr)
  
  x %>% 
    ##Split into indiv extra fields
    str_split(";;;") %>%
    ##Filter out impermissible fields
    map(str_subset, paste0("^(", paste(permissible, collapse="|"), "):")) %>% 
    ##Get df of name and value
    map(~ as.data.frame(str_match(.x, "(?<name>.+): (?<value>.+)"))) %>% 
    ##Remove "whole-match" col
    map(select, -1)
}

##Add extra columns
pubs <- pubs %>% 
  ##Turn NOTE into list-col
  mutate(across(NOTE, parse_extra)) %>% 
  ##Pull out name-value pairs
  unnest(NOTE, keep_empty=TRUE) %>% 
  ##Each field in its own column
  pivot_wider() %>% 
  ##Remove NA column
  select(-"NA")
```

Heading logic

``` r
patchYear <- tibble(YEAR = c("in prep", "under review", 
                             "revisions in prep", "revisions under review", 
                             "forthcoming"),
                    heading = "Works in progress")
patchCategory <- tribble(
  ~CATEGORY, ~heading,
  "ARTICLE", "Peer-reviewed publications",
  "INCOLLECTION", "Publications in edited volumes",
  "INPROCEEDINGS", "Publications in conference proceedings",
  "PHDTHESIS", "PhD dissertation",
  "MISC", "Open research tools" ##Dataset, Software
)
matchHeading <- c(
  "peer-reviewed" ~ "Peer-reviewed publications",
  "proceedings" ~ "Publications in conference proceedings",
  "book-review" ~ "Book reviews",
  "open-tools" ~ "Open research tools"
)

pubs <- pubs %>% 
  ##Recode heading
  mutate(across(heading, ~ case_match(.x, !!!matchHeading, .default=.x))) %>% 
  ##Patch based on YEAR first, then CATEGORY
  rows_patch(patchYear, "YEAR", unmatched="ignore") %>% 
  rows_patch(patchCategory, "CATEGORY", unmatched="error")
```

Handle PDF attachments (`FILE`)

``` r
pubs <- pubs %>% 
  ##Point FILE paths to website URL
  mutate(across(FILE, ~ paste0("/pubs/", .x)),
         ##PDFs only
         across(FILE, ~ if_else(endsWith(.x, ".pdf"), .x, NA_character_)))
```

Replace NA in `themes` with “other”

``` r
pubs <- pubs %>% 
  replace_na(list(themes = "other"))
```

Turn `URL`, `themes`, `gradauth`, & `undergradauth` into list-columns

``` r
pubs <- pubs %>% 
  mutate(across(URL, ~ str_split(.x, " and ")),
         across(c(themes, contains("gradauth")), ~ str_split(.x, ",")))
```

Replace temporary `;;;` with newlines

``` r
pubs <- pubs %>% 
  mutate(across(where(is.atomic), ~ str_replace_all(.x, ";;;", "\n")))
```

Add asterisks to `AUTHOR` (\* = grad/professional student co-author,
\*\* = undergrad)

``` r
addStar <- function(x, oneStar, twoStar, starAfter=c("last","end")) {
  library(dplyr)
  starAfter <- match.arg(starAfter)
  star <- case_when(str_remove(x, ",.+") %in% oneStar ~ "*",
                    str_remove(x, ",.+") %in% twoStar ~ "**",
                    TRUE ~ "")
  
  if (starAfter=="last") {
    ##Last*, First
    str_replace(x, ",", paste0(star, ","))
  } else {
    ##Last, First*
    paste0(x, star)
  }
}

pubs <- pubs %>%
  mutate(across(AUTHOR, ~ pmap(list(x=.x, oneStar=gradauth, twoStar=undergradauth),
                               addStar)))
```

Specify sort orders for `heading` (based on CV ordering) and `YEAR` (to
accommodate qualitative date codes)

``` r
##Heading order (PhD dissertation is an outlier, will be handled separately)
headingOrd <- c("PhD dissertation",
                "Works in progress", "Peer-reviewed publications", 
                "Open research tools", "Publications in edited volumes", 
                "Publications in conference proceedings", "Book reviews")

##Qualitative date codes in order from "oldest" to "newest"
qualDates <- c("in press", "forthcoming", 
                "revisions under review", "revisions in prep", 
                "under review", "in prep")

pubs <- pubs %>% 
  mutate(across(heading, ~ factor(.x, headingOrd)),
         ##YEAR sort order: 4-digit years from oldest to newest, followed by
         ##  qualitative dates from oldest to newest
         across(YEAR, ~ factor(.x, levels=.x %>% 
                                 unique() %>% 
                                 str_subset("^\\d{4}$") %>% 
                                 sort() %>% 
                                 c(qualDates))))
```

# Write Rds & csv files

Write Rds file

``` r
saveRDS(pubs, file.path(params$outfolder, params$outrds))
```

For csv file, collapse list-cols into character vectors, with entries
separated by `|`:

``` r
pubs %>% 
  mutate(across(!where(is.atomic), ~ map_chr(.x, paste, collapse="|"))) %>% 
  write.csv(file.path(params$outfolder, params$outcsv), row.names=FALSE, na="")
```

# Write BibTeX files

Override `bib2df::df2bib()` to use UTF-8 encoding (via
`xfun::write_utf8()`)

``` r
df2bib <- function (x, file = "", append = FALSE, allfields = TRUE) {
  library(bib2df)
  library(xfun)
  
  if (!is.character(file)) {
    stop("Invalid file path: Non-character supplied.", call. = FALSE)
  }
  if (as.numeric(file.access(dirname(file), mode = 2)) != 
    0 && file != "") {
    stop("Invalid file path: File is not writeable.", call. = FALSE)
  }
  if (any({
    df_elements <- sapply(x$AUTHOR, inherits, "data.frame")
  })) {
    x$AUTHOR[df_elements] <- lapply(x$AUTHOR[df_elements], 
      na_replace)
    x$AUTHOR[df_elements] <- lapply(x$AUTHOR[df_elements], 
      function(x) {
        paste(x$last_name, ", ", x$first_name, " ", 
          x$middle_name, sep = "")
      })
    x$AUTHOR[df_elements] <- lapply(x$AUTHOR[df_elements], 
      trimws)
  }
  names(x) <- toupper(names(x))
  fields <- lapply(seq_len(nrow(x)), function(r) {
    rowfields <- rep(list(character(0)), ncol(x))
    names(rowfields) <- names(x)
    for (i in seq_along(rowfields)) {
      f <- x[[i]][r]
      if (is.list(f)) {
        f <- unlist(f)
      }
      rowfields[[i]] <- if (!length(f) | any(is.na(f))) {
        character(0L)
      }
      else if (names(x)[i] %in% c("AUTHOR", "EDITOR")) {
        paste(f, collapse = " and ")
      }
      else {
        paste0(f, collapse = ", ")
      }
    }
    rowfields <- rowfields[lengths(rowfields) > 0]
    rowfields <- rowfields[!names(rowfields) %in% c("CATEGORY", 
      "BIBTEXKEY")]
    if (allfields) {
      paste0("  ", names(rowfields), " = {", unname(unlist(rowfields)), 
        "}", collapse = ",\n")
    }
    else {
      paste0("  ", names(rowfields[nzchar(rowfields)]), 
        " = {", unname(unlist(rowfields[nzchar(rowfields)])), 
        "}", collapse = ",\n")
    }
  })
  write_utf8(paste0("@", bib2df:::capitalize(x$CATEGORY), "{", x$BIBTEXKEY, 
    ",\n", unlist(fields), "\n}\n", collapse = "\n\n"), 
    con = file)
  invisible(file)
}
```

Whole version with all categories of publication:

``` r
pubs %>% 
  ##Remove fields unpacked from NOTE
  select(matches("^[A-Z]+$", ignore.case=FALSE)) %>% 
  ##Write
  df2bib(file.path(params$outfolder, params$outbib))
```

Individual bibfiles for each theme:

``` r
pubs %>% 
  ##No reviews
  filter(heading != "Book reviews",
         ##No WIP, unless accepted ("forthcoming")
         !(YEAR %in% c("in prep", "under review", 
                       "revisions in prep", "revisions under review")),
         ##No items with themes exclusion override
         !(exclude %in% c("themes", "both"))) %>% 
  unnest(themes) %>% 
  group_by(themes) %>% 
  group_walk(~ df2bib(.x,
                      file.path(params$outfolder, paste0(.y$themes, ".bib"))))
```

Nice version excluding some categories and items explictly excluded:

``` r
pubs %>% 
  ##No reviews or WIP
  filter(!(heading %in% c("Book reviews", "Works in progress")),
         ##No items with BibTeX exclusion override
         !(exclude %in% c("bibtex", "both"))) %>%
  ##Remove fields unpacked from NOTE
  select(matches("^[A-Z]+$", ignore.case=FALSE)) %>% 
  ##Write
  df2bib(params$nicebib)
```

# Session info

``` r
sessionInfo()
```

    R version 4.3.1 (2023-06-16 ucrt)
    Platform: x86_64-w64-mingw32/x64 (64-bit)
    Running under: Windows 10 x64 (build 19045)

    Matrix products: default


    locale:
    [1] LC_COLLATE=English_United States.utf8 
    [2] LC_CTYPE=English_United States.1252   
    [3] LC_MONETARY=English_United States.utf8
    [4] LC_NUMERIC=C                          
    [5] LC_TIME=English_United States.utf8    
    system code page: 65001

    time zone: America/New_York
    tzcode source: internal

    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base     

    other attached packages:
     [1] xfun_0.39       bib2df_1.1.2.0  lubridate_1.9.2 forcats_1.0.0  
     [5] stringr_1.5.0   dplyr_1.1.2     purrr_1.0.1     readr_2.1.4    
     [9] tidyr_1.3.0     tibble_3.2.1    ggplot2_3.4.2   tidyverse_2.0.0

    loaded via a namespace (and not attached):
     [1] gtable_0.3.3       compiler_4.3.1     Rcpp_1.0.10        tidyselect_1.2.0  
     [5] scales_1.2.1       yaml_2.3.7         fastmap_1.1.1      R6_2.5.1          
     [9] generics_0.1.3     knitr_1.43         munsell_0.5.0      pillar_1.9.0      
    [13] tzdb_0.4.0         rlang_1.1.1        utf8_1.2.3         stringi_1.7.12    
    [17] timechange_0.2.0   cli_3.6.1          withr_2.5.0        magrittr_2.0.3    
    [21] digest_0.6.31      grid_4.3.1         hms_1.1.3          lifecycle_1.0.3   
    [25] vctrs_0.6.3        humaniformat_0.6.0 evaluate_0.21      glue_1.6.2        
    [29] fansi_1.0.4        colorspace_2.1-0   httr_1.4.6         rmarkdown_2.22    
    [33] tools_4.3.1        pkgconfig_2.0.3    htmltools_0.5.5   
