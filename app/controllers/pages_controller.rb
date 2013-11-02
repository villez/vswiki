class PagesController < ApplicationController

  def home
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.create(page_params)
    if @page.valid?
      redirect_to page_url(@page)
    end
  end

  def show
    @page = Page.find_by_wikititle(params[:id])
    @page.build_formatted_html
  end

  private

  def page_params
    params.require(:page).permit(:title, :wikitext)
  end
end
