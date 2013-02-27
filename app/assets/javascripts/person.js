$(document).ready(function(){
  $(".set_attend").popover({
    html: true,
    trigger: 'click',
    content: getHtmlAttendance(),
    title: '考勤项<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>',
    placement: 'left'
  })
  $(".popover-inner input[type=radio]").live("click",function(o){
      $(this).parents("tr").find("input[type=text]").val($(this).val());
      $(this).parents(".popover").remove();
  })
})

function getHtmlAttendance(){
  return '<div style="width:227px">'+
      '<input name="opt" type="radio" value="出勤一天">出勤一天 </input>'+
      '<input name="opt" type="radio" value="出勤半天">出勤半天</input>'+
      '<input name="opt" type="radio" value="公出一天">公出一天 </input>'+
      '<input name="opt" type="radio" value="出勤半天">公出半天 </input>'+
      '<input name="opt" type="radio" value="培训一天">培训一天 </input>'+
      '<input name="opt" type="radio" value="培训半天">培训半天 </input>'+
      '<hr style="margin:4px 0px" />'+
      '<input name="opt" type="radio" value="事假一天">事假一天 </input>'+
      '<input name="opt" type="radio" value="事假半天">事假半天</input>'+
      '<input name="opt" type="radio" value="病假一天">病假一天 </input>'+
      '<input name="opt" type="radio" value="病假半天">病假半天 </input>'+
      '<input name="opt" type="radio" value="产假一天">产假一天 </input>'+
      '<input name="opt" type="radio" value="产假半天">产假半天 </input>'+
      '<hr style="margin:4px 0px" />'+
      '<input name="opt" type="radio" value="休息一天">休息一天 </input>'+
      '<input name="opt" type="radio" value="休息半天">休息半天</input>'+
      '<input name="opt" type="radio" value="调息一天">调息一天 </input>'+
      '<input name="opt" type="radio" value="调息半天">调息半天 </input>'+
      '<hr style="margin:4px 0px" />'+
      '<input name="opt" type="radio" value="矿工一天">旷工一天 </input>'+
      '<input name="opt" type="radio" value="矿工半天">旷工半天 </input>'+
      '<hr style="margin:4px 0px" />'+
      '<input name="opt" type="radio" value="迟到">迟到 </input>'+
      '<input name="opt" type="radio" value="离职">离职 </input>'+
      '<input name="opt" type="radio" value="调动">调动 </input>'+
      '</div>'
}
