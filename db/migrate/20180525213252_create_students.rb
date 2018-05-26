class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :username
      t.string :auth_token

      t.timestamps
    end
  end
end
