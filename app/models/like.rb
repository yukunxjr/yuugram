class Like < ApplicationRecord
    belongs_to :user
    belongs_to :post
    
    # user_idとpost_idの組み合わせが重複していないことを検証
    # ユーザーは１post（記事）に対して１like（いいね）しかできない
    validates :user_id, uniqueness: { scope: :post_id }


    def liked_by(user)
        # user_idとpost_idが一致するlikeを検索する
        Like.find_by(user_id: user.id, post_id: id)
    end
end
