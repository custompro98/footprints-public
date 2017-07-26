class ApplicationController < ActionController::Base
  attr_accessor :repo

  def current_user
    @current_user = repo.user.find_by_id(session[:user_id]) if session[:user_id]
  end

  def admin?
    current_user.admin?
  end
  helper_method :admin?

  protected
  def repo
    Footprints::Repository
  end

  def authenticate
    if !current_user || current_user.uid == nil
      session[:return_to] = request.url
      redirect_request
    end
  end

  # TODO: Checking email substrings is a bad idea. Use the attribute on the model instead
  def employee?
    redirect_to(oauth_signin_url, :notice => "You don't have permission to view this page.") unless current_user && current_user.employee?
  end

  def require_admin
    if !current_user.admin
      flash[:error] = ["You are not authorized to view this page"]
      redirect_to(root_url)
    end
  end

  def redirect_request
    if is_ajax_request
      redirect_to oauth_signin_url, :status => :unauthorized
    else
      redirect_to oauth_signin_url, :notice => "Please sign in through Google."
    end
  end

  # TODO: I would think we could leverage this for logging
  def is_ajax_request
    request.headers["X-Requested-With"] == "XMLHttpRequest"
  end
end
