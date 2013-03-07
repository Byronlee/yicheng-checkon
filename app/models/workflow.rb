class Workflow


  def self.launch
    export = Definition.new.export
    wfid = RUOTE.launch(export)
    workflow = RUOTE.storage_participant.by_wfid(wfid).first
    RUOTE.storage_participant.proceed(workflow)
  end
end
