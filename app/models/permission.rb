class Permission

  def self.assign roles
    roles.each do |role|
      # 多种角色有bug,roles应该是数组
      User.current_user.roles = Object.const_get(role+"Role").new
    end
  end
end
