# coding: utf-8

require_relative '../../../lib/vswiki/parser'

module Vswiki
  describe Parser do

    # by default, make the link checker parameter always return true for
    # most tests; separately test the false case
    parser = Vswiki::Parser.new(Proc.new {true})

    describe "Wikititles" do
      it "creates wikititle from a normal string" do
        expect(parser.make_wikititle("normal string with whitespace")).to eq "NormalStringWithWhitespace"
      end

      it "removes more than one space in a row" do
        expect(parser.make_wikititle("a   very    sparse    string")).to eq "AVerySparseString"
      end

      it "doesn't change the string when already in wikititle format" do
        expect(parser.make_wikititle("WikiTitleText")).to eq "WikiTitleText"
      end

      it "correctly upcases umlaut characters" do
        expect(parser.make_wikititle("ööliä ääliö")).to eq "ÖöliäÄäliö"
        expect(parser.make_wikititle("über alles")).to eq "ÜberAlles"
        expect(parser.make_wikititle("åland öisin")).to eq "ÅlandÖisin"
        expect(parser.make_wikititle("ÄäliöÄlälyö")).to eq "ÄäliöÄlälyö"
      end

      it "removes punctuation but splits words on them" do
        expect(parser.make_wikititle("foo: bar, baz: quux.")).to eq "FooBarBazQuux"
        expect(parser.make_wikititle("foo:bar,baz:quux!")).to eq "FooBarBazQuux"
      end

      it "removes quotes and doesn't split the word on them" do
        expect(parser.make_wikititle("it's foo's \"bar\"")).to eq "ItsFoosBar"
      end

      it "removes other special characters and doesn't split the word on them" do
        expect(parser.make_wikititle("Foo#bar Baz/quux")).to eq "FoobarBazquux"
      end

      it "keeps dashes and underscores" do
        expect(parser.make_wikititle("foo_bar")).to eq "Foo_bar"
        expect(parser.make_wikititle("objective-C")).to eq "Objective-C"
      end
    end


    describe "paragraphs based on newlines (or end of string)" do
      it "creates paragraph tags for text surrounded by blank lines" do
        expect(parser.to_html("first para\r\nsecond para\r\nthird para")).
          to eq "<p>first para</p>\n<p>second para</p>\n<p>third para</p>\n"
      end

      # a basic example of input that has just \n for newlines to begin with
      it "creates paragraph tags for text surrounded by blank lines" do
        expect(parser.to_html("first para\nsecond para\nthird para")).
          to eq "<p>first para</p>\n<p>second para</p>\n<p>third para</p>\n"
      end

      it "removes extra newlines from the input" do
        expect(parser.to_html("first para\r\n\r\nsecond para\r\n\r\n\r\n\r\nthird para\r\n\r\n")).
          to eq "<p>first para</p>\n<p>second para</p>\n<p>third para</p>\n"
      end
      
    end

    describe "Headings" do
      describe "heading tags with '=' (optional suffix) and '!'" do
        it "creates correct heading tags based on number of leading '='s" do
          expect(parser.to_html("=First Level Heading")).to eq "<h1>First Level Heading</h1>\n"
          expect(parser.to_html("!!Second Level Heading")).to eq "<h2>Second Level Heading</h2>\n"
          expect(parser.to_html("=== Third Level Heading ===")).to eq "<h3>Third Level Heading</h3>\n"
          expect(parser.to_html("!!!!Fourth Level Heading\r\n")).to eq "<h4>Fourth Level Heading</h4>\n"
          expect(parser.to_html("=====Fifth Level Heading=====\n")).to eq "<h5>Fifth Level Heading</h5>\n"
        end

        it "correctly follows paragraphs after heading" do
          expect(parser.to_html("=First Level Heading" + "\r\n" + "first para\r\n\r\nsecond para")).
            to eq "<h1>First Level Heading</h1>\n<p>first para</p>\n<p>second para</p>\n"
        end

        it "doesn't create a heading when inside a paragraph" do
          expect(parser.to_html("this is not a !!Heading but just part of the paragraph")).
            to eq "<p>this is not a !!Heading but just part of the paragraph</p>\n"
        end
      end
    end

    describe "Links" do

      describe "simple wikilinks" do
        it "creates an anchor tag for a wikilink" do
          expect(parser.to_html( "[[some link]]")).to eq "<p><a href=\"SomeLink\">some link</a></p>\n"
        end
      end

      describe "wikilink with label" do
        it "creates an anchor tag with label as link text" do
          expect(parser.to_html("[[some link|displayed text]]")).
            to eq "<p><a href=\"SomeLink\">displayed text</a></p>\n"
        end
      end

      describe "bare external links" do
        it "creates an anchor tag for an external http link" do
          expect(parser.to_html("http://www.google.com")).
            to eq "<p><a href=\"http://www.google.com\" target=\"_blank\">http://www.google.com</a></p>\n"
        end
        it "creates an anchor tag for an external https link" do
          expect(parser.to_html("https://www.google.fi")).
            to eq "<p><a href=\"https://www.google.fi\" target=\"_blank\">https://www.google.fi</a></p>\n"
        end
      end

      describe "bracket-enclosed external links" do
        it "creates an anchor tag but doesn't capitalize" do
          expect(parser.to_html("[[http://www.google.com]]")).
            to eq "<p><a href=\"http://www.google.com\" target=\"_blank\">http://www.google.com</a></p>\n"
        end
      end

      describe "labeling external links" do
        it "creates an anchor tag with label as link text" do
        expect(parser.to_html("[[http://www.google.fi/|Google]]")).
            to eq "<p><a href=\"http://www.google.fi/\" target=\"_blank\">Google</a></p>\n"
        end
      end

      describe "several links in single paragraph" do
        it "creates an anchor tag for each link within a paragraph" do
          expect(parser.to_html("Here [[one link]] and then [[another link]]")).
            to eq "<p>Here <a href=\"OneLink\">one link</a> and then <a href=\"AnotherLink\">another link</a></p>\n"
        end
      end

      describe "wikilinks where the link target page does not exist" do
        # instantiate a parser with link_checker always returning false to
        # simulate the case where the linked page doesn't exist without having
        # to call ActiveRecord and the actual database in the parser tests
        noexist_parser = Vswiki::Parser.new(Proc.new {false})
        it "adds a special class to wikilink anchor tags if the linked page does not exist" do
          expect(noexist_parser.to_html( "[[some link]]")).to eq "<p><a href=\"SomeLink\" class=\"wikinoexist\">some link</a></p>\n"
        end
      end
        
    end # Links

    describe "Lists" do

      describe "simple unordered lists" do
        it "creates a ul tag and a li tag inside it" do
          expect(parser.to_html("* list item 1")).
            to eq("<ul><li>list item 1</li></ul>\n")
        end

        it "combines consecutive list items into a single ul" do
          expect(parser.to_html("* list item 1\r\n*list item 2\n* list item 3")).
            to eq("<ul><li>list item 1</li><li>list item 2</li><li>list item 3</li></ul>\n")
        end
      end

      describe "nested unordered lists" do
        it "creates nested ul tags for multiple *'s" do
          expect(parser.to_html("* list item 1\r\n**list item 1.1\r\n*list item 2")).
            to eq("<ul><li>list item 1</li><ul><li>list item 1.1</li></ul>\n<li>list item 2</li></ul>\n")
        end

        it "supports deeper ul nesting" do
          expect(parser.to_html("* list item 1\r\n**list item 1.1\r\n***list item 1.1.1\r\n*list item 2")).
            to eq("<ul><li>list item 1</li><ul><li>list item 1.1</li><ul><li>list item 1.1.1</li></ul>\n</ul>\n<li>list item 2</li></ul>\n")
        end

        it "formats links in list elements" do
          expect(parser.to_html("* [[LinkHere]]\r\n* [[Link There]]")).
            to eq("<ul><li><a href=\"LinkHere\">LinkHere</a></li><li><a href=\"LinkThere\">Link There</a></li></ul>\n")
        end
      end

      describe "nested ordered lists" do
        it "creates nested ol tags for multiple #'s" do
          expect(parser.to_html("# item 1\r\n##item 1.1\r\n###item 1.1.1\r\n#item 2")).
            to eq("<ol><li>item 1</li><ol><li>item 1.1</li><ol><li>item 1.1.1</li></ol>\n</ol>\n<li>item 2</li></ol>\n")
        end
      end

      describe "mixed ul and ol" do
        it "allows nesting <ul> in <ol> and vice versa" do
          expect(parser.to_html("* item 1\r\n##item 1.1\r\n***item 1.1.1\r\n*item 2")).
            to eq("<ul><li>item 1</li><ol><li>item 1.1</li><ul><li>item 1.1.1</li></ul>\n</ol>\n<li>item 2</li></ul>\n")
        end
      end

      describe "paragraph after list" do
        it "can start a paragraph right after list with no blank line in between" do
          expect(parser.to_html("* item 1\r\n##item 1.1\r\nparagraph text")).
            to eq("<ul><li>item 1</li><ol><li>item 1.1</li></ol>\n</ul>\n<p>paragraph text</p>\n")
          
        end
      end
      
    end  # Lists

    describe "Preformatted Text" do

      describe "preformatted code block" do
        it "creates a <pre><code> block" do
          expect(parser.to_html("\r\n\r\n```\r\npreformatted\r\ntext\r\nblock\r\n```")).
            to eq("<pre><code>preformatted\ntext\nblock\n</code></pre>\n")
        end

        it "adds language class when language name given" do
          expect(parser.to_html("```ruby\r\ndef foo\r\n  puts 'foo!'\r\nend\r\n```")).
            to eq("<pre><code class=\"language-ruby\">def foo\n  puts 'foo!'\nend\n</code></pre>\n")
        end

        it "does not format headings or links within preformatted block" do
          expect(parser.to_html("```\r\n!!Heading\r\n[[Link]]\r\n```")).
            to eq("<pre><code>!!Heading\n[[Link]]\n</code></pre>\n")
        end
      end

      describe "inline preformatted text" do
        it "creates an inline code block with backticks" do
          expect(parser.to_html("paragraph with `preformatted` text")).
            to eq("<p>paragraph with <code>preformatted</code> text</p>\n")
        end
        it "creates an inline code block with double @" do
          expect(parser.to_html("paragraph with @@preformatted@@ text")).
            to eq("<p>paragraph with <code>preformatted</code> text</p>\n")
        end

        it "allows ` within @@ preformatted block and vice versa" do
          expect(parser.to_html("@@` backtick here@@ and `double-at @@ here`")).
            to eq("<p><code>` backtick here</code> and <code>double-at @@ here</code></p>\n")
        end

        it "doesn't make an anchor tag for a link in a preformatted inline block" do
          expect(parser.to_html("this is `not a link: [[Link]]`")).
            to eq("<p>this is <code>not a link: [[Link]]</code></p>\n")
        end

        it "allows single @'s in text without making a preformatted block" do
          expect(parser.to_html("email test@example.com does not cause preformat")).
            to eq("<p>email test@example.com does not cause preformat</p>\n")
        end
      end
    end

    describe "Basic Text Formatting" do

      describe "emphasis" do
        it "creates an em tag with ''" do
          expect(parser.to_html("this is ''important''")).
            to eq("<p>this is <em>important</em></p>\n")
        end

        it "formats links within emphasized text" do
          expect(parser.to_html("''emphasized text with [[Link]]'' within")).
            to eq("<p><em>emphasized text with <a href=\"Link\">Link</a></em> within</p>\n")
        end

        it "doesn't create an em tag if the '' is not closed" do
          expect(parser.to_html("starting '' but no corresponding ending markup")).
            to eq("<p>starting &#39;&#39; but no corresponding ending markup</p>\n")
        end
      end

      describe "strong" do
        it "creates a strong tag with '''" do
          expect(parser.to_html("I feel very '''strongly''' about this")).
            to eq("<p>I feel very <strong>strongly</strong> about this</p>\n")
        end

        it "formats links within strong text" do
          expect(parser.to_html("'''strong text with [[Link]]''' within")).
            to eq("<p><strong>strong text with <a href=\"Link\">Link</a></strong> within</p>\n")
        end

        it "doesn't create a strong tag if the ''' is not closed" do
          expect(parser.to_html("starting ''' but no corresponding ending markup")).
            to eq("<p>starting &#39;&#39;&#39; but no corresponding ending markup</p>\n")
        end
