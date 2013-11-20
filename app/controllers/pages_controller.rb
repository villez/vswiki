class PagesController < ApplicationController
  before_filter :get_page, only: [:show, :edit, :update, :destroy]
  before_filter :get_sidebar, only: [:show, :index]
  before_filter :format_page, only: [:show]

  def index
    if params[:go_to_page]  # the go-to-page miniform in the sidebar
      redirect_to action: "show", id: Page.make_wikititle(params[:go_to_page])
    end
  end

  def new
    title = params[:title] || ""
    @page = Page.new(title: title)
  end

  def create
    @page = Page.create(page_params)
    if @page.valid?
      redirect_to_show_or_edit(params)
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
    redirect_to new_page_path(title: params[:id]) unless @page
  end

  def edit
  end

  def update
    if @page.update_attributes(page_params)
      redirect_to_show_or_edit(params)
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

  def get_sidebar
    @sidebar = Page.find_by(wikititle: "Sidebar") ||
      Page.create(title: "Sidebar", wikitext: "!!Sidebar\nDefault sidebar")
    @sidebar.build_formatted_html
  end

  def format_page
    @page.build_formatted_html if @page
  end

  def page_params
    params.require(:page).permit(:title, :wikitext)
  end

  def redirect_to_show_or_edit(params)
    if params[:save_and_edit]
      render "edit"
    else
      redirect_to @page
    end
  end
end
