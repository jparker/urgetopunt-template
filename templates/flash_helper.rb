module FlashHelper
  SEVERITIES = {
    alert:  'alert alert-danger',
    notice: 'alert alert-success',
  }.tap { |h| h.default = 'alert alert-info' }

  def flash_div(severity)
    content_tag :div, class: SEVERITIES[severity], data: {dismiss: 'alert'} do
      content_tag :p, class: 'lead' do
        content_tag(:span, raw('&times;'), class: 'close') + capture(&block)
      end
    end
  end
end
