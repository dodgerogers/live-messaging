class CreateMessagesTable < ActiveRecord::Migration
  def up
    create_table :messages do |t|
      t.integer :user_id
      t.string :text
      t.timestamps
    end
  end
  
  def down
    drop_table :messages
  end
end
