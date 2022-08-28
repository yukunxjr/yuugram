class AddNameToUser < ActiveRecord::Migration[7.0]
  # null:falseをつけるとNotnull制約になる。
  # ユーザー名に何も入ってない状態でユーザーが作成されると困るのでNOT NULL制約を追加
  def change
    add_column :users, :name, :string, null: false
  end
end
