class ShopValidator < ActiveModel::Validator
  def validate(record)
    if record.name.blank?
      record.errors[:name] << 'Name cannot be blank'
    end
    if record.address.blank?
      record.errors[:address] << 'Address cannot be blank'
    end
  end
end
