class TraineeRecordCell < Cell::Rails
  helper StaffRecordsHelper , ApplicationHelper

  def show
    @number = TraineeRecord.state("checking").length
    @tasks =  TraineeRecord.trainee_records.decorate
    render
  end
end
