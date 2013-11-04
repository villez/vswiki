class PagesController < ApplicationController
  before_filter :get_page, only: [:show, :edit, :update, :destroy]

  def index
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
      if @page.errors.messages[:title]
        flash.now[:error] = "Cannot save with empty title"
      else
        flash.now[:error] = "Title is already taken"
      end
      render :new
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
      # should not happen, as title not editable via form and
      # there are currently no validations on content
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to root_url
  end


  private

  def get_page
    @page = Page.find_by(wikititle: params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :wikitext)
  end
end
