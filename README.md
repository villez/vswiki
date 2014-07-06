# vswiki

[![Code Climate](https://codeclimate.com/github/villez/vswiki.png)](https://codeclimate.com/github/villez/vswiki)

A personal wiki project. Because at the last count, there were only
9999 different wiki implementations. And to try out the latest
versions of various tools, mainly Rails 4.0 (see the full list
below). **Note: in an early stage of development** - most likely won't
fit anybody else's purposes than my own at this point, but you're of
course free to take a look.


## Features & Non-Features

The target is not necessarily a "full-featured" wiki competing with
MediaWiki and the other big boys; rather, will cherry-pick features
based on which ones are useful and/or interesting to me in a *personal
wiki* use case. The target usage environment is on a local machine in
a restricted/controlled environment, such as a home network behind a
firewall and with only trusted users. For example, currently not
planning to implement user logins, authentication & authorization, and
won't care that much about protecting from malicious user input
either. May still include at least basic authetication features later.

The default wiki markup will also be a blend of Mediawiki, Creole,
Markdown, and some other markup languages, based on my own habits and
tastes. Will possibly make it possible to switch the formatting/parser
engine at some point, though. 

Current markup features include:

 * paragraphs are lines of text separated by newlines that don't have
   any more specific markup described below
 * Headings: either `== Heading 2`,  `== Heading 2 ==`, or
  `!!Heading 2`
 * emphasized text with `''emphasis''`, strong text with
   `'''strong'''`, and strong + emphasis with `'''''very strong'''''`
 * Wikilinks with `[[wiki page|display label]]`
 * automatic recognition of bare http(s) links
 * unordered lists with 1 or more *'s and ordered lists with 1 or more
   #'s; number of asterisks/hashes indicates the nesting level
 * can nest unordered lists within ordered lists and vice versa
 * tables with a block of `|table|rows|with|pipe|for|cell|separation|`
 * setting text color with `%green%this is colored%%`. The parameter
   accepts the same values as the CSS color property - color names,
   hex values, etc. 
 * preformatted code blocks with the same "fenced" syntax as
   Github-flavored markdown
 * preformatted inline text with either single backquotes or @@text@@
 * horizontal rule with `----`


## Tools & Dependencies

 * Rails 4.1
 * Ruby 2.1 (only a minor dependency with the new %i array of symbols syntax)
 * PostgreSQL for all environments (no strong dependency yet, but
   planning to use full text search later)
 * Bootstrap 3 for layout & styling
 * main testing tools: RSpec, capybara, poltergeist, database_cleaner, shoulda-matchers
 * additional testing utilities: guard, launchy, simplecov


## Copyright & License

(c) 2013-2014 Ville Siltanen. MIT License.
