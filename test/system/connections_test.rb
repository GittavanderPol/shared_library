require "application_system_test_case"

class ConnectionsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in users(:gitta)
  end

  test "visiting the index" do
    visit connections_path
    assert_equal 2, find("#connections-received").all("tbody tr").count
    assert_equal 2, find("#connections-sent").all("tbody tr").count
    assert_selector "h3", text: "Incoming friend requests"
    assert_selector "h3", text: "Sent friend requests"
    assert_text "Marit"
    assert_text "Calvin"
  end

  test "should create Connection" do
    visit connections_path
    click_on "Add friend"
    fill_in "Friend's email", with: "jason@shared-library.com"
    click_on "Add friend"
    assert_selector "h1", text: "Your friends"
  end

  test "should accept Connection" do
    connection = connections(:three)
    visit connections_path
    within_table_row_for(connection) do
      click_on "Accept"
    end
    assert_text "Friend has been added"
  end

  test "should decline Connection" do
    connection = connections(:three)
    visit connections_path
    within_table_row_for(connection) do
      accept_alert do
        click_on "Decline"
      end
    end
    assert_text "Request has been declined"
  end

  test "should cancel sent connection" do
    connection = connections(:one)
    visit connections_path
    within_table_row_for(connection) do
      click_on "Cancel"
    end
    assert_text "Request has been cancelled"
  end
end
