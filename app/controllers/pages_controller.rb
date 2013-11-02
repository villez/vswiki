class PagesController < ApplicationController
  before_filter :get_page, only: [:show, :edit, :update]

  def home
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.create(page_params)
    if @page.valid?
      redirect_to @page
    end
  end

  def show
    @page.build_formatted_html
  end

  def edit
  end

  def update
    if @page.update_attributes(page_params)
      redirect_to @page
    else
      render :edit
    end
  end


  private

  def get_page
    @page = Page.find_by(wikititle: params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :wikitext)
  end
end
