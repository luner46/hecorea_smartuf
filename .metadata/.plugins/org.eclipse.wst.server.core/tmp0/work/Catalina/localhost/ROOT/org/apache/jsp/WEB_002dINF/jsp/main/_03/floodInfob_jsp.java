/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.32
 * Generated at: 2021-10-18 07:57:21 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp.main._03;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class floodInfob_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(3);
    _jspx_dependants.put("jar:file:/C:/workspace/eclipse_workspace/hecorea/SMARTUF/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/SMARTUF/WEB-INF/lib/jstl-1.2.jar!/META-INF/fn.tld", Long.valueOf(1153352682000L));
    _jspx_dependants.put("/WEB-INF/lib/jstl-1.2.jar", Long.valueOf(1480903226000L));
    _jspx_dependants.put("jar:file:/C:/workspace/eclipse_workspace/hecorea/SMARTUF/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/SMARTUF/WEB-INF/lib/jstl-1.2.jar!/META-INF/c.tld", Long.valueOf(1153352682000L));
  }

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = null;
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

final java.lang.String _jspx_method = request.getMethod();
if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method) && !javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET POST or HEAD");
return;
}

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "/WEB-INF/jsp/include/common_header.jsp", out, false);
      out.write("\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("var node = \"CS1001\";\r\n");
      out.write("\r\n");
      out.write("$(function() {\r\n");
      out.write("\t$('.menu_main li').eq(2).addClass(\"on\");\r\n");
      out.write("\t$('#acc').val('030');\r\n");
      out.write("\t$('#step').val('999');\r\n");
      out.write("\t\r\n");
      out.write("\tvar container = document.getElementById('popup');\r\n");
      out.write("\tvar content = document.getElementById('popup-content');\r\n");
      out.write("\tvar overlay = new ol.Overlay(({element: container}));\r\n");
      out.write("\tvar overlay = new ol.Overlay(({element: container}));\r\n");
      out.write("\t\r\n");
      out.write("\tmap = new ol.Map({\r\n");
      out.write("\t    logo: false,\r\n");
      out.write("\t    target: 'map',\r\n");
      out.write("\t    overlays: [overlay],\r\n");
      out.write("\t    //layers: [layer_google_base, layer_dg_node, node_layer, marker_layer],\r\n");
      out.write("\t    layers: [new ol.layer.Tile({source: new ol.source.OSM()}), layer_dg_node, node_layer, marker_layer],\r\n");
      out.write("\t    view: new ol.View({\r\n");
      out.write("\t        projection : global_projection,\r\n");
      out.write("\t        center: [128.5724234, 35.877653], //126.62, 36.33 35.891653,128.5724234\r\n");
      out.write("\t        zoom: 13.8 //9.2\r\n");
      out.write("\t        //minZoom: 8.0\r\n");
      out.write("\t    })\r\n");
      out.write("\t});\r\n");
      out.write("\t\r\n");
      out.write("\tmap.on('pointermove', function (evt) {\r\n");
      out.write("    \tif (evt.dragging) return;\r\n");
      out.write("\t    \r\n");
      out.write("\t    var pixel = map.getEventPixel(evt.originalEvent);\r\n");
      out.write("\t    var coordinate = evt.coordinate;\r\n");
      out.write("\t    var target = map.getTarget();\r\n");
      out.write("    \tvar jTarget = typeof target == \"string\" ? $(\"#\" + target) : $(target);\r\n");
      out.write("\t    \r\n");
      out.write("\t    var feature = map.forEachFeatureAtPixel(pixel, function(feature) {\r\n");
      out.write("            return feature;\r\n");
      out.write("        });\r\n");
      out.write("\t    \r\n");
      out.write("\t    var html = \"\";\r\n");
      out.write("\t    \r\n");
      out.write("\t    if(feature) {\r\n");
      out.write("\t    \tif(typeof feature.H.id != 'undefined') {\r\n");
      out.write("\t    \t\tjTarget.css(\"cursor\", \"pointer\");\r\n");
      out.write("\t\t    \t\r\n");
      out.write("\t   \t\t\thtml +=  \"맨홀 : \" + feature.H.id + \"<br />\";\r\n");
      out.write("\t   \t\t\t/*\r\n");
      out.write("\t   \t\t\thtml +=  \"결측률 : \" + feature.H.params.per + \"%<br />\";\r\n");
      out.write("\t            html +=  \"위도 : \" + feature.H.params.lat + \"˚ / 경도: \" +  feature.H.params.lon + \"˚<br />\";\r\n");
      out.write("\t\t    \t*/\r\n");
      out.write("\t\t    \tcontent.innerHTML = html;\r\n");
      out.write("\t            overlay.setPosition(coordinate);\r\n");
      out.write("\t    \t}\r\n");
      out.write("            \r\n");
      out.write("\t    } else {\r\n");
      out.write("\t    \tjTarget.css(\"cursor\", \"default\");\r\n");
      out.write("\t    \toverlay.setPosition(undefined);\r\n");
      out.write("\t    }\r\n");
      out.write("    });\r\n");
      out.write("\t\r\n");
      out.write("\tmap.on('singleclick', function (evt) {\r\n");
      out.write("\t\tif (evt.dragging) return;\r\n");
      out.write("\t    \r\n");
      out.write("\t    var pixel = map.getEventPixel(evt.originalEvent);\r\n");
      out.write("\t    var target = map.getTarget();\r\n");
      out.write("    \tvar jTarget = typeof target === \"string\" ? $(\"#\" + target) : $(target);\r\n");
      out.write("\t    \r\n");
      out.write("\t    var feature = map.forEachFeatureAtPixel(pixel, function(feature) {\r\n");
      out.write("            return feature;\r\n");
      out.write("        });\r\n");
      out.write("\t    \r\n");
      out.write("\t    if(feature) {\r\n");
      out.write("\t    \tjTarget.css(\"cursor\", \"pointer\");\r\n");
      out.write("\t    \t\r\n");
      out.write("\t    \tnode = feature.H.id;\r\n");
      out.write("\r\n");
      out.write("\t    \tselectDetail(node);\r\n");
      out.write("            setMapMarker(feature.H.id, feature.H.params);\r\n");
      out.write("            \r\n");
      out.write("\t    } else {\r\n");
      out.write("\t    \tjTarget.css(\"cursor\", \"default\");\r\n");
      out.write("\t    }\r\n");
      out.write("    });\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("\tvar geom_trans = ([128.584, 35.9033]); //35.9033\t128.584\r\n");
      out.write("\tvar geom = new ol.geom.Point(geom_trans);\r\n");
      out.write("\t\r\n");
      out.write("\tvar node = new ol.Feature({\r\n");
      out.write("        id : 'CS1001',\r\n");
      out.write("        params: {\r\n");
      out.write("            'lat': 35.9033,\r\n");
      out.write("            'lon': 128.584\r\n");
      out.write("        }\r\n");
      out.write("   \t});\r\n");
      out.write("\t\r\n");
      out.write("\tnode.setGeometry(geom);\r\n");
      out.write("\tnode.setStyle(icon_style_node);\r\n");
      out.write("\t\r\n");
      out.write("\tmarker_layer.getSource().addFeature(node);\r\n");
      out.write("\tmarker_layer.setZIndex(1);\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("\tselectData();\r\n");
      out.write("\tnode = \"CS1001\";\r\n");
      out.write("\tselectDetail('CS1001');\r\n");
      out.write("});\r\n");
      out.write("\r\n");
      out.write("function setMapMarker(id, val) {\r\n");
      out.write("\tvar geom_trans = ([val.lon, val.lat]);\r\n");
      out.write("\tvar geom = new ol.geom.Point(geom_trans);\r\n");
      out.write("\t\r\n");
      out.write("\tmarker_layer.getSource().clear();\r\n");
      out.write("\t\r\n");
      out.write("\tvar node = new ol.Feature({\r\n");
      out.write("        id : id,\r\n");
      out.write("        params: {\r\n");
      out.write("            'lat': val.lat,\r\n");
      out.write("            'lon': val.lon\r\n");
      out.write("        }\r\n");
      out.write("   \t});\r\n");
      out.write("\t\r\n");
      out.write("\tnode.setGeometry(geom);\r\n");
      out.write("\tnode.setStyle(icon_style_node);\r\n");
      out.write("\t\r\n");
      out.write("\tmarker_layer.getSource().addFeature(node);\r\n");
      out.write("\tmarker_layer.setZIndex(1);\r\n");
      out.write("\t\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("function selectData() {\r\n");
      out.write("\tvar acc = $('#acc').val();\r\n");
      out.write("\tvar step = $('#step').val();\r\n");
      out.write("\t\r\n");
      out.write("\tnode_layer.getSource().clear();\r\n");
      out.write("\t\r\n");
      out.write("\t$.ajax({\r\n");
      out.write("\t\ttype: \"POST\",\r\n");
      out.write("\t\turl: \"/floodCont/selectNodeData.do\",\r\n");
      out.write("\t\tdataType: \"json\",\r\n");
      out.write("\t\tasync : false,\r\n");
      out.write("\t\tdata: {'acc': acc, 'step': step},\r\n");
      out.write("\t\tsuccess: function(data) {\r\n");
      out.write("\t\t\tvar html = \"\";\r\n");
      out.write("\t\t\tvar color = \"\";\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tfor(var i=0; i<data.dataList.length; i++) {\r\n");
      out.write("\t\t\t\tvar geom_trans = ([data.dataList[i].LON, data.dataList[i].LAT]);\r\n");
      out.write("\t\t\t\tvar geom = new ol.geom.Point(geom_trans);\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\tvar node = new ol.Feature({\r\n");
      out.write("\t    \t         id : data.dataList[i].NODE,\r\n");
      out.write("\t    \t         params: {\r\n");
      out.write("\t                     'lat': data.dataList[i].LAT,\r\n");
      out.write("\t                     'lon': data.dataList[i].LON\r\n");
      out.write("\t                 }\r\n");
      out.write("\t    \t    });\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\tif(data.dataList[i].GRADE == '5') {\r\n");
      out.write("\t\t\t\t\tcolor = \"#D80012\";\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\tvar warn_circle_style = new ol.style.Style({\r\n");
      out.write("\t\t\t\t\t\timage: new ol.style.Circle({\r\n");
      out.write("\t\t\t\t\t\t    radius: 10,\r\n");
      out.write("\t\t\t\t\t\t    stroke: new ol.style.Stroke({\r\n");
      out.write("\t\t\t\t\t\t      color: '#000000',\r\n");
      out.write("\t\t\t\t\t    \t  width: 3\r\n");
      out.write("\t\t\t\t\t\t    }),\r\n");
      out.write("\t\t\t\t\t\t    fill: new ol.style.Fill({\r\n");
      out.write("\t\t\t\t\t\t      color: color\r\n");
      out.write("\t\t\t\t\t\t    })\r\n");
      out.write("\t\t\t\t\t\t})\r\n");
      out.write("\t\t\t\t\t});\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\tnode.setStyle(warn_circle_style);\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t} else {\r\n");
      out.write("\t\t\t\t\tif(data.dataList[i].GRADE == '1') color = \"#FFFFFF\";\r\n");
      out.write("\t\t\t\t\tif(data.dataList[i].GRADE == '2') color = \"#00B7EE\";\r\n");
      out.write("\t\t\t\t\tif(data.dataList[i].GRADE == '3') color = \"#5F52A0\";\r\n");
      out.write("\t\t\t\t\tif(data.dataList[i].GRADE == '4') color = \"#BA0469\";\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\tvar node_circle_style = new ol.style.Style({\r\n");
      out.write("\t\t\t\t\t\timage: new ol.style.Circle({\r\n");
      out.write("\t\t\t\t\t\t    radius: 5,\r\n");
      out.write("\t\t\t\t\t\t    stroke: new ol.style.Stroke({\r\n");
      out.write("\t\t\t\t\t\t      color: '#000000'\r\n");
      out.write("\t\t\t\t\t\t    }),\r\n");
      out.write("\t\t\t\t\t\t    fill: new ol.style.Fill({\r\n");
      out.write("\t\t\t\t\t\t      color: color\r\n");
      out.write("\t\t\t\t\t\t    })\r\n");
      out.write("\t\t\t\t\t\t})\r\n");
      out.write("\t\t\t\t\t});\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\tnode.setStyle(node_circle_style)\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t \tnode.setGeometry(geom);\r\n");
      out.write("\t    \t\tnode_layer.getSource().addFeature(node);\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}\r\n");
      out.write("\t});\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function selectDetail(node) {\r\n");
      out.write("\tvar acc = $('#acc').val();\r\n");
      out.write("\t\r\n");
      out.write("\t$.ajax({\r\n");
      out.write("\t\ttype: \"POST\",\r\n");
      out.write("\t\turl: \"/floodCont/selectNodeDetail.do\",\r\n");
      out.write("\t\tdataType: \"json\",\r\n");
      out.write("\t\tasync : false,\r\n");
      out.write("\t\tdata: {'acc': acc, 'node': node},\r\n");
      out.write("\t\tsuccess: function(data) {\r\n");
      out.write("\t\t\tvar html = \"\";\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tfor(var i=0; i<data.dataList.length; i++) {\r\n");
      out.write("\t\t\t\thtml += \"<tr class='tr_class tr_\" + data.dataList[i].FCSTTIMESTEP + \"'>\";\r\n");
      out.write("\t\t\t\thtml += \"<td>+\" + data.dataList[i].FCSTTIMESTEP + \"</td>\";\r\n");
      out.write("\t\t\t\thtml += \"<td>\" + data.dataList[i].DEPTH.toFixed(3) + \"</td>\";\r\n");
      out.write("\t\t\t\thtml += \"<td>\" + data.dataList[i].OVFLW.toFixed(1) + \"</td>\";\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\tif(data.dataList[i].GRADE == '1') html += \"<td class='legend1'>\" + selectGrade(data.dataList[i].GRADE) + \"</td>\";\r\n");
      out.write("\t\t\t\tif(data.dataList[i].GRADE == '2') html += \"<td class='legend2'>\" + selectGrade(data.dataList[i].GRADE) + \"</td>\";\r\n");
      out.write("\t\t\t\tif(data.dataList[i].GRADE == '3') html += \"<td class='legend3'>\" + selectGrade(data.dataList[i].GRADE) + \"</td>\";\r\n");
      out.write("\t\t\t\tif(data.dataList[i].GRADE == '4') html += \"<td class='legend4'>\" + selectGrade(data.dataList[i].GRADE) + \"</td>\";\r\n");
      out.write("\t\t\t\tif(data.dataList[i].GRADE == '5') html += \"<td class='legend5'>\" + selectGrade(data.dataList[i].GRADE) + \"</td>\";\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\thtml += \"</tr>\";\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\t$(\".tbody_data\").eq(0).html(html);\r\n");
      out.write("\t\t\t$(\"#h3_text\").html(\"<h3>맨홀 \" + node + \": 1차원 홍수정보</h3>\"); //맨홀 OOOOOO: 1차원 홍수정보\r\n");
      out.write("\t\t}\r\n");
      out.write("\t});\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function selectGrade(val) {\r\n");
      out.write("\tvar result = \"\";\r\n");
      out.write("\t\r\n");
      out.write("\tif(val == '1') result = \"안전\";\r\n");
      out.write("\tif(val == '2') result = \"관심\";\r\n");
      out.write("\tif(val == '3') result = \"주의\";\r\n");
      out.write("\tif(val == '4') result = \"경계\";\r\n");
      out.write("\tif(val == '5') result = \"<strong>심각</strong>\";\r\n");
      out.write("\t\r\n");
      out.write("\treturn result;\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("$(document).on('click', '.tab li', function() { //top tap only table, gis\r\n");
      out.write("\tvar current_class = $(this).attr('class');\r\n");
      out.write("\t\r\n");
      out.write("\tif(!$(this).hasClass(\"on\")) {\r\n");
      out.write("\t\t$('.tab li').removeClass(\"on\");\r\n");
      out.write("\t\t$('.' + current_class).addClass(\"on\");\r\n");
      out.write("\t\t$('#acc').val(current_class);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tselectData();\r\n");
      out.write("\t\tselectDetail(node);\r\n");
      out.write("\t}\r\n");
      out.write("});\r\n");
      out.write("\r\n");
      out.write("$(document).on('click', '.tabBttm li', function() { //bottom tab only gis data\r\n");
      out.write("\tvar current_class = $(this).attr('class');\r\n");
      out.write("\t\r\n");
      out.write("\tif(!$(this).hasClass(\"on\")) {\r\n");
      out.write("\t\t$('.tabBttm li').removeClass(\"on\");\r\n");
      out.write("\t\t$('.' + current_class).addClass(\"on\");\r\n");
      out.write("\t\t$('#step').val(current_class);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$('.tr_class').removeClass(\"on\");\r\n");
      out.write("\t\t$('.tr_' + current_class).addClass(\"on\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tselectData();\r\n");
      out.write("\t\tselectDetail(node);\r\n");
      out.write("\t}\r\n");
      out.write("});\r\n");
      out.write("\r\n");
      out.write("</script>\r\n");
      out.write("\r\n");
      out.write("<form action=\"\" method=\"get\">\r\n");
      out.write("<input type=\"hidden\" id=\"acc\" />\r\n");
      out.write("<input type=\"hidden\" id=\"step\" />\r\n");
      out.write("\r\n");
      out.write("\t<div id=\"container\" class=\"fldInfo\">\r\n");
      out.write("\t\t<div class=\"submenu\">\r\n");
      out.write("            <a href=\"/flood/floodLive.do\" class=\"on\">실황</a>\r\n");
      out.write("            <a href=\"/flood/floodInfoB.do\">예측</a>\r\n");
      out.write("            <a href=\"/flood/floodInfo.do\">시나리오</a>\r\n");
      out.write("        </div>\r\n");
      out.write("        <ul class=\"tab\">\r\n");
      out.write("          \t<li class=\"030 on\"><a href=\"#\">30mm</a></li>\r\n");
      out.write("\t\t\t<li class=\"040\"><a href=\"#\">40mm</a></li>\r\n");
      out.write("\t\t\t<li class=\"050\"><a href=\"#\">50mm</a></li>\r\n");
      out.write("\t\t\t<li class=\"060\"><a href=\"#\">60mm</a></li>\r\n");
      out.write("\t\t\t<li class=\"070\"><a href=\"#\">70mm</a></li>\r\n");
      out.write("\t\t\t<li class=\"080\"><a href=\"#\">80mm</a></li>\r\n");
      out.write("\t\t\t<li class=\"090\"><a href=\"#\">90mm</a></li>\r\n");
      out.write("        </ul>\r\n");
      out.write("        \r\n");
      out.write("        <div class=\"ltWd\">\r\n");
      out.write("          \t<div class=\"cnt\" id=\"map\"><!-- <img src=\"/images/samp_fldInfo.gif\" alt=\"\" /> --></div>\r\n");
      out.write("          \t<ul class=\"legend\">\r\n");
      out.write("            \t<li>안전</li>\r\n");
      out.write("            \t<li>관심</li>\r\n");
      out.write("            \t<li>주의</li>\r\n");
      out.write("            \t<li>경계</li>\r\n");
      out.write("            \t<li>심각</li>\r\n");
      out.write("          \t</ul>\r\n");
      out.write("        </div>\r\n");
      out.write("        \r\n");
      out.write("        <div id=\"popup\" class=\"ol-popup\">\r\n");
      out.write("\t\t\t<div id=\"popup-content\"></div>\r\n");
      out.write("\t    </div>\r\n");
      out.write("        \r\n");
      out.write("        <div class=\"rtWd\">\r\n");
      out.write("          \t<div id='h3_text'></div>\r\n");
      out.write("          \t<div class=\"tblwrap\">\r\n");
      out.write("\t            <table>\r\n");
      out.write("\t              \t<col width=\"*\" />\r\n");
      out.write("\t              \t<col width=\"23.3%\" span=\"3\" />\r\n");
      out.write("\t              \t<thead>\r\n");
      out.write("\t\t                <tr>\r\n");
      out.write("\t\t                  \t<th scope=\"col\">발생시간</th>\r\n");
      out.write("\t\t                  \t<th scope=\"col\">수위</th>\r\n");
      out.write("\t\t                  \t<th scope=\"col\">월류량</th>\r\n");
      out.write("\t\t                  \t<th scope=\"col\">예경보</th>\r\n");
      out.write("\t\t                </tr>\r\n");
      out.write("\t              \t</thead>\r\n");
      out.write("\t              \t<tbody class=\"tbody_data\">\r\n");
      out.write("\t              \t</tbody>\r\n");
      out.write("\t\t\t\t</table>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\t\r\n");
      out.write("        <ul class=\"tabBttm\">\r\n");
      out.write("          \t<li class=\"10\"><a href=\"#\">+10</a></li>\r\n");
      out.write("          \t<li class=\"20\"><a href=\"#\">+20</a></li>\r\n");
      out.write("          \t<li class=\"30\"><a href=\"#\">+30</a></li>\r\n");
      out.write("          \t<li class=\"40\"><a href=\"#\">+40</a></li>\r\n");
      out.write("          \t<li class=\"50\"><a href=\"#\">+50</a></li>\r\n");
      out.write("          \t<li class=\"60\"><a href=\"#\">+60</a></li>\r\n");
      out.write("          \t<li class=\"70\"><a href=\"#\">+70</a></li>\r\n");
      out.write("          \t<li class=\"80\"><a href=\"#\">+80</a></li>\r\n");
      out.write("          \t<li class=\"90\"><a href=\"#\">+90</a></li>\r\n");
      out.write("          \t<li class=\"100\"><a href=\"#\">+100</a></li>\r\n");
      out.write("          \t<li class=\"110\"><a href=\"#\">+110</a></li>\r\n");
      out.write("          \t<li class=\"120\"><a href=\"#\">+120</a></li>\r\n");
      out.write("          \t<li class=\"130\"><a href=\"#\">+130</a></li>\r\n");
      out.write("          \t<li class=\"140\"><a href=\"#\">+140</a></li>\r\n");
      out.write("          \t<li class=\"150\"><a href=\"#\">+150</a></li>\r\n");
      out.write("          \t<li class=\"160\"><a href=\"#\">+160</a></li>\r\n");
      out.write("          \t<li class=\"170\"><a href=\"#\">+170</a></li>\r\n");
      out.write("          \t<li class=\"180\"><a href=\"#\">+180</a></li>\r\n");
      out.write("          \t<li class=\"999 on\"><a href=\"#\">최대</a></li>\r\n");
      out.write("        </ul>\r\n");
      out.write("\t</div>\r\n");
      out.write("</form>\r\n");
      out.write("    \r\n");
      out.write("    ");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "/WEB-INF/jsp/include/common_footer.jsp", out, false);
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
