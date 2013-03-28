class StaffRecordObserver < Mongoid::Observer
  include Rails.application.routes.url_helpers

  def after_create(staff_record)
    expire_cache_for(staff_record)
  end

  def after_update(staff_record)
    expire_cache_for(staff_record)
  end

  private
    def expire_cache_for(record)
      # expire fragments/pages for record
      @c ||= ActionController::Base.new

      @c.expire_page("/")
    end
end
