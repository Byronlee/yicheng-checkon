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

        event :apply, :transitions_to => :verifying do
          transition [:submitted] => :verifying 
        end

        event :verify, :transitions_to => :submitted do
          transition [:verifying] => :submitted
        end

        event :opposed, :transitions_to => :submitted do
          transition [:verifying] => :submitted
        end
      end
    end
  end
end
