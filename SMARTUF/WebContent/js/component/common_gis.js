//var map = "";
//var overlay = "";

//var daegu_danger_layer = "";
//var basin_line = "";

var global_projection = new ol.proj.Projection({
    code: 'EPSG:4326',
    units: 'degrees',
    axisOrientation: 'neu',
    global: true
});

var daegu_danger_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_path + '/wms',
        params: {
            'LAYERS': 'smartuf:flood_output_2dis_060mm_060m_3q'
        },
        opaque: false,
        serverType: 'geoserver',
        crossOrigin : 'anonymous'
    })
});

var daegu_danger_sc_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_path + '/wms',
        params: {
            'LAYERS': 'smartuf:flood_sc_output_2dis_030mm'
        },
        opaque: false,
        serverType: 'geoserver',
        crossOrigin : 'anonymous'
    })
});

var daegu_danger_bc_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_path + '/wms',
        params: {
            'LAYERS': 'smartuf:flood_bc_output_2dis_030mm'
        },
        opaque: false,
        serverType: 'geoserver',
        crossOrigin : 'anonymous'
    })
});

var daegu_danger_rp_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_path + '/wms',
        params: {
            'LAYERS': 'smartuf:flood_rp_output_2dis_030mm'
        },
        opaque: false,
        serverType: 'geoserver',
        crossOrigin : 'anonymous'
    })
});

var daegu_danger_sk_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_path + '/wms',
        params: {
            'LAYERS': 'smartuf:flood_sk_output_2dis_030mm'
        },
        opaque: false,
        serverType: 'geoserver',
        crossOrigin : 'anonymous'
    })
});

var daegu_danger_ds_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_path + '/wms',
        params: {
            'LAYERS': 'smartuf:flood_ds_output_2dis_030mm'
        },
        opaque: false,
        serverType: 'geoserver',
        crossOrigin : 'anonymous'
    })
});

var daegu_danger_kd_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_path + '/wms',
        params: {
            'LAYERS': 'smartuf:flood_kd_output_2dis_030mm'
        },
        opaque: false,
        serverType: 'geoserver',
        crossOrigin : 'anonymous'
    })
});

var daegu_danger_prsd_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_path + '/wms',
        params: {
            'LAYERS': 'smartuf:flood_prsd_output_2dis_030mm'
        },
        opaque: false,
        serverType: 'geoserver',
        crossOrigin : 'anonymous'
    })
});

/*
var risk_daegu_layer = new ol.layer.Tile({
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
            url: 'http://geornd.hecorea.co.kr/smartuf' + '/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=smartuf:flood_risk_new&maxFeatures=50&outputFormat=application%2Fjson',
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
*/

var marker_layer = new ol.layer.Vector({
	source: new ol.source.Vector(),
	title : 'marker',
	visible : true,
	type : 'Unit'
});

var icon_style_node = new ol.style.Style({
    image: new ol.style.Icon(({
    	anchor: [0.5, 32],
        anchorXUnits: 'fraction',
        anchorYUnits: 'pixels',
        src: '/images/marker_stn.gif'
    }))
});

var layer_google_base = new ol.layer.Tile({
    title: "Google Road Map",
    visible : true,
    type : 'base',
    source: new ol.source.XYZ({ url: 'http://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}' }),
});

var flood_risk_layer = new ol.layer.Image({
    source: new ol.source.ImageVector({
        source: new ol.source.Vector({
            url: 'http://geornd.hecorea.co.kr/sims/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=sims:flood_risk_daegu&maxFeatures=50&outputFormat=application%2Fjson',
            format: new ol.format.GeoJSON()
        }),
        style: new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
                color: '#319FD3',
                width: 5
            })
        })
    })
});

var node_layer = new ol.layer.Vector({
	source: new ol.source.Vector(),
	title : 'node',
	visible : true,
	type : 'Unit'
});

var node_circle_style = new ol.style.Style({
	image: new ol.style.Circle({
	    radius: 5,
	    stroke: new ol.style.Stroke({
	      color: '#000000'
	    }),
	    fill: new ol.style.Fill({
	      color: '#00B2FF'
	    })
	})
});

/*
var layer_dg_node = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_path + '/wms',
        params: {
            'LAYERS': 'smartuf:node_dg_mtm'
        },
        opaque: false,
        serverType: 'geoserver',
        crossOrigin : 'anonymous'
    })
});


var layer_base_basin_africa = new ol.layer.Image({
    source: new ol.source.ImageVector({
        source: new ol.source.Vector({
            url: 'http://gwbgeo.hecorea.co.kr/gwb/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gwb:africa_basin_large&maxFeatures=5000&outputFormat=application%2Fjson',
            format: new ol.format.GeoJSON()
        }),
        style: new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
                color: '#319FD3',
                width: 1
            })
        })
    })
});


//http://geornd.hecorea.co.kr/smartuf/wms?service=WMS&version=1.1.0&request=GetMap&layers=smartuf:node_dg_mtm&styles=&bbox=339206.7418025717,265606.149857496,344028.88530937774,268518.944646685&width=768&height=463&srs=EPSG:5181&format=application/openlayers

var layer_dg_node = new ol.layer.Image({
    source: new ol.source.ImageVector({
        source: new ol.source.Vector({
        	url: 'http://geornd.hecorea.co.kr/smartuf/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=smartuf:node_dg_mtm&maxFeatures=50&outputFormat=application%2Fjson',
    		format: new ol.format.GeoJSON(),
        }),
        style: new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 1.2)'
            }),
            stroke: new ol.style.Stroke({
                color: '#ED1C24',
                width: 5
            })
        })
    })
});



var layer_dg_node = new ol.layer.Vector({
    source: new ol.source.Vector({
        url: 'http://geornd.hecorea.co.kr/smartuf/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=smartuf:node_dg_mtm&maxFeatures=50&outputFormat=application%2Fjson',
        format: new ol.format.GeoJSON()
    })
});

*/

var layer_dg_node = new ol.layer.Image({
    source: new ol.source.ImageVector({
        source: new ol.source.Vector({
            url: 'http://geornd.hecorea.co.kr/smartuf/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=smartuf:node_dg_mtm&maxFeatures=50&outputFormat=application%2Fjson',
            format: new ol.format.GeoJSON()
        }),
        style: new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
                color: '#319FD3',
                width: 5
            })
        })
    })
});




