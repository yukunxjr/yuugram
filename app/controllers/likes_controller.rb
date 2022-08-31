class LikesController < ApplicationController
    # サインイン済みユーザーのみにアクセス許可
    before_action :authenticate_user!

    def create
        @like = current_user.likes.build(like_params)
        @post = @like.post
        if @like.save
          respond_to :js
        end
    end

    def destroy
        @like = Like.find_by(id: params[:id])
        @post = @like.post
        if @like.destroy
          respond_to :js
        end
      end
    
    private
    # paramsとは送られてきたリクエスト情報をひとまとめにしたものです。
    # permitで変更を加えられるキーを指定します。今回の場合、post_idキーを指定しています。
    # いいねを押したときに、どの投稿にいいねを押したのかpost_idの情報を変更できるように指定しています
    def like_params
        params.permit(:post_id)
    end
end
