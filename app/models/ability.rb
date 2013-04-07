class Ability
  include CanCan::Ability

  def initialize(user)
    user = User.current_user

    if user.registrar?
      can :manage , Trainee
      can :manage , Count
      can :manage , StaffRecord
      can :registrar ,Task
   #   can :index ,Homes
#     can :apply ,Flow
#     can :view ,Flow
    else  user.approval?
#       can :approve ,Flow
    #  can :index ,Homes
      can :access, :Task

      can :manage , Count
      can  :approval , Task
      cannot :manage , Trainee   
    end
  end
end
