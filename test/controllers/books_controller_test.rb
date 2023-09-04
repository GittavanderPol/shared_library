require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in users(:gitta)
  end

  test "lists books" do
    user = users(:gitta)
    @books = Book.from_user_and_connections(user).order(:title)
    get books_path

    assert_select "h1", "All books"
    assert_select "table > tbody > tr", count: @books.count

    @books.take(3).each_with_index do |book, index|
      assert_select "tr:nth-child(#{index + 1}) td", book.title
    end
  end

  test "creates new book" do
    assert_difference("Book.count", 1) do
      post books_path, params: { book: { author: "Some author", title: "Some title" } }
    end
    assert_redirected_to books_path
    follow_redirect!
    new_book = Book.last
    assert_equal "Some title", new_book.title
    assert_includes response.body, "Some title"
  end

  test "fails creating a new book" do
    assert_no_difference("Book.count") do
      post books_path, params: { book: { title: "Should not be valid" } }
    end
    assert_template :new
    assert_response :unprocessable_entity
    assert_select "li", "Can't be blank"
  end

  test "updates a book" do
    @book = books(:wool)
    get edit_book_path(@book)
    assert_select "#book_title[value=?]", "Wool"
    assert_select "#book_author[value=?]", "Hugh Howey"

    patch book_path(@book), params: { book: { author: "Steve Jason", title: "An updated book" } }
    assert_redirected_to books_path
    follow_redirect!
    assert_select "h1", "All books"
    assert_includes response.body, "An updated book"
    assert_includes response.body, "Steve Jason"
  end

  test "fails updating a book" do
    @book = books(:wool)
    get edit_book_path(@book)
    assert_select "#book_title[value=?]", "Wool"
    assert_select "#book_author[value=?]", "Hugh Howey"
    patch book_path(@book), params: { book: { author: "Steve Jason", title: "" } }
    assert_select "li", "Can't be blank"
  end

  test "destroys a book" do
    user = users(:gitta)
    @book = books(:wool)
    @books = Book.from_user_and_connections(user)
    assert_difference("Book.count", -1) do
      delete book_path(@book)
    end
    assert_redirected_to books_path
    follow_redirect!
    assert_select "tbody tr", count: @books.count
  end

  test "searches for a specific title" do
    @book = books(:wool)
    get books_path, params: { query: "Wool" }
    assert_select "table > tbody > tr", count: 1
    assert_select "td", @book.title
  end
end
