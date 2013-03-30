class Ability
  include CanCan::Ability

  def initialize(user)
    user = User.current_user
    if user.role.include? "Registrar"
      can :manage , Trainee
      can :manage , Count
      can :lanuch , WorkFlow
      can :manage , StaffRecord
    else
      cannot :manage , Trainee
      cannot :manage , StaffRecord
    end
  end
end
