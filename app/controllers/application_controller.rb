class ApplicationController < ActionController::Base

  def has_user_rights?
    redirect_back fallback_location: root_path unless (user_signed_in? == true || admin_signed_in? == true)
  end

  def has_admin_rights?
    redirect_back fallback_location: root_path unless admin_signed_in? == true
  end

  def is_legal_rep?
    
  end

end
