class Ability
  include CanCan::Ability

  def initialize(user)
    user = User.current_user

    if user.registrar?
      can :manage , Trainee
      can :manage , Count
      can :manage , StaffRecord
      can :registrar ,Task
      can :apply ,Message
      can :view ,Message
    end
    if user.approval?
      can :approve ,Message
      can :manage , Count
      can :approval , Task
      can :operate , StaffRecord
      can :query , StaffRecord
    end
  end
end
