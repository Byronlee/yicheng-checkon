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
  return '<table class="table table-bordered"><thead><tr><td>出勤:</td><td><label class="radio"><input name="opt" type="radio">出勤一天 </label><label class="radio"><input name="opt" type="radio">出勤半天</label></td></tr><tr><td>请假:</td><td><label class="radio"><input name="opt" type="radio">出勤一天 </label><label class="radio"><input name="opt" type="radio">出勤半天</label></td></tr><tr><td>休息:</td><td><label class="radio"><input name="opt" type="radio">休息一天 </label><label class="radio"><input name="opt" type="radio">休息半天</label></td></tr><tr><td>其他:</td><td><label class="radio"><input name="opt" type="radio">迟到 </label><label class="radio"><input name="opt" type="radio">离职 </label></td></tr></thead></table>'

}
