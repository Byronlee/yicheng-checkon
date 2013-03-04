class Count
  include Mongoid::Document
  
  @map = %Q{
    function(){
      emit(this.bahave_id., this.check_unit_id)
    }
  }

  @reduce = %Q{
    function(key, value){
        for(var v in value){
            count += v[key] ;
          }
      }
      return count ;
    }

  
  def count
   p Record.where(staffid: '4028809b3c6fbaa7013c6fbc3da51b49').first.checkins.map_reduce(@map, @reduce).firstl
  end
end
