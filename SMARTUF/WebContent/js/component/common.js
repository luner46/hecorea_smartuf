var lay_idx = 0;
var dam_idx = 0;
var res_idx = 0;
	
function datepicker(id) {
	$("#" + id).datepicker({
		showOn: "button",
	    buttonImageOnly: true,
	    buttonImage: "/images/calendar.png",
		dateFormat:'yy년 mm월 dd일',
		maxDate: '+0D',
		showButtonPanel: false,
		closeText: "닫기",
		currentText: "오늘날짜",
		nextText: "다음",
		prevText: "이전",
		changeYear: true,
		changeMonth: true,
		showMonthAfterYear: true,
		monthNames: ["1월", "2월", "3월", "4월", "5월", "6월","7월", "8월", "9월", "10월", "11월", "12월"],
		monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월","7월", "8월", "9월", "10월", "11월", "12월"],
		dayNames:  ["일", "월", "화", "수", "목", "금", "토"],
		dayNamesShort:  ["일", "월", "화", "수", "목", "금", "토"],
		dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
		maxDate: "+0D",
	    onSelect: function (dateText, inst) {
	    	$('#input_issuestime').datepicker().datepicker("hide");
	    	currentDateCheck("em_issuestime");
	    	selectData();
	    }
	});
}

function hourpicker(id) {
	$("#" + id).empty();
	
	var result = "";
	
	for(var i=0; i<=23; i++) {
		if(i < 10) {
			result = "0" + i;
			
		} else {
			result = i;
		}
		
		$("#" + id).append("<option value='" + result + "'>" + result + "</option>");
	}
}

function minpicker(id) {
	$("#" + id).empty();
	
	var result = "";
	
	for(var i=0; i<=5; i++) {
		if(i < 1) {
			result = "0" + i;
			
		} else {
			result = i * 10;
		}
		
		$("#" + id).append("<option value='" + result + "'>" + result + "</option>");
	}
}

function currentDateCheck(id) {
	var dt = selectIssuetime();
	var hh = selectIssuehour();
	
	$("#" + id).html(dt.substr(0, 4) + "년 " + dt.substr(4, 2) + "월 " + dt.substr(6, 2) + "일 " + hh + "시");
}


function selectIssuetime() {
	var input_issuestime = $('#input_issuestime').val();
	
	var yy = input_issuestime.substr(0, 4);
	var mm = input_issuestime.substr(6, 2);
	var dd = input_issuestime.substr(10, 2);
	
	return yy + "" + mm + "" + dd;
}

function selectIssuehour() {
	var input_hour = $('#input_hour').val();
	
	return input_hour;
}

function selectIssuemin() {
	var input_min = $('#input_min').val();
	
	return input_min;
}

function selectDamCd() {
	var select_dam_cd = $('#select_dam_cd option:selected').val();
	
	return select_dam_cd;
}


function selectFocus() {
	 $('#input_issuestime').datepicker().datepicker("show");
}

function selectNow() {
	var issue_date = $('#issue_date').val();
	var current_input_hour = $('#current_input_hour').val();
	
	var yy = issue_date.substr(0, 4);
	var mm = issue_date.substr(4, 2);
	var dd = issue_date.substr(6, 2);
	
	$('#input_issuestime').val(yy + "년 " + mm + "월 " + dd + "일");
	$('#input_hour').val(current_input_hour);
	
	selectData();
}

function selectAddTimeProc(issue_time, it) {
	var temp_year = issue_time.substr(0, 4);
	var temp_month = issue_time.substr(4, 2);
	var temp_day = issue_time.substr(6, 2);
	
	var temp_date = new Date(temp_year, temp_month - 1, temp_day);

	temp_date.setDate(temp_date.getDate() + parseInt(it));

	var new_year = temp_date.getFullYear();
	var new_month = temp_date.getMonth() + 1;
	var new_day = temp_date.getDate();

	var str_new_year   = new_year;
	var str_new_month  = (parseInt(new_month) < 10) ? "0" + new_month:new_month;
	var str_new_day    = (parseInt(new_day) < 10) ? "0" + new_day:new_day;
	
	return "" + str_new_year + str_new_month + str_new_day;
}

function selectIdxValue() {
	var idx_val = $('#idx_val').val();
	var result = "";
	
	if(idx_val == '0') result = "7D";
	if(idx_val == '1') result = "15D";
	if(idx_val == '2') result = "1M";
	if(idx_val == '3') result = "3M";
	if(idx_val == '4') result = "6M";
	if(idx_val == '5') result = "9M";
	if(idx_val == '6') result = "12M";
	if(idx_val == '7') result = "0Y";
	
	return result;
}










