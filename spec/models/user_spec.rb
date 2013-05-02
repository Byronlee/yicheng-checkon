# -*- coding: utf-8 -*-

require 'spec_helper'
require "cancan/matchers"
  
describe Ability do
  context "when current_user include registrar role" do
      it{ should be_able_to(:manage, Trainee.new) }
    end
end

