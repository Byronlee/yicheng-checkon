# -*- coding: utf-8 -*-

require 'spec_helper'
require "cancan/matchers"
  
describe Ability do
  before :each do
    @user = User.resource("123456")
  end
  context "when current_user include registrar role" do
    before :each do 
      @user.roles = ['Registrar']
    end
    it {@user.should have_ability(:manage, for: Trainee.new)}
    it {@user.should have_ability(:manage, for: StaffRecord.new)}
    it {@user.should have_ability(:manage, for: Count.new)}

    it {@user.should have_ability(:registrar, for: Task.new)}
    it {@user.should_not have_ability(:approval, for: Task.new)}
  
    it {@user.should have_ability([:index,:update,:show], for: Examine.new)}
    it {@user.should_not have_ability([:index,:show,:create,:destroy,:proces_detail], for: Examine.new)}

    it {@user.should have_ability([:create,:destroy], for: Modify.new)}
    it {@user.should_not have_ability(:update, for: Modify.new)}

    it {@user.should_not have_ability(:manage, for: Perssion.new)}
  end

  context "when current_user include rightsman role" do
    before :each do 
      @user.roles = ['Rightsman']
    end
    it {@user.should have_ability(:manage, for: Perssion.new)}
  end

  context "when current_user include approval role" do
    before :each do 
      @user.roles = ['Approval']
    end

    it {@user.should have_ability(:manage, for: Count.new)}
    it {@user.should have_ability(:manage, for: StaffRecord.new)}
    it {@user.should_not have_ability(:manage, for: Perssion.new)}

    it {@user.should have_ability([:index,:show,:create,:destroy,:proces_detail], for: Examine.new)}
    it {@user.should_not have_ability([:index,:update,:show], for: Examine.new)}

    it {@user.should have_ability(:update, for: Modify.new)}
    it {@user.should_not have_ability([:create,:destroy], for: Modify.new)}

    it {@user.should have_ability(:approval, for: Task.new)}
    it {@user.should_not have_ability(:registrar, for: Task.new)}
  end
end

