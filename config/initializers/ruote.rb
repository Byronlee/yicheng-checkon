require 'ruote'
 
class Registrar < Ruote::Participant
  def on_workitem
  # puts workitem.participant_name
  # reply
  end
end


class Adminer < Ruote::Participant
  def on_workitem
  # puts workitem.participant_name
  # reply
  end
end

# set up ruote storage

RUOTE =  Ruote::Dashboard.new(
  Ruote::Worker.new(
    Ruote::Mon::Storage.new(
      Mongo::Connection.new()['ruote_mon'],{})))
 
RUOTE.noisy = ENV['NOISY'] == 'true'
# participant registration
 
RUOTE.register do
# participant :registrar, Registrar
# participant :adminer, Adminer
  catchall
end

