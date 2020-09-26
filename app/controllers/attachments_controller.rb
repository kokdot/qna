class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  
  def delete
    @file = ActiveStorage::Attachment.find(params[:id])
    @id = params[:id] if @file 
    if current_user.author_of?(@file.record)
      @file.purge
    end
  end
end
