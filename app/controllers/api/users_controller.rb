class Api::UsersController < Api::BaseController
  USER_JSON = { only: %i[id name email created_at updated_at] }.freeze

  before_action :set_user, only: %i[show update destroy]

  # GET /api/users
  def index
    render json: User.order(:id).as_json(USER_JSON)
  end

  # GET /api/users/:id
  def show
    render json: @user.as_json(USER_JSON)
  end

  # POST /api/users
  def create
    user = User.new(user_params)
    if user.save
      render json: user.as_json(USER_JSON), status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_content
    end
  end

  # PATCH/PUT /api/users/:id
  def update
    if @user.update(user_update_params)
      render json: @user.as_json(USER_JSON)
    else
      render json: { errors: @user.errors }, status: :unprocessable_content
    end
  end

  # DELETE /api/users/:id
  def destroy
    @user.destroy!
    head :no_content
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
