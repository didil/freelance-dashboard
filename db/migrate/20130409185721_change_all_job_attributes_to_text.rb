class ChangeAllJobAttributesToText < ActiveRecord::Migration
  def up
    change_column :jobs , :title , :text
    change_column :jobs , :keywords , :text
  end

  def down
    change_column :jobs , :title , :string
    change_column :jobs , :keywords , :string
  end
end
