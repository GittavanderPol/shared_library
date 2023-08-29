class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = current_user.connected_users.with_book_count
  end

  def show
    @user = current_user.connected_users_and_me.find(params[:id])
  end
end
