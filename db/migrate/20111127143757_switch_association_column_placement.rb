class SwitchAssociationColumnPlacement < ActiveRecord::Migration
  # The problem with your original setup was that despite the User belonging to a Zodiac and
  # a Zodiac having many users, the placement of the column in your schema was reversed. As a
  # rule of thumb the foreign key column goes on the table for the model which belongs_to another.
  def up
    remove_column :zodiacs, :user_id
    add_column :users, :zodiac_id, :integer
  end

  def down
    remove_column :users, :zodiac_id
    add_column :zodiacs, :user_id, :integer
  end
end
