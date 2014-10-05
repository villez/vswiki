# vswiki

[![Code Climate](https://codeclimate.com/github/villez/vswiki.png)](https://codeclimate.com/github/villez/vswiki)

A personal wiki project. Because at the last count, there were only
9999 different wiki implementations. And to try out the latest
versions of various tools, mainly Rails 4 (see the full list
below) and some interesting techniques.

**Note: in an early stage of development** - most likely won't
fit anybody else's purposes than my own at this point, but you're of
course free to take a look.


## Scope and Non-Scope

The current target is not a "full-featured" wiki on par with MediaWiki
etc. Rather, the idea is to cherry-pick features based on which ones
are useful and/or interesting to me in a *personal wiki* use case. The
target usage environment is on a local machine in a
restricted/controlled environment, such as a home network behind a
firewall and with only trusted users. For example, I'm currently not
planning to implement user logins, authentication & authorization, and
won't care that much about protecting from malicious user input
either, beyond what normal Rails best practices provide. Some of these
features may end up getting included later, but globally accessible
multiuser environment is not the target environment for this project.


## Wiki Markup

The default wiki markup is a blend of Mediawiki, Creole, Markdown, and
some other markup languages, based on my own habits and
preferences. Full-blown NIH syndrome in action. Obviously it'd be
simpler and more "portable" to just use one of the existing specs and
parsers as-is, but this is a personal hobby project, and figuring out
how to specify and implement the markup part is one of the more
interesting aspects.

It's possible that later on switching the markup language/parser to
another one becomes a feature, or just adopting an existing language,
but that's not currently planned. The markup part of the application
is already decently well isolated from the CRUD part of the wiki
functionality, so this should not pose a major technical challenge,
although some adapter type of stuff between different parser
interfaces etc. would probably be necessary. Actually the biggest
dependency at the moment is probably in the integration/feature tests,
which assume certain HTML output based on certain markup input.

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
   Github-flavored markdown - see the description:
   https://help.github.com/articles/github-flavored-markdown#fenced-code-blocks
 * syntax highlighting supported for some programming languages for
   fenced code blocks, again like in Github-flavored markdown:
   https://help.github.com/articles/github-flavored-markdown#syntax-highlighting
 * the syntax highlighter currently used is Prism.js
   (http://prismjs.com/), which doesn't support quite as many
   languages as some other highlighters; might be switched or made
   configurable later on


## Tools & Dependencies

In general, plan to keep up with the latest versions of tools,
especially Ruby and Rails. Since this is an experimental project with
no deployed base, will *not* put much effort into being backwards
compatible with older versions.

The main tool dependencies are:

 * Rails 4.1
 * Ruby 2.1 - only a minor dependency with the new %i array of symbols
   syntax, otherwise 2.0 should work as well, but not planning to
   support at the moment
 * PostgreSQL, including the development & testing environments; no
   strong dependency yet, but may use e.g. PostgreSQL full text search later
 * Bootstrap 3 for layout & styling; subject to change later
 * main testing tools: RSpec, capybara, poltergeist, database_cleaner, shoulda-matchers
 * additional dev & test utilities: launchy, simplecov


## Future Development

Current ideas for future development. There's not an actual detailed
plan or commitment to implement any of these, and the list is in more
or less random order, not reflecting schedule or priority.

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
