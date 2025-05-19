class ApplicationController < ActionController::Base
  # Autenticación del usuario antes de cualquier acción
  before_action :authenticate_user!

  # Incluir funcionalidades de Pundit para autorización
  include Pundit::Authorization

  # Incluir funcionalidad de PublicActivity para registrar acciones del usuario actual
  include PublicActivity::StoreController

  # Protección contra ataques CSRF
  protect_from_forgery

  # Permitir solo navegadores modernos (si tienes configurado este método)
  allow_browser versions: :modern

  # Manejo de errores de autorización con Pundit

  private

 
end
