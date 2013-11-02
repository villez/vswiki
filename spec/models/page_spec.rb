require 'spec_helper'

describe Page do

  let(:wikipage) { Page.new(title: "Test page with a few words", wikitext: "testing basic model") }

  describe "handling attributes" do

    it { expect(wikipage).to validate_presence_of :title }
    it { expect(wikipage).to validate_uniqueness_of :wikititle }

    it "generates wikititle from title" do
      wikipage.build_wikititle
      expect(wikipage.wikititle).to eq "TestPageWithAFewWords"
    end

    it "generates html from wikitext" do
      # note: not testing the actual markup parsing correctness here,
      # just that the parsing step is done
      wikipage.build_formatted_html
      expect(wikipage.formatted_html).to include("testing basic model")
    end

    it "saves the basic attributes successfully" do
      expect(wikipage.save).to be true
    end

  end
end
