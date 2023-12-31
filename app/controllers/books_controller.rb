class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:edit, :update, :destroy]

  def index
    @query = params[:query]
    @order_attribute, @order_direction = (params[:sort].presence || "author_asc").split("_")

    @books = Book.from_user_and_connections(current_user)
      .includes(:owner)
      .order_by(@order_attribute, @order_direction)
    @books = @books.search_by_title_and_author(@query) if @query.present?
    @pagy, @books = pagy(@books)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.owner = current_user

    if @book.save
      redirect_to books_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to books_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:author, :title)
  end

  def set_book
    @book = current_user.books.find(params[:id])
  end
end
