require "tweeter"

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create!(post_params)
    tweeter.tweet("#{@post.title} #{post_url(@post)}")

    redirect_to @post, notice: 'Post was successfully created.'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def tweeter
    @tweeter ||= Tweeter.new(Net::HTTP)
  end
end
