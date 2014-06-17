module ApplicationHelper
  def controller_name_as_page_title(controller_name)
    controller_name.humanize 
  end
end
