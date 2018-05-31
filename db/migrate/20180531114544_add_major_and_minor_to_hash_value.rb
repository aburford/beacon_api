class AddMajorAndMinorToHashValue < ActiveRecord::Migration[5.1]
  def change
    add_column :hash_values, :major, :string
    add_column :hash_values, :minor, :string
  end
end
