class CustomerResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :name
  attribute :address
  attribute :phone
  attribute :created_at, form: false
  attribute :updated_at, form: false

  # 


  # Uncomment this to customize the display name of records in the admin area.
  def self.display_name(record)
    record.phone
  end

  # Uncomment this to customize the default sort column and direction.
  # def self.default_sort_column
  #   "created_at"
  # end
  #
  # def self.default_sort_direction
  #   "desc"
  # end
end
