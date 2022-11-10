<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/jsp/include/common_header.jsp" />

<script type="text/javascript">
$(function() {
	$('.menu_main li').eq(1).addClass("on");
	
	/* 
	setInterval(function() {
		if($('#refreshOn').is(':checked')) {
			document.location.href = '/flood/rainfall.do';
		}
	}, 1000 * 60);
	 */
	
	hourpicker("input_hour");
	
	var current_input_hour = $('#current_input_hour').val();
	$('#input_hour').val(current_input_hour);
	
	datepicker("input_issuestime");
	currentDateCheck("em_issuestime");
	
	selectData();
});

// 시간 계산 함수.(선택 시간, 계산 할 시간) return String ex)2021101010
function selectAddHourProc (issue_time, it) {
	var temp_date = "";
	
	// 적용하고자 하는 시간이 있는 경우.
	if(issue_time){
		var temp_year = issue_time.substr(0, 4);
		var temp_month = issue_time.substr(4, 2);
		var temp_day = issue_time.substr(6, 2);
		var temp_hour = issue_time.substr(8, 2);
		
		temp_date = new Date(temp_year, temp_month - 1, temp_day, temp_hour);
		
	// 적용하고자 하는 시간이 없는 경우 현재 시간.
	}else{
		temp_date = new Date();
	}
	
	// 더하는 시간이 있는경우.
	if(it){
		temp_date.setHours(temp_date.getHours() + parseInt(it));
	}

	var new_year = temp_date.getFullYear();
	var new_month = temp_date.getMonth() + 1;
	var new_day = temp_date.getDate();
	var new_hour = temp_date.getHours();

	var str_new_year   = new_year;
	var str_new_month  = (parseInt(new_month) < 10) ? "0" + new_month:new_month;
	var str_new_day    = (parseInt(new_day) < 10) ? "0" + new_day:new_day;
	var str_new_hour    = (parseInt(new_hour) < 10) ? "0" + new_hour:new_hour;
	
	return "" + str_new_year + str_new_month + str_new_day + str_new_hour;
}

// 날짜를 string으로 변환 후 표출.
function updateDateText(id, value) {
	$("#" + id).html("("+value.substr(0, 4) + "년 " + value.substr(4, 2) + "월 " + value.substr(6, 2) + "일 " + value.substr(8, 2) + "시)");
}

// 데이터 가져오기.
function selectData() {
	var issue_date = $('#issue_date').val();
	var current_input_hour = $('#current_input_hour').val();
	var yy = selectIssuetime().substr(0, 4);
	var mm = selectIssuetime().substr(4, 2);
	var dd = selectIssuetime().substr(6, 2);
	var hh = selectIssuehour();
	var h0m_value = selectAddHourProc (selectIssuetime()+selectIssuehour(), 0);
	var h1p_value = selectAddHourProc (h0m_value, 1);
	var h2p_value = selectAddHourProc (h1p_value, 1);
	var h3p_value = selectAddHourProc (h2p_value, 1);
	var now_value = selectAddHourProc ( ""+issue_date.substr(0, 4)+issue_date.substr(4, 2)+issue_date.substr(6, 2)+current_input_hour);
	var gu_arr = ["남구", "달서구", "달성군", "동구", "북구", "서구", "수성구", "중구", ];
	var html = "";
	
	if(h0m_value > now_value){
		selectNow();
		currentDateCheck("em_issuestime");
		alert("해당 시간을 선택 하실 수 없습니다.");
		
		/* 
		$(".maparea img:eq(0)").attr("src", "/images/nodata.png");
		$(".maparea img:eq(1)").attr("src", "/images/nodata.png");
		$(".maparea img:eq(2)").attr("src", "/images/nodata.png");
		 */
		 return;
	}else{
		$(".maparea img:eq(0)").attr("src", "/images/img_map_434x307.gif");
		$(".maparea img:eq(1)").attr("src", "/images/img_map_434x307.gif");
		$(".maparea img:eq(2)").attr("src", "/images/img_map_434x307.gif");
	}
	
	currentDateCheck("em_issuestime");
	updateDateText("H1P", h1p_value);
	updateDateText("H2P", h2p_value);
	updateDateText("H3P", h3p_value);
	
	
	
	for(var i=0; i<gu_arr.length; i++) {
		var h2m = selectAddHourProc (h0m_value, -2) > now_value? "-":"0.0";
		var h1m = selectAddHourProc (h0m_value, -1) > now_value? "-":"0.0";
		var h0m = h0m_value > now_value? "-":"0.0";
		var h1p = h0m_value > now_value? "-":"0.0";
		var h2p = h0m_value > now_value? "-":"0.0";
		var h3p = h0m_value > now_value? "-":"0.0";
		
		html += "<tr>";
		html += "<td>" + gu_arr[i] + "</td>";
		html += "<td>" + h2m + "</td>";
		html += "<td>" + h1m + "</td>";
		html += "<td>" + h0m + "</td>";
		html += "<td>" + h1p + "</td>";
		html += "<td>" + h2p + "</td>";
		html += "<td>" + h3p + "</td>";
		html += "</tr>";
	}
	
	$(".tbody_data").eq(0).html(html);
	
	/* 
	$.ajax({
		type: "POST",
		url: "/floodCont/selectRainfallData.do",
		dataType: "json",
		async : false,
		data: {'dt': selectIssuetime() + '' + selectIssuehour() + '00'},
		success: function(data) {
			var html = "";
			var html1 = "";
			
			for(var i=0; i<data.dataList.length; i++) {
				html += "<tr>";
				html += "<td>" + data.dataList[i].SSGNM + "</td>";
				html += "<td>" + data.dataList[i].H2M + "</td>";
				html += "<td>" + data.dataList[i].H1M + "</td>";
				html += "<td>" + data.dataList[i].H0M + "</td>";
				html += "<td>" + data.dataList[i].H1P + "</td>";
				html += "<td>" + data.dataList[i].H2P + "</td>";
				html += "<td>" + data.dataList[i].H3P + "</td>";
				html += "</tr>";
			}
			
			$(".tbody_data").eq(0).html(html);
			
			var src = "/ncl_images/aws_1hr/" + yy  + "/" + mm + "/" + dd + "/AWS_1HR_PRCP_" + selectIssuetime() + '' + selectIssuehour() +"_DAEGU.png"
			
			$('#src').val(src);
			
			$('.cnt').html("<img id='check_img' src=" + src + "' onerror='javascript:selectCheckImage();'/ >");

			//th add 2021-08-23
			for(var i=0; i<data.stnList.length; i++) {
				console.log(data.stnList[i].rnmm);
				console.log(data.stnList[i].ssgnm);
			}
			
		}
	});
	 */
	
}

