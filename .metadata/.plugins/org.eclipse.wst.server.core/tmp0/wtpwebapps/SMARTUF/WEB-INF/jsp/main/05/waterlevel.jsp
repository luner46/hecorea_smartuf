<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/jsp/include/common_header.jsp" />

<script type="text/javascript">
$(function() {
	$('.menu_main li').eq(4).addClass("on");
	
	hourpicker("input_hour");
	
	var current_input_hour = $('#current_input_hour').val();
	$('#input_hour').val(current_input_hour);
	
	datepicker("input_issuestime");
	currentDateCheck("em_issuestime");
	
	selectData();
});

function selectMinProc(issue_time, it) {
	var yy = issue_time.substr(0, 4);
	var mm = issue_time.substr(4, 2);
	var dd = issue_time.substr(6, 2);
	var hh = issue_time.substr(8, 2);
	var mi = issue_time.substr(10, 2);
	var ds = yy + '/' + mm + '/' + dd + ' ' + hh + ':' + mi + ':00';
	var temp_date = new Date(ds);

	temp_date.setMinutes(temp_date.getMinutes() + parseInt(it));

	var new_yy = temp_date.getFullYear();
	var new_mm = temp_date.getMonth() + 1;
	var new_dd = temp_date.getDate();
	var new_hh = temp_date.getHours();
	var new_mi = temp_date.getMinutes();

	var str_new_yy = new_yy;
	var str_new_mm = (parseInt(new_mm) < 10) ? "0" + new_mm:new_mm;
	var str_new_dd = (parseInt(new_dd) < 10) ? "0" + new_dd:new_dd;
	var str_new_hh = (parseInt(new_hh) < 10) ? "0" + new_hh:new_hh;
	var str_new_mi = (parseInt(new_mi) < 10) ? "0" + new_mi:new_mi;
	
	return "" + str_new_yy + str_new_mm + str_new_dd + str_new_hh + str_new_mi;
}

function selectData() {
	var input_issuestime = selectIssuetime();
	var input_hour = selectIssuehour();
	
	//var yy = input_issuestime.substr(0, 4);
	//var mm = input_issuestime.substr(4, 2);
	//var dd = input_issuestime.substr(6, 2);
	
	$.ajax({
		type: "POST",
		url: "/floodCont/selectWaterLevelData.do",
		dataType: "json",
		async : false,
		data: {'dt': input_issuestime + "" + input_hour, 'gid': '220300001'},
		success: function(data) {
			var html = "";
			var dt = "";
			var wl = "";
			
			var xaxis = new Array();
			var val = new Array();
			
			var yy = data.dt24H.substr(0, 4);
			var mm = data.dt24H.substr(4, 2);
			var dd = data.dt24H.substr(6, 2);
			
			for(var i=0; i<= 144; i++) {
				dt = selectMinProc(data.dt24H, i*10);
				at = dt.substr(4, 2) + "-" + dt.substr(6, 2) + "<br/> " + dt.substr(8, 2) + ":" + dt.substr(10, 2);
				bt = dt.substr(0, 4) + "-" + dt.substr(4, 2) + "-" + dt.substr(6, 2) + " " + dt.substr(8, 2) + ":" + dt.substr(10, 2);
				/*
				if(i * 10 < 10) {
					dt = "0" + i
					
				} else {
					dt = i * 10;
				}
				*/
				
				xaxis.push(at);
				val.push('');
				
				for(var j=0; j<data.dataList.length; j++) {
					if(dt == data.dataList[j].OBSTM) val[i] = data.dataList[j].WL;
				} 			
				
				html += "<tr>";
				html += "<td>" + bt + "</td>";
				html += "<td>" + selectDataCheck(val[i]) + "</td>";
				html += "<td>-</td>";
				html += "</tr>";
			}
			
			//console.log(xaxis);
			
			$('.tbody_data').eq(0).html(html);
			
			$("#chart_data").highcharts({
			    chart: {
			        type: "line"
			    },
			    title: {
			    	text : null
			    },
			    xAxis: {
			    	title: {
			            text: '시간(10분)'
			        },
			        tickInterval : 24,
			        categories: xaxis
			    },
			    plotOptions: {
			        series: {
			            animation: false,
			            marker: {
			                enabled: false
			            }
			        }
			    },
			    credits: {
		            enabled: false
		        },
			    yAxis: [{
			        title: {
			        	text: '수위(cm)'
			        },
			        labels: {
			            format: '{value:,.2f}'
			        },
			        lineWidth: 1
			    }],
			    series: [{
			        name: '수위',
			        data: val
			    }],
			    legend: {
			        enabled: false
			    },
				exporting : {
					enabled : false,
					sourceWidth : 1100,
					sourceHeight : 250,
					scale : 1
				}
		        
			});
			
			
		}
	});
}

