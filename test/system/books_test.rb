require "application_system_test_case"

class BooksTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in users(:gitta)
  end

  test "visiting the index" do
    visit books_path
    assert_equal 3, find("#books").all("tbody tr").count
    assert_selector "h1", text: "All books"
    assert_text "Oorsprong"
    assert_text "Dan Brown"
  end

  test "search for Book" do
    book = books(:harry_potter)
    visit books_path
    fill_in name: "query", with: "Potter"
    click_on "Search"

    assert_current_path books_path
    assert_text book.title
    assert_equal 1, find("#books").all("tbody tr").count
  end

  test "go to User page" do
    book = books(:wool)
    visit books_path
    within_table_row_for(book) do
      click_on book.owner.name
    end

    assert_current_path user_path(book.owner)
    assert_selector "h1", text: book.owner.name
  end

  test "should create Book" do
    visit books_path
    click_on "Add book"
    fill_in "Title", with: "Creating a book"
    fill_in "Author", with: "Dean Shawn"
    click_on "Create Book"
    assert_text "Creating a book"
  end

  test "should fail creating new Book" do
    visit books_path
    click_on "Add book"
    fill_in "Title", with: "Creating a book"
    click_on "Create Book"
    assert_text "Can't be blank"
  end

  test "should update Book" do
    book = books(:wool)

    visit books_path

    within_table_row_for(book) do
      click_on "Edit"
    end

    assert_equal find_field("Author").value, book.author
    assert_equal find_field("Title").value, book.title

    fill_in "Title", with: "Wool2"
    click_on "Update Book"

    assert_text "Wool2"
  end

  test "should fail updating a book" do
    book = books(:wool)

    visit books_path

    within_table_row_for(book) do
      click_on "Edit"
    end

    assert_equal find_field("Author").value, book.author
    assert_equal find_field("Title").value, book.title

    fill_in "Title", with: ""
    click_on "Update Book"

    assert_text "Can't be blank"
    visit books_path
    assert_text "Wool"
  end

  test "should delete Book" do
    book = books(:wool)
    visit books_path

    within_table_row_for(book) do
      accept_alert do
        click_on "Delete"
      end
    end

    assert_current_path books_path
    assert_no_text "Wool"
    assert_not Book.exists?(book.id)
  end
end
