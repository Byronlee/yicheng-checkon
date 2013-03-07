class RecordObserver < Mongoid::Observer
  include Rails.application.routes.url_helpers

  def after_create(record)
    expire_cache_for(record)
  end

  def after_update(record)
    expire_cache_for(record)
  end

  private
    def expire_cache_for(record)
      # expire fragments/pages for record
      @c ||= ActionController::Base.new
 
      @c.expire_page("/")
    end
end
