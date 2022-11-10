<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/jsp/include/common_header.jsp" />

<script type="text/javascript">
var node = "DS3000";

$(function() {
	$('.menu_main li').eq(2).addClass("on");
	$('#acc').val('030');
	$('#step').val('10');
	
	var container = document.getElementById('popup');
	var content = document.getElementById('popup-content');
	var overlay = new ol.Overlay(({element: container}));
	var overlay = new ol.Overlay(({element: container}));
	
	map = new ol.Map({
	    logo: false,
	    target: 'map',
	    overlays: [overlay],
	    //layers: [layer_google_base, layer_dg_node, node_layer, marker_layer],
	    layers: [new ol.layer.Tile({source: new ol.source.OSM()}), layer_dg_node, node_layer, marker_layer],
	    view: new ol.View({
	        projection : global_projection,
	        center: [128.5724234, 35.877653], //126.62, 36.33 35.891653,128.5724234
	        zoom: 13.8 //9.2
	        //minZoom: 8.0
	    })
	});
	
	map.on('pointermove', function (evt) {
    	if (evt.dragging) return;
	    
	    var pixel = map.getEventPixel(evt.originalEvent);
	    var coordinate = evt.coordinate;
	    var target = map.getTarget();
    	var jTarget = typeof target == "string" ? $("#" + target) : $(target);
	    
	    var feature = map.forEachFeatureAtPixel(pixel, function(feature) {
            return feature;
        });
	    
	    var html = "";
	    
	    if(feature) {
	    	if(typeof feature.H.id != 'undefined') {
	    		jTarget.css("cursor", "pointer");
		    	
	   			html +=  "맨홀 : " + feature.H.id + "<br />";
	   			/*
	   			html +=  "결측률 : " + feature.H.params.per + "%<br />";
	            html +=  "위도 : " + feature.H.params.lat + "˚ / 경도: " +  feature.H.params.lon + "˚<br />";
		    	*/
		    	content.innerHTML = html;
	            overlay.setPosition(coordinate);
	    	}
            
	    } else {
	    	jTarget.css("cursor", "default");
	    	overlay.setPosition(undefined);
	    }
    });
	
	map.on('singleclick', function (evt) {
		if (evt.dragging) return;
	    
	    var pixel = map.getEventPixel(evt.originalEvent);
	    var target = map.getTarget();
    	var jTarget = typeof target === "string" ? $("#" + target) : $(target);
	    
	    var feature = map.forEachFeatureAtPixel(pixel, function(feature) {
            return feature;
        });
	    
	    if(feature) {
	    	jTarget.css("cursor", "pointer");
	    	
	    	node = feature.H.id;

	    	selectDetail(node);
            setMapMarker(feature.H.id, feature.H.params);
            
	    } else {
	    	jTarget.css("cursor", "default");
	    }
    });
	
	
	var geom_trans = ([128.584, 35.9033]); //35.9033 128.584
	var geom = new ol.geom.Point(geom_trans);
	
	var node = new ol.Feature({
        id : 'DS3000',
        params: {
            'lat': 35.9033,
            'lon': 128.584
        }
   	});
	
	node.setGeometry(geom);
	node.setStyle(icon_style_node);
	
	marker_layer.getSource().addFeature(node);
	marker_layer.setZIndex(1);
	
	
	selectData();
	node = "DS3000";
	selectDetail('DS3000');
});

function setMapMarker(id, val) {
	var geom_trans = ([val.lon, val.lat]);
	var geom = new ol.geom.Point(geom_trans);
	
	marker_layer.getSource().clear();
	
	var node = new ol.Feature({
        id : id,
        params: {
            'lat': val.lat,
            'lon': val.lon
        }
   	});
	
	node.setGeometry(geom);
	node.setStyle(icon_style_node);
	
	marker_layer.getSource().addFeature(node);
	marker_layer.setZIndex(1);
	
}


