class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_SENDER'] || 'noreply@example.com'
  layout "mailer"
end
