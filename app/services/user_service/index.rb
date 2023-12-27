# rubocop:disable Style/ClassAndModuleChildren
class UserService::Index
  include Pundit::Authorization

  attr_accessor :params, :records, :query

  def initialize(params, current_user = nil)
    @params = params
    @current_user = current_user
    @records = UserPolicy::Scope.new(current_user, User).resolve
  end

  def execute
    filter_and_paginate_users
  end

  private

  def filter_and_paginate_users
    filter_by_phone_number(params.dig(:users, :phone_number))
    filter_by_first_name(params.dig(:users, :firstname))
    filter_by_last_name(params.dig(:users, :lastname))
    filter_by_dob(params.dig(:users, :dob))
    filter_by_gender(params.dig(:users, :gender))
    filter_by_interests(params.dig(:users, :interests))
    filter_by_location(params.dig(:users, :location))
    filter_by_email(params.dig(:users, :email))
    order_records
    paginate_records
  end

  def filter_by_phone_number(phone_number)
    @records = @records.where('phone_number LIKE ?', "%#{phone_number}%") if phone_number.present?
  end

  def filter_by_first_name(first_name)
    @records = @records.where('firstname LIKE ?', "%#{first_name}%") if first_name.present?
  end

  def filter_by_last_name(last_name)
    @records = @records.where('lastname LIKE ?', "%#{last_name}%") if last_name.present?
  end

  def filter_by_dob(dob)
    @records = @records.where('dob = ?', dob) if dob.present?
  end

  def filter_by_gender(gender)
    @records = @records.where('gender = ?', gender) if gender.present?
  end

  def filter_by_interests(interests)
    @records = @records.where('interests LIKE ?', "%#{interests}%") if interests.present?
  end

  def filter_by_location(location)
    @records = @records.where('location LIKE ?', "%#{location}%") if location.present?
  end

  def filter_by_email(email)
    @records = @records.where('email LIKE ?', "%#{email}%") if email.present?
  end

  def order_records
    @records = @records.order('created_at DESC')
  end

  def paginate_records
    page = params.dig(:pagination, :page) || 1
    limit = params.dig(:pagination, :limit) || 20
    @records = @records.page(page).per(limit)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