function selectData() {
	var acc = $('#acc').val();
	var step = $('#step').val();
	var dt = $('#dt').val();
	
	node_layer.getSource().clear();
	
	console.log(acc + step + dt);
	
	$.ajax({
		type: "POST",
		url: "/floodCont/selectNodeData.do",
		dataType: "json",
		async : false,
		data: {'acc': acc, 'step': step, 'dt': dt.substr(0, 10)},
		success: function(data) {
			var html = "";
			var color = "";
			
			for(var i=0; i<data.liveList.length; i++) {
				var geom_trans = ([data.liveList[i].LON, data.liveList[i].LAT]);
				var geom = new ol.geom.Point(geom_trans);
				
				var node = new ol.Feature({
	    	         id : data.liveList[i].NODE,
	    	         params: {
	                     'lat': data.liveList[i].LAT,
	                     'lon': data.liveList[i].LON
	                 }
	    	    });
				
				if(data.dataList[i].GRADE == '5') {
					color = "#D80012";
					
					var warn_circle_style = new ol.style.Style({
						image: new ol.style.Circle({
						    radius: 10,
						    stroke: new ol.style.Stroke({
						      color: '#000000',
					    	  width: 3
						    }),
						    fill: new ol.style.Fill({
						      color: color
						    })
						})
					});
					
					node.setStyle(warn_circle_style);
					
				} else {
					if(data.liveList[i].GRADE == '1') color = "#FFFFFF";
					if(data.liveList[i].GRADE == '2') color = "#00B7EE";
					if(data.liveList[i].GRADE == '3') color = "#5F52A0";
					if(data.liveList[i].GRADE == '4') color = "#BA0469";
					
					var node_circle_style = new ol.style.Style({
						image: new ol.style.Circle({
						    radius: 5,
						    stroke: new ol.style.Stroke({
						      color: '#000000'
						    }),
						    fill: new ol.style.Fill({
						      color: color
						    })
						})
					});
					
					node.setStyle(node_circle_style)
				}
				
			 	node.setGeometry(geom);
	    		node_layer.getSource().addFeature(node);
			}
		}
	});
}

function selectDetail(node) {
	var acc = $('#acc').val();
	
	$.ajax({
		type: "POST",
		url: "/floodCont/selectNodeDetail.do",
		dataType: "json",
		async : false,
		data: {'acc': acc, 'node': node},
		success: function(data) {
			var html = "";
			
			for(var i=0; i<data.dataList.length; i++) {
				html += "<tr class='tr_class tr_" + data.dataList[i].FCSTTIMESTEP + "'>";
				html += "<td>+" + data.dataList[i].FCSTTIMESTEP + "</td>";
				html += "<td>" + data.dataList[i].DEPTH.toFixed(3) + "</td>";
				html += "<td>" + data.dataList[i].OVFLW.toFixed(1) + "</td>";
				
				if(data.dataList[i].GRADE == '1') html += "<td class='legend1'>" + selectGrade(data.dataList[i].GRADE) + "</td>";
				if(data.dataList[i].GRADE == '2') html += "<td class='legend2'>" + selectGrade(data.dataList[i].GRADE) + "</td>";
				if(data.dataList[i].GRADE == '3') html += "<td class='legend3'>" + selectGrade(data.dataList[i].GRADE) + "</td>";
				if(data.dataList[i].GRADE == '4') html += "<td class='legend4'>" + selectGrade(data.dataList[i].GRADE) + "</td>";
				if(data.dataList[i].GRADE == '5') html += "<td class='legend5'>" + selectGrade(data.dataList[i].GRADE) + "</td>";
				
				html += "</tr>";
			}
			
			$(".tbody_data").eq(0).html(html);
			$("#h3_text").html("<h3>맨홀 " + node + ": 1차원 홍수정보</h3>"); //맨홀 OOOOOO: 1차원 홍수정보
		}
	});
}

function selectGrade(val) {
	var result = "";
	
	if(val == '1') result = "안전";
	if(val == '2') result = "관심";
	if(val == '3') result = "주의";
	if(val == '4') result = "경계";
	if(val == '5') result = "<strong>심각</strong>";
	
	return result;
}

