# coding: utf-8

require_relative '../../../lib/vswiki/parser'

module Vswiki
  describe Parser do

    parser = Vswiki::Parser.new

    describe "wikititles" do
      let(:normaltitle) { "normal string with whitespace" }

      it "creates wikititle from a normal string" do
        expect(parser.make_wikititle(normaltitle)).to eq "NormalStringWithWhitespace"
      end
    end

    describe "paragraphs based on blank lines (or end of string)" do
      let(:paragraphs) { "first para\r\n\r\nsecond para\r\n\r\nthird para" }
      let(:singlenewline) { "first line\r\nsecond line\r\nthird line" }

      it "creates paragraph tags for text surrounded by blank lines" do
        expect(parser.to_html(paragraphs)).
          to eq "<p>first para</p><p>second para</p><p>third para</p>"
      end

      it "collects lines separated by single newline into a single paragraph" do
        expect(parser.to_html(singlenewline)).
          to eq"<p>first line\r\nsecond line\r\nthird line</p>"
      end
    end

    describe "heading tags" do
      let(:first) { "=First Heading Level" }
      let(:third) { "=== Third Heading Level" }
      let(:fifth) { "=====Fifth Heading Level\n" }
      let(:paragraphs) { "first para\r\n\r\nsecond para" }

      it "creates correct heading tags based on number of leading '='s" do
        expect(parser.to_html(first)).to eq "<h1>First Heading Level</h1>"
        expect(parser.to_html(third)).to eq "<h3>Third Heading Level</h3>"
        expect(parser.to_html(fifth)).to eq "<h5>Fifth Heading Level</h5>"
      end

      it "correctly follows paragraphs after heading" do
        expect(parser.to_html(first + "\r\n" + paragraphs)).
          to eq "<h1>First Heading Level</h1><p>first para</p><p>second para</p>"
      end
    end

    describe "simple wikilinks" do
      let(:link) { "[[some link]]" }

      it "creates an anchor tag for a wikilink" do
        expect(parser.to_html(link)).to eq '<p><a href="SomeLink">some link</a></p>'
      end
    end

    describe "wikilink with label" do
      let(:labeledlink) { "[[some link|displayed text]]" }

      it "creates an anchor tag with label as link text" do
        expect(parser.to_html(labeledlink)).
          to eq '<p><a href="SomeLink">displayed text</a></p>'
      end
    end

    describe "bare external links" do
      let(:httplink) { "http://www.google.com" }
      let(:httpslink) { "https://www.google.fi" }

      it "creates an anchor tag for an external http link" do
        expect(parser.to_html(httplink)).
          to eq '<p><a href="http://www.google.com">http://www.google.com</a></p>'
      end
      it "creates an anchor tag for an external https link" do
        expect(parser.to_html(httpslink)).
          to eq '<p><a href="https://www.google.fi">https://www.google.fi</a></p>'
      end
    end

    describe "bracket-enclosed external links" do
      let(:httplink) { "[[http://www.google.com]]" }

      it "creates an anchor tag but doesn't capitalize" do
        expect(parser.to_html(httplink)).
          to eq '<p><a href="http://www.google.com">http://www.google.com</a></p>'
      end
    end

    describe "labeling external links" do
      let(:extlinkwlabel) { "[[http://www.google.fi/|Google]]" }

      it "creates an anchor tag with label as link text" do
        expect(parser.to_html(extlinkwlabel)).
          to eq '<p><a href="http://www.google.fi/">Google</a></p>'
      end
    end


  end
end
