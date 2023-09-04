require "test_helper"

class ConnectionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in users(:gitta)
  end

  test "list incoming friend requests" do
    user = users(:gitta)
    connections_to_accept = user.connections_to_accept

    get connections_path

    assert_select "h3", "Incoming friend requests"
    connections_to_accept.take(2).each_with_index do |connection, index|
      assert_select "table > tbody > tr:nth-child(#{index + 1}) > td", connection.sender.name
      assert_select "table > tbody > tr:nth-child(#{index + 1}) > td > form", "Decline"
      assert_select "table > tbody > tr:nth-child(#{index + 1}) > td > form", "Accept"
    end
  end

  test "list sent friend requests" do
    user = users(:gitta)
    connections_sent = user.connections_sent

    get connections_path

    assert_select "h3", "Sent friend requests"
    connections_sent.take(2).each_with_index do |connection, index|
      assert_select "body:nth-child(2) > table > tbody > tr:nth-child(#{index + 1}) > td", connection.recipient.name
      assert_select "body:nth-child(2) > table > tbody > tr:nth-child(#{index + 1}) > td > form", "Cancel"
    end
  end

  test "sends a connection" do
    user = users(:gitta)
    user_2 = users(:jason)

    get new_connection_path
    assert_difference("Connection.count", 1) do
      post connections_path, params: { connection: { recipient_email: user_2.email } }
    end
    assert_redirected_to users_path
    follow_redirect!

    get connections_path
    last_connection = user.connections_sent.last
    assert_select "body:nth-child(2) > table > tbody > tr:nth-last-child(1) > td", last_connection.recipient.name
    assert_select "body:nth-child(2) > table > tbody > tr:nth-last-child(1) > td > form", "Cancel"

    assert_equal "Jason", last_connection.recipient.name
  end

  test "receives a connection" do
    user = users(:gitta)
    user_2 = users(:jason)

    Connection.create!(sender: user_2, recipient: user, connection_status: "requested")
    get connections_path
    last_connection = user.connections_to_accept.last
    assert_select "table > tbody > tr:nth-last-child(1) > td", last_connection.sender.name
    assert_select "table > tbody > tr:nth-last-child(1) > td > form", "Decline"
    assert_select "table > tbody > tr:nth-last-child(1) > td > form", "Accept"

    assert_equal "Jason", last_connection.sender.name
  end

  test "accepts a connection" do
    user = users(:gitta)
    user_2 = users(:jason)

    connection = Connection.create(sender: user_2, recipient: user, connection_status: "requested")

    post accept_connection_path(connection)

    connection.reload

    assert_equal user_2, connection.sender
    assert_equal user, connection.recipient
    assert_equal "connected", connection.connection_status

    assert_redirected_to connections_path
  end
end
