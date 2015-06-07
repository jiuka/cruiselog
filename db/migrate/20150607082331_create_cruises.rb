class CreateCruises < ActiveRecord::Migration
  def change
    create_table :cruises do |t|
      t.string :name
      t.text :description
      t.references :ship, index: true, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps null: false
    end
  end
end
