# coding: utf-8

require_relative '../../../lib/vswiki/parser'

module Vswiki
  describe Parser do

    describe "wikititles" do
      let(:normaltitle) { "normal string with whitespace" }

      it "creates wikititle from a normal string" do
        expect(Vswiki::Parser.make_wikititle(normaltitle)).to eq "NormalStringWithWhitespace"
      end
    end

    describe "simple wikilinks" do
      let(:link) { "[[some link]]" }

      it "creates an anchor tag for a wikilink" do
        expect(Vswiki::Parser.format_wikilinks(link)).to eq '<a href="SomeLink">some link</a>'
      end
    end

    describe "wikilink with label" do
      let(:labeledlink) { "[[some link|displayed text]]" }

      it "creates an anchor tag with label as link text" do
        expect(Vswiki::Parser.format_wikilinks(labeledlink)).
          to eq '<a href="SomeLink">displayed text</a>'
      end
    end

    describe "bare external links" do
      let(:httplink) { "http://www.google.com" }
      let(:httpslink) { "https://www.google.fi" }

      it "creates an anchor tag for an external http(s) link" do
        expect(Vswiki::Parser.format_wikilinks(httplink)).
          to eq '<a href="http://www.google.com">http://www.google.com</a>'
        expect(Vswiki::Parser.format_wikilinks(httpslink)).
          to eq '<a href="https://www.google.fi">https://www.google.fi</a>'
      end
    end

    describe "bracket-enclosed external links" do
      let(:httplink) { "[[http://www.google.com]]" }

      it "creates an anchor tag but doesn't capitalize" do
        expect(Vswiki::Parser.format_wikilinks(httplink)).
          to eq '<a href="http://www.google.com">http://www.google.com</a>'
      end
    end

    describe "labeling external links" do
      let(:extlinkwlabel) { "[[http://www.google.fi/|Google]]" }

      it "creates an anchor tag with label as link text" do
        expect(Vswiki::Parser.format_wikilinks(extlinkwlabel)).
          to eq '<a href="http://www.google.fi/">Google</a>'
      end
    end

    describe "paragraphs based on blank lines (or end of string)" do
      let(:paragraphs) { "first para\r\n\r\nsecond para\r\n\r\nthird para" }

      it "creates paragraph tags for text surrounded by blank lines" do
        expect(Vswiki::Parser.format_paragraphs(paragraphs)).
          to eq "<p>first para</p>\r\n\r\n<p>second para</p>\r\n\r\n<p>third para</p>"
      end
    end
  end
end
