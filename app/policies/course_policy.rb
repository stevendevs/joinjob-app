class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    return false unless @user
    @user.has_role?(:admin) || @record.user_id == @user.id
  end

  def update?
    return false unless @user
    @user.has_role?(:admin) || @record.user_id == @user.id
  end

  def new?
    return false unless @user
    @user.has_role?(:teacher)
  end

  def create?
    return false unless @user
    @user.has_role?(:teacher)
  end

  def destroy?
    return false unless @user
    @user.has_role?(:admin) || @record.user_id == @user.id
  end
end
