class Ability
  include CanCan::Ability

  def initialize(user)
    user = User.current_user

    if user.registrar?
      can :manage , Trainee
      can :manage , Count
      can :manage , StaffRecord
      can :registrar ,Task
      can :apply ,Flow
      can :view ,Flow
    end
    if user.approval?
      can :approve ,Flow
      can :manage , Count
      can :approval , Task
      can :operate , StaffRecord
      can :query , StaffRecord
    end
  end
end
