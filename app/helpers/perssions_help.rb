# -*- coding: utf-8 -*-
module PerssionsHelper
  
  def perssion? user_id
    $PERSSION.peroid(user_id) ? true : false
  end
end
