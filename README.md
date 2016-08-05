# vswiki

[![Code Climate](https://codeclimate.com/github/villez/vswiki.png)](https://codeclimate.com/github/villez/vswiki)

A toy wiki project. Not meant for "real" use, mainly for personal use
and testing some new tools. Unlikely to fit any other use case at this
point.

## Scope and Non-Scope

The target is not a "full-featured" wiki on par with MediaWiki
etc. Rather, the idea is to cherry-pick features that
are useful and/or interesting to me in a *personal wiki* use case. The
target usage environment is on a local machine in a
restricted/controlled environment, such as a home network behind a
firewall and with only trusted users. For example, currently there's
no plan to implement even user logins, let alone more fine-grained
access control and authorization mechanisms. Some of these features
may end up getting included later, but globally accessible multiuser
environment is not the target environment for this project.


## Wiki Markup

### Rationale

The default wiki markup is a blend of Mediawiki, Creole, Markdown, and
some other markup languages, based on my own habits and
preferences. In other words, full-blown NIH syndrome in
action. Obviously it'd be simpler and more "portable" (from the user's
perspective) to just use one of the existing wiki markup
specifications and parsers as-is, but this is a personal hobby
project, and figuring out how to specify and implement the markup part
is one of the more interesting aspects.

It's possible that later on switching the markup language/parser to
another one becomes a feature, or maybe I'll just adopt an existing
language, but that's not currently planned. The markup part of the
application is already decently well isolated from the CRUD part of
the wiki functionality, so this should not pose a major technical
challenge, although some adapter functionality between different
parser interfaces etc. would probably be necessary in the case of
supporting several different markup engines. Actually the biggest
dependency on the current home-grown markup is currently in the
integration/feature tests, which assume certain HTML output based on
certain markup input.

The current markup spec is roughly as follows:

### Basic Text Formatting

 * paragraphs are lines of text separated by newlines and which don't have
   any more specific markup described below
 * Headings: either `= Heading 1`,  `== Heading 2 ==`, or
  `!!!Heading 3`
 * emphasized (italics) text with `''emphasis''`, strong (bold) text with
   `'''strong'''`, and strong + emphasis with `'''''very strong'''''`
 * setting text color with `%green%this is green text%%`. The parameter
   accepts the same values as the CSS color property - color names,
   hex values, etc.
 * horizontal rule with `----`
 * preformatted inline text with either single backquotes or @@text@@

### Internal and External Links

 * Wikilinks (links to other pages in the same wiki) with `[[wiki page|display label]]`
 * automatic recognition of bare http(s) links
 * external links with labeling: `[[http://example.com|display label]]`

### Block Formatting: Lists, Tables,

 * unordered lists with one or more `*`'s and ordered lists with one or more
   `#`'s; the number of asterisks/hashes indicates the nesting level
 * can nest unordered lists within ordered lists and vice versa
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
   (http://prismjs.com/); I like it's design, but it doesn't support
   nearly as many languages as some other highlighters, such as
   pygments; might be switched or made configurable later on


## Tools & Dependencies

As mentioned at the beginning, currently this is an experimental hobby
project. There's no deployed base outside of my own. Thus the general
plan to keep up with the latest versions of tools, especially Ruby and
Rails, but also the testing tools and other utilities. This means I
will *not* put much effort into being backwards compatible with older
versions; rather, will lean towards quick upgrades and use the project
as a testing ground for the upgrades themselves to see what's required.

The main dependencies and tools are:

 * Rails 5.0 - no strong feature dependency, just keeping up with the latest
   in order to see what's in there and how the migration works
 * Ruby 2.x - again, only a minor technical dependency but want to
   keep up with the latest
 * PostgreSQL, including the development & testing environments; no
   strong dependency yet, but may use e.g. PostgreSQL full text search later
 * Bootstrap 3 for layout & styling (quite possibly will change later)
 * main testing tools: RSpec 3, Capybara, Poltergeist, database_cleaner, shoulda-matchers
 * additional dev & test utilities: launchy, SimpleCov, quiet_assets
 * Capistrano 3 set up for deployment; private deployment details not
   included in the public repo. The app doesn't contain anything
   special why other deployment methods (such as Git deployment to Heroku) wouldn't work, but they haven't been set up or tested.


## Future Development

This is just a list of ideas. There's no actual plan, schedule or
commitment to implement any of these, and the list is in more or less
random order.

 * keeping up with Rails upgrades
 * implementing full text search, possibly with PostgreSQL, but
   investigate other alternatives
 * investigating possibilities for configuring other markup parsers
 * supporting image uploads, then any arbitrary files
 * investigating implementing the markup parser with a proper grammar
   and parser generator instead of ad hoc regexes
 * making sections/subsections of text "foldable" when displaying wiki pages
 * supporting wiki page renaming; the tricky part is handling
   any potential wikilinks in other pages that are referring to the
   old name
 * supporting wiki page templates - essentially predefined markup
   structure that would be automatically inserted when creating a new page
 * more text formatting options: small text, super/subscripts, definition
   lists
 * possibility to add/configure custom markup options at runtime via configuration?
 * investigate different wiki page versioning options; not a high
   priority feature for me, but is a key wiki feature in general
 * user settings?
 * supporting themes and customization
 * including wiki pages within other pages
 * footnotes/references
 * generating TOC for a wiki page (from header markup)
 * implementing authentication and access control - as stated above, not an
   important feature for my own use case, but has obvious benefits for
   more general usage


## Copyright & License

(c) 2013-2016 Ville Siltanen. MIT License.
