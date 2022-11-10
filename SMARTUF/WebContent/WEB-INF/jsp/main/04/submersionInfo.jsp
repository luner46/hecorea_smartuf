<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/jsp/include/common_header.jsp" />

<script type="text/javascript">
$(function() {
	$('.menu_main li').eq(3).addClass("on");
	$('.fcstStus').eq(0).show();
	$('.fcstStus').eq(1).hide();
	selectTable('01');
	
	var container = document.getElementById('popup');
	var content = document.getElementById('popup-content');
	var overlay = new ol.Overlay(({element: container}));
	
	var daegu_emd_layer = new ol.layer.Tile({
	    source: new ol.source.TileWMS({
	    	url: 'http://geornd.hecorea.co.kr/smartuf/wms',
	    	params: {
	            'LAYERS': 'smartuf:daegu_emd'
	        },
	        opaque: false,
	        serverType: 'geoserver',
	        crossOrigin : 'anonymous'
	    })
	});
	
	var daegu_gugun_layer = new ol.layer.Tile({
	    source: new ol.source.TileWMS({
	    	url: 'http://geornd.hecorea.co.kr/smartuf/wms',
	    	params: {
	            'LAYERS': 'smartuf:daegu_gugun'
	        },
	        opaque: false,
	        serverType: 'geoserver',
	        crossOrigin : 'anonymous'
	    })
	});
	
	var daegu_si_layer = new ol.layer.Tile({
	    source: new ol.source.TileWMS({
	    	url: 'http://geornd.hecorea.co.kr/smartuf/wms',
	    	params: {
	            'LAYERS': 'smartuf:daegu_si'
	        },
	        opaque: false,
	        serverType: 'geoserver',
	        crossOrigin : 'anonymous'
	    })
	});
	
	var daegu_point = new ol.layer.Tile({
	    source: new ol.source.TileWMS({
	    	url: 'http://geornd.hecorea.co.kr/smartuf/wms',
	    	params: {
	            'LAYERS': 'smartuf:daegu_point'
	        },
	        opaque: false,
	        serverType: 'geoserver',
	        crossOrigin : 'anonymous'
	    })
	});
	
	map = new ol.Map({
	    logo: false,
	    target: 'map',
	    overlays: [overlay],
	    //layers: [new ol.layer.Tile({source: new ol.source.OSM()}), layer_all_basin],
	    layers: [new ol.layer.Tile({source: new ol.source.OSM()}), daegu_danger_layer, daegu_danger_sc_layer, daegu_danger_bc_layer, daegu_danger_rp_layer, daegu_danger_sk_layer, daegu_danger_kd_layer, daegu_danger_prsd_layer, daegu_emd_layer, daegu_gugun_layer, daegu_si_layer, daegu_point],
	    //layers: [new ol.layer.Tile({source: new ol.source.OSM()}), daegu_danger_ds_layer, daegu_emd_layer, daegu_gugun_layer, daegu_si_layer, daegu_point],
	    view: new ol.View({
	        projection : global_projection,
	        //center: [128.5724234, 35.891653], //126.62, 36.33 35.891653,128.5724234
	        center: [128.632566, 35.882781], //126.62, 36.33 35.891653,128.5724234
	        zoom: 13.4 //9.2
	        //minZoom: 8.0
	    })
	});
});

function selectData() {
	var node_cd = $('#node_cd').val();

	daegu_danger_layer.getSource().updateParams({LAYERS : "smartuf:flood_new_output_2dis_0" + node_cd + "mm_060m_3q"});
	daegu_danger_sc_layer.getSource().updateParams({LAYERS : "smartuf:flood_sc_output_2dis_0" + node_cd + "mm"});
	daegu_danger_bc_layer.getSource().updateParams({LAYERS : "smartuf:flood_bc_output_2dis_0" + node_cd + "mm"});
	daegu_danger_rp_layer.getSource().updateParams({LAYERS : "smartuf:flood_rp_output_2dis_0" + node_cd + "mm"});
	daegu_danger_sk_layer.getSource().updateParams({LAYERS : "smartuf:flood_sk_output_2dis_0" + node_cd + "mm"});
	daegu_danger_kd_layer.getSource().updateParams({LAYERS : "smartuf:flood_kd_output_2dis_0" + node_cd + "mm"});
	daegu_danger_prsd_layer.getSource().updateParams({LAYERS : "smartuf:flood_prsd_output_2dis_0" + node_cd + "mm"});
	
	//daegu_danger_ds_layer.getSource().updateParams({LAYERS : "smartuf:flood_ds_output_2dis_0" + node_cd + "mm"});
	//"smartuf:flood_sc_output_2dis_0
}

