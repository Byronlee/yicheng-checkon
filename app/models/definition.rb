class Definition
  include Mongoid::Document
  field :content, type: Array

  belongs_to :record

  def export
    self.content = Ruote.process_definition :name => 'apply for record' do
      sequence do
        participant "${recorder}", task: "apply"
        participant "${attend_manager}", task: "approve"
      end
    end
  end
end
