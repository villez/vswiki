# vswiki

[![Code Climate](https://codeclimate.com/github/villez/vswiki.png)](https://codeclimate.com/github/villez/vswiki)

A personal wiki project. Because at the last count, there were only
9999 different wiki implementations. And to try out the latest
versions of tools, mainly Rails 4.0. **Note: in very early stage of
development** and currently probably not fit for any actual usage.


## Features

The target is *not* a "full-featured" wiki; rather, will
cherry-pick features based on which ones are useful and/or interesting
to me. The target usage environment is on a local machine, or a
restricted/controlled environment, such as a home network. For
example, currently not planning to implement user logins,
authentication & authorization, and won't care that much about
protecting from malicious user input either.

The default wiki markup will also be a blend of Mediawiki, Creole,
Markdown, and some other markup languages, based on my own habits and
tastes. Will probably make it possible to switch the formatting/parser
engine at some point, though. 

Current markup features include:

 * paragraphs are indicated by blank lines in-between; consecutive
   non-blank lines separated with only a single newline are
   considered to be part of the same paragraph
 * Headings: either `== Heading 2`,  `== Heading 2 ==`, or
  `!!Heading 2`
 * Wikilinks with `[[wiki page|display label]]`
 * automatic recognition of bare http(s) links
 * unordered lists with 1 or more *'s and ordered lists with 1 or more
   #'s; number of asterisks/hashes indicates the nesting level
 * preformatted code blocks with the same "fenced" syntax as
   Github-flavored markdown
 * preformatted inline text with either single backquotes or @@text@@
 * can nest unordered lists within ordered lists and vice versa
 * horizontal rule with `----`


## Tools & Dependencies

 * Ruby 2.0 (only minor dependency, using some new syntax, but should
   be easy to backport to 1.9.x if desired)
 * Rails 4.0
 * RSpec & Capybara
 * PostgreSQL (also in development & test environments)
 * Shoulda-matchers (in testing)
 * Bootstrap 3 for layout & styling


## Copyright & License

(c) 2013 Ville Siltanen. MIT License.
