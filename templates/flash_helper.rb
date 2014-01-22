module FlashHelper
  ALERT_CLASSES = { notice: 'alert-success', alert: 'alert-danger', warning: 'alert-warning' }

  def alert_class(level)
    ALERT_CLASSES.fetch(level) { 'alert-info' }
  end
end
