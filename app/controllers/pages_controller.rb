class PagesController < ApplicationController
  before_action :get_page, only: [:show, :edit, :update, :destroy]
  before_action :get_sidebar, only: [:show, :index]

  def index
    if params[:go_to_page]
      redirect_to action: "show", id: to_wikititle(params[:go_to_page])
    end
  end

  def new
    title = params[:title] || ""
    @page = Page.new(title: title)
  end

  def create
    @prev_page = Page.find_by(wikititle: to_wikititle(params[:page][:title]))
    @page = Page.create(page_params)
    if @page.valid?
      redirect_to_show_or_keep_editing
    else
      render :new
    end
  end

  def show
    return redirect_to new_page_path(title: params[:id]) unless @page

    if @page.redirect_to.present?
      redirect_to(page_path(to_wikititle(@page.redirect_to)),
                  flash: {info: wiki_redirection_message})
    end
  end

  def edit
  end

  def update
    if @page.update_attributes(page_params)
      redirect_to_show_or_keep_editing
    else
      # should not happen normally, as title not editable via form and
      # there are currently no validations on other attributes
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
    @sidebar = Page.fetch_sidebar
  end

  def page_params
    params.require(:page).permit(:title, :wikitext, :redirect_to)
  end

  def redirect_to_show_or_keep_editing
    params[:save_and_edit] ? render(:edit) : redirect_to(@page)
  end

  def to_wikititle(text)
    Page.make_wikititle(text)
  end

  def wiki_redirection_message
    "Redirected from #{view_context.link_to @page.title, edit_page_path(@page)}"
  end
end
