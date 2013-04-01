module Mongoid
  module StateMachine
    extend ActiveSupport::Concern

    included do
      state_machine initial: :checking do
        event :register do
          transition [:checking] => :registered
        end

        event :submit do
          transition [:registered] => :submitted
        end

        event :apply do |params|
          transition [:submitted] => :applying 
       #   Message.new_message params
        end

        event :approval do |params|
          transition [:applying] => :submitted
       #   StaffRecord.approval params
       #   Message.new_message  params
        end
      end
    end



  end
end
