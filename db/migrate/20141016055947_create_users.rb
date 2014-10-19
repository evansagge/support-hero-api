class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :roles, array: true
      t.timestamps
    end
  end
end
