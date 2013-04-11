require 'spec_helper'
describe Message do

   context 'should have fields and associations' do
     it { should have_fields(:launcher,:receiver,:record_id,:remark) }
     it { should have_field(:is_view).of_type(Boolean).with_default_value_of(false) }
     it { should have_field(:checkins).of_type(Hash)}
     it { should be_timestamped_document }
   end
end
