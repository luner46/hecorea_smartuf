<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/jsp/include/common_header.jsp" />

<script type="text/javascript">
var node = "DS3000";
var current_stn_cd = "2011696"; 

$(function() {
	$('.menu_main li').eq(4).addClass("on");
	
	datepicker("input_issuestime");
	hourpicker("input_hour");
	minpicker("input_min");
	
	var current_input_hour = $('#current_input_hour').val();
	$('#input_hour').val(current_input_hour);
	
	var current_input_min = parseInt($('#current_input_min').val()) * 10;
	if(current_input_min == 0) {
		$('#input_min').val('0' + current_input_min);
		
	} else {
		$('#input_min').val('' + current_input_min);
	}
	
	var container = document.getElementById('popup');
	var content = document.getElementById('popup-content');
	var overlay = new ol.Overlay(({element: container}));
	var overlay = new ol.Overlay(({element: container}));
	
	map = new ol.Map({
	    logo: false,
	    target: 'map',
	    controls: [],
	    overlays: [overlay],
	    layers: [new ol.layer.Tile({source: new ol.source.OSM()}), layer_dg_node, node_layer, marker_layer],
	    view: new ol.View({
	        projection : global_projection,
	        center: [128.5724234, 35.807651], //126.62, 36.33 35.891653,128.5724234
	        zoom: 11.0 //9.2
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
	    	if(typeof feature.H.params.wlobscd != 'undefined') {
	    		jTarget.css("cursor", "pointer");
		    	
	    		html += "<table border='1'>"
	    		html +=  "<tr><td>관측소명</td><td>" + feature.H.params.obsnm + "</td></tr>";
	   			html +=  "<tr><td>관측소코드</td><td>" + feature.H.params.wlobscd + "</td></tr>";
	   			
	   			if(feature.H.params.wl == '-999') {
	   				html +=  "<tr><td>수위</td><td>자료없음</td></tr>";
	   			} else {
	   				html +=  "<tr><td>수위</td><td>" + feature.H.params.wl + "El.m</td></tr>";
	   			}
	   			
	   			html +=  "<tr><td style='color: #1fbc02'>안전</td><td>" + feature.H.params.lv1 + "↓</td></tr>";
	   			html +=  "<tr><td style='color: #00B7EE'>관심</td><td>" + feature.H.params.lv1 + "~" + feature.H.params.lv2 + "</td></tr>";
	   			html +=  "<tr><td style='color: #CBC100'>주의</td><td>" + feature.H.params.lv2 + "~" + feature.H.params.lv3 + "</td></tr>";
	   			html +=  "<tr><td style='color: #BA0469'>경계</td><td>" + feature.H.params.lv3 + "~" + feature.H.params.lv4 + "</td></tr>";
	   			html +=  "<tr><td style='color: #D80012'>심각</td><td>" + feature.H.params.lv4 + "↑</td></tr>";
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
	    	if(typeof feature.H.params.wlobscd != 'undefined') {
		    	jTarget.css("cursor", "pointer");
		    	
		    	selectDetail(feature.H.params.wlobscd);
		    	setMapMarker(feature.H.params.wlobscd, feature.H.params.lon, feature.H.params.lat);
	            
		    } else {
		    	jTarget.css("cursor", "default");
		    }
	    }
    });
	
	selectData();
	setMapMarker('2011696', '128.4653', '35.8392');
});

function setMapMarker(id, lon, lat) {
	var geom_trans = ([lon, lat]);
	var geom = new ol.geom.Point(geom_trans);
	
	marker_layer.getSource().clear();
	
	var node = new ol.Feature({
        id : id,
        params: {
            'lat': lat,
            'lon': lon
        }
   	});
	
	//console.log("aaa");
	
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
	
	node_layer.getSource().clear();
	
	//console.log(selectIssuetime() + '' + selectIssuehour() + '' + selectIssuemin());
	
	$.ajax({
		type: "POST",
		url: "/floodCont/selectBasinLevelData.do",
		dataType: "json",
		async : false,
		data: {'dt': selectIssuetime() + '' + selectIssuehour() + '' + selectIssuemin()},
		success: function(data) {
			var html = "";
			var color = "";
			
			$('#kma_txt').html(data.resultText);
			$('#image_path').attr('src', data.resultFile);
			
			for(var i=0; i<data.dataList.length; i++) {
				var geom_trans = ([data.dataList[i].LON, data.dataList[i].LAT]);
				var geom = new ol.geom.Point(geom_trans);
				
				var wl = parseFloat(data.dataList[i].WL);
				var wl_name = '';
				
				if(wl == '-999') {
					wl_name = "자료없음";
					
				} else {
					wl_name = wl + 'El.m';
				}
				
				var lv1 = parseFloat(data.dataList[i].LV1);
				var lv2 = parseFloat(data.dataList[i].LV2);
				var lv3 = parseFloat(data.dataList[i].LV3);
				var lv4 = parseFloat(data.dataList[i].LV4);
				
				var node = new ol.Feature({
	    	         id : data.dataList[i].NODE,
	    	         params: {
	    	        	 'wlobscd': data.dataList[i].WLOBSCD,
	    	        	 'obsnm': data.dataList[i].WLOBSNM,
	                     'lat': data.dataList[i].LAT,
	                     'lon': data.dataList[i].LON,
	                     'wl': wl,
	                     'lv1': lv1.toFixed(1),
	                     'lv2': lv2.toFixed(1),
	                     'lv3': lv3.toFixed(1),
	                     'lv4': lv4.toFixed(1)
	                 }
	    	    });
				
				var current_grade = '';
				var legend_class = '';
				var legend_name = '';
				var current_color = '';
				
				if(wl == '-999') {
					current_grade = 'lv-1';
					legend_class = 'legend1';
					legend_name = '자료없음';
					current_color = '#777777';
					
				} else {
					if(wl < lv2 && wl >= lv1) {
						current_grade = 'lv1';
						legend_class = 'legend2';
						legend_name = '관심';
						current_color = '#00B7EE';
						
					} else if(wl < lv3 && wl >= lv2) {
						current_grade = 'lv2';
						legend_class = 'legend3';
						legend_name = '주의';
						current_color = '#ffff00';
						
					} else if(wl < lv4 && wl >= lv3) {
						current_grade = 'lv3';
						legend_class = 'legend4';
						legend_name = '경계';
						current_color = '#BA0469';
						
					} else if(wl >= lv4) {
						current_grade = 'lv4';
						legend_class = 'legend5';
						legend_name = '심각';
						current_color = '#D80012';
						
					}  else {
						current_grade = 'lv0';
						legend_class = 'legend1';
						legend_name = '안전';
						current_color = '#1fbc02';
					}
				}
					
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
				        text: data.dataList[i].WLOBSNM + "(" + wl_name + ")",
			    		font: 'bold, "NanumBarunGothic"',
				        scale: 1.3,
				        fill: new ol.style.Fill({
				          color: '#000000'
				        }),
				        stroke: new ol.style.Stroke({
				          color: '#FFFFFF',
				          width: 3.0
				        }),
				        offsetX: 50
				        //offsetY: 20
				      })
				});
				
				node.setStyle(ls_stn_style)
			 	node.setGeometry(geom);
	    		node_layer.getSource().addFeature(node);
			}
			
			//$('#h3_text').html('<h3>수위관측소: 전체</h3>');
			//$(".tbody_data").eq(0).html(html);
		}
	});
	
	selectDetail(current_stn_cd);
}

