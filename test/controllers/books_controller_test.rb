require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in users(:gitta)
  end

  test "lists books" do
    get books_path

    assert_select "h1", "All books"
    assert_select "table > tbody > tr", count: Book.count

    Book.order(:title).take(3).each_with_index do |book, index|
      assert_select "tr:nth-child(#{index + 1}) td", book.title
    end
  end

  test "creates new book" do
    assert_difference("Book.count", 1) do
      post books_path, params: { book: { author: "Some author", title: "Some title" } }
    end
    assert redirect_to books_path
    follow_redirect!
    new_book = Book.last
    assert_equal "Some title", new_book.title
    assert_includes response.body, "Some title"
  end

  test "fails creating a new book" do
    assert_no_difference("Book.count") do
      post books_path, params: { book: { title: "Should not be valid" } }
    end
    assert redirect_to new_book_path
    assert_select "li", "Can't be blank"
  end

  test "shows a book" do
    @book = books(:wool)
    get book_path(@book)
    assert_select "h1", "Wool"
    assert_select "h6", "By Hugh Howey"
  end

  test "updates a book" do
    @book = books(:wool)
    get edit_book_path(@book)
    assert_select "#book_title[value=?]", "Wool"
    assert_select "#book_author[value=?]", "Hugh Howey"

    patch book_path(@book), params: { book: { author: "Steve Jason", title: "An updated book" } }
    assert redirect_to books_path
    follow_redirect!
    get book_path(@book)
    assert_select "h1", "An updated book"
    assert_select "h6", "By Steve Jason"

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
    @book = books(:wool)
    assert_difference("Book.count", -1) do
      delete book_path(@book)
    end
    assert redirect_to books_path
    follow_redirect!
    assert_select "tbody tr", count: Book.count
  end

  test "searches for a specific title" do
    @book = books(:wool)
    get books_path, params: { query: "Wool" }
    assert_select "table > tbody > tr", count: 1
    assert_select "td", @book.title
  end
end
