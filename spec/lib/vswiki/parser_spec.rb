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
        expect(Vswiki::Parser.format_html(link)).to eq '<a href="SomeLink">some link</a>'
      end
    end

    describe "wikilink with label" do
      let(:labeledlink) { "[[some link|displayed text]]" }

      it "creates an anchor tag with label as link text" do
        expect(Vswiki::Parser.format_html(labeledlink)).
          to eq '<a href="SomeLink">displayed text</a>'
      end
    end

    describe "bare external links" do
      let(:httplink) { "http://www.google.com" }
      let(:httpslink) { "https://www.google.fi" }

      it "creates an anchor tag for an external http(s) link" do
        expect(Vswiki::Parser.format_html(httplink)).
          to eq '<a href="http://www.google.com">http://www.google.com</a>'
        expect(Vswiki::Parser.format_html(httpslink)).
          to eq '<a href="https://www.google.fi">https://www.google.fi</a>'
      end
    end

    describe "bracket-enclosed external links" do
      let(:httplink) { "[[http://www.google.com]]" }

      it "creates an anchor tag but doesn't capitalize" do
        expect(Vswiki::Parser.format_html(httplink)).
          to eq '<a href="http://www.google.com">http://www.google.com</a>'
      end
    end

    describe "labeling external links" do
      let(:extlinkwlabel) { "[[http://www.google.fi/|Google]]" }

      it "creates an anchor tag with label as link text" do
        expect(Vswiki::Parser.format_html(extlinkwlabel)).
          to eq '<a href="http://www.google.fi/">Google</a>'
      end
    end
  end
end
