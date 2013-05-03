class NoticeType
  include Mongoid::Document
  # type names
  #  modify_applied, modify_approved, modify_direct
  #  examine_applied, exception_leave,unfinished_attend

  field :name , type: String
  has_many :notices

  Settings.notice_types.each do |type|
    define_method type+'?' do
      name.eql?(type) ? true : false
    end
  end
end
