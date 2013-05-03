require 'spec_helper'
describe Crontask do 
  context "Continuous three days in leave should notice to approval" do
    before :each do
      @records = create :three_away
    end

    it "test " do
      p @records
    end

  end
end
