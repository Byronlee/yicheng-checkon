class Ability
  include CanCan::Ability
  
  def initialize(user)

    if user.registrar?
      can :manage , Trainee
      can :manage , Count
      can :manage , StaffRecord
      can :registrar ,Task
    end
    
    if user.registrar?
      can :create, Modify
    end

    if user.approval?
      can :manage , Count
      can :approval , Task
      can :operate , StaffRecord
    end
  end
end
