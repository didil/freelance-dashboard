module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def flash_display
    response = ""
    flash.each do |name, msg|
      if msg.is_a?(String)
        response = response + '<div class="alert alert-' + (name == :notice ? "success" : "error") + '">'
        response = response + '<a class="close" data-dismiss="alert">&#215;</a>'
        response = response + content_tag(:div, msg, :id => "flash_#{name}")
        response = response + "</div>"
      end
    end
    flash.discard
    response
  end

end
