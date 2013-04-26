require "#{File.dirname(__FILE__)}/org_stru"

$ACCESSOR = OrgStru.new


def attend_tree user_id
  $ACCESSOR.attend_tree user_id
end

def dept_users dept_id
  $ACCESSOR.dept_users dept_id
end 

def dept_users_with_subdept dept_id
  $ACCESSOR.dept_users_with_subdept dept_id
end 

def dept_users1 dept_id
  $ACCESSOR.dept_users_with_attr dept_id
end 

def search_users keyword
  $ACCESSOR.search_user(params[:keyword]).map{|id| $ACCESSOR.user_attr id}
end

def dept
  $ACCESSOR.dept_list
end 


def dept_id dept_id
  $ACCESSOR.dept_attr dept_id
end 

def user_id user_id
  user = $ACCESSOR.user_attr user_id
  ext_attrs = $ACCESSOR.user_attr_ext user 
  user.merge ext_attrs
end 

# get user_ext_id user_id
#   JSON.dump $ACCESSOR.user_attr_ext params[:user_id]
# end

def dept_tree
  $ACCESSOR.produce_tree_to_map ($ACCESSOR.dept_tree) 
end

def dept_tree dept_id
  $ACCESSOR.produce_tree_to_map ($ACCESSOR.dept_tree dept_id) 
end

def post
  $ACCESSOR.post_map
end

def user_posts user_id
  $ACCESSOR.user_posts user_id
end

def registrars
  $ACCESSOR.all_users_with_role :registrar
end

def registrars dept_id
  $ACCESSOR.users_with_role :registrar,dept_id
end

def perssion_users user_id
  $ACCESSOR.temp_registrars user_id
end


def perssion_authorize lists 
  begin 
    lists.each do |user|
      next unless ["user_id","begin","end"].reduce(true){|r,key| r and (user.has_key? key)}
      next unless check_id user["user_id"] 
      $ACCESSOR.temp_registrar_rights_peroid(user["user_id"],
                                             :begin => Date.parse(user["begin"]),
                                             :end => Date.parse(user["user_id"]))
    end
    return true
  rescue
    return false
  end
end

