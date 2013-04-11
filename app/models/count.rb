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
  
    def addup(query_map)
      return [] unless StaffRecord.exists?
      delete_all
      records = eval(query_map)
      counts = records.map_reduce(map,reduce).out(replace: "mr_results").map do | document |
        result = document["value"]["ids"].inject(Hash.new(0)) do |h,v|
          h[v.to_s] += 1
          h
        end    
        create(staffid: document["_id"],result: result) 
      end
      counts_result(counts,init_arra(Behave))
    end

    def counts_result counts,bh_array
      counts.map do |count|
        user = User.resource(count["staffid"])
         behaves = bh_array.clone
         count["result"].map do | behave_id , num |
           behaves["#{Behave.find(behave_id).name}"] = num
         end
         {user_no: user.user_no ,staffid: user.staffid,  username: user.username , behaves: behaves }
       end
     end


      def amount
        tp_array = init_arra  BehaveType
        tp_rs = Count.all.map {|tp| {staffid: tp.staffid , tps: tp.result.map{|k,v| {Behave.find(k).behave_type.name.to_sym => v} }}}
        tp_rs.map  do  |tp| 
         user = User.resource(tp[:staffid])
         array = tp_array.clone;
         tp[:tps].each {|k|    k.map{|x, c| array[x.to_s] += c   }   }
         {user_no: user.user_no , staffid: tp[:staffid], username: user.username , behaves:  array }
       end
     end

    def init_arra model_name
        model_name.all.inject({}) do |hash ,value|
        hash.merge({value.name => 0})
      end
    end
  end
end
