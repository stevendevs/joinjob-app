class ApplicationController < ActionController::Base
  # Autenticación del usuario antes de cualquier acción
  before_action :authenticate_user!


  include Pundit::Authorization
  include Pundit
  protect_from_forgery
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Incluir funcionalidad de PublicActivity para registrar acciones del usuario actual
  include PublicActivity::StoreController

  # Protección contra ataques CSRF
  protect_from_forgery

  # Permitir solo navegadores modernos (si tienes configurado este método)
  allow_browser versions: :modern

  # Manejo de errores de autorización con Pundit

  private


  def user_not_authorized #pundit
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
 
end
