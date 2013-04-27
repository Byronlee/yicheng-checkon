class Ability
  include CanCan::Ability
  
  def initialize(user)

    if user.registrar?
      can :manage , Trainee
      can :manage , StaffRecord
      can :registrar ,Task
      can :index, Count
      can :update ,Examine
      can [:create,:destroy], Modify
    end
    
    if user.rightsman?
      can :manage , Perssion
    end

    if user.approval?
      can :manage , Count
      can [:index,:show,:create,:destroy] , Examine
      can :update , Modify
   #   can [:index,:search] , StaffRecord
      can :approval , Task
   #   can [:operate,:update] , StaffRecord
      can :manage ,StaffRecord
    end
  end
end