$(document).on('click', '.tab li', function() { //top tap only table, gis
	var current_class = $(this).attr('class');
	
	if(!$(this).hasClass("on")) {
		$('.tab li').removeClass("on");
		$('.' + current_class).addClass("on");
		$('#acc').val(current_class);
		
		selectData();
		selectDetail(node);
	}
});

$(document).on('click', '.tabBttm li', function() { //bottom tab only gis data
	var current_class = $(this).attr('class');
	
	if(!$(this).hasClass("on")) {
		$('.tabBttm li').removeClass("on");
		$('.' + current_class).addClass("on");
		$('#step').val(current_class);
		
		$('.tr_class').removeClass("on");
		$('.tr_' + current_class).addClass("on");
		
		selectData();
		selectDetail(node);
	}
});

</script>

<form action="" method="get">
<input type="hidden" id="acc" />
<input type="hidden" id="step" />
<input type="hidden" id="dt" value="${issueDate}"/>

	<div id="container" class="fldInfo live">
		<div class="submenu">
            <a href="/flood/floodLive.do">실황</a>
            <a href="/flood/floodLiveB.do" class="on">예측</a>
            <a href="/flood/floodInfo.do">시나리오</a>
        </div>
        
        <ul class="tab" style="display:none;">
          	<li class="030 on"><a href="#">30mm</a></li>
			<li class="040"><a href="#">40mm</a></li>
			<li class="050"><a href="#">50mm</a></li>
			<li class="060"><a href="#">60mm</a></li>
			<li class="070"><a href="#">70mm</a></li>
			<li class="080"><a href="#">80mm</a></li>
			<li class="090"><a href="#">90mm</a></li>
        </ul>
        
        <div class="ltWd">
          	<div class="cnt" id="map"><!-- <img src="/images/samp_fldInfo.gif" alt="" /> --></div>
          	<ul class="legend">
            	<li>안전</li>
            	<li>관심</li>
            	<li>주의</li>
            	<li>경계</li>
            	<li>심각</li>
          	</ul>
        </div>
        
        <div id="popup" class="ol-popup">
			<div id="popup-content"></div>
	    </div>
        
        <div class="rtWd">
          	<div id='h3_text'></div>
          	<div class="tblwrap">
	            <table>
	              	<col width="*" />
	              	<col width="23.3%" span="3" />
	              	<thead>
		                <tr>
		                  	<th scope="col">발생시간</th>
		                  	<th scope="col">수위</th>
		                  	<th scope="col">월류량</th>
		                  	<th scope="col">예경보</th>
		                </tr>
	              	</thead>
	              	<tbody class="tbody_data">
	              	</tbody>
				</table>
			</div>
		</div>
		
        <ul class="tabBttm" style="display:none;">
          	<li class="10"><a href="#">+10</a></li>
          	<li class="20"><a href="#">+20</a></li>
          	<li class="30"><a href="#">+30</a></li>
          	<li class="40"><a href="#">+40</a></li>
          	<li class="50"><a href="#">+50</a></li>
          	<li class="60"><a href="#">+60</a></li>
          	<li class="70"><a href="#">+70</a></li>
          	<li class="80"><a href="#">+80</a></li>
          	<li class="90"><a href="#">+90</a></li>
          	<li class="100"><a href="#">+100</a></li>
          	<li class="110"><a href="#">+110</a></li>
          	<li class="120"><a href="#">+120</a></li>
          	<li class="130"><a href="#">+130</a></li>
          	<li class="140"><a href="#">+140</a></li>
          	<li class="150"><a href="#">+150</a></li>
          	<li class="160"><a href="#">+160</a></li>
          	<li class="170"><a href="#">+170</a></li>
          	<li class="180"><a href="#">+180</a></li>
          	<li class="999 on"><a href="#">최대</a></li>
        </ul>
        
	</div>
</form>
    
    <jsp:include page="/WEB-INF/jsp/include/common_footer.jsp" />