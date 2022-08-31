class User < ApplicationRecord

  # オブジェクトが削除されるときに、関連付けられたオブジェクトのdestroyメソッドが実行されます。
  # つまり今回で言うと、ユーザーが削除されたら、そのユーザーに紐づく投稿も削除します。
  has_many :posts, dependent: :destroy

  has_many :likes

  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }

  def update_without_current_password(params, *options)
    # if フォームのパスワード欄が空欄？
    #   　　　パラメータのパスワード情報を削除
    #   　　　パラメータのパスワード確認情報を削除
    #   　　　パラメータの現在のパスワード情報を削除
    #   　　　結果=self.update(名前情報,メールアドレス情報)
    #   else #(フォームのパスワード欄に入力が有りの場合)
    #   　　　current_password=パラメータの現在のパスワード情報
    #   　　　result= if 現在のパスワードが正しい？
    #           結果=self.update(名前情報,メールアドレス情報,パスワード情報,パスワード確認情報)
    #        else#(フォームの現在のパスワード欄に入力誤りの場合)
    #           更新中の値（名前情報,メールアドレス情報,パスワード情報,パスワード確認情報）をフォームの各欄に戻す
    #   　　　　　現在のパスワードがエラーになった理由を返す。
    #   　　　end
    #   end
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
      params.delete(:current_password)
      result = update(params, *options)
    else
      current_password = params.delete(:current_password)
      result = if valid_password?(current_password)
        update(params, *options)
      else
        assign_attributes(params, *options)
        valid?
        errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end
    end

    clean_up_passwords
    result
  end

end
