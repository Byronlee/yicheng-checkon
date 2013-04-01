class Ability
  include CanCan::Ability

  def initialize(user)
    user = User.current_user

    if user.role.include? "Registrar"
      can :manage , Trainee
      can :manage , Count
      can :manage , StaffRecord
      can :registrar ,Task
    else
      cannot :manage , Trainee
      can :manage , Count
      cannot :manage , StaffRecord
      can  :approval , Task
    end
  end
end
