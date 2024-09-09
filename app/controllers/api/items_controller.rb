class Api::ItemsController < Api::BaseController
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    items = Item.all
    render json: ItemSerializer.new(items).serializable_hash, status: :ok
  end

  def show
    render json: ItemSerializer.new(@item).serializable_hash, status: :ok
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item).serializable_hash, status: :created
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: ItemSerializer.new(@item).serializable_hash, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    head :no_content
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :price, :discounted_price, :collection_id)
  end
end