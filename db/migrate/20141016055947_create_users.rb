class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :roles, array: true
      t.timestamps
    end

    add_index :users, :name
  end
end