end

      describe "strong emphasis" do
        it "creates an em tag within a strong tag for 5 single quotes" do
          expect(parser.to_html("This is a '''''critical''''' issue")).
            to eq("<p>This is a <strong><em>critical</em></strong> issue</p>\n")
        end

        it "formats links within strong emphasis text" do
          expect(parser.to_html("'''''strong emphasis text with [[Link]]''''' within")).
            to eq("<p><strong><em>strong emphasis text with <a href=\"Link\">Link</a></em></strong> within</p>\n")
        end
      end

      describe "horizontal rule" do
        it "creates a hr tag" do
          expect(parser.to_html("----")).to eq("<hr />\n")
          expect(parser.to_html("-----  ")).to eq("<hr />\n")
        end

        it "generates just a paragraph for < 4 dashes" do
          expect(parser.to_html("---")).to eq("<p>---</p>\n")
        end
      end
    end

    describe "Tables" do
      describe "basic table markup" do
        it "creates table, tr & td tags" do
          expect(parser.to_html("|cell1a|cell1b|\n|cell2a|cell2b|")).
            to eq("<table><tr><td>cell1a</td><td>cell1b</td></tr><tr><td>cell2a</td><td>cell2b</td></tr></table>\n")
        end

        it "creates th tags for ! or = prefixed cell content" do
          expect(parser.to_html("|!cell1a|!cell1b|\n|cell2a|cell2b|")).
            to eq("<table><tr><th>cell1a</th><th>cell1b</th></tr><tr><td>cell2a</td><td>cell2b</td></tr></table>\n")          
          expect(parser.to_html("|=cell1a|=cell1b|\n|cell2a|cell2b|")).
            to eq("<table><tr><th>cell1a</th><th>cell1b</th></tr><tr><td>cell2a</td><td>cell2b</td></tr></table>\n")
        end

        it "parses inline markup within table cells" do
          expect(parser.to_html("|cell1a|''cell1b''|\n|[[link]]|cell2b|")).
            to eq("<table><tr><td>cell1a</td><td><em>cell1b</em></td></tr><tr><td><a href=\"Link\">link</a></td><td>cell2b</td></tr></table>\n")
        end

        it "doesn't confuse labeled links cell borders" do
          expect(parser.to_html("|cell1a|''cell1b''|\n|link: [[link|label]]|cell2b|")).
            to eq("<table><tr><td>cell1a</td><td><em>cell1b</em></td></tr><tr><td>link: <a href=\"Link\">label</a></td><td>cell2b</td></tr></table>\n")
        end

        it "handles empty cells" do
          expect(parser.to_html("|cell1a| |\n| |cell2b|")).
            to eq("<table><tr><td>cell1a</td><td></td></tr><tr><td></td><td>cell2b</td></tr></table>\n")
        end
        
        it "can start a paragraph right after a table with no blank line in between" do
          expect(parser.to_html("|cell1a|cell1b|\r\n|cell2a|cell2b|\r\nparagraph text")).
            to eq("<table><tr><td>cell1a</td><td>cell1b</td></tr><tr><td>cell2a</td><td>cell2b</td></tr></table>\n<p>paragraph text</p>\n")
          
        end
      end
    end # Tables

    describe "Text Coloring" do
      it "generates a span within a paragraph with text color set to name" do
        expect(parser.to_html("this text has %green%some green text%% within")).
          to eq("<p>this text has <span style=\"color: green;\">some green text</span> within</p>\n")
      end

      it "generates a span within a paragraph with text color set to hex value" do
        expect(parser.to_html("this text has %#7a6d5f%some green text%% within")).
          to eq("<p>this text has <span style=\"color: #7a6d5f;\">some green text</span> within</p>\n")
      end
      
      it "supports other inline markup within colored text" do
        expect(parser.to_html("this text has %green%some ''green'' text%% within")).
          to eq("<p>this text has <span style=\"color: green;\">some <em>green</em> text</span> within</p>\n")
      end

      it "supports colored text within other inline markup" do
        expect(parser.to_html("this '''strong text has %green%some green text%% within'''")).
          to eq("<p>this <strong>strong text has <span style=\"color: green;\">some green text</span> within</strong></p>\n")
      end
    end

    describe "escaping special HTML characters" do
      it "escapes < and > within paragraphs" do
        expect(parser.to_html("a > b or c < d")).to eq "<p>a &gt; b or c &lt; d</p>\n"
      end
      
      it "escapes & within paragraphs" do
        expect(parser.to_html("a && b || c && d")).to eq "<p>a &amp;&amp; b || c &amp;&amp; d</p>\n"
      end

      it "escapes special chars within emphasized or strong inline text" do
        expect(parser.to_html("emphasized ''text with < and >''")).
          to eq "<p>emphasized <em>text with &lt; and &gt;</em></p>\n"
        expect(parser.to_html("strong '''text with < and >'''")).
          to eq "<p>strong <strong>text with &lt; and &gt;</strong></p>\n"
      end

      it "escapes special chars within headers" do
        expect(parser.to_html("!!!Section describing <ul> and <li>")).
          to eq "<h3>Section describing &lt;ul&gt; and &lt;li&gt;</h3>\n"
      end
      
      it "escapes special chars within list elements" do
        expect(parser.to_html("* this is a <li> within an <ul>")).
          to eq "<ul><li>this is a &lt;li&gt; within an &lt;ul&gt;</li></ul>\n"
      end

      it "escapes special chars within table cells" do
        expect(parser.to_html("|a < b|c > d|\n|a & b|foo|")).
          to eq "<table><tr><td>a &lt; b</td><td>c &gt; d</td></tr><tr><td>a &amp; b</td><td>foo</td></tr></table>\n"
      end

    end

  end
end
