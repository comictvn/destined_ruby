class Api::ItemsController < Api::BaseController
  def fetch_latest_products
    page = params[:page].to_i
    limit = params[:limit].to_i
    offset = (page - 1) * limit

    query = Item.includes(:collection).order(id: :desc)

    query = query.limit(limit).offset(offset) if page > 0 && limit > 0

    products = ItemSerializer.new(query).serializable_hash[:data].map do |data|
      data[:attributes]
    end

    total_items = Item.count
    total_pages = (total_items.to_f / limit).ceil if limit > 0

    metadata = {
      current_page: page,
      total_pages: total_pages,
      total_items: total_items
    }.compact # Removes any nil values if pagination is not used

    render json: { products: products, metadata: metadata }, status: :ok
  end
end