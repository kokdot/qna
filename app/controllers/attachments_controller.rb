class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    authorize! :destroy, ActiveStorage::Attachment
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge
  end
end
