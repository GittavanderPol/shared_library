require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  test "should log user in" do
    user = users(:gitta)
    visit new_user_session_path
    fill_in "Email", with: "gitta@shared-library.com"
    fill_in "Password", with: "password"
    click_on "Log in"
    assert_text "Signed in successfully."
    assert_text "Gitta"
  end

  test "should not log user in without password" do
    user = users(:gitta)
    visit new_user_session_path
    fill_in "Email", with: "gitta@shared-library.com"
    click_on "Log in"
    assert_text "Invalid Email or password."
  end


  test "should sign user up" do
    visit new_user_registration_path
    within("form#new_user") do
      fill_in "Name", with: "Olaf"
      fill_in "Email", with: "olaf@shared-library.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_on "Sign up"
    end

    wait_for_mail_to("olaf@shared-library.com")
    sign_up_email = find_mail_to("olaf@shared-library.com")
    email_body = sign_up_email.body.raw_source

    assert_match "Welcome olaf@shared-library.com!", email_body

    parsed_email = Nokogiri::HTML(email_body)
    link_element = parsed_email.at("a")
    confirmation_link = link_element["href"]

    visit confirmation_link
    assert_text "Your email address has been successfully confirmed."
  end

  test "visiting the index" do
    user = users(:gitta)
    sign_in user
    visit users_path
    assert_selector "h1", text: "Your friends"
  end

  test "should create Connection" do
    user = users(:gitta)
    sign_in user
    visit users_path
    click_on "Add friend"
    assert_selector "h1", text: "Add a friend"
  end
end
