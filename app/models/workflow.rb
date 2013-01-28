class Workflow
  @@engine = nil
   def self.engine
    if @@engine.nil? then
      @@engine = Ruote::Dashboard.new(Ruote::Worker.new(Ruote::Mon::Storage.new(Mongo::Connection.new()['ruote_mon'],{})))
      @@engine.register do
        catchall
      end
    end
    @@engine
  end
end
