class UsersController < ApplicationController
  before_action :authenticate_request!, :only => [:update, :show]
  wrap_parameters :user, include: [:email, :password, :password_confirmation, :username, :age, :birth_place, :date_of_birth, :address, :gender]
  
  def create
    user = User.new(user_params)

    if user.save
      render json: {status: 'User created Successfully', token: user.confirmation_token}, status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :bad_request
    end
  end

  def confirm
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)

    if user.present? && user.confirmation_token_valid?
      user.mark_as_confirmed!
      render json: {status: 'User confirmed successfully'}, status: :ok
    else
      render json: {status: 'Invalid token'}, status: :not_found
    end
  end

  def update
    if @current_user.update(update_params)
      render json: {status: 'User details updated successfully'}
    else
      render json: {errors: user.errors.full_messages}, status: :bad_request
    end
  end

  def show
    if @current_user
      render json: {user: @current_user }, status: :ok
    else
      render json: {errors: 'Invalid user' }, status: :bad_request
    end
  end

  def login
    user = User.find_by(email: params[:email].to_s.downcase)

    if user && user.authenticate(params[:password])
      generate_token(user)
    else
      rate_limit_exceeded?(params[:email])? notify_rate_limit_exceeded : invalid_request
      @rate_limit_counter.increment
    end
  end

  def generate_token(user)
    if user.confirmed_at?
      auth_token = JsonWebToken.encode({user_id: user.id})
      render json: {auth_token: auth_token}, status: :ok
    else
      render json: {error: 'Email not verified'}, status: :unauthorized
    end
  end

  def notify_rate_limit_exceeded
    render json: {error: 'You have fired too many requests. Please try after 5 minutes.'}, status: :too_many_requests
  end

  def invalid_request
    render json: {error: 'Invalid username/password'}, status: :unauthorized
  end


  private

  def rate_limit_exceeded?(email)
    @rate_limit_counter = LoginCounter.new(email)
    @rate_limit_counter.rate_limiting_exceeded?
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :age, :birth_place, :date_of_birth, :address, :gender)
  end
  def update_params
    params.require(:user).permit(:username, :age, :birth_place, :date_of_birth, :address, :gender)
  end
end
