class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :equipment
      t.string :genre
      t.string :url
      t.string :self_introduction
      t.string :facebook
      t.string :twitter
      t.string :prof_image

      t.timestamps
    end
  end
end