function selectTable(param) {
	$.ajax({
		type: "POST",
		url: "/floodCont/selectSubmersionData.do",
		dataType: "json",
		async : false,
		data: {'infoId': param},
		success: function(data) {
			console.log(data.dataList.length);
			$('#text_name').html("<h4>" + data.dataList[0].infoName + "</h4>");
			$('#text_dist_type').html(data.dataList[0].distType);
			$('#text_info_name').html(data.dataList[0].infoName);
			$('#text_info_model').html(data.dataList[0].infoModel);
			$('#text_loc').html(data.dataList[0].loc);
			$('#text_info_dt').html(data.dataList[0].infoDt);
			$('#ul_quality').html(data.dataList[0].quality);
			$('#ul_reason').html(data.dataList[0].reason);
			$('#ul_forecast').html(data.dataList[0].forecast);
			$('#text_etc').html(data.dataList[0].etc);
			$('#img_dist_type').attr("src", "/images/submersion/" + data.dataList[0].infoId + "_00.jpg");
			$('#img_field_01').attr("src", "/images/submersion/" + data.dataList[0].infoId + "_01.jpg");
			$('#img_field_02').attr("src", "/images/submersion/" + data.dataList[0].infoId + "_02.jpg");
		}
	});
}

$(document).on('click', '.tab li', function() {
	var current_class = $(this).attr('class');
	
	if(!$(this).hasClass("on")) {
		$('.tab li').removeClass("on");
		$('.' + current_class).addClass("on");
		$('#node_cd').val(current_class);
		
		selectData();
	}
});

$(document).on('change', '#select_area', function() {
	var select_area = $('#select_area option:selected').val();
	selectTable(select_area);
	
	
	
	/*
	if(select_area == 'option_a') {
		$('.fcstStus').eq(0).show();
		$('.fcstStus').eq(1).hide();
		$('#text_name').html("<h4>3공단분구1지구</h4>");
		
	} else {
		$('.fcstStus').eq(0).hide();
		$('.fcstStus').eq(1).show();
		$('#text_name').html("<h4>침산분구1지구</h4>");
	}
	*/
	
});

</script>

