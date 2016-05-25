class CommentsController < ApplicationController
  before_action :set_photo

  def create
    @comment = @photo.comments.build(comment_params)
    @comment.commenter = current_user
    if @comment.save
      redirect_to @photo, notice: "Comment added successfully!"
    else
      flash[:error] = "Comment could not be added."
      redirect_to @photo
    end
  end

  def edit
    @comment = @photo.comments.find(params[:id])
  end

  def update
    @comment = @photo.comments.find(params[:id])
    if @comment.update_attributes(comment_params)
      redirect_to @photo, notice: "Comment updated successfully!"
    else
      render :edit
    end
  end

  def archive
    @comment = @photo.comments.find(params[:id])
    @comment.archived!
    redirect_to photo_path(@photo), notice: 'Comment successfully deleted'
  end

  private

  def set_photo
    @photo = Photo.find_by(id: params[:photo_id])
  end

  def comment_params
    params.require(:comment).permit(:message)
  end

end
