module FlashHelper
  SEVERITIES = {
    'notice'  => 'alert-success',
    'warning' => 'alert-warning',
    'alert'   => 'alert-danger',
  }.tap { |h| h.default = 'alert-info' }

  SEVERITY_ICONS = {
    'notice'  => 'check',
    'warning' => 'exclamation-triangle',
    'alert'   => 'exclamation-circle',
  }.tap { |h| h.default = 'info-circle' }

  IGNORED_FLASH_KEYS = %w[timedout]

  def alert_class(severity)
    SEVERITIES[severity]
  end

  def alert_icon(severity)
    SEVERITY_ICONS[severity]
  end

  def printable_flash
    flash.reject { |key, _| key.in? IGNORED_FLASH_KEYS }
  end
end
