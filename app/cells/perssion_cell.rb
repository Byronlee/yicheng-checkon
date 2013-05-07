class PerssionCell < Cell::Rails

  def operate arg
    @user = arg[:user]
    if @user[:state]
      render :view => :cancel
    else
      render :view => :authorize
    end
  end
end
