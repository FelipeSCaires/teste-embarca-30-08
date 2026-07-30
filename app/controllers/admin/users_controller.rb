class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[edit update destroy]

  # GET /admin/users
  def index
    @users = User.order(:id)
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # POST /admin/users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "Usuário criado com sucesso."
    else
      render :new, status: :unprocessable_content
    end
  end

  # GET /admin/users/:id/edit
  def edit
  end

  # PATCH/PUT /admin/users/:id
  def update
    if @user.update(user_update_params)
      redirect_to admin_users_path, notice: "Usuário atualizado com sucesso."
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /admin/users/:id
  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "Você não pode excluir o usuário da sessão atual.", status: :see_other
    else
      @user.destroy!
      redirect_to admin_users_path, notice: "Usuário excluído com sucesso.", status: :see_other
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: [ :name, :email, :password, :password_confirmation ])
  end

  # Senha em branco no update e ignorada (permite editar so nome/email).
  def user_update_params
    attrs = user_params
    attrs = attrs.except(:password, :password_confirmation) if attrs[:password].blank?
    attrs
  end
end
