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
  end
end
