class Schema
  def self.create
    create_table :organizations, force: true do |t|
      t.string :name
      t.integer :parent_id
    end

    create_table :investments, force: true do |t|
      t.string :name
      t.integer :cost
      t.integer :organization_id
    end
  end

  def self.create_table(*args, &block)
    ActiveRecord::Base.connection.create_table *args, &block
  end
end