function selectDataCheck(val) {
	var result = "";
	
	if(val != '0' && val == '') {
		result = "-";
		
	} else {
		result = val.toFixed(1);
	}
	
	return result;
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
	
	<div id="container" class="wtrLvl">
		<div class="submenu">
            <a href="/flood/basinlevel.do">하천수위실황</a>
            <a href="/flood/waterlevel.do" class="on">우수관로실황</a>
        </div>
        
    	<div class="sett">
			<strong>현재시각</strong>
          	<em id="em_issuestime"></em>
          	<span>|</span>
          	<strong>날짜 선택</strong>
          	<input type="text" id="input_issuestime" name="" value="<c:out value='${fn:substring(issueDate, 0, 4)}' />년 <c:out value='${fn:substring(issueDate, 4, 6)}' />월 <c:out value='${fn:substring(issueDate, 6, 8)}' />일"  onfocus="javascript:selectFocus(this);" />
          	<select id="input_hour" name=""></select>
          	
          	<a href="javascript:selectNow();"><img src="/images/btn_now.gif" alt="Now" /></a>
          	
          	<!--  
          	<div class="sltWrap">
	            <select>
	              <option value="">지구</option>
	            </select>
	            <select name="">
	              <option value="">지점?</option>
	            </select>
          	</div>
          	-->
		</div>
		
        <div class="ltWd">
          	<div class="crtwrap">
            <div class="cnt" id="chart_data"><!-- <img src="/images/waterdepth.gif" alt="" /> --></div>
            <ul class="legend">
              	<li>안전</li>
              	<li>관심</li>
              	<li>주의</li>
              	<li>경계</li>
              	<li>심각</li>
            </ul>
		</div>

		<div class="tblwrap">
            <div class="thead">
                <table>
                    <col width="120px" />
                    <col width="70px" />
                    <col width="*" />
                    <tr>
                        <td scope="col">시간</td>
                        <td scope="col">수위</td>
                        <td scope="col">예경보</td>
                    </tr>
                </table>
            </div>
            <div class="scroll">
                <table>

                <col width="120px" />
                <col width="70px" />
                <col width="*" />
              	<tbody class="tbody_data">
              		<!-- 
	                <tr>
	                  	<td>현시점</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                <tr>
	                  	<td>2019. 00.00 13:00</td>
	                  	<td>0.0</td>
	                  	<td>0.0</td>
	                </tr>
	                 -->
              	</tbody>
            </table>
          </div>
        </div>
        </div>
        
        <div class="rtWd">
        	<h3>관측지점 및 수위계측기 정보</h3> <!-- h3 텍스트 변경 -->
        	<div class="maplink"><img width="330" src="/images/waterlevel01.png" alt="" /></div>
            <dl class="detail">
                <dt class="captn">시범 대상지역에 설치한 초음파 수위계측기 사양</dt>
                <dd class="list">
                    <ul>
                        <li>
                            <dl>
                                <dt>모델</dt>
                                <dd>LT-200</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>측정방식</dt>
                                <dd>초음파펄스반사방식</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>측정정도</dt>
                                <dd>±0.20%</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>측정범위</dt>
                                <dd>0.30~20m, 0.60~30m</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>측정주기</dt>
                                <dd>5~10회 /sec</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>측정정도</dt>
                                <dd>±0.20%</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>제어방식</dt>
                                <dd>CPU 제어방식</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>기능</dt>
                                <dd>자기진단기능, 액정밝기 조정기능, 전류출력 확인가능(출력 이상유무 LED 확인)</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>조작</dt>
                                <dd>6KEY  (UP, DOWN, RIGHT, LEFT, MENU, ESC)</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>동작온도</dt>
                                <dd>-30 ~ +85℃</dd>
                            </dl>
                        </li>
                    </ul>
                </dd>
            </dl>
        </div>
      </div>
    </form>
    
    <jsp:include page="/WEB-INF/jsp/include/common_footer.jsp" />