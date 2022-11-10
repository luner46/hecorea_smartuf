<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/jsp/include/common_header.jsp" />

<script type="text/javascript">
var node = "DS3000";

$(function() {
	$('.menu_main li').eq(6).addClass("on");
	
	datepicker("input_issuestime");
	hourpicker("input_hour");
	var current_input_hour = $('#current_input_hour').val();
	$('#input_hour').val(current_input_hour);
	
	var container = document.getElementById('popup');
	var content = document.getElementById('popup-content');
	var overlay = new ol.Overlay(({element: container}));
	var overlay = new ol.Overlay(({element: container}));
	
	map = new ol.Map({
	    logo: false,
	    target: 'map',
	    controls: [],
	    overlays: [overlay],
	    //layers: [layer_google_base, layer_dg_node, node_layer, marker_layer],
	    layers: [new ol.layer.Tile({source: new ol.source.OSM()}), layer_dg_node, node_layer, marker_layer],
	    view: new ol.View({
	        projection : global_projection,
	        center: [128.5724234, 35.847653], //126.62, 36.33 35.891653,128.5724234
	        zoom: 11.5 //9.2
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
	    	if(typeof feature.H.params.lscd != 'undefined') {
	    		jTarget.css("cursor", "pointer");
		    	
	    		html += "<table border='1'>"
	   			html +=  "<tr><td>예경보지점</td><td>" + feature.H.params.lscd + "</td></tr>";
	   			html +=  "<tr><td>현재시강우량(mm)</td><td>" + feature.H.params.current_rain + "</td></tr>";
	   			html +=  "<tr><td>강우지속기간(hr)</td><td>" + feature.H.params.r_count + "</td></tr>";
	   			//html +=  "<tr><td>w_count</td><td>" + feature.H.params.w_count + "</td></tr>";
	   			html +=  "<tr><td>강우강도(mm/hr)</td><td>" + feature.H.params.i_val + "</td></tr>";
	   			html +=  "<tr><td>누적강우량(mm)</td><td>" + feature.H.params.c_val + "</td></tr>";
	   			html +=  "<tr><td>누적강우*0.75(mm)</td><td>" + feature.H.params.cr_val + "</td></tr>";
	   			html +=  "<tr><td>누적임계강우량(mm)</td><td>" + feature.H.params.critical + "</td></tr>";
	   			html += "</table>"
	   			
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
	    	if(typeof feature.H.params.lscd != 'undefined') {
		    	jTarget.css("cursor", "pointer");
		    	
		    	//node = feature.H.id;
	
		    	selectDetail(feature.H.params.lscd);
	            setMapMarker(feature.H.params.lscd, feature.H.params);
	            
		    } else {
		    	jTarget.css("cursor", "default");
		    }
	    }
    });
	
	/*
	var geom_trans = ([128.584, 35.9033]); //35.9033	128.584
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
	*/
	
	selectData();
	//selectDetail('DS3000');
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
	
	var ls_stn_style = new ol.style.Style({
	    image: new ol.style.Icon(({
	    	anchor: [0.5, 32],
	        anchorXUnits: 'fraction',
	        anchorYUnits: 'pixels',
	        src: '/images/marker_stn.gif'
	    }))
	});
	
	node.setGeometry(geom);
	node.setStyle(ls_stn_style);
	
	marker_layer.getSource().addFeature(node);
	marker_layer.setZIndex(1);
	
}


function selectData() {
	var yy = selectIssuetime().substr(0, 4);
	var mm = selectIssuetime().substr(4, 2);
	var dd = selectIssuetime().substr(6, 2);
	var hh = selectIssuehour();
	
	node_layer.getSource().clear();
	
	$.ajax({
		type: "POST",
		url: "/floodCont/selectLandSlideData.do",
		dataType: "json",
		async : false,
		data: {'dt': selectIssuetime() + '' + selectIssuehour()},
		success: function(data) {
			var html = "";
			var color = "";
			
			for(var i=0; i<data.dataList.length; i++) {
				var geom_trans = ([data.dataList[i].LON, data.dataList[i].LAT]);
				var geom = new ol.geom.Point(geom_trans);
				
				var lv1 = data.dataList[i].LV1;
				var lv2 = data.dataList[i].LV2;
				var lv3 = data.dataList[i].LV3;
				var lv4 = data.dataList[i].LV4;
				
				var current_grade = '';
				var legend_class = '';
				var legend_name = '';
				var current_color = '';
				
				/*
				if(lv1 == 'y' && lv2 == 'n' && lv3 == 'n' && lv4 == 'n') {
					current_grade = 'lv1';
					legend_class = 'legend2';
					legend_name = '관심';
					current_color = '#0054ff';
					
				} else if(lv1 == 'y' && lv2 == 'y' && lv3 == 'n' && lv4 == 'n') {
					current_grade = 'lv2';
					legend_class = 'legend3';
					legend_name = '주의';
					current_color = '#ffff00';
					
				} else if(lv1 == 'y' && lv2 == 'y' && lv3 == 'y' && lv4 == 'n') {
					current_grade = 'lv3';
					legend_class = 'legend4';
					legend_name = '경계';
					current_color = '#ffaa00';
					
				} else if(lv1 == 'y' && lv2 == 'y' && lv3 == 'y' && lv4 == 'y') {
					current_grade = 'lv4';
					legend_class = 'legend5';
					legend_name = '심각';
					current_color = '#ff0000';
					
				} else {
					current_grade = 'lv0';
					legend_class = 'legend1';
					legend_name = '안전';
					current_color = '#1fbc02';
				}
				*/
				
				if(lv1 == 'n' && lv2 == 'y' && lv3 == 'y' && lv4 == 'y') {
					current_grade = 'lv1';
					legend_class = 'legend2';
					legend_name = '관심';
					current_color = '#0054ff';
					
				} else if(lv1 == 'n' && lv2 == 'n' && lv3 == 'y' && lv4 == 'y') {
					current_grade = 'lv2';
					legend_class = 'legend3';
					legend_name = '주의';
					current_color = '#ffff00';
					
				} else if(lv1 == 'n' && lv2 == 'n' && lv3 == 'n' && lv4 == 'y') {
					current_grade = 'lv3';
					legend_class = 'legend4';
					legend_name = '경계';
					current_color = '#ffaa00';
					
				} else if(lv1 == 'n' && lv2 == 'n' && lv3 == 'n' && lv4 == 'n') {
					current_grade = 'lv4';
					legend_class = 'legend5';
					legend_name = '심각';
					current_color = '#ff0000';
					
				} else {
					current_grade = 'lv0';
					legend_class = 'legend1';
					legend_name = '안전';
					current_color = '#1fbc02';
				}
				
				var node = new ol.Feature({
	    	         id : data.dataList[i].NODE,
	    	         params: {
	    	        	 'lscd': data.dataList[i].LSCD,
	                     'lat': data.dataList[i].LAT,
	                     'lon': data.dataList[i].LON,
	                     'current_rain': data.dataList[i].CURRENTRAIN,
	                     'r_count': data.dataList[i].RCOUNT,
	                     'w_count': data.dataList[i].WCOUNT,
	                     'i_val': data.dataList[i].IVAL,
	                     'c_val': data.dataList[i].CVAL,
	                     'cr_val': data.dataList[i].CRVAL,
	                     'critical': data.dataList[i].CR,
	                 }
	    	    });
				
				var ls_stn_style = new ol.style.Style({
					image: new ol.style.Circle({
					    radius: 10,
					    stroke: new ol.style.Stroke({
					      color: '#000000',
				    	  width: 2
					    }),
					    fill: new ol.style.Fill({
					      color: current_color
					    })
					}),
				    text: new ol.style.Text({
				        text: data.dataList[i].LSCD,
			    		font: 'NanumBarunGothic',
				        scale: 1.5,
				        fill: new ol.style.Fill({
				          color: '#000000'
				        }),
				        stroke: new ol.style.Stroke({
				          color: '#FFFFFF',
				          width: 2.0
				        }),
				        offsetX: 30
				        //offsetY: 20
				      })
				});
				
				node.setStyle(ls_stn_style)
			 	node.setGeometry(geom);
	    		node_layer.getSource().addFeature(node);
	    		
	    		html += "<tr class=''>";
				html += "<td>" + data.dataList[i].OBSTM.substr(0, 4) + '.' + data.dataList[i].OBSTM.substr(4, 2) + '.' + data.dataList[i].OBSTM.substr(6, 2) + ' ' + data.dataList[i].OBSTM.substr(8, 2) + ":00</td>";
				html += "<td>" + data.dataList[i].LSCD + "</td>";
				html += "<td class='" + legend_class + "'>" + legend_name + "</td>";
				
				/*
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
					if(data.dataList[i].GRADE == '1') color = "#FFFFFF";
					if(data.dataList[i].GRADE == '2') color = "#00B7EE";
					if(data.dataList[i].GRADE == '3') color = "#5F52A0";
					if(data.dataList[i].GRADE == '4') color = "#BA0469";
					
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
				*/
				
			}
			
			$('#h3_text').html('<h3>예경보지점: 전체</h3>');
			$(".tbody_data").eq(0).html(html);
		}
	});
}

function selectDetail(ls_cd) {
	var yy = selectIssuetime().substr(0, 4);
	var mm = selectIssuetime().substr(4, 2);
	var dd = selectIssuetime().substr(6, 2);
	var hh = selectIssuehour();
	
	$.ajax({
		type: "POST",
		url: "/floodCont/selectLandSlideDetail.do",
		dataType: "json",
		async : false,
		data: {'dt': selectIssuetime() + '' + selectIssuehour(), 'lsCd': ls_cd},
		success: function(data) {
			var html = "";
			var color = "";
			
			for(var i=0; i<data.dataList.length; i++) {
				var geom_trans = ([data.dataList[i].LON, data.dataList[i].LAT]);
				var geom = new ol.geom.Point(geom_trans);
				
				var lv1 = data.dataList[i].LV1;
				var lv2 = data.dataList[i].LV2;
				var lv3 = data.dataList[i].LV3;
				var lv4 = data.dataList[i].LV4;
				
				var current_grade = '';
				var legend_class = '';
				var legend_name = '';
				var current_color = '';
				
				/*
				if(lv1 == 'y' && lv2 == 'n' && lv3 == 'n' && lv4 == 'n') {
					current_grade = 'lv1';
					legend_class = 'legend2';
					legend_name = '관심';
					current_color = '#0054ff';
					
				} else if(lv1 == 'y' && lv2 == 'y' && lv3 == 'n' && lv4 == 'n') {
					current_grade = 'lv2';
					legend_class = 'legend3';
					legend_name = '주의';
					current_color = '#ffff00';
					
				} else if(lv1 == 'y' && lv2 == 'y' && lv3 == 'y' && lv4 == 'n') {
					current_grade = 'lv3';
					legend_class = 'legend4';
					legend_name = '경계';
					current_color = '#ffaa00';
					
				} else if(lv1 == 'y' && lv2 == 'y' && lv3 == 'y' && lv4 == 'y') {
					current_grade = 'lv4';
					legend_class = 'legend5';
					legend_name = '심각';
					current_color = '#ff0000';
					
				} else {
					current_grade = 'lv0';
					legend_class = 'legend1';
					legend_name = '안전';
					current_color = '#1fbc02';
				}
				*/
				
				if(lv1 == 'n' && lv2 == 'y' && lv3 == 'y' && lv4 == 'y') {
					current_grade = 'lv1';
					legend_class = 'legend2';
					legend_name = '관심';
					current_color = '#0054ff';
					
				} else if(lv1 == 'n' && lv2 == 'n' && lv3 == 'y' && lv4 == 'y') {
					current_grade = 'lv2';
					legend_class = 'legend3';
					legend_name = '주의';
					current_color = '#ffff00';
					
				} else if(lv1 == 'n' && lv2 == 'n' && lv3 == 'n' && lv4 == 'y') {
					current_grade = 'lv3';
					legend_class = 'legend4';
					legend_name = '경계';
					current_color = '#ffaa00';
					
				} else if(lv1 == 'n' && lv2 == 'n' && lv3 == 'n' && lv4 == 'n') {
					current_grade = 'lv4';
					legend_class = 'legend5';
					legend_name = '심각';
					current_color = '#ff0000';
					
				} else {
					current_grade = 'lv0';
					legend_class = 'legend1';
					legend_name = '안전';
					current_color = '#1fbc02';
				}
				
	    		html += "<tr class=''>";
				html += "<td>" + data.dataList[i].OBSTM.substr(0, 4) + '.' + data.dataList[i].OBSTM.substr(4, 2) + '.' + data.dataList[i].OBSTM.substr(6, 2) + ' ' + data.dataList[i].OBSTM.substr(8, 2) + ":00</td>";
				html += "<td>" + data.dataList[i].LSCD + "</td>";
				html += "<td class='" + legend_class + "'>" + legend_name + "</td>";
			}
			
			$('#h3_text').html('<h3>예경보지점: ' + ls_cd + '</h3>');
			$(".tbody_data").eq(0).html(html);
		}
	});
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

$(document).on('change', '#input_hour', function() {
	selectData();
});

</script>

<form action="" method="get">
<input type="hidden" id="current_input_hour" value="${issueHour}" />
	<div id="container" class="landslide">
    	<div class="sett">
          	<strong>날짜 선택</strong>
          	<input type="text" id="input_issuestime" name="" value="<c:out value='${fn:substring(issueDate, 0, 4)}' />년 <c:out value='${fn:substring(issueDate, 4, 6)}' />월 <c:out value='${fn:substring(issueDate, 6, 8)}' />일"  onfocus="javascript:selectFocus(this);" />
          	<select id="input_hour" name=""></select>
          	<a href="javascript:selectNow();"><img src="/images/btn_now.gif" alt="Now"></a>
    	</div>
                
        <div class="ltWd">
            <div class="cnt" id="map"></div>
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
			<div class="btnre"><a href="/flood/landSlide.do">전체지점표출</a></div>
          	<div class="tblwrap">
	            <table>
	              	<col width="*" />
	              	<col width="38%" />
	              	<col width="26%" />
	              	<thead>
		                <tr>
		                  	<th scope="col">발생시간</th>
		                  	<th scope="col">예경보지점</th>
		                  	<th scope="col">예경보</th>
		                </tr>
	              	</thead>
	              	<tbody class="tbody_data">
	              		<!--  
                        <tr class=""><td>+10</td><td>0.000</td><td class="legend1">안전</td></tr>
                        <tr class=""><td>+10</td><td>0.000</td><td class="legend2">관심</td></tr>
                        <tr class=""><td>+10</td><td>0.000</td><td class="legend3">주의</td></tr>
                        <tr class=""><td>+10</td><td>0.000</td><td class="legend4">경계</td></tr>
                        <tr class=""><td>+10</td><td>0.000</td><td class="legend5">심각</td></tr>
                        -->
                    </tbody>
				</table>
			</div>
		</div>
	</div>
</form>
    
<jsp:include page="/WEB-INF/jsp/include/common_footer.jsp" />