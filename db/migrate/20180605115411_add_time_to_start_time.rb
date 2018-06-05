class AddTimeToStartTime < ActiveRecord::Migration[5.1]
  def change
    add_column :start_times, :time, :string
  end
end
