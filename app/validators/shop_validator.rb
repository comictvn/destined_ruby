class ShopValidator
  def validate_update(shop_params)
    errors = []
    if shop_params[:id].blank?
      errors << "ID can't be blank"
    end
    if shop_params[:name].blank?
      errors << "Name can't be blank"
    end
    if shop_params[:address].blank?
      errors << "Address can't be blank"
    end
    # Add more validation rules as needed
    if errors.any?
      return { valid: false, errors: errors }
    else
      return { valid: true }
    end
  end
end
