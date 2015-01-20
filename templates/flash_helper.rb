module FlashHelper
  ALERT_SEVERITIES = {
    'notice'  => 'alert-success',
    'info'    => 'alert-info',
    'warning' => 'alert-warning',
    'alert'   => 'alert-danger',
  }

  def alert_class(key)
    ALERT_SEVERITIES.fetch(key)
  end

  ALERT_ICONS = {
    'notice'  => 'check-circle',
    'info'    => 'info-circle',
    'warning' => 'exclamation-triangle',
    'alert'   => 'exclamation-circle',
  }

  def alert_icon(key, *args)
    icon ALERT_ICONS.fetch(key), *args
  end

  def close_alert
    button_tag aria: { label: 'Close' }, class: 'close', data: { dismiss: 'alert' }, type: 'button' do
      content_tag :span, raw('&times;'), aria: { hidden: true }
    end
  end

  # Devise stores data in the flash that is not meant to be displayed
  IGNORED_FLASH_KEYS = %w[ timedout ]

  def printable_flash
    flash.reject { |key, _| IGNORED_FLASH_KEYS.include? key }
  end
end
