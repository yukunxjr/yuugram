class PostsController < ApplicationController

    # :authenticate_user!はdeviseが用意しているヘルパー
    # サインインしていない状態でnewアクションやcreateアクションを実行しようとすると、サインインページにリダイレクト
    before_action :authenticate_user!

    # @post = Post.find_by(id: params[:id])をshowとdestroyに最初に適用
    before_action :set_post, only: %i(show destroy create)

    def new
        @post = Post.new
        @post.photos.build
    end

    def create
        @post = Post.new(post_params)

        # present?はnilまたは空のオブジェクト（例えば空の配列）でなければtrueを返します。
        # なので@post.photosが空のオブジェクトでなければtrue、それ以外ならfalse
        if @post.photos.present?
          @post.save
          redirect_to root_path
          flash[:notice] = "投稿が保存されました"
        else
          redirect_to root_path
          flash[:alert] = "投稿に失敗しました"
        end
    end

    def index
      # includesメソッドを使うことで必要な情報のみを拾ってくるため処理が早くなる
      # 今回の場合では:photosと:userのみ拾ってくる。
      @posts = Post.limit(10).includes(:photos, :user).order('created_at DESC')
    end

    def show
      @post = Post.find_by(id: params[:id])
    end

    def destroy
      @post = Post.find_by(id: params[:id])

      # 投稿したユーザーと現在サインインしているユーザーが等しければ、真を返す条件式
      if @post.user == current_user
        # @post.destroyが真だったら、「投稿が削除されました」というフラッシュメッセージを表示
        flash[:notice] = "投稿が削除されました" if @post.destroy
      else
        flash[:alert] = "投稿の削除に失敗しました"
      end
      redirect_to root_path
    end
    
    private
        def post_params
            # paramsとは送られてきたリクエスト情報をひとまとめにしたものです。
            # requireで受け取る値のキーを設定します。
            # permitで変更を加えられるキーを指定します。今回の場合、captionキーとimageキーを指定しています。
            # mergeメソッドは2つのハッシュを統合するメソッドです。今回は誰が投稿したかという情報が必要なためuser_idの情報を統合しています。
          params.require(:post).permit(:caption, photos_attributes: [:image]).merge(user_id: current_user.id)
        end

        def set_post
          @post = Post.find_by(id: params[:id])
        end
end
