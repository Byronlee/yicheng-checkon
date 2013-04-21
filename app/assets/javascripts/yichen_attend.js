jQuery(function(){ 
    document.getElementById('time').innerHTML=new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());
    setInterval("document.getElementById('time').innerHTML=new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());",1000);

    function farmat(num){return num = num<10 ? "0"+num : num} 

    $('#trainee_salary_time').datepicker({
                          format: 'yyyy-mm-dd',
                          language: 'zh-CN'
                          })

    var datapicker_option ={
            ranges: {
		'今天': ['today', 'today'],
		'昨天': ['yesterday', 'yesterday'],
		'最近7天': [Date.today().add({ days: -6 }), 'today'],
		'最近30天': [Date.today().add({ days: -29 }), 'today'],
		'本月': [Date.today().moveToFirstDayOfMonth(), Date.today().moveToLastDayOfMonth()],
		'上月': [Date.today().moveToFirstDayOfMonth().add({ months: -1 }), Date.today().moveToFirstDayOfMonth().add({ days: -1 })]
            }	}

    var datapicker_callback = function(start, end) {
	    $('input[name=end_time]').val(end.getFullYear()+"-"+farmat((end.getMonth()+1))+"-"+farmat(end.getDate()));
            $('input[name=start_time]').val(start.getFullYear()+"-"+farmat((start.getMonth()+1))+"-"+farmat(start.getDate()));
    }
    $('input[name=range_time]').daterangepicker(datapicker_option,datapicker_callback)





   count_reslut("#new_examine","创建失败！，请查看上次的考勤审核任务是否完成！")
   count_reslut("#new_count","统计失败！请稍后再试！")
   count_reslut("#delete_examine","取消失败！请稍后再试！")
    //  看看 提交之前的 表单 是否 填好！ TODO  
    function  count_reslut(object_name,message){	
	$(object_name).live('ajax:success', function(event,data,status, xhr) {
	    $("body").find(".waiting").remove();
	    data ? $(".count_page").html(data) : alert(message);
	    $('input[name=range_time]').daterangepicker(datapicker_option,datapicker_callback)
	}).live('ajax:beforeSend', function(event,data,status, xhr) {
	    $('.modal').modal('hide')
	    $("body").prepend('<div class="modal-backdrop waiting fade in"><strong>请稍等，正在处理中,可能会几分钟.....<strong></div>')
	});
    }


});

    function ajax_dept_users_select(o){
      $.get("trainees/ajax_dept_users_select",{dept_id : o.val()},function(html){
      o.parents('.input-prepend').next().replaceWith(html);
      })
    }

    function ajax_attend_tree(o){
	o.parents(".input-prepend").nextAll().find("select").html('<option value="">--全部--</option>');
	$.post("/ajax_attend_tree",{dept_id :o.val()}, function(html){
	    if(html){	  
	     o.parents(".input-prepend").next().find("select").html(html);
	     o.parents(".query_data").find("input[name=dept_id]").val(o.val);
	    }
	})
    }



    function query_attach(o){
     if(o.attr("order")=="false"&&o.val()=="") return false
        $.post("operate" ,{value: o.val() , 
			 field: o.attr("field"),
			 order: o.attr("order"),
			 type : "attach"
			},
               function(html){
		   $(".show_query_result").html(html);
	       });
	
    }

  function merge_submit(o,update){
       o.parent().siblings().children('form').submit()
  }

  function  config_approval_title(o){
      o.parents("td").find(".config_approval_title").html(o.attr("attr")) ;
      o.parents("td").find("#modify_data_decision").val(o.attr("dec"));
  }
