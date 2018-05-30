class RemovePresentFromPresences < ActiveRecord::Migration[5.1]
  def change
    remove_column :presences, :present, :string
  end
end
