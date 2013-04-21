class Ability
  include CanCan::Ability
  
  def initialize(user)

    if user.registrar?
      can :manage , Trainee
      can :manage , Count
      can :manage , StaffRecord
      can :registrar ,Task
      can :index, Count
      can [:create,:destroy], Modify
    end
    
    if user.rightsman?
      
    end

    if user.approval?
      can :manage , Count
      can :manage , Examine
      can :update , Modify
      can :approval , Task
      can [:operate,:update] , StaffRecord
    end
  end
end
