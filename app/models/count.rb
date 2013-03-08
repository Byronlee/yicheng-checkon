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
      reduce = %Q{
        function(key, values) {
          return {ids:values};
        }
      }
    end
  
    def addup(start,over,state)
      return [] unless Record.exists?
      Record.by_period(start,over).state(state).map_reduce(map,reduce).out(replace: "mr_results").map do | document |
        result = document["value"]["ids"].inject(Hash.new(0)) do |h,v|
          h[v.to_s] += 1
          h
        end
        Count.find_or_create_by(staffid: document["_id"],result: result) 
      end
    end

    def counts_result counts,init
      counts.map do |count|
        user = User.new(count["staffid"])
        behaves = init.clone
        count["result"].map do | behave_id , num |
          behaves["#{Behave.find(behave_id).name}"] = num         
        end
        {user_no: user.user_no , username: user.username , behaves: behaves }
      end
    end
  end
end
