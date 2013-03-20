module Mongoid
  module WorkFlow
    extend ActiveSupport::Concern

    included do

      include Workflow
      field :state
      workflow_column :state

      workflow do
        state :checking do
          event :register, :transitions_to => :registered
        end
        state :registered do
          event :submit, :transitions_to => :submitted
        end
        state :submitted do
          event :apply, :transitions_to => :verifying
        end
        state :verifying do
          event :verify, :transitions_to => :submitted
          event :opposed, :transitions_to => :submitted
        end
      end
    end
  end
end
