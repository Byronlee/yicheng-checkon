
jQuery(function(){ 
    document.getElementById('time').innerHTML=new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());
    setInterval("document.getElementById('time').innerHTML=new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());",1000);



   var yy = { 
	"data" : "node_title", 
	// omit `attr` if not needed; the `attr` object gets passed to the jQuery `attr` function
	"attr" : { "id" : "node_identificator", "some-other-attribute" : "attribute_value" }, 
	// `state` and `children` are only used for NON-leaf nodes
	"state" : "open", // or "open", defaults to "closed"
	"children" : ["adf","asdf" ]
   }


	 $(".permission").jstree({
                "core" : { "initially_open" : [ "topic_root" ] }, 
                "json_data": {  "data": yy},
                "themes": { "theme": "default", "dots": false, "icons": true },
                "plugins": ["themes", "json_data", "ui"]
            })

/*
    $.get("tree_dept" , function(data){
	 $(".permission").jstree({
                "core" : { "initially_open" : [ "topic_root" ] }, 
                "json_data": {  "data": data },
                "themes": { "theme": "default", "dots": false, "icons": true },
                "plugins": ["themes", "json_data", "ui"]
            })
    });
*/

   



//   $('input[class=salary_time]').datepicker();

    function farmat(num){return num = num<10 ? "0"+num : num} 

    $('.salary_time').datepicker({
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





});

    function ajax_select(params,url,update,o){
      $.get(url,{dept_id :o.val()},function(html){
      o.parents('form').children("#"+update).html(html);
      })
    }

    function query_records(){
     $.post("query" ,{start_time: $('input[name=start_time]').val() , 
		      end_time  : $('input[name=end_time]').val() ,
		      dept_id   : $('#condition_dept').val(),
		      cell_id   : $('#condition_cell').val(), 
	              region    : $('#condition_region').val(),
                      type      : "direct"
		     },
             function(html){
		 $(".show_query_result").html(html);
	     });
    }


    function query_attach(o){
     if(o.attr("order")=="false"&&o.val()=="") return false
        $.post("query" ,{value: o.val() , 
			 field: o.attr("field"),
			 order: o.attr("order"),
			 type : "attach"
			},
               function(html){
		   $(".show_query_result").html(html);
	       });
	
    }

function u_submit(o,update){
     o.parent().siblings().children('form').submit()
}





