jQuery(function(){ 
    document.getElementById('time').innerHTML=new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());
    setInterval("document.getElementById('time').innerHTML=new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());",1000);

    function farmat(num){return num = num<10 ? "0"+num : num} 

    $('#trainee_salary_time').datepicker({
                          format: 'yyyy-mm-dd',
                          language: 'zh-CN'
                          })

    $('input[name=range_time]').daterangepicker(
	{
            ranges: {
		'今天': ['today', 'today'],
		'昨天': ['yesterday', 'yesterday'],
		'最近7天': [Date.today().add({ days: -6 }), 'today'],
		'最近30天': [Date.today().add({ days: -29 }), 'today'],
		'本月': [Date.today().moveToFirstDayOfMonth(), Date.today().moveToLastDayOfMonth()],
		'上月': [Date.today().moveToFirstDayOfMonth().add({ months: -1 }), Date.today().moveToFirstDayOfMonth().add({ days: -1 })]
            }
	},
	function(start, end) {
	    $('input[name=end_time]').val(end.getFullYear()+"-"+farmat((end.getMonth()+1))+"-"+farmat(end.getDate()));
            $('input[name=start_time]').val(start.getFullYear()+"-"+farmat((start.getMonth()+1))+"-"+farmat(start.getDate()));
	}
    );
    
    $(".count_head .btn-mini").live("click", function(){
	$.post('counts/update', {behave_id : [$(this).attr("id")]} ,function(html){
	    $(".count_result").html(html)
	})
    })

$('#autocomplete').autocomplete({
    serviceUrl: '/autocomplete/search_users',
    onSelect: function (suggestion) {
        $(this).parents('form').find('#input_search_user_id').val(suggestion.data)
    }
});

$('#choice_user').carousel({
  interval: 0
})

});

    function ajax_dept_users_select(o){
      $.get("/ajax_dept_users",{dept_id : o.val()},function(html){
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

  $('.query_data_form').live('ajax:success',function(evt, data, status, xhr){
    alert(data)
   $('.show_query_result').html(data)
  })

