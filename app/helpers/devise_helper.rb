

module DeviseHelper

  def devise_error_messages!
    flash_alerts = []
    error_key = 'errors.messages.not_saved'

    if !flash.empty?
      flash_alerts.push(flash[:error]) if flash[:error]
      flash_alerts.push(flash[:alert]) if flash[:alert]
      flash_alerts.push(flash[:notice]) if flash[:notice]
      error_key = 'devise.failure.invalid'
    end

    return "" if resource.errors.empty? && flash_alerts.empty?
    errors = resource.errors.empty? ? flash_alerts : resource.errors.full_messages

    messages = errors.map { |msg| msg != 'Signed out successfully.' ? content_tag(:li, msg) : '' }.join
    count_err = resource.errors.count
    sentence = I18n.t("errors.messages.not_saved",
                           count: count_err ? errors.size : count_err,
                           resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      
      <ul>#{messages}</ul>
      
    </div>
    HTML

    html.html_safe
  end

end