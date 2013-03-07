class Definition
  include Mongoid::Document
  field :content, type: Array

  belongs_to :record

  def export 
    self.content = Ruote.process_definition :name => 'apply for record' do
      sequence do
        registrar action: "xxx" ,controller: "yyy" 
        adminer action: "uuu" ,controller: "nnn"
      end
    end
  end
end

