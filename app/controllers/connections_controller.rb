class ConnectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @connections_to_accept = current_user.connections_to_accept.includes(:sender)
    @connections_sent = current_user.connections_sent.includes(:recipient)
  end

  def new
    @connection = Connection.new
  end

  def create
    recipient = User.find_by(email: create_params[:recipient_email]&.downcase)
    @connection = Connection.new(sender: current_user, recipient: recipient)

    unless recipient
      flash.now[:connection_errors] = ["Friend's email is incorrect or missing"]
      render :new, status: :unprocessable_entity
      return
    end

    if current_user.all_connections.where(sender_id: recipient).or(current_user.all_connections.where(recipient_id: recipient)).exists?
      flash.now[:connection_errors] = ["You cannot request this friend. Check your friend requests."]
      render :new, status: :unprocessable_entity
      return
    end

    if @connection.save
      flash[:notice] = "Friend request has been sent"
      redirect_to users_path
    else
      flash.now[:connection_errors] = @connection.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    @connection = current_user.connections_to_accept.find(params[:id])

    if @connection.update(connection_status: "connected")
      flash[:notice] = "Friend has been added"
      redirect_to connections_path
    else
      flash[:alert] = "Friend could not be added"
      redirect_to connections_path
    end
  end

  def decline
    @connection = current_user.connections_to_accept.find(params[:id])

    if @connection.destroy
      flash[:notice] = "Request has been declined"
      redirect_to connections_path
    else
      flash[:alert] = "Request could not be declined"
      redirect_to connections_path
    end
  end

  def cancel
    @connection = current_user.connections_sent.find(params[:id])

    if @connection.destroy
      flash[:notice] = "Request has been cancelled"
      redirect_to connections_path
    else
      flash[:alert] = "Request could not be cancelled"
      redirect_to connections_path
    end
  end

  def unfriend
    @connection = Connection.where(recipient_id: params[:user_id], sender_id: current_user.id)
      .or(Connection.where(recipient_id: current_user.id, sender_id: params[:user_id]))
      .first

    if @connection.destroy
      flash[:notice] = "Friend has been removed"
      redirect_to users_path
    else
      flash[:alert] = "Friend could not be removed"
      redirect_to users_path
    end
  end

  private

  def create_params
    params.require(:connection).permit(:recipient_email)
  end

end
