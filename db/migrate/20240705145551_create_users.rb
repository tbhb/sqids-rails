class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :sqid
      t.string :long_sqid
      t.timestamps
    end
  end
end