function selectCheckImage(idx) {
	var image = document.getElementById('check_img');
	var src = $('#src').val();
	
	$('.no_data').hide();
	$('.cnt').show();
	
	$('#check_img').attr('src', src);
	
	image.onerror = function () {
		$('.no_data').show();
		$('.cnt').hide();
	};
}

$(document).on("change", "#input_hour", function() {
	selectData();
});
</script>

<form action="" method="get">
	<input type="hidden" id="current_date" value="${currentDate}" />
	<input type="hidden" id="issue_date" value="${issueDate}" />
	<input type="hidden" id="current_input_hour" value="${issueHour}" />
	<input type="hidden" id="src" />
	
	<div id="container">
    	<div class="sett">
          	<strong>현재시각</strong>
          	<em id="em_issuestime"></em>
          	<span>|</span>
          	<strong>날짜 선택</strong>
          	<input type="text" id="input_issuestime" name="" value="<c:out value='${fn:substring(issueDate, 0, 4)}' />년 <c:out value='${fn:substring(issueDate, 4, 6)}' />월 <c:out value='${fn:substring(issueDate, 6, 8)}' />일"  onfocus="javascript:selectFocus(this);" />
          	<select id="input_hour" name=""></select>
          	
          	<a href="javascript:selectNow();"><img src="/images/btn_now.gif" alt="Now" /></a>
          	<!-- 
          	<div class="refreshOnOff">
            	<input name="refreshOnOff" id="refreshOn" value="on" checked="" type="radio"><label for="refreshOn">자동갱신 On</label>
            	<input name="refreshOnOff" id="refreshOff" value="off" type="radio"><label for="refreshOff">자동갱신 Off</label>
          	</div>
          	 -->
    	</div>
        
        <div class="prdRnf">
            <ul>
                <li>
                    <p><em>+1h</em><span id="H1P">(2021년 10월 07일 15시)</span></p>
                    <div class="maparea"><img src="/images/img_map_434x307.gif" alt=""/></div>
                </li>
                <li>
                    <p><em>+2h</em><span id="H2P">(2021년 10월 07일 16시)</span></p>
                    <div class="maparea"><img src="/images/img_map_434x307.gif" alt=""/></div>
                </li>
                <li>
                    <p><em>+3h</em><span id="H3P">(2021년 10월 07일 17시)</span></p>
                    <div class="maparea"><img src="/images/img_map_434x307.gif" alt=""/></div>
                </li>
            </ul>
            <h3>자치구별 예측강우(mm/hr)</h3>
			<div class="tblwrap">
				<table>
					<col width="*" />
					<col width="14%" span="6" />
					<thead>
						<tr>
							<th scope="col">구</th>
							<th scope="col">-2h</th>
							<th scope="col">-1h</th>
							<th scope="col">0h</th>
							<th scope="col">+1h</th>
							<th scope="col">+2h</th>
							<th scope="col">+3h</th>
						</tr>
					</thead>
					<tbody class="tbody_data">
                    	<tr><td>남구</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td></tr>
                    	<tr><td>달서구</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td></tr>
                    	<tr><td>달성군</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td></tr>
                    	<tr><td>동구</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td></tr>
                    	<tr><td>북구</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td></tr>
                    	<tr><td>서구</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td></tr>
                    	<tr><td>수성구</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td></tr>
                    	<tr><td>중구</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td><td>0.0</td></tr>
                    </tbody>
				</table>
			</div>
		</div>
	</div>
</form>
    
<jsp:include page="/WEB-INF/jsp/include/common_footer.jsp" />