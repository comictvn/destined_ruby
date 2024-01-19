class Category < ApplicationRecord
  # ... existing code ...

  def self.categories_exist?(category_names)
    where(name: category_names).count == category_names.size
  end
end
