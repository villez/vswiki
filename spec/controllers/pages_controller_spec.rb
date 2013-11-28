require 'spec_helper'

describe PagesController do

  describe "PATCH#update" do
    
    context "updating with invalid attributes" do
      
      it "doesn't update the title if trying to save a blank" do
        p = Page.create(title: "a page", wikitext: "just some text")
        patch :update, id: p, page: { title: "" }
        p.reload
        expect(p.title).to eq "a page"
      end
      
      it "re-renders the edit template" do
        p = Page.create(title: "a page", wikitext: "just some text")
        patch :update, id: p, page: { title: "" }
        expect(response).to render_template :edit
      end
    end
  end
end
