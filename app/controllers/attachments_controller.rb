class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    authorize! :destroy, ActiveStorage::Attachment
    @file = ActiveStorage::Attachment.find(params[:id])
    if current_user.author_of?(@file.record)
      @file.purge
    end
  end
end
