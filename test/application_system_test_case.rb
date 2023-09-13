require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def within_table_row_for(model, &block)
    within("##{dom_id(model)}") do
      yield
    end
  end

  def find_mail_to(email)
    ActionMailer::Base.deliveries.find { |mail| mail.to.include?(email) }
  end

  def wait_for_mail_to(email)
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { !find_mail_to(email).nil? }
  end
end
