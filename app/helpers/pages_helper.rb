module PagesHelper

  def make_error_display_string(err)
    msg = err.join
    if msg =~ /already exists/
      msg << "; "
      msg << link_to("edit the existing page", edit_page_path(@prev_page))
      msg << " or enter a different title"
    end
    msg
  end
end
