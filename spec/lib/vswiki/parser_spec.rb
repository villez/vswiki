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

    describe "wikilinks" do
      let(:link) { "[[some link]]" }

      it "creates an anchor tag for a wikilink" do
        expect(Vswiki::Parser.format_html(link)).to eq '<a href="SomeLink">some link</a>'
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
  end
end
