class ExceptionRecordCell < Cell::Rails
  helper RecordsHelper
  def show
    @number = ExceptionRecord.state("checking").length
    @tasks = ExceptionRecord.exception_records.decorate
    render
  end
end
