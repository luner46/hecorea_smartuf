<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/jsp/include/common_header.jsp" />

<script type="text/javascript">
var map = "";
var overlay = "";
var risk_daegu_layer ="";


$(function() {
	$('.menu_main li').eq(5).addClass("on");
	
	var container = document.getElementById('popup');
	var content = document.getElementById('popup-content');
	var overlay = new ol.Overlay(({element: container}));
	
	map = new ol.Map({
	    logo: false,
	    target: 'map',
	    overlays: [overlay],
	    layers: [new ol.layer.Tile({source: new ol.source.OSM()})],
	    view: new ol.View({
	        projection : global_projection,
	        center: [128.5992834, 35.891653],
	        zoom: 11.4 //9.2
	    })
	});
	
	risk_daegu_layer = new ol.layer.Tile({
	    source: new ol.source.TileWMS({
	    	//url: 'http://geornd.hecorea.co.kr/smartuf/wms?service=WMS&version=1.1.0&request=GetMap&layers=smartuf:flood_risk_new&styles=&bbox=332697.06018891523,253965.85974026026,359162.217542953,281168.51733306004&width=747&height=768&srs=EPSG:2097&format=image%2Fpng',
	    	url: 'http://geornd.hecorea.co.kr/smartuf/wms',
	    	params: {
	            'LAYERS': 'smartuf:flood_risk_new'
	        },
	        opaque: false,
	        serverType: 'geoserver',
	        crossOrigin : 'anonymous'
	    })
	});

	var basin_line = new ol.layer.Image({
	    source: new ol.source.ImageVector({
	        source: new ol.source.Vector({
	            url: 'http://geornd.hecorea.co.kr/smartuf' + '/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=smartuf:flood_risk_new_01&maxFeatures=50&outputFormat=application%2Fjson',
	            format: new ol.format.GeoJSON()
	        }),
	        style: new ol.style.Style({
	            stroke: new ol.style.Stroke({
	                color: '#808080',
	                width: 0.3
	            })
	        })
	    })
	});
	
	//map.addLayer(layer_google_base);
	map.addLayer(risk_daegu_layer);
	map.addLayer(basin_line);
	//layer_google_base.setZIndex(1);
	//risk_daegu_layer.setZIndex(11);
	//risk_daegu_layer.setZIndex(1);
	//basin_line.setZIndex(11);
	
	map.on('pointermove', function (evt) {
    	if (evt.dragging) return;
	    
    	
    	
	    var pixel = map.getEventPixel(evt.originalEvent);
	    var coordinate = evt.coordinate;
	    var target = map.getTarget();
    	var jTarget = typeof target == "string" ? $("#" + target) : $(target);
    	
	    var feature = map.forEachFeatureAtPixel(pixel, function(feature) {
            return feature;
        });
	    /*
	    var url = risk_daegu_layer.getFeatureInfoUrl(
	    	    evt.coordinate, viewResolution, 'EPSG:2097',
	    	    {'INFO_FORMAT': 'text/html'});
	    */
	    
	    var html = "";
	    
	    if(feature) {
	    	jTarget.css("cursor", "pointer");
	    	
	    	console.log(feature);
	    	
	    	/*
	    	if(typeof feature.H.id != 'undefined') {
	    		jTarget.css("cursor", "pointer");
		    	
	   			html +=  "맨홀 : " + feature.H.id + "<br />";
	   			
		    	content.innerHTML = html;
	            overlay.setPosition(coordinate);
	    	}
	    	*/
            
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
	    
	    console.log('singleclick');
	    
	    if(feature) {
			console.log(feature);
            
	    } else {
	    	jTarget.css("cursor", "default");
	    }
    });
	
	selectData();
});

function selectData() {
	
	 //map.addLayer(risk_daegu_layer);
	 
	$.ajax({
		type: "POST",
		url: "/floodCont/selectFloodMapData.do",
		dataType: "json",
		async : false,
		success: function(data) {
			var html = "";
			
			for(var i=0; i<data.dataList.length; i++) {
				html += "<tr>";
				html += "<td>" + data.dataList[i].ANALYSIS_RANK +  "순위</td>";
				html += "<td>" + data.dataList[i].ADM_NM + "</td>";
				html += "<td>" + data.dataList[i].RSI + "</td>";
				html += "<td>" + data.dataList[i].DPI + "</td>";
				html += "<td>" + data.dataList[i].FVI + "</td>";
				html += "</tr>";
			} 			
			
			$('.tbody_data').eq(0).html(html);
			
		}
	});
}
</script>

<form action="" method="get">
	<div id="container" class="fldVln">
        <h3>행정단위별 홍수취약성 지수</h3>
        <div class="ltWd">
          	<div class="cnt" id="map"></div>
        </div>
        <div class="rtWd">
          	<h3>홍수취약성 상세정보</h3>
          	<div class="tblwrap">
                <div class="thead">
                    <table>
                        <col width="55px" />
                        <col width="88px" />
                        <col width="60px" span="2" />
                        <col width="*" />
                        <tr>
                            <td scope="col">구분</td>
                            <td scope="col">기초단위구역</td>
                            <td scope="col">RSI</td>
                            <td scope="col">DPI</td>
                            <td scope="col">FVI</td>
                        </tr>
                    </table>
                </div>
                <div class="scroll">
                    <table>
                        <col width="55px" />
                        <col width="88px" />
                        <col width="60px" span="2" />
                        <col width="*" />
              	<tbody class="tbody_data">
              		<!--  
	                <tr>
	                  	<td>1순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>2순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>3순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>4순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>5순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>6순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>7순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>8순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>9순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>10순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>11순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>12순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>13순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>14순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                <tr>
	                  	<td>15순위</td>
	                  	<td></td>
	                  	<td></td>
	                </tr>
	                -->
              	</tbody>
			</table>
		</div>
        </div>
        </div>
        <img src="/images/fldVln_legend.gif" alt="" class="legend" />
      </div>
    </form>
    
    <jsp:include page="/WEB-INF/jsp/include/common_footer.jsp" />