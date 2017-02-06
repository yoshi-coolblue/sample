class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.string :name
      t.text :article_id_list
      t.string :status

      t.timestamps
    end
  end
end
