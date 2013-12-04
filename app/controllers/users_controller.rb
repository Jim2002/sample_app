class UsersController < ApplicationController
  before_action :sign_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user 
      flash[:success] = "Welcome to Jim's Sample App!"
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation) 
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      redirect_to(root_url) 
    end
  end


  def admin_user
    unless current_user.admin?
     redirect_to root_url 
    end
  end
   

   

end
