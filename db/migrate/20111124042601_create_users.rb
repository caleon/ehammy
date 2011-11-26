class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email   
      t.date :birthday
      t.boolean :sex
      t.string :salt

      t.timestamps
    end
  end
end
