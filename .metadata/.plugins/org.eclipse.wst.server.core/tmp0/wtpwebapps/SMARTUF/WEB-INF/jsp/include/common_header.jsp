<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="/css/common.css" />
    <link rel="stylesheet" type="text/css" href="/css/jquery-ui.css" />
    
    <script type="text/javascript" src="/js/plugin/jquery/jquery-1.11.1.min.js"></script>
	<script type="text/javascript" src="/js/plugin/jquery/jquery-ui-1.11.1.min.js"></script>
	
    <script type="text/javascript" src="/js/plugin/ol_3/ol.js" ></script>
	<script type="text/javascript" src="/js/plugin/ol_3/proj4.js"></script>
	<script src="/js/plugin/highcharts/highcharts.js"></script>
	<script src="/js/plugin/highcharts/modules/exporting.js"></script>
	
    <title>도시홍수상황인지 플랫폼</title>
    
    <style>
		.ol-popup {
		    position: absolute;
		    background-color: white;
		    -webkit-filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
		    filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
		    padding: 15px;
		    border-radius: 10px;
		    border: 1px solid #cccccc;
		    bottom: 12px;
		    left: -50px;
		    min-width: 200px;
		}
		.ol-popup:after, .ol-popup:before {
		    top: 100%;
		    border: solid transparent;
		    content: " ";
		    height: 0;
		    width: 0;
		    position: absolute;
		    pointer-events: none;
		}
		.ol-popup:after {
		    border-top-color: white;
		    border-width: 10px;
		    left: 48px;
		    margin-left: -10px;
		}
		.ol-popup:before {
		    border-top-color: #cccccc;
		    border-width: 11px;
		    left: 48px;
		    margin-left: -11px;
		}
		.ol-popup-closer {
		  text-decoration: none;
		  position: absolute;
		  top: 2px;
		  right: 8px;
		}
    </style>
    
    <c:if test="${empty sessionScope.loginUserGd}">
	    <script type="text/javascript">
			window.location = "/userConn/userLogIn.do";
		</script>
	</c:if>
    
    <script type="text/javascript">
		var geoserver_path = '${geoserverPath}';
	    
		$(function() {
			$(".gnb li").hover(function() {
	            $('ul:first', this).fadeIn(100);
	        }, function() {
	            $('ul:first', this).hide();
	        });
	        $(".gnb ul>li:has(ul)>a").each(function() {
	            //$(this).html($(this).html() + ' &or;');
	        	$(this).html($(this).html());
	        });
	        
	        if(window.location.pathname == '/dev/situation.do') {
	        	$('#p_situation').hide();
	        	
	        } else {
	        	$('#p_situation').show();
	        }
	        
	        /*
	        if($(location).attr("pathname") == '/dev/situation.do') {
	        	$('.dimInfo').show();
	        	
	        } else {
	        	$('.dimInfo').hide();
	        }
	        */
		});
	</script>
	
	<script type="text/javascript" src="/js/component/common_gis.js" ></script>
	<script type="text/javascript" src="/js/component/common.js" ></script>

</head>

<body>
	<div id="wrap">
	    <div id="header">
	    	<!--
			<h1>
				<a href="/flood/rainfall.do"><img src="/images/logo.jpg" alt="" /></a>
	        	<a href="/flood/rainfall.do"><img src="/images/logo.gif" alt="" /></a>
			</h1>
			-->
			
			<h1><a href="/flood/rainfall.do"><img src="/images/logo.gif" alt="" /></a></h1>
			
			
			<div class="logout"><a href="/userConn/userLogOut.do" class="">로그아웃</a></div>
			
	      	<h2 class="skip">주메뉴</h2>
			<ul class="menu_main">
	  			<li><a href="/flood/rainfall.do">강우실황</a></li>
	  			<li><a href="/flood/forecastRainfall.do">예측강우</a></li>
				<li><a href="/flood/floodLive.do">1차원 홍수정보</a></li>
				<li><a href="/flood/submersionInfo.do">2차원 침수정보</a></li>
				<li><a href="/flood/basinlevel.do">수위실황</a></li>
				<li><a href="/flood/floodMap.do">홍수취약성 지도</a></li>
				<li><a href="/flood/landSlide.do">산사태예경보</a></li>
			</ul>
		</div>
