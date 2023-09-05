require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def within_table_row_for(model, &block)
    within("##{dom_id(model)}") do
      yield
    end
  end
end
