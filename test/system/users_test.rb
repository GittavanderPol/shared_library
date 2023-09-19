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
      fill_in "Whatsapp", with: "+31612345678"
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

    user = User.find_by(email: "olaf@shared-library.com")
    assert_equal "+31612345678", user.whatsapp
  end

  test "should not sign user up with invalid international whatsapp number" do
    visit new_user_registration_path
    within("form#new_user") do
      fill_in "Name", with: "Olaf"
      fill_in "Email", with: "olaf@shared-library.com"
      fill_in "Whatsapp", with: "0612345678"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_on "Sign up"
      assert_text "Whatsapp number is not a valid international phone number"
    end
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

  test "should open whatsapp when clicking the whatsapp button" do
    user = users(:gitta)
    user_2 = users(:bob)

    sign_in user
    visit user_path(user_2)
    whatsapp_link = find_link('Write Bob')
    assert whatsapp_link.visible?
    assert_equal "https://wa.me/31610203040", whatsapp_link[:href]
  end

  test "should not display whatsapp button for friend without whatsapp number" do
    user = users(:gitta)
    user_2 = users(:jannie)

    sign_in user
    visit user_path(user_2)
    assert_no_text "Write Jannie"
  end

  test "should add whatsapp number to existing user and edit the number" do
    user = users(:helen)
    number = "+31674937429"
    other_number = "+31655443322"
    password = "password"

    sign_in user
    visit edit_user_registration_path(user)
    fill_in "Whatsapp number", with: number
    fill_in "Current password", with: password

    wait_until_changes("user.reload.whatsapp") do
      click_on "Update"
    end

    assert_equal number, user.whatsapp

    visit edit_user_registration_path(user)
    fill_in "Whatsapp number", with: other_number
    fill_in "Current password", with: password

    wait_until_changes("user.reload.whatsapp") do
      click_on "Update"
    end

    assert_equal other_number, user.whatsapp
  end
end
