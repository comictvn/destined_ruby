class Api::ItemsController < Api::BaseController
  def fetch_latest_products
    page = params[:page].to_i
    limit = params[:limit].to_i
    offset = (page - 1) * limit

    query = Item.joins(:collection).select(
      'items.id, items.name, items.price, items.discounted_price, collections.name as collection_name'
    ).order(id: :desc)

    query = query.limit(limit).offset(offset) if page > 0 && limit > 0

    products = query.map do |item|
      {
        id: item.id,
        name: item.name,
        price: item.price,
        imageUrl: item.image_url, # Assuming there is an image_url method or attribute for the item
        collection: item.collection_name,
        discounted_price: item.discounted_price
      }.compact # Removes any nil values if discounted_price is nil
    end

    total_items = Item.count
    total_pages = (total_items.to_f / limit).ceil if limit > 0

    metadata = {
      current_page: page,
      total_pages: total_pages,
      total_items: total_items
    }.compact # Removes any nil values if pagination is not used

    render_response(products, metadata: metadata)
  end
end