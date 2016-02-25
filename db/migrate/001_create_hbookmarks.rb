class CreateHbookmarks < ActiveRecord::Migration
  def self.up
    create_table :h_bookmarks do |t|
      t.string :title, null: false
      t.string :url, unique: true
      t.string :summary
      t.date :published
      t.boolean :slacked, default: false
    end
  end

  def self.down
    drop_table :h_bookmarks
  end
end
