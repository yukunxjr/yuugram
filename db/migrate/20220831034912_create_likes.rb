class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      # reference型を指定したカラム名は テーブル名_id となる
      # referencesを指定したことで、生成されたモデルファイルにbelongs_toが追加される
      t.references :post, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
