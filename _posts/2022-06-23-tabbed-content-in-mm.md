---
## From https://github.com/qiujames/qiujames.github.io/blob/main/_posts/2022-06-23-tabbed-content-in-mm.md
title: "Tabbed Content in Minimal Mistakes"
toc: true
hello-world-tablist: 
  - title: Python
    language: python
    code_content: |
      print("Hello World");
    text_content: |
      Additional area under the code content where one
      can add text that is also formatted in **markdown**.
      You can add [links](https://qiujames.github.io/) or even images!
      ![birdie!](/assets/images/favicon.ico)
  - title: Java
    language: java
    code_content: |
      public class MyClass {
        public static void main(String[] args) {
          System.out.println("Hello World");
        }
      }
    text_content: |
      :smile:
  - title: C
    language: c
    code_content: |
      #include <stdio.h>

      int main() {
        printf("Hello World");
        return 0;
      }
    text_content: |
      I sure to do love pointers!
  - title: HTML
    language: html
    code_content: |
      <!DOCTYPE html>
      <html>
      <head>
      </head>
      <body>
        <h1>Hello World<h1>
      </body>
      </html>
    text_content: |
      But let's be real here... HTML doesn't belong here
  - title: Nested Python
    text_content: |
      You can even add nested tablists as seen below:
    nested_tablist: nested-python-tablist
nested-python-tablist:
  - title: Python2
    language: python
    code_content: |
      print "hello world"
    text_content: |
      Alternative output printing in Python2
  - title: Python3
    language: python
    code_content: |
      print("hello world")
    text_content: |
      Output printing in Python3
permalink: /test/
---

Tabbed content is pretty useful whenever you're writing
a blog post that highlights code snippets in multiple
programming languages or installation commands that depend 
on what OS you're running (ie. Mac/Windows/Linux). 

Minimal Mistakes (the theme powering this
Jekyll site) has some pretty nifty built-in syntax highlighting
for highlighting code depending on what language you specify.
Unfortunately, it doesn't come with a way to create tabbed content.
But luckily for us, Minimal Mistakes as a theme is
highly customizable so why not implement this feature ourselves.

I'll refer to the concept of having content separated by tabs
as "tablists" throughout.

NOTE: Ideally, you'd use an **actual** tool meant for writing
technical documentation to implement a sleeker tab/content system,
but what we have is pretty polished IMO.
{: .notice}


## Features
- Content separated by clickable tabs (duh)
- Code segments with syntax highlighting
- Ability to add additional text content
- Support for multiple tablist groups
- Ability to scroll for overflowed tabs
- Nested tablists (see the "Nested Python" tab)
- Stylistically coherent with MM concepts/themes

## Demo

In typical CS fashion, here you have the world's most famous program
written in various different programming languages:

{% include tablist id="hello-world-tablist" %}


## Usage

Generate a `tablist` element with content separated by titled tabs.
Each tabbed content element may contain syntactically highlighted
lines of code followed by optional markdown text content.

To place a tablist add the necessary YAML Front Matter.

| Name           | Required     | Description                                                                                                           |
| -------------- | ------------ | --------------------------------------------------------------------------------------------------------------------- |
| **title** | **Required** | Title of the content tab.  |
| **language**  | Optional | Specified programming language of the code content for syntax highlighting. See [Rouge](http://rouge.jneen.net/) for a list of supported languages |
| **code_content**  | Optional     | Code content.                                                                                             |
| **text_content**  | Optional     | Text content (markdown parsable). |

```yaml
tablist: 
  - title: Python
    language: python
    code_content: |
      print("Hello World");
    text_content: |
      Additional area under the code content where one
      can add text that is also formatted in **markdown**.
      You can add [links](https://qiujames.github.io/) or even images!
      ![birdie!](/assets/images/favicon.ico)
  - title: Java...
```

Indentation matters! The YAML Front Matter expects
one level of indentation after the `|` character 
(to indicate multiline front matter content). 
The contents positioning and spacing relative
to that indentation will be perserved in the final output.
{: .notice--info}

And then drop-in the tablist include in the body where you'd like it to appear.

| Include Parameter | Required | Description                                                                                                                                                       | Default                                                                      |
| ----------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| **id**            | Optional | To add multiple tablists to a document uniquely name them in the YAML Front Matter and reference in `{% raw %}{% include tablist id="tablist_id" %}{% endraw %}` | `tablist`                                                                    |

```liquid
{% raw %}{% include tablist %}{% endraw %}
<!-- OR -->
{% raw %}{% include tablist id="tablist_id" %}{% endraw %}
```


Tablists were heavily inspired by the 
[gallery](https://mmistakes.github.io/minimal-mistakes/docs/helpers/#gallery) 
Jekyll helper.  
We also stylistically follow the Minimal Mistakes documentation.
{: .notice--success}

## Implementation

Since Jekyll utilizes the template language [Liquid](https://shopify.github.io/liquid/)
(it just allows us to insert stuff into HTML), we can
insert an HTML block with the corresponding tab content in.

To do so, we create an includes html block that will get inserted whenever it
comes across the {% raw %}{% include tablist %}{% endraw %} in the markdown.
When it is inserted, it will loop across the written contents in the
YAML front content and then correspondingly layout the contents
and highlight code as needed. We finally write some javascript to
toggle the displayed content and keep an underline on the selected tab.

The trickiest part here was styling
the elements to match up coherently with the rest of the Minimal
Mistakes theme and getting the markdown to render correctly within
Liquid since Markdown and HTML don't mix well.
Feel free to check out the code
[here](https://github.com/qiujames/qiujames.github.io/commit/d1873795bb1d114f9930fcddf7702e9d3fe410d5).

And there you have it! A custom built functionality supporting tabbed content in Minimal Mistakes.