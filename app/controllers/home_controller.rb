class HomeController < ApplicationController
  
  before_action :authenticate_user!, only: [:upload, :create, :review, :review_destroy]
  
  def index
    @stores = Store.all
    @banner = @stores.sample
  end
  
  def detail
    @store = Store.find(params[:id])
  end
  
  def upload
    if user_signed_in? and current_user.admin == false
      flash[:warning] = 'Only admin can access.'
      redirect_to '/'
    end
  end
  
  def create
    Store.create(user_id: current_user.id,
                 title: params[:new_title],
                 img: params[:new_img],
                 intro: params[:new_intro])
    redirect_to "/"
  end
  
  
  def review
    Comment.create(user_id: current_user.id,
                   store_id: params[:shop_id].to_i,  
                   score: params[:rating].to_i, 
                   comment: params[:msg])
    redirect_to :back
  end
  
  def review_destroy
    Comment.destroy(params[:id])
    redirect_to :back
  end
  
  def destroy
    Store.destroy(params[:id])
    redirect_to :back
  end
  

  def edit
    @adjust = Store.find(params[:id])
  end
  
  def update
    shop = Store.find(params[:id])
    shop.title = params[:new_title]
    shop.img = params[:new_img]
    shop.intro = params[:new_intro]
    shop.save
    redirect_to '/'
  end
  
  def write
    comments = Comment.new(comment :params[:msg])
     if comments.save
        redirect_to '/home/detail'
     else
        render :text => comments.errors.messages[:msg]
     end
  end
end
