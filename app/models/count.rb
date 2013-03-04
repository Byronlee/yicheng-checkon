class Count
  include Mongoid::Document

  def self.stat 
    map = %Q{
    function() {
      emit(this.behave_id , this.check_unit_id)
    }
  }


    # key:0,values: ["name_6","name_12","name_18"]
    reduce = %Q{
    function(key, values) {
      return { behave_id: key,count: values.length };
     }
    }
    
    Record.where(staffid: "4028809b3c6fbaa7013c6fbc3da51b51").first.checkins.map_reduce(map,reduce).out(replace: "results").each do | document |
      p document
    end
  end
end
