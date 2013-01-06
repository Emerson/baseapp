class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :unique_token
      t.boolean :verified

      t.timestamps
    end
  end
end
