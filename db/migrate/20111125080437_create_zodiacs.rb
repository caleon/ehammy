class CreateZodiacs < ActiveRecord::Migration
  def change
    create_table :zodiacs do |t|
      t.integer :user_id
      t.string :animal

      t.timestamps
    end
  end
end
