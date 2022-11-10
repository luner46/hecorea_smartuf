<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/jsp/include/common_header.jsp" />

<script type="text/javascript">
$(function() {
	$('.menu_main li').eq(0).addClass("on");
	
	setInterval(function() {
		if($('#refreshOn').is(':checked')) {
			document.location.href = '/flood/rainfall.do';
		}
	}, 1000 * 60);
	
	hourpicker("input_hour");
	
	var current_input_hour = $('#current_input_hour').val();
	$('#input_hour').val(current_input_hour);
	
	datepicker("input_issuestime");
	currentDateCheck("em_issuestime");
	
	selectData();
});

function selectData() {
	var yy = selectIssuetime().substr(0, 4);
	var mm = selectIssuetime().substr(4, 2);
	var dd = selectIssuetime().substr(6, 2);
	var hh = selectIssuehour();
	
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
				html += "</tr>";
				
				html1 += "<tr>";
				html1 += "<td>" + data.stnList[i].ssgnm + "</td>";
				html1 += "<td>" + data.stnList[i].rnmm2 + "</td>";
				html1 += "<td>" + data.stnList[i].rnmm1 + "</td>";
				html1 += "<td>" + data.stnList[i].rnmm + "</td>";
				html1 += "</tr>";
			}
			
			$(".tbody_data").eq(0).html(html);
			$(".tbody_data").eq(1).html(html1);
			
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

$(document).on('change', '#input_hour', function() {
	currentDateCheck("em_issuestime");
	selectData();
});
</script>

<form action="" method="get">
	<input type="hidden" id="current_date" value="${currentDate}" />
	<input type="hidden" id="issue_date" value="${issueDate}" />
	<input type="hidden" id="current_input_hour" value="${issueHour}" />
	<input type="hidden" id="src" />
	
	<div id="container" class="rainfall">
    	<div class="sett">
          	<strong>현재시각</strong>
          	<em id="em_issuestime"></em>
          	<span>|</span>
          	<strong>날짜 선택</strong>
          	<input type="text" id="input_issuestime" name="" value="<c:out value='${fn:substring(issueDate, 0, 4)}' />년 <c:out value='${fn:substring(issueDate, 4, 6)}' />월 <c:out value='${fn:substring(issueDate, 6, 8)}' />일"  onfocus="javascript:selectFocus(this);" />
          	<select id="input_hour" name=""></select>
          	
          	<a href="javascript:selectNow();"><img src="/images/btn_now.gif" alt="Now" /></a>
          	
          	<div class="refreshOnOff">
            	<input name="refreshOnOff" id="refreshOn" value="on" checked="" type="radio"><label for="refreshOn">자동갱신 On</label>
            	<input name="refreshOnOff" id="refreshOff" value="off" type="radio"><label for="refreshOff">자동갱신 Off</label>
          	</div>
    	</div>
        
        <div class="ltWd">
		  	<div class="cnt"><!-- <img src="/images/AWS_1HR_PRCP_2019101422_natgrid_DAEGU.png" alt="" /> --></div>
		  	<div class="no_data"><p>자료가 생산되지 않았습니다.</p></div>
		  	<div class="legend"><img src="/images/legend.gif" alt="" /></div>
		</div>
        
        <div class="rtWd">
      		<h3>자치구별 강우실황(mm/hr)</h3>
          	<div class="tblwrap">
            	<table>
              	<col width="*" />
              	<col width="23.3%" span="3" />
              	<thead>
                <tr>
                  	<th scope="col">구</th>
                  	<th scope="col">-2h</th>
                  	<th scope="col">-1h</th>
                  	<th scope="col">0h</th>
                </tr>
              	</thead>
              	<tbody class="tbody_data">
              		<!--
	                <tr>
	                  	<td>강남구</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                -->
              	</tbody>
			</table>
          </div>
          
          <h3>자치구별 최대강우(mm/hr)</h3>
			<div class="tblwrap">
				<table>
					<col width="*" />
					<col width="23.3%" span="3" />
					<thead>
						<tr>
							<th scope="col">구</th>
							<th scope="col">-2h</th>
							<th scope="col">-1h</th>
							<th scope="col">0h</th>
						</tr>
					</thead>
					<tbody class="tbody_data"></tbody>
				</table>
			</div>
          
        </div>
	</div>
</form>
    
<jsp:include page="/WEB-INF/jsp/include/common_footer.jsp" />