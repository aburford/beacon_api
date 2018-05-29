class AddHashToClassSession < ActiveRecord::Migration[5.1]
  def change
    add_column :class_sessions, :hash, :string
  end
end
