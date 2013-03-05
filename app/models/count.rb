class Count
  include Mongoid::Document
  
  field :staffid , type: String
  field :result , type: Hash

  class << self
    def map
      map = %Q{
        function() {
          for (var checkin in this.checkins){
            emit(this.staffid,this.checkins[checkin].behave_id);
          }
        }
      }
    end
  
    def reduce
      reduce = %q{
        function(key, values) {
          return {ids:values};
        }
      }
    end
  
    def addup
      Record.get_record_by_period("2013-03-01","2013-03-06").map_reduce(map,reduce).out(replace: "mr_results").map do | document |
        result = document["value"]["ids"].inject(Hash.new(0)) do |h,v|
          h[v.to_s] += 1
          h
        end
        Count.find_or_create_by(staffid: document["_id"],result: result) 
      end
    end


#    Record.where(staffid: "4028809b3c6fbaa7013c6fbc3da51b70").first.checkins.map_reduce(map,reduce).out(replace: "results").each do | document |
#      p document
#    end
  end




end