function selectDetail(wlobscd) {
	$.ajax({
		type: "POST",
		url: "/floodCont/selectBasinLevelDetail.do",
		dataType: "json",
		async : false,
		data: {'dt': selectIssuetime() + '' + selectIssuehour() + '' + selectIssuemin(), 'wlobscd': wlobscd},
		success: function(data) {
			var html = "";
			var color = "";
			var wlobsnm = "";
			
			var xaxis = new Array();
			var val = new Array();
			
			var level1_val = '';
			var level2_val = '';
			var level3_val = '';
			var level4_val = '';
			
			console.log(data.dataList.length);
			
			for(var i=0; i<data.dataList.length; i++) {
				var geom_trans = ([data.dataList[i].LON, data.dataList[i].LAT]);
				var geom = new ol.geom.Point(geom_trans);
				
				var wl = parseFloat(data.dataList[i].WL);
				var lv1 = parseFloat(data.dataList[i].LV1);
				var lv2 = parseFloat(data.dataList[i].LV2);
				var lv3 = parseFloat(data.dataList[i].LV3);
				var lv4 = parseFloat(data.dataList[i].LV4);
				wlobsnm = data.dataList[i].WLOBSNM;
				
				var current_grade = '';
				var legend_class = '';
				var legend_name = '';
				var current_color = '';
				
				level1_val = lv1;
				level2_val = lv2;
				level3_val = lv3;
				level4_val = lv4;
				
				if(data.dataList.length < 1) {
					xaxis.push(null);
					val.push(null);
					
				} else {
					xaxis.push(data.dataList[i].OBSTM.substr(0, 4) + "." + data.dataList[i].OBSTM.substr(4, 2) + '.' + data.dataList[i].OBSTM.substr(6, 2) + ' ' + data.dataList[i].OBSTM.substr(8, 2) + ":" + data.dataList[i].OBSTM.substr(10, 2));
					val.push(wl);
				}
				
				if(wl == '-999') {
					current_grade = 'lv-1';
					legend_class = 'legend1';
					legend_name = '자료없음';
					current_color = '#777777';
					
				} else {
					if(wl < lv2 && wl >= lv1) {
						current_grade = 'lv1';
						legend_class = 'legend2';
						legend_name = '관심';
						current_color = '#00B7EE';
						
					} else if(wl < lv3 && wl >= lv2) {
						current_grade = 'lv2';
						legend_class = 'legend3';
						legend_name = '주의';
						current_color = '#ffff00';
						
					} else if(wl < lv4 && wl >= lv3) {
						current_grade = 'lv3';
						legend_class = 'legend4';
						legend_name = '경계';
						current_color = '#BA0469';
						
					} else if(wl >= lv4) {
						current_grade = 'lv4';
						legend_class = 'legend5';
						legend_name = '심각';
						current_color = '#D80012';
						
					}  else {
						current_grade = 'lv0';
						legend_class = 'legend1';
						legend_name = '안전';
						current_color = '#1fbc02';
					}
				}
				
				var geom_trans = ([data.dataList[i].LON, data.dataList[i].LAT]);
				var geom = new ol.geom.Point(geom_trans);
				
				marker_layer.getSource().clear();
				
				var node = new ol.Feature({
			        id : data.dataList[i].WLOBSCD,
			        params: {
			            'lat': data.dataList[i].LAT,
			            'lon': data.dataList[i].LON
			        }
			   	});
				
				var ls_stn_style = new ol.style.Style({
				    image: new ol.style.Icon(({
				    	anchor: [0.5, 32],
				        anchorXUnits: 'fraction',
				        anchorYUnits: 'pixels',
				        src: '//images/marker_stn.gif'
				    }))
				});
				
				node.setGeometry(geom);
				node.setStyle(ls_stn_style);
				
				marker_layer.getSource().addFeature(node);
				marker_layer.setZIndex(1);
				
				if(data.dataList.length < 1) {
					html += "<tr class=''>";
					html += "<td colspan='4'>자료없음</td>";
					html += "</tr>";
					
				} else {
					html += "<tr class=''>";
					html += "<td>" + data.dataList[i].OBSTM.substr(0, 4) + "." + data.dataList[i].OBSTM.substr(4, 2) + '.' + data.dataList[i].OBSTM.substr(6, 2) + ' ' + data.dataList[i].OBSTM.substr(8, 2) + ":" + data.dataList[i].OBSTM.substr(10, 2) + "</td>";
					html += "<td>" + data.dataList[i].WLOBSNM + "</td>";
					html += "<td>" + data.dataList[i].WL + "</td>";
					html += "<td class='" + legend_class + "'>" + legend_name + "</td>";
					html += "</tr>";
				}
			}
			
			$('#h3_text').html('<h3>수위관측소: ' + wlobsnm + '</h3>');
			$(".tbody_data").eq(0).html(html);
			
			$("#chart_data").highcharts({
			    chart: {
			        type: "line"
			    },
			    title: {
			    	text : null
			    },
			    xAxis: {
			    	title: {
			            text: '시간(분)'
			        },
			        tickInterval : 4,
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
			        	text: '수위(El.m)'
			        },
			        labels: {
			            format: '{value:,.2f}'
			        },
			        plotLines: [{
			            color: '#00B7EE',
			            width: 2,
			            value: level1_val,
			            dashStyle: 'ShortDot',
			            label: {
			                text: '관심',
			                style: {
			                    color: '#00B7EE',
			                    fontWeight: 'bold'
			                },
			                useHTML: true,
			                verticalAlign: 'top',
			                align: 'right',
			                //textAlign: 'right',
			                rotation: 0,
			                x: -10,
			                y: 15
			            },
			            zIndex: 5
			        },
			        {
			            color: '#5F52A0',
			            width: 2,
			            value: level2_val,
			            dashStyle: 'ShortDot',
			            label: {
			                text: '주의',
			                style: {
			                    color: '#5F52A0',
			                    fontWeight: 'bold'
			                },
			                useHTML: true,
			                verticalAlign: 'top',
			                align: 'right',
			                //textAlign: 'right',
			                rotation: 0,
			                x: -10,
			                y: 15
			            },
			            zIndex: 5
			        },
			        {
			            color: '#BA0469',
			            width: 2,
			            value: level3_val,
			            dashStyle: 'ShortDot',
			            label: {
			                text: '경계',
			                style: {
			                    color: '#BA0469',
			                    fontWeight: 'bold'
			                },
			                useHTML: true,
			                verticalAlign: 'top',
			                align: 'right',
			                //textAlign: 'right',
			                rotation: 0,
			                x: -10,
			                y: 15
			            },
			            zIndex: 5
			        },
			        {
			            color: '#D80012',
			            width: 2,
			            value: level4_val,
			            dashStyle: 'ShortDot',
			            label: {
			                text: '심각',
			                style: {
			                    color: '#D80012',
			                    fontWeight: 'bold'
			                },
			                useHTML: true,
			                verticalAlign: 'top',
			                align: 'right',
			                //textAlign: 'right',
			                rotation: 0,
			                x: -10,
			                y: 15
			            },
			            zIndex: 5
			        }]//,
			       	//max: level4_val + level2_val * 0.01
			    }
			    
			    ],
			    series: [{
			        name: '수위',
			        data: val,
			        lineWidth: 3
			    }],
			    legend: {
			        enabled: false
			    },
				exporting : {
					enabled : false,
					sourceWidth : 1100,
					sourceHeight : 250,
					scale : 1
				},
				lang: {
			        noData: "Nichts zu anzeigen"
			    },
				noData: {
			        style: {
			            fontWeight: 'bold',
			            fontSize: '15px',
			            color: '#303030'
			        }
			    }
			});
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

$(document).on('change', '#input_min', function() {
	selectData();
});

</script>

<form action="" method="get">
<input type="hidden" id="current_input_hour" value="${issueHour}" />
<input type="hidden" id="current_input_min" value="${issueMin}" />
<input type="hidden" id="issue_date" value="${issueDate}" />

	<div id="container" class="wtrLvl">
        <div class="submenu">
        	<a href="/flood/basinlevel.do" class="on">하천수위실황</a>
            <a href="/flood/waterlevel.do">우수관로실황</a>
        </div>
        <div class="sett">
          	<strong>날짜 선택</strong>
          	<input type="text" id="input_issuestime" name="" value="<c:out value='${fn:substring(issueDate, 0, 4)}' />년 <c:out value='${fn:substring(issueDate, 4, 6)}' />월 <c:out value='${fn:substring(issueDate, 6, 8)}' />일"  onfocus="javascript:selectFocus(this);" />
          	<select id="input_hour" name=""></select>
          	<select id="input_min" name=""></select>
          	<a href="javascript:selectNow();"><img src="/images/btn_now.gif" alt="Now"></a>
		</div>
        
        <div class="rvrwtLevel">
            <div class="giswrap">
                <div class="gisarea" id="map"></div>
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
            
            <div class="tblwrap">
                <div id="h3_text"><h3>관측지점: 전체</h3></div>
                <div class="thead">
                    <table>
                        <col width="118" />
                        <col width="82" />
                        <col width="80" />
                        <col width="*" />
                        <tbody><tr>
                            <td scope="col">시간</td>
                            <td scope="col">관측지점</td>
                            <td scope="col">수위</td>
                            <td scope="col">예경보</td>
                        </tr>
                    </tbody></table>
                </div>
                <div class="scroll">
                    <table>
                        <col width="118" />
                        <col width="82" />
                        <col width="80" />
                        <col width="*" />
                        <tbody class="tbody_data">
                        	<!--
                            <tr>
                                <td>2020.09.17 14:00</td>
                                <td>aB123</td>
                                <td>12.3mm</td>
                                <td class="legend1">안전</td>
                            </tr>
                            <tr>
                                <td>2020.09.17 14:00</td>
                                <td>aB123</td>
                                <td>12.3mm</td>
                                <td class="legend2">관심</td>
                            </tr>
                            <tr>
                                <td>2020.09.17 14:00</td>
                                <td>aB123</td>
                                <td>12.3mm</td>
                                <td class="legend3">주의</td>
                            </tr>
                            <tr>
                                <td>2020.09.17 14:00</td>
                                <td>aB123</td>
                                <td>12.3mm</td>
                                <td class="legend4">경계</td>
                            </tr>
                            <tr>
                                <td>2020.09.17 14:00</td>
                                <td>aB123</td>
                                <td>12.3mm</td>
                                <td class="legend5">심각</td>
                            </tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            <tr><td>2020.09.17 14:00</td><td>aB123</td><td>12.3mm</td><td>안전</td></tr>
                            -->
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="wthrRprt">
                <div class="imgwrap">
                    <p class="tit">기상특보</p>
                    <p class="txt" id="kma_txt"></p>
                    <div class="con con1"><img id="image_path" src=""></div>
                </div>
                
            </div>
            
            <div class="crtwrap">
                <div class="cnt" id="chart_data">
<!--                    <img src="/images/samp_graph.gif" alt="Chart Area" height="307" />-->
                </div>
            </div>
        </div>
    </div>
</form>
    
<jsp:include page="/WEB-INF/jsp/include/common_footer.jsp" />
    