<form action="" method="get">
<input type="hidden" id="node_cd" value='${nodeCd}' />

	<div id="container" class="indInfo">
        <ul class="tab">
			<li class="30 on"><a href="#">30mm</a></li>
			<li class="40"><a href="#">40mm</a></li>
			<li class="50"><a href="#">50mm</a></li>
			<li class="60"><a href="#">60mm</a></li>
			<li class="70"><a href="#">70mm</a></li>
			<li class="80"><a href="#">80mm</a></li>
			<li class="90"><a href="#">90mm</a></li>
		</ul>
		<div class="ltWd">
			<div class="cnt" id="map"><!-- <img src="//images/samp_indInfo.png" alt="" /> --></div>
			<ul class="legend">
				<li>안전</li>
				<li>관심</li>
				<li>주의</li>
				<li>경계</li>
				<li>심각</li>
			</ul>
		</div>
		<div class="rtWd">
		
			<h3>홍수 위험지구 현황</h3>
            <div class="nameSelt">
                <div id="text_name"><h4>3공단분구1지구</h4></div>
                <select id="select_area">
                	<c:forEach var="dl" items="${dataList}">
              			<option value="${dl.infoId}">${dl.infoName}</option>
					</c:forEach>
                	<!--  
                    <option value="option_a">3공단분구1지구</option>
                    <option value="option_b">침산분구1지구</option>
                    -->
                </select>
            </div>
			<div class="tblwrap">
				<!--  
				<table class="fcstStus">
					<col width="*" />
					<col width="30%" />
					<col width="50%" />
					<tr>
						<td>재해유형</td>
						<td>내수재해</td>
						<td rowspan="5"><img width="140" src="/images/samp_indInfo2.png" alt="" /></td>
					</tr>
					<tr>
						<td>지구명</td>
						<td>3공단분구1지구</td>
					</tr>
					<tr>
						<td>기호명</td>
						<td>IFP-W28</td>
					</tr>
					<tr>
						<td>위치</td>
						<td>서구 비산동 2041-112번지 일원</td>
					</tr>
					<tr>
						<td>조사일자</td>
						<td>2013. 09. 03</td>
					</tr>
					<tr>
						<td>현장사진</td>
						<td colspan="2">
							<img width="119" src="/images/samp_indInfo3.png" alt="" />
							<img width="119" src="/images/samp_indInfo4.png" alt="" />
						</td>
					</tr>
					<tr>
						<td>지구특성</td>
						<td colspan="2">산업시설 및 밀집지역이며 금호강 수위대비 저지대 지역으로 3공단 빗물펌프장 유역에 해당됨</td>
					</tr>
					<tr>
						<td>위험요인</td>
						<td colspan="2">
							<ul>
								<li>위험지구 주변 관거에 대한 정량적 분석(방재성능목표강우량 적용)을 검토한 결과 하류에 위치한 3공단빗물펌프장 용량 부족으로 우수흐름이 지체되어 침수발생이 되고 있는 것으로 검토됨.</li>
								<li>정량적 분석결과 하류인근에 위치한 3공단 빗물펌프장 용량부족으로 우수흐름이 지체되고 부분적으로 관거 통수단면이 부족하여 침수위험성이 있는 것으로 검토되어 빗물펌프장 증설 및 관거개선이 필요함.</li>
							</ul>
						</td>
					</tr>
					<tr>
						<td>예상피해</td>
						<td colspan="2">
							<ul>
								<li>예상피해지역내 산업지역이 밀집해 있음.</li>
								<li>인구 및 자산조사 순위 : 75위(자산가치 67위, 인구순위 78위)</li>
								<li>예상 피해면적 : 6.88ha</li>
								<li>예상 피해액 : 1,073백만원</li>
							</ul>
						</td>
					</tr>
					<tr>
						<td>참고사항</td>
						<td colspan="2">내수재해위험지구 3공단빗물펌프장 저감대책으로 위험요인 해소</td>
					</tr>
				</table>
				-->
				
                <!-- 침산분구1지구 -->
				<table class="fcstStus">
					<col width="*" />
					<col width="30%" />
					<col width="50%" />
					<tr>
						<td>재해유형</td>
						<td id="text_dist_type"></td>
						<td rowspan="5"><img id="img_dist_type" width="140" src="/images/samp_indInfo5.png" alt="" /></td>
					</tr>
					<tr>
						<td>지구명</td>
						<td id="text_info_name">침산분구1지구</td>
					</tr>
					<tr>
						<td>기호명</td>
						<td id="text_info_model">IFP-N16</td>
					</tr>
					<tr>
						<td>위치</td>
						<td id="text_loc">북구 침산동 772번지 일원</td>
					</tr>
					<tr>
						<td>조사일자</td>
						<td id="text_info_dt">2013. 09. 05</td>
					</tr>
					<tr>
						<td>현장사진</td>
						<td colspan="2">
							<img width="119" id="img_field_01" src="/images/samp_indInfo6.png" alt="" />
							<img width="119" id="img_field_02" src="/images/samp_indInfo7.png" alt="" />
						</td>
					</tr>
					<tr>
						<td>지구특성</td>
						<td colspan="2">
                            <ul id="ul_quality">
                                <!--<li>금호강 우안( No.36+400) 제내지 지역에 신천대로와 접속도로 부근이며, 주변 지역은 대부분 공장지대로 형성되어 있음</li>
                                <li>하수관로의 구배가 완만하여 배수의 흐름이 원활하지 못함.</li>
                                <li>저지대로 인한 금호강의 홍수위 상승시 배수지체가 발생하여 도로침수</li>-->
                            </ul>
                        </td>
					</tr>
					<tr>
						<td>위험요인</td>
						<td colspan="2">
							<ul id="ul_reason">
								<!--<li>위험지구 주변 관거에 대한 정량적 분석(방재성능목표강우량 적용)을 검토한 결과 하구에 위치한 침산 빗물펌프</li>
								<li>하구에 위치한 침산 빗물펌프장 용량부족으로 인해 관로내 우수가 원활하게 배수되지 않아 침수(최대침수심 1.14m)가 발생되고 있어 침산빗물펌프장 용량 증설 필요</li>-->
							</ul>
						</td>
					</tr>
					<tr>
						<td>예상피해</td>
						<td colspan="2">
							<ul id="ul_forecast">
								<!--<li>예상피해지역내 주거지역과 상업지역이 입지함.</li>
								<li>인구 및 자산조사 순위 : 80위(자산가치 76위, 인구순위 82위)</li>
								<li>예상 피해면적 : 3.0ha</li>
								<li>예상 피해액 : 609백만원</li>-->
							</ul>
						</td>
					</tr>
					<tr>
						<td>참고사항</td>
						<td colspan="2" id="text_etc">&nbsp;</td>
					</tr>
				</table>
			</div>
            <!-- /2019-10-23 수정 end -->
            
		</div>
	</div>
</form>
    
    <jsp:include page="/WEB-INF/jsp/include/common_footer.jsp" />