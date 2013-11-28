require 'spec_helper'

describe Page do

  let(:wikipage) { Page.new(title: "Test page with a few words", wikitext: "testing basic model") }

  describe "validations" do
    it { expect(wikipage).to validate_presence_of(:title).with_message("Cannot save with empty title") }
    it { expect(wikipage).to validate_uniqueness_of(:wikititle).with_message("page with that title already exists") }
  end
  
  describe "handling attributes" do

    it "generates wikititle from title on save" do
      wikipage.save
      expect(wikipage.wikititle).to eq "TestPageWithAFewWords"
    end

    it "generates html from wikitext" do
      # note: not testing the actual markup parsing correctness here,
      # just that the parsing step is done
      expect(wikipage.formatted_html).to eq("<p>testing basic model</p>\n")
    end

    it "saves the basic attributes successfully" do
      expect(wikipage.save).to be true
    end

  end
end
