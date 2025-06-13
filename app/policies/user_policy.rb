class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    return false unless @user
    @user.has_role?(:admin)
  end

  def update?
    return false unless @user
    @user.has_role?(:admin)
  end
end
