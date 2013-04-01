class Ability
  include CanCan::Ability

  def initialize(user)
    user = User.current_user

    if user.role.include? "Registrar"
      can :action ,:controller

    end
    if user.role.include? "Approval" 

    end
  end
end
