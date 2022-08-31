class Post < ApplicationRecord
    # userテーブルと１対多の関係
    belongs_to :user

    # photoテーブルと１対多の関係
    # postテーブルが削除されると必然とphotoテーブルも削除される
    has_many :photos, dependent: :destroy

    has_many :likes, -> { order(created_at: :desc) }, dependent: :destroy

    # 親子関係のある関連モデル(今回でいうとPostモデルとPhotoモデル）で、親から子を作成したり保存するときに使用
    # 投稿する際にPostモデルの子に値するPhotoモデルを通して、photosテーブルに写真を保存します
    accepts_nested_attributes_for :photos
end
