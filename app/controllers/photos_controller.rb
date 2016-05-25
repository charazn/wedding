class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :upvote, :undo_upvote]
  before_action :correct_user, only: [:edit, :update, :archive]
  before_action :find_admin, only: [:my_photos]
  before_action :set_photos, only: [:show, :hongkong, :singapore, :shanghai, :friends]

  def index
    photo = Photo.active.last
    if photo.hk?
      redirect_to hongkong_photos_path
    elsif photo.sg?
      redirect_to singapore_photos_path
    elsif photo.sh?
      redirect_to shanghai_photos_path
    end
  end

  def show
    @comment = Comment.new
    set_next_and_previous_photo
  end

  def hongkong
    @admin_hk_photos = @admin.photos.active.hk.sort
  end

  def singapore
    @admin_sg_photos = @admin.photos.active.sg.sort
  end

  def shanghai
    @admin_sh_photos = @admin.photos.active.sh.sort
  end

  def friends
    @friends_photos = @photos.recent_first - @admin_photos.recent_first
  end

  def my
    @my_photos = current_user.photos.active.recent_first unless current_user == @admin
  end

  def new
    @photo = Photo.new
  end

  def create
    params[:images].each do |image|
      @current_user.photos.build(image: image, location: params[:photo][:location].to_i)
    end

    if @current_user.save
      redirect_to photos_path, notice: 'Photos successfully uploaded'
    else
      flash[:error] = 'Photos were not saved successfully. Please try again.'
      render :new
    end
  end

  def edit
  end

  def update
    if @photo.update(photo_params)
      redirect_to @photo, notice: 'Photo successfully updated'
    else
      render :edit
    end
  end

  def archive
    @photo.comments.active.each { |comment| comment.archived! }
    @photo.archived!
    redirect_to photos_path, notice: 'Photo successfully deleted'
  end

  def upvote
    @photo.liked_by(current_user)
    redirect_back_or_to @photo
  end

  def undo_upvote
    @photo.unliked_by(current_user)
    redirect_back_or_to @photo
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def correct_user
    @photo = current_user.photos.find_by(id: params[:id])
    redirect_to photos_path, notice: 'You are not the author of this photo' if @photo.nil?
  end

  def photo_params
    params.require(:photo).permit(:caption, :image, :images, :location)
  end

  def find_admin
    @admin = User.find_by(role: 0)
  end

  def set_photos
    find_admin
    @photos = Photo.active
    @admin_photos = @admin.photos.active
  end

  def set_next_and_previous_photo
    if @photo.user.admin?
      @next_photo = @admin_photos.where('id > ?', params[:id]).limit(1).first || @photo
      @previous_photo = @admin_photos.where('id < ?', params[:id]).last || @photo
      if @photo == @admin_photos.last
        @next_photo = @admin_photos.first
      elsif @photo == @admin_photos.first
        @previous_photo = @admin_photos.last
      end
    else
      friends_photos_count = @friends_photos.count
      photo_index = @friends_photos.find_index(@photo)
      if friends_photos_count - 1 == photo_index
        @next_photo = @friends_photos.first
      else
        @next_photo = @friends_photos[photo_index + 1]
      end
      @previous_photo = @friends_photos[photo_index - 1]
    end
  end

end
