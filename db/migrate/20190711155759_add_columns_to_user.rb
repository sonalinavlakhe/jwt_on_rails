class AddColumnsToUser < ActiveRecord::Migration[5.2]
   def change
  	add_column :users, :username, :string
  	add_column :users, :age, :integer
  	add_column :users, :birth_place, :string
  	add_column :users, :date_of_birth, :string
  	add_column :users, :address, :text
  	add_column :users, :gender, :string
  end
end
