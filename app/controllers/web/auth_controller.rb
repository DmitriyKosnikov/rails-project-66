class Web::AuthController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']

    auth_params = { email: auth['info']['email'] }

    user = User.find_or_create_by auth_params
    user.nickname = auth['info']['nickname']
    user.name = auth['info']['name']
    user.email = auth['info']['email']
    user.image_url = auth['info']['image']
    user.token = auth['credentials']['token'] # Токен пользователя, потребуется нам позднее

    user.save!

    session[:user_id] = user.id

    redirect_to root_path, notice: t('.sign_in')
  rescue StandardError
    redirect_to root_path, alert: t('.error')
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path, notice: t('.sign_out')
  end
end
