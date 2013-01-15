$(document).ready(function(){
  $(".set_attend").popover({
    html: true,
    trigger: 'click',
    content: getHtmlAttendance(),
    title: '考勤项',
    placement: 'left'
  })
  $(".popover-inner input[type=radio]").live("click",function(){
    $(this).parents(".popover").remove();
  })
})

function getHtmlAttendance(){
  return '<div style="width:227px"><input name="opt" type="radio">出勤一天 </input><input name="opt" type="radio">出勤半天</input><input name="opt" type="radio">公出一天 </input><input name="opt" type="radio">公出半天 </input><input name="opt" type="radio">培训一天 </input><input name="opt" type="radio">培训半天 </input></div><hr style="margin:4px 0px" /><div style="width:227px"><input name="opt" type="radio">事假一天 </input><input name="opt" type="radio">事假半天</input><input name="opt" type="radio">病假一天 </input><input name="opt" type="radio">病假半天 </input><input name="opt" type="radio">产假一天 </input><input name="opt" type="radio">产假半天 </input></div><hr style="margin:4px 0px" /><div style="width:227px"><input name="opt" type="radio">休息一天 </input><input name="opt" type="radio">休息半天</input><input name="opt" type="radio">调息一天 </input><input name="opt" type="radio">调息一天 </input></div><hr style="margin:4px 0px" /><div style="width:227px"><input name="opt" type="radio">旷工一天 </input><input name="opt" type="radio">旷工半天 </input></div><hr style="margin:4px 0px" /><div style="width:227px"><input name="opt" type="radio">迟到 </input><input name="opt" type="radio">离职 </input><input name="opt" type="radio">调动 </input></div>' 
}
