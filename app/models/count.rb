class Count
  include Mongoid::Document


  def self.checks id
    id
  #  Checkin.where(record_id: id).each{|x| p x}
  end

  def self.stat 

    checkin_map = %Q{
    function() {
      emit(this.behave_id , 1)
    }
  }
 
    # key:0,values: ["name_6","name_12","name_18"]
    checkin_reduce = %Q{
    function(key, values) {
      return values.length ;
     }
    }
    

    user_map = %Q{
      function(){
        emit(this.staffid , db.runCommand({ distinct : "checkins" ,"key" : "_id", query : {record_id: this._id}}))
      }
    }

    user_reduce = %Q{

      function(key.values){
             var checkins = [];
             values.forEach(function(doc){  checkins << doc})
             return checkins
      }

    }



#    Record.where(staffid: "4028809b3c6fbaa7013c6fbc3da51b9f").first.checkins.map_reduce(map,reduce).out(replace: "results").each do | document |
 #     p document
  #  end
  
    Record.where(:attend_date.gt => "2013-03-01" , :attend_date.lt => "2013-03-05").map_reduce(user_map, user_reduce).out(replace: "output").each do |document |  
      p document
    end


#    Record.where(staffid: "4028809b3c6fbaa7013c6fbc3da51b70").first.checkins.map_reduce(map,reduce).out(replace: "results").each do | document |
#      p document
#    end
  end




end
