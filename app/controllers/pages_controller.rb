class PagesController < ApplicationController
  before_filter :get_page, only: [:show, :edit, :update]

  def home
  end

  def new
    title = params[:title] || ""
    @page = Page.new(title: title)
  end

  def create
    @page = Page.create(page_params)
    if @page.valid?
      redirect_to @page
    else
      render :edit
    end
  end

  def show
    if @page
      @page.build_formatted_html
    else
      redirect_to new_page_path(title: params[:id])
    end
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
