# coding: utf-8

require_relative '../../../lib/vswiki/parser'

module Vswiki
  describe Parser do

    parser = Vswiki::Parser.new

    describe "Wikititles" do
      it "creates wikititle from a normal string" do
        expect(parser.make_wikititle("normal string with whitespace")).to eq "NormalStringWithWhitespace"
      end

      it "doesn't change the string when already in wikititle format" do
        expect(parser.make_wikititle("WikiTitleText")).to eq "WikiTitleText"
      end
    end

    describe "paragraphs based on blank lines (or end of string)" do
      it "creates paragraph tags for text surrounded by blank lines" do
        expect(parser.to_html("first para\r\n\r\nsecond para\r\n\r\nthird para")).
          to eq "<p>first para</p><p>second para</p><p>third para</p>"
      end

      it "collects lines separated by single newline into a single paragraph" do
        expect(parser.to_html("first line\r\nsecond line\r\nthird line")).
          to eq"<p>first line\r\nsecond line\r\nthird line</p>"
      end
    end

    describe "Headings" do
      describe "heading tags with '=' (optional suffix) and '!'" do
        it "creates correct heading tags based on number of leading '='s" do
          expect(parser.to_html("=First Level Heading")).to eq "<h1>First Level Heading</h1>"
          expect(parser.to_html("!!Second Level Heading")).to eq "<h2>Second Level Heading</h2>"
          expect(parser.to_html("=== Third Level Heading ===")).to eq "<h3>Third Level Heading</h3>"
          expect(parser.to_html("!!!!Fourth Level Heading\r\n")).to eq "<h4>Fourth Level Heading</h4>"
          expect(parser.to_html("=====Fifth Level Heading=====\n")).to eq "<h5>Fifth Level Heading</h5>"
        end

        it "correctly follows paragraphs after heading" do
          expect(parser.to_html("=First Level Heading" + "\r\n" + "first para\r\n\r\nsecond para")).
            to eq "<h1>First Level Heading</h1><p>first para</p><p>second para</p>"
        end

        it "doesn't create a heading when inside a paragraph" do
          expect(parser.to_html("this is not a !!Heading but just part of the paragraph")).
            to eq "<p>this is not a !!Heading but just part of the paragraph</p>"
        end
      end
    end

    describe "Links" do

      describe "simple wikilinks" do
        it "creates an anchor tag for a wikilink" do
          expect(parser.to_html( "[[some link]]")).to eq '<p><a href="SomeLink">some link</a></p>'
        end
      end

      describe "wikilink with label" do
        it "creates an anchor tag with label as link text" do
          expect(parser.to_html("[[some link|displayed text]]")).
            to eq '<p><a href="SomeLink">displayed text</a></p>'
        end
      end

      describe "bare external links" do
        it "creates an anchor tag for an external http link" do
          expect(parser.to_html("http://www.google.com")).
            to eq '<p><a href="http://www.google.com">http://www.google.com</a></p>'
        end
        it "creates an anchor tag for an external https link" do
          expect(parser.to_html("https://www.google.fi")).
            to eq '<p><a href="https://www.google.fi">https://www.google.fi</a></p>'
        end
      end

      describe "bracket-enclosed external links" do
        it "creates an anchor tag but doesn't capitalize" do
          expect(parser.to_html("[[http://www.google.com]]")).
            to eq '<p><a href="http://www.google.com">http://www.google.com</a></p>'
        end
      end

      describe "labeling external links" do
        it "creates an anchor tag with label as link text" do
        expect(parser.to_html("[[http://www.google.fi/|Google]]")).
            to eq '<p><a href="http://www.google.fi/">Google</a></p>'
        end
      end

      describe "several links in single paragraph" do
        it "creates an anchor tag for each link within a paragraph" do
          expect(parser.to_html("Here's [[one link]] and then [[another link]]")).
            to eq "<p>Here's <a href=\"OneLink\">one link</a> and then <a href=\"AnotherLink\">another link</a></p>"
        end
      end
    end # Links

    describe "Lists" do

      describe "simple unordered lists" do
        it "creates a ul tag and a li tag inside it" do
          expect(parser.to_html("* list item 1")).
            to eq("<ul><li>list item 1</li></ul>")
        end

        it "combines consecutive list items into a single ul" do
          expect(parser.to_html("* list item 1\r\n*list item 2\n* list item 3")).
            to eq("<ul><li>list item 1</li><li>list item 2</li><li>list item 3</li></ul>")
        end
      end

      describe "nested unordered lists" do
        it "creates nested ul tags for multiple *'s" do
          expect(parser.to_html("* list item 1\r\n**list item 1.1\r\n*list item 2")).
            to eq("<ul><li>list item 1</li><ul><li>list item 1.1</li></ul><li>list item 2</li></ul>")
        end

        it "supports deeper ul nesting" do
          expect(parser.to_html("* list item 1\r\n**list item 1.1\r\n***list item 1.1.1\r\n*list item 2")).
            to eq("<ul><li>list item 1</li><ul><li>list item 1.1</li><ul><li>list item 1.1.1</li></ul></ul><li>list item 2</li></ul>")
        end

        it "formats links in list elements" do
          expect(parser.to_html("* [[LinkHere]]\r\n* [[Link There]]")).
            to eq('<ul><li><a href="LinkHere">LinkHere</a></li><li><a href="LinkThere">Link There</a></li></ul>')
        end
      end

      describe "nested ordered lists" do
        it "creates nested ol tags for multiple #'s" do
          expect(parser.to_html("# item 1\r\n##item 1.1\r\n###item 1.1.1\r\n#item 2")).
            to eq("<ol><li>item 1</li><ol><li>item 1.1</li><ol><li>item 1.1.1</li></ol></ol><li>item 2</li></ol>")
        end
      end

      describe "mixed ul and ol" do
        it "allows nesting <ul> in <ol> and vice versa" do
          expect(parser.to_html("* item 1\r\n##item 1.1\r\n***item 1.1.1\r\n*item 2")).
            to eq("<ul><li>item 1</li><ol><li>item 1.1</li><ul><li>item 1.1.1</li></ul></ol><li>item 2</li></ul>")
        end
      end
    end  # Lists

    describe "Preformatted Text" do

      describe "preformatted code block" do
        it "creates a <pre><code> block" do
          expect(parser.to_html("\r\n\r\n```\r\npreformatted\r\ntext\r\nblock\r\n```")).
            to eq("<pre><code>preformatted\r\ntext\r\nblock\r\n</code></pre>")
        end

        it "adds language class when language name given" do
          expect(parser.to_html("```ruby\r\ndef foo\r\n  puts 'foo!'\r\nend\r\n```")).
            to eq("<pre><code class=\"language-ruby\">def foo\r\n  puts 'foo!'\r\nend\r\n</code></pre>")
        end

        it "does not format headings or links within preformatted block" do
          expect(parser.to_html("```\r\n!!Heading\r\n[[Link]]\r\n```")).
            to eq("<pre><code>!!Heading\r\n[[Link]]\r\n</code></pre>")
        end
      end

      describe "inline preformatted text" do
        it "creates an inline code block with backticks" do
          expect(parser.to_html("paragraph with `preformatted` text")).
            to eq("<p>paragraph with <code>preformatted</code> text</p>")
        end
        it "creates an inline code block with double @" do
          expect(parser.to_html("paragraph with @@preformatted@@ text")).
            to eq("<p>paragraph with <code>preformatted</code> text</p>")
        end

        it "allows ` within @@ preformatted block and vice versa" do
          expect(parser.to_html("@@` backtick here@@ and `double-at @@ here`")).
            to eq("<p><code>` backtick here</code> and <code>double-at @@ here</code></p>")
        end

        it "doesn't make an anchor tag for a link in a preformatted inline block" do
          expect(parser.to_html("this is `not a link: [[Link]]`")).
            to eq("<p>this is <code>not a link: [[Link]]</code></p>")
        end

        it "allows single @'s in text without making a preformatted block" do
          expect(parser.to_html("email test@example.com doesn't cause preformat")).
            to eq("<p>email test@example.com doesn't cause preformat</p>")
        end
      end
    end

    describe "Basic Text Formatting" do

      describe "emphasis" do
        it "creates an em tag with ''" do
          expect(parser.to_html("this is ''important''")).
            to eq("<p>this is <em>important</em></p>")
        end

        it "formats links within emphasized text" do
          expect(parser.to_html("''emphasized text with [[Link]]'' within")).
            to eq("<p><em>emphasized text with <a href=\"Link\">Link</a></em> within</p>")
        end

        it "doesn't create an em tag if the '' is not closed" do
          expect(parser.to_html("there's starting '' but no corresponding ending markup")).
            to eq("<p>there's starting '' but no corresponding ending markup</p>")
        end
      end

      describe "strong" do
        it "creates a strong tag with '''" do
          expect(parser.to_html("I feel very '''strongly''' about this")).
            to eq("<p>I feel very <strong>strongly</strong> about this</p>")
        end

        it "formats links within strong text" do
          expect(parser.to_html("'''strong text with [[Link]]''' within")).
            to eq("<p><strong>strong text with <a href=\"Link\">Link</a></strong> within</p>")
        end

        it "doesn't create a strong tag if the ''' is not closed" do
          expect(parser.to_html("there's starting ''' but no corresponding ending markup")).
            to eq("<p>there's starting ''' but no corresponding ending markup</p>")
        end
end

      describe "strong emphasis" do
        it "creates an em tag within a strong tag for 5 single quotes" do
          expect(parser.to_html("This is a '''''critical''''' issue")).
            to eq("<p>This is a <strong><em>critical</em></strong> issue</p>")
        end

        it "formats links within strong emphasis text" do
          expect(parser.to_html("'''''strong emphasis text with [[Link]]''''' within")).
            to eq("<p><strong><em>strong emphasis text with <a href=\"Link\">Link</a></em></strong> within</p>")
        end
      end

      describe "horizontal rule" do
        it "creates a hr tag" do
          expect(parser.to_html("----")).to eq("<hr />")
          expect(parser.to_html("-----  ")).to eq("<hr />")
        end

        it "generates just a paragraph for < 4 dashes" do
          expect(parser.to_html("---")).to eq("<p>---</p>")
        end
      end
    end
  end
end
