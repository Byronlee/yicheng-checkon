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
	    $("input[id$=start_time]").val(end.getFullYear()+"-"+farmat((end.getMonth()+1))+"-"+farmat(end.getDate()));
            $("input[id$=end_time]").val(start.getFullYear()+"-"+farmat((start.getMonth()+1))+"-"+farmat(start.getDate()));
    }
   $('input[name=range_time]').daterangepicker(datapicker_option,datapicker_callback)
//  count_reslut("#new_examine","创建失败！，请查看上次的考勤审核任务是否完成！")
   count_reslut("#new_count","统计失败！请稍后再试！")
   count_reslut("#delete_examine","取消失败！请稍后再试！")
//  count_reslut(".update_examine","处理失败！请稍后再试！")

    function  count_reslut(object_name,message){	
	$(object_name).live('ajax:success', function(event,data,status, xhr) {
	    $("body").find(".waiting").remove();
	    data ? $(".count_page").html(data) : alert(message);
	    $('input[name=range_time]').daterangepicker(datapicker_option,datapicker_callback)
	}).live('ajax:beforeSend', function(event,data,status, xhr) {
	    $('.modal').modal('hide')
	    $("body").prepend('<div class="modal-backdrop waiting fade in"><strong>请稍等，正在处理中,可能会几分钟.....<strong></div>')
	}).live('ajax:error', function(event,data,status, xhr) {
	     $("body").find(".waiting").remove();
	     alert("出错了，你所访问资源不存在，请稍后再试!")
	});
    }

    $(".submit_trainee_records").bind('click',function(){
        $(this).parent().siblings().children('form').submit()
    })
    
    $(".chzn-select").ajaxChosen({
	type: 'GET',
	url: 'autocomplete/search_users',
	dataType: 'json'
    }, function (data) {
	var results = [];	
	$.each(data, function (i, val) {
            results.push({ value: val.value, text: val.text });
	});
	return results;
    });

});

function ajax_dept_users_select(o){
    $.get("ajax_dept_users",{dept_id : o.val()},function(html){
	o.parents("form").find(".staff_select").parents('.input-prepend').replaceWith(html);
    })
}

function ajax_attend_tree(o){
    o.parents(".selects_group").nextAll().find("#search_dept_id").parents(".input-prepend").html('<option value="">--全部--</option>');
    $.post("ajax_attend_tree",{dept_id :o.val()}, function(html){
	    if(html){	  
		o.parents(".input-prepend").next().find("select").html(html);
	    }
	})     
    ajax_dept_users_select(o)
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
       if(confirm("学员的考勤记录将会覆盖此员工的所有考勤记录,是否继续")){
           o.parent().siblings().children('form').submit()
       }
  }


function examine_proce(o){
    $.post("proces_detail",{examine_id : o.attr("href").substr(1) }, function(html){
	$(o.attr("href")).find(".modal-body").html(html)
    })     
}



function  config_approval_title(o){
    o.parents("td").find(".config_approval_title").html(o.attr("attr")) ;
    o.parents("td").find("#modify_data_decision").val(o.attr("dec"));
    if(o.attr("dec")=="agree"){
	html = '<label class="checkbox" style="width: 257px;padding-left: 64px;"><input name="modify[data][exception]" type="checkbox" value="true">此修改为修改上月或上月以前的考勤数据</label>'
	o.parents("td").find(".checkbox").remove();
	o.parents("td").find(".modal-body").append(html)
    }else{
    	o.parents("td").find(".checkbox").remove();
    }
}

$('.query_data_form').live('ajax:before', function(event,data,status, xhr) {
    var user_id = $("#dept_user_id").val() ;
    if (user_id==""){
	alert("请根据关键字或者部门选择相关的员工在进行查询！")
	return false;
    }
}).live('ajax:success',function(evt, data, status, xhr){
    $('.show_query_result').html(data)
});

$('.new_care').live('ajax:success',function(evt, data, status, xhr){
    $('.cares-body').html(data)
}).live('ajax:error',function(event, xhr, status){alert(xhr.responseText)});

$('#export').live('ajax:success',function(evt, data, status, xhr){
    if(data.state == 1){
	window.location.href = data.url
    }else{
	alert(data.notice)
    }
});
