class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @notifications = current_user.passive_notifications.paginate(page: params[:page], per_page: 100)
  end
end
