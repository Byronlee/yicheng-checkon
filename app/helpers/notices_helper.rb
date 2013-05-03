# -*- coding: utf-8 -*-
module NoticesHelper
  
  def decision decision
    decision.eql?('agree') ? '同意' : '拒绝'
  end
end
