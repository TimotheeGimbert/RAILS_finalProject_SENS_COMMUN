class CreatePrivateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :private_messages do |t|
      t.string :object
      t.text :content
      t.references :author, polymorphic: true, null: false

      t.timestamps
    end
  end
end
