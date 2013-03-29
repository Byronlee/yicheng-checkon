class Permission

  def self.assign roles
    roles.each do |role|
      User.send :include ,Object.const_get(role)
    end
  end
end
