module ApplicationHelper

  def flash_message
    flash.map do |key, msg|
      content_tag :div, msg, :class => "flash #{key}"
    end.join
  end

end
