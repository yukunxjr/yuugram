class Photo < ApplicationRecord

    # postテーブルと１対多の関係を示す
    belongs_to :post
    # イメージカラムに対して値が空ではないということ確かめるバリデーション
    validates :image, presence: true
    # Uploaderをphotoモデルのイメージカラムに紐付け
    mount_uploader :image, ImageUploader
end
