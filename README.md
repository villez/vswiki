# vswiki

[![Code Climate](https://codeclimate.com/github/villez/vswiki.png)](https://codeclimate.com/github/villez/vswiki)

A personal wiki project. Because at the last count, there were only
9999 different wiki implementations. And to try out the latest
versions of various tools, mainly Rails 4 (see the full list
below).

**Note: in an early stage of development** - most likely won't
fit anybody else's purposes than my own at this point, but you're of
course free to take a look.


## Features & Non-Features

The target is not a "full-featured" wiki competing with MediaWiki and
the other big names; rather, will cherry-pick features based on which
ones are useful and/or interesting to me in a *personal wiki* use
case. The target usage environment is on a local machine in a
restricted/controlled environment, such as a home network behind a
firewall and with only trusted users. For example, I'm currently not
planning to implement user logins, authentication & authorization, and
won't care that much about protecting from malicious user input
either. Some of these features may end up getting included later, but
globally accessible multiuser environment is not the target
environment for this project.


## Wiki Markup

The default wiki markup is a blend of Mediawiki, Creole,
Markdown, and some other markup languages, based on my own habits and
tastes. It's possible that later on it'll become possible to switch
the parser to another one, but not guaranteed.

The current markup spec is roughly as follows:

### Basic Text Formatting

 * paragraphs are lines of text separated by newlines that don't have
   any more specific markup described below
 * Headings: either `== Heading 2`,  `== Heading 2 ==`, or
  `!!Heading 2`
 * emphasized text with `''emphasis''`, strong text with
   `'''strong'''`, and strong + emphasis with `'''''very strong'''''`
 * setting text color with `%green%this is colored green%%`. The parameter
   accepts the same values as the CSS color property - color names,
   hex values, etc. 
 * horizontal rule with `----`
 * preformatted inline text with either single backquotes or @@text@@
 
### Internal and External Links

 * Wikilinks with `[[wiki page|display label]]`
 * automatic recognition of bare http(s) links

### Block Formatting: Lists, Tables, 

 * unordered lists with 1 or more *'s and ordered lists with 1 or more
   #'s; number of asterisks/hashes indicates the nesting level
 * can nest unordered lists within ordered lists and vice
 * tables with a block of
   `|table|rows|with|pipe|for|cell|separation|`; each line must start
   with the `|` character to be considered part of the table  
 * preformatted code blocks with the same "fenced" syntax as
   Github-flavored markdown (but not necessarily all the same
   features): block delimited by lines with three "`" characters, and the starting
   delimiter may be followed with the name of the language in the code
   block, e.g. ruby, but that's optional

   ```ruby
   def foo(a, b)
     a + b * (a + b)
   end
   ```

 * syntax highlighting supported for some programming languages,
   currently using Prism.js (http://prismjs.com/) 


## Tools & Dependencies

In general, plan to keep up with the latest versions of tools,
especially Ruby and Rails. Since this is an experimental project with
no deployed base, will *not* put much effort into being backwards
compatible with older versions.

The main tool dependencies are:

 * Rails 4.1
 * Ruby 2.1 (only a minor dependency with the new %i array of symbols syntax)
 * PostgreSQL, including the development & testing environments (no
   strong dependency yet, but may use e.g. full text search later)
 * Bootstrap 3 for layout & styling (but subject to change later)
 * main testing tools: RSpec, capybara, poltergeist, database_cleaner, shoulda-matchers
 * additional testing utilities: guard, launchy, simplecov


## Future Development

These are just ideas, not an actual plan!

 * planning to keep up with Rails upgrades, at least within 4.x
 * implementing full text search, possibly with PostgreSQL
 * investigating possibilities for configuring other markup parsers
 * supporting image uploads (or other files)
 * investigating implementing the markup parser with a proper grammar
   instead of ad hoc regexes
 * making sections/subsections of text "foldable" when displaying wiki pages
 * supporting wiki page renaming; the tricky part is handling
   any potential wikilinks in other pages that are referring to the
   old name
 * supporting templates for certain kinds of wiki pages
 * more text formatting options: small text, super/subscripts, definition
   lists
 * possibility to add/configure custom markup options at runtime via configuration?
 * investigate different wiki page versioning options; not a high
   priority feature for me, but is a key wiki feature in general
 * user settings?
 * supporting themes and customization
 * including wiki pages within other pages
 * footnotes/references
 * generating TOC for a wiki page (from section headers)
 * implementing authentication and access control - again, not an
   important feature for my own use case, but necessary in the general
   case
   

## Copyright & License

(c) 2013-2014 Ville Siltanen. MIT License.
