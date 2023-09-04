require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def within_table_row(number, &block)
    within("table tr:nth-child(#{number})") do
      yield
    end
  end
end
