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
    if user.approval?
      can :approve ,Flow
      can :manage , Count
      can  :approval , Task
    end
  end
end
