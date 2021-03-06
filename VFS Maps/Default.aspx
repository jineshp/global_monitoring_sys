﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="VFSMaps._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
    <head>
    	<title>VFS Global Reports</title>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <meta name="viewport" content="initial-scale=1, maximum-scale=1,user-scalable=0;">
        <!--For Twitter Bootstrap-->
    	<link rel="stylesheet" type="text/css" href="lib/bootstrap/css/bootstrap.css" />
    	<link rel="stylesheet" type="text/css" href="stylesheets/theme.css" />
    	<link rel="stylesheet" href="lib/font-awesome/css/font-awesome.css" />
    	<link rel="icon" href="images/favicon.ico" type="image/ico">
    	<link rel="shortcut icon" href="assets/ico/favicon.ico">
    	<link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/ico/apple-touch-icon-144-precomposed.png">
    	<link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
    	<link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
    	<link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">    
        <!--For jQuery-->
        <link rel="stylesheet" href="css/theme.css"/>
        <link rel="stylesheet" href="css/jquery-ui.css" />
        <script src="js/jquery-1.10.2.js"></script>
        <!--For amMaps-->
        <script type="text/javascript" src="ammap/ammap/ammap.js"></script>
        <script type="text/javascript" src="ammap/ammap/maps/js/worldHigh.js"></script>
        <script type="text/javascript" src="ammap/ammap/maps/js/continentsHigh.js"></script>
		<script type="text/javascript" src="ammap/ammap/maps/js/indiaHigh.js"></script>
		<script type="text/javascript" src="ammap/ammap/maps/js/sriLankaHigh.js"></script>
		<script type="text/javascript" src="ammap/ammap/maps/js/bangladeshHigh.js"></script>
		<script type="text/javascript" src="ammap/ammap/maps/js/nepalHigh.js"></script>
		<script type="text/javascript" src="ammap/ammap/maps/js/chinaHigh.js"></script>
		<script type="text/javascript" src="ammap/ammap/themes/light.js"></script>
	</head>           
	<script type="text/javascript">
	    var CountryCodeList = "";
	    var $xmldata = "";
	    var selectedid = "";
	    var selectedcode = "";
	    var SELECT_COUNTRY_ID = "";
	    var SELECT_COUNTRY_NAME = "";
	    var SELECT_COUNTRY_CODE = "";
	    var vaccards = "";

	    $(function() {
	        $("#header").show();
	        Show_Loading();
	        Hide_Error_Loading();
	        setTimeout(fillcountrydropdown, 2000);
	        locationname = $("#LocationSelect").val();
	        $("#LocationSelect").change(function() {

	            $("#LocationSelect option:selected").each(function() {
	                selectedid = $(this).attr("id");
	                selectedcode = $(this).attr("code");
	                var locationname = $(this).text();
	                if (selectedid == "0") {
	                    Show_Loading();
	                    setTimeout(GlobalDiv, 3000);
	                }
	                else {
	                    Show_Loading();
	                    setTimeout(CountryDiv, 3000);
	                }
	            });
	        }).trigger("change");
	    });

	    function fillcountrydropdown() {
	        $.ajax({
	            type: "POST",
	            contentType: "application/json;charset=utf-8",
	            url: "Default.aspx/GetCountryMaster",
	            data: "{}",
	            dataType: "json",
	            async: false,
	            success: function(result) {
	                if (result.d == "NO DATA") {
	                    alert("No data available currently.");
	                    location.reload();
	                }
	                else {
	                    CountryMaster = $(result.d);
	                }
	            },
	            error: function(error) {
	                Show_Error_Loading();
	            }
	        });
	        var $xmldata = $(CountryMaster);
	        $xmldata.find('Country').each(function() {
	            SELECT_COUNTRY_ID = $(this).attr("ID");
	            SELECT_COUNTRY_NAME = $(this).attr("Name");
	            SELECT_COUNTRY_CODE = $(this).attr("CountryCode");
	            var SELECT_COUNTRY_DATA = "<option id=" + SELECT_COUNTRY_ID + " name=" + SELECT_COUNTRY_NAME + " code=" + SELECT_COUNTRY_CODE + ">" + SELECT_COUNTRY_NAME + "</option>"
	            $(SELECT_COUNTRY_DATA).appendTo('#LocationSelect');
	        });
	    } //end of get fillcountrydropdown

	    function GetTATSummary() {
	        Show_Loading();
	        $.ajax({
	            type: "POST",
	            contentType: "application/json;charset=utf-8",
	            url: "Default.aspx/GetTATSummary",
	            data: "{CountryID:" + selectedid + "}",
	            dataType: "json",
	            async: false,
	            success: function(result) {
	                if (result.d == "<DATA><STATS><ONLINELOC>0</ONLINELOC><OFFLINELOC>0</OFFLINELOC><TOTALTICKETS>0</TOTALTICKETS><NOOFAPPLICATIONS>0</NOOFAPPLICATIONS></STATS><BESTVACS></BESTVACS><WORSTVACS></WORSTVACS></DATA>") {
	                    alert("No data available currently");
	                    location.reload();
	                }
	                else {
	                    TATSummary = $(result.d)
	                }
	            },
	            error: function(error) { Show_Error_Loading(); }
	        });
	        $xmldata = $(TATSummary);
	        locationname = $("#LocationSelect").val();
	        $("#CountryName").text(locationname);

	        $xmldata.find('ONLINELOC').each(function() {
	            ONLINE_LOC = $(this).text();
	            $("#TotalOnlineLocations").text(ONLINE_LOC);
	        });
	        $xmldata.find('OFFLINELOC').each(function() {
	            OFFLINE_LOC = $(this).text();
	            $("#TotalOfflineLocations").text(OFFLINE_LOC);
	        });
	        $xmldata.find('TOTALTICKETS').each(function() {
	            TOTALTICKETS_LOC = $(this).text();
	            $("#TotalTickets").text(TOTALTICKETS_LOC);
	        });
	        $xmldata.find('NOOFAPPLICATIONS').each(function() {
	            TOTALNOOFAPPLICATIONS_LOC = $(this).text();
	            $("#TotalApplications").text(TOTALNOOFAPPLICATIONS_LOC);
	        });
	        $("#BESTVACS").empty();
	        $xmldata.find('BESTVACS').each(function() {
	            $(this).children('VAC').each(function() {
	                BESTVAC_RANK = $(this).attr('RANK');
	                BESTVAC_NAME = $(this).attr('NAME');
	                BESTVAC_AVGTAT = $(this).attr('AVGTAT');
	                BESTVAC_TOTALTICKETS = $(this).attr('TOTALTICKETS');
	                BESTVAC_NOOFAPPLICATIONS = $(this).attr('NOOFAPPLICATIONS');
	                var BESTVACS = "<li><b>#" + BESTVAC_RANK + "&nbsp;&nbsp;" + BESTVAC_NAME + "</b>&nbsp;&nbsp;&nbsp<i style='float: right;color:#00FF00'>" + BESTVAC_AVGTAT + "</i>&nbsp;&nbsp;&nbsp</li><br>"
	                $(BESTVACS).appendTo("#BESTVACS");

	            });
	        });
	        $("#WORSTVACS").empty();
	        $xmldata.find('WORSTVACS').each(function() {
	            $(this).children('VAC').each(function() {
	                WORSTVAC_RANK = $(this).attr('RANK');
	                WORSTVAC_NAME = $(this).attr('NAME');
	                WORSTVAC_AVGTAT = $(this).attr('AVGTAT');
	                WORSTVAC_TOTALTICKETS = $(this).attr('TOTALTICKETS');
	                WORSTVAC_NOOFAPPLICATIONS = $(this).attr('NOOFAPPLICATIONS');
	                var WORSTVACS = "<li><b>#" + WORSTVAC_RANK + "&nbsp;&nbsp;" + WORSTVAC_NAME + "</b>&nbsp;&nbsp;&nbsp<i style='float: right;color:#FF0000'>" + WORSTVAC_AVGTAT + "</i>&nbsp;&nbsp;&nbsp</li><br>"
	                $(WORSTVACS).appendTo("#WORSTVACS");

	            });
	        });
	    } //end of GetTATSummary

	    function GetLocationSummaryXml() {
	        Show_Loading();
	        $.ajax({
	            type: "POST",
	            contentType: "application/json;charset=utf-8",
	            url: "Default.aspx/GetLocationSummaryXml",
	            data: "{CountryID:" + selectedid + "}",
	            dataType: "json",
	            async: false,
	            success: function(result) {
	                if (result.d == "NO DATA") {
	                    //alert("No data available currently");
	                    location.reload();
	                }
	                else {
	                    LocationSummaryXML = $(result.d)
	                    $xmlsummarydata = $(LocationSummaryXML);
	                }
	            },
	            error: function(error) { Show_Error_Loading(); }
	        });

	        $("#vaccard").empty();
	        $xmlsummarydata.find('Location').each(function() {
	            VACCARD_NAME = $(this).attr('Name');
	            VACCARD_RANK = $(this).attr('Rank');
	            VACCARD_TOTALTICKETS = $(this).attr('TotalTickets');
	            VACCARD_NOOFAPPLICATIONS = $(this).attr('NumberOfApplications');
	            VACCARD_TAT = $(this).attr('TAT');
	            VACCARD_AVGST = $(this).attr('AvgST');
	            VACCARD_AVGWT = $(this).attr('AvgWT');
	            VACCARD_ACTIVECOUNTERS = $(this).attr('ActiveCounters');
	            VACCARD_TOTALCOUNTERS = $(this).attr('TotalCounters');
	            VACCARD_FIRSTTICKETLOGGEDIN = $(this).attr('FirstTicketLoggedIn');
	            VACCARD_BENCHMARKTIMECOLOR = $(this).attr('BenchmarkTimeColor');
	            var vaccards = '<table id="vaccards" style="width: 95%;" align="center"><tr style="width: 100%; height: 100%" ><td style="width:100%;border-radius:10px"><br/></td></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #FF9C00;border-top-left-radius:0.5em;color:#00305D"><span id="vac_rank" style="float:left"><b>&nbsp;&nbsp;#' + VACCARD_RANK + '&nbsp;&nbsp;</b></span><center><span id="vac_name"><b>' + VACCARD_NAME + '</b></span></center><br></td><td style="width:100%;background-color: #FF9C00;border-top-right-radius:0.5em;"></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #00305D"><b><span>Total Tickets:&nbsp;</span></b></td><td style="width:100%;background-color: #00305D;"><i><span id="vac_totaltickets">' + VACCARD_TOTALTICKETS + '</span></i>&nbsp;&nbsp;&nbsp;</td></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #00305D"><b><span>No Of Applications:&nbsp;</span></b></td><td style="width:100%;background-color: #00305D;"><i><span id="vac_noofapplications">' + VACCARD_NOOFAPPLICATIONS + '</span></i>&nbsp;&nbsp;&nbsp;</td></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #00305D"><b><span>Avg Service Time:&nbsp;</span></b></td><td style="width:100%;background-color: #00305D;"><i><span id="vac_avgservtime">' + VACCARD_AVGST + '</span></i>&nbsp;&nbsp;&nbsp;</td></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #00305D"><b><span>Avg Wait Time:&nbsp;</span></b></td><td style="width:100%;background-color: #00305D;"><i><span id="vac_avgwaittime">' + VACCARD_AVGWT + '</span></i>&nbsp;&nbsp;&nbsp;</td></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #00305D"><b><span>Avg TAT:&nbsp;</span></b></td><td style="width:100%;background-color: #00305D;"><i><font color="' + VACCARD_BENCHMARKTIMECOLOR + '"><span id="vac_avgtat">' + VACCARD_TAT + '</span></i>&nbsp;&nbsp;&nbsp;</font></td></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #00305D"><b><span>First Ticket At:&nbsp;</span></b></td><td style="width:100%;background-color: #00305D;"><i><span id="vac_firstticket">' + VACCARD_FIRSTTICKETLOGGEDIN + '</span></i>&nbsp;&nbsp;&nbsp;</td></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #00305D"><b><span>Total Counters:&nbsp;</span></b></td><td style="width:100%;background-color: #00305D;"><i><span id="vac_totalcounter">' + VACCARD_TOTALCOUNTERS + '</span></i>&nbsp;&nbsp;&nbsp;</td></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #00305D"><b><span>Active Counters:&nbsp;</span></b></td><td style="width:100%;background-color: #00305D;"><i><span id="vac_activecounter">' + VACCARD_ACTIVECOUNTERS + '</span></i>&nbsp;&nbsp;&nbsp;</td></tr><tr style="width: 100%; height: 100%"><td style="width:100%;background-color: #00305D"></td><td style="width:100%;background-color: #00305D;"></td></tr></table>'

	            $("#vaccard").append(vaccards);
	        });
	    } //end of GetLocationSummaryXml

	    function GlobalDiv() {
	        GetTATSummary();
	        $("#mapcard").css("width", "85%");
	        $("#mainvactab").hide();
	        // svg path for target icon
	        var targetSVG = "M9,0C4.029,0,0,4.029,0,9s4.029,9,9,9s9-4.029,9-9S13.971,0,9,0z M9,15.93 c-3.83,0-6.93-3.1-6.93-6.93S5.17,2.07,9,2.07s6.93,3.1,6.93,6.93S12.83,15.93,9,15.93 M12.5,9c0,1.933-1.567,3.5-3.5,3.5S5.5,10.933,5.5,9S7.067,5.5,9,5.5 S12.5,7.067,12.5,9z";
	        // svg path for plane icon
	        var planeSVG = "M19.671,8.11l-2.777,2.777l-3.837-0.861c0.362-0.505,0.916-1.683,0.464-2.135c-0.518-0.517-1.979,0.278-2.305,0.604l-0.913,0.913L7.614,8.804l-2.021,2.021l2.232,1.061l-0.082,0.082l1.701,1.701l0.688-0.687l3.164,1.504L9.571,18.21H6.413l-1.137,1.138l3.6,0.948l1.83,1.83l0.947,3.598l1.137-1.137V21.43l3.725-3.725l1.504,3.164l-0.687,0.687l1.702,1.701l0.081-0.081l1.062,2.231l2.02-2.02l-0.604-2.689l0.912-0.912c0.326-0.326,1.121-1.789,0.604-2.306c-0.452-0.452-1.63,0.101-2.135,0.464l-0.861-3.838l2.777-2.777c0.947-0.947,3.599-4.862,2.62-5.839C24.533,4.512,20.618,7.163,19.671,8.11z";

	        $.ajax({
	            type: "POST",
	            contentType: "application/json;charset=utf-8",
	            url: "Default.aspx/GetCountryCodeList",
	            data: "{}",
	            dataType: "json",
	            async: false,
	            success: function(result) {
	                if (result.d == "NO DATA") {
	                    alert("No data available currently");
	                    location.reload();
	                }
	                else {
	                    CountryCodeList = (typeof result.d) == 'string' ? eval('(' + result.d + ')') : result.d;
	                }
	            },
	            error: function(error) { Show_Error_Loading(); }
	        });

	        var map = AmCharts.makeChart("mapdiv", {
	            type: "map",
	            theme: "dark",
	            pathToImages: "ammap/ammap/images/",
	            smallMap: {},
	            mouseWheelZoomEnabled: true,
	            zoomDuration: 0.2,
	            panEventsEnabled: true,
	            dataProvider: {
	                map: "worldHigh",
	                getAreasFromMap: true,
	                areas: CountryCodeList
	            },

	            zoomControl: { maxZoomLevel: 100, left: 10, buttonFillColor: "#15A892" },
	            areasSettings: { outlineThickness: 0.1, autoZoom: true, color: "#00305D", unlistedAreasColor: "#00305D" }
	        });
	        setTimeout(Hide_Loading, 2000);
	    } //end of GlobalDiv

	    function CountryDiv() {
	        GetTATSummary();
	        GetLocationSummaryXml();
	        $.ajax({
	            type: "POST",
	            contentType: "application/json;charset=utf-8",
	            url: "Default.aspx/GetLocationSummaryJson",
	            data: "{CountryID:" + selectedid + "}",
	            dataType: "json",
	            async: false,
	            success: function(result) {
	                if (result.d == "NO DATA") {
	                    alert("No data available currently for the selected country.");
	                    location.reload();
	                }
	                else {
	                    LocationSummaryJson = (typeof result.d) == 'string' ? eval('(' + result.d + ')') : result.d;
	                    $("#mainvactab").hide();
	                    $("#VACCARD34").show();
	                    $("#vaccard2").show();
	                    $("#vaccard3").show();
	                    $("#vaccard4").show();
	                    $("#mapcard").css("width", "70%");
	                    $("#mainvactab").fadeIn(2000);
	                    if (selectedcode == "IN") {
	                        mapjs = "indiaHigh";
	                    }
	                    else if (selectedcode == "NP") {
	                        mapjs = "nepalHigh";
	                    }
	                    else if (selectedcode == "LK") {
	                        mapjs = "sriLankaHigh";
	                    }
	                    else if (selectedcode == "CN") {
	                        mapjs = "chinaHigh";
	                    }
	                    else if (selectedcode == "BD") {
	                        mapjs = "bangladeshHigh";
	                    }
	                    else if (selectedcode == "AE" || selectedcode == "ZA" || selectedcode == "NG") {
	                        mapjs = "worldHigh";
	                    }

	                    // svg path for target icon
	                    var targetSVG = "M9,0C4.029,0,0,4.029,0,9s4.029,9,9,9s9-4.029,9-9S13.971,0,9,0z M9,15.93 c-3.83,0-6.93-3.1-6.93-6.93S5.17,2.07,9,2.07s6.93,3.1,6.93,6.93S12.83,15.93,9,15.93 M12.5,9c0,1.933-1.567,3.5-3.5,3.5S5.5,10.933,5.5,9S7.067,5.5,9,5.5 S12.5,7.067,12.5,9z";
	                    // svg path for plane icon
	                    var planeSVG = "M19.671,8.11l-2.777,2.777l-3.837-0.861c0.362-0.505,0.916-1.683,0.464-2.135c-0.518-0.517-1.979,0.278-2.305,0.604l-0.913,0.913L7.614,8.804l-2.021,2.021l2.232,1.061l-0.082,0.082l1.701,1.701l0.688-0.687l3.164,1.504L9.571,18.21H6.413l-1.137,1.138l3.6,0.948l1.83,1.83l0.947,3.598l1.137-1.137V21.43l3.725-3.725l1.504,3.164l-0.687,0.687l1.702,1.701l0.081-0.081l1.062,2.231l2.02-2.02l-0.604-2.689l0.912-0.912c0.326-0.326,1.121-1.789,0.604-2.306c-0.452-0.452-1.63,0.101-2.135,0.464l-0.861-3.838l2.777-2.777c0.947-0.947,3.599-4.862,2.62-5.839C24.533,4.512,20.618,7.163,19.671,8.11z";
	                    AmCharts.makeChart("mapdiv", {
	                        type: "map",
	                        "theme": "dark",
	                        pathToImages: "ammap/ammap/images/",
	                        smallMap: {},
	                        mouseWheelZoomEnabled: true,
	                        zoomDuration: 0.2,
	                        dataProvider: {
	                            map: mapjs,
	                            getAreasFromMap: true,
	                            images: (typeof result.d) == 'string' ? eval('(' + result.d + ')') : result.d
	                        },

	                        zoomControl: { maxZoomLevel: 3000, left: 10, buttonFillColor: "#15A892" },
	                        areasSettings: { outlineThickness: 0.1, selectedColor: "blue", autoZoom: true, color: "#00305D", unlistedAreasColor: "#00305D" }
	                    });
	                }
	            },
	            error: function(error) { Show_Error_Loading(); }
	        });
	        setTimeout(Hide_Loading, 2000);
	    } //end of IndiaDiv

	    function Show_Loading() {
	        $("#header").show();
	        //alert($(document).height());
	        //alert($('#mainpage').width());
	        //alert($('#spnLoading').width());
	        $('#spnLoading').css({ top: (($(document).height() / 4)) });
	        $('#spnLoading').css({ left: (($('#mainpage').width() / 2 - ($('#spnLoading').width() / 2))) });
	        $('#divLoading').hide();

	        $('#divLoading').width($('#mainpage').width());
	        $('#divLoading').height($(document).height());
	        $('#divLoading').show();
	    } //end of Show_Loading

	    function Hide_Loading() {
	        $('#divLoading').fadeIn(0, 'swing', function() {
	            $('#divLoading').fadeOut(500);
	            $("#header").fadeOut(500);
	            $('#mainpage').show();
	        });
	    } //end of Hide_Loading

	    function Show_Error_Loading() {
	        $("#header").show();
	        Hide_Loading();
	        $('#mainpage').hide();
	        $('#spnErrorLoading').css({ top: (($(document).height() / 4)) });
	        $('#spnErrorLoading').css({ left: (($('#mainpage').width() / 2) - ($('#spnErrorLoading').width() / 2)) });
	        $('#divErrorLoading').hide();

	        $('#divErrorLoading').width($('#mainpage').width());
	        $('#divErrorLoading').height($(document).height());
	        $('#divErrorLoading').show();
	    } //end of Show_Error_Loading

	    function Hide_Error_Loading() {
	        $('#divErrorLoading').fadeIn(0, 'swing', function() {
	            $('#divErrorLoading').fadeOut(500);
	            //$("#header").fadeOut(500);
	            $('#mainpage').show();
	        });
	    } //end of Hide_Error_Loading
	</script>
<body>
	<div id="header">
		<table style="width: 100%; height: 100%; color: white; font-size: 100%">
			<tr style="width: 100%; height: 10%; background-color: #00305D">
	            <td style="width: 100%; height: 100%; color: white; font-size: 120%">
	                <center>
	                	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/vfs-global-logo.png" width="100px" height="40px"><b>VFS Global - Reports</b>
	        			</span>
	                </center>
	            </td>
	        </tr>
        </table>
	</div>
	<div id="divLoading" class="Loading">        
	    <!--<div id="spnLoading" style="position:absolute;width:700px" class="progress progress-striped active">
	  		<div style="width:700px">
	  			<font size="4">
	  				<i>Collecting data from across your branches</i>
	  			</font>
	  		</div>
		</div>-->
	    <div id="spnLoading" style="position:absolute;width:700px">
	  		<div style="width:700px">
		  		<center>
		  			<img src="images/loader.gif"><br/><br/>
		  			<font size="3" color="white">
		  				<i>Collecting data from across your branches</i>
		  			</font>
		  		</center>
	  		</div>
		</div>
    </div>
    <div id="divErrorLoading" class="ErrorLoading">
		<div id-"spnErrorLoading" class="progress progress-danger progress-striped">
	  		<div class="bar" style="width: 100%">
	  			<font size="3"><b>&nbsp;&nbsp;&nbsp;Sorry, experiencing problem fetching data from the server&nbsp;&nbsp;&nbsp;</b></font>
	  		</div>
		</div>
	</div>
	<table id="mainpage" style="width: 100%; height: 100%; color: white; font-size: 100%">
		<tr style="width: 100%; height: 10%; background-color: #00305D">
            <td style="width: 100%; height: 100%; color: white; font-size: 120%">
                <center>
                	<span style="float:left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/vfs-global-logo.png" width="100px" height="40px"><b>VFS Global - Reports</b></span>
                	<span style="float:right">Location:
                    <select id="LocationSelect" style="font-size: 100%">
                    <option id="0" name="Global">Global</option>
                    </select>&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </span>
                </center>
            </td>
        </tr>
        <tr style="width: 100%; height: 90%">
         	<td>
         		<div id="tabcard">
	         		<table id="statstabcard" style="width: 95%; height: 100%;">
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;border-radius:10px"><br/></td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;background-color: #FF9C00;color:#00305D"><br><b><span id="CountryName"></span></b></td>
	         				<td style="width:100%;background-color: #FF9C00;border-top-right-radius:0.5em;"><br><i></i>&nbsp;&nbsp;&nbsp;</td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;background-color: #00305D"><br><b>Online Locations :</b></td>
	         				<td style="width:100%;background-color: #00305D;"><br><i><span id="TotalOnlineLocations"></span></i>&nbsp;&nbsp;&nbsp;</td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;background-color: #00305D"><br><b>Offline Locations :</b></td>
	         				<td style="width:100%;background-color: #00305D;"><br><i><span id="TotalOfflineLocations"></span></i>&nbsp;&nbsp;&nbsp;</td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;background-color: #00305D"><br><b>Total Tickets:</b></td>
	         				<td style="width:100%;background-color: #00305D"><br><i><span id="TotalTickets"></span>&nbsp;&nbsp;&nbsp;</i></td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;background-color: #00305D"><br><b>Total Applications:</b></td>
	         				<td style="width:100%;background-color: #00305D"><br><i><span id="TotalApplications"></span>&nbsp;&nbsp;&nbsp;</i></td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;background-color: #00305D"><br/></td>
	         				<td style="width:100%;background-color: #00305D;"><br/></td>
	         			</tr>
	         		</table>
	         		<table id="statstopcard" style="width: 95%; height: 100%;">
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;border-radius:10px"><br/></td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;background-color: #FF9C00;color:#00305D"><br><b>Best Performing VACs</b><br><font size="1"> (As per Avg.TAT)</span></font></td>
	         				<td style="width:100%;background-color: #FF9C00;border-top-right-radius:0.5em;"><br><i></i>&nbsp;&nbsp;&nbsp;</td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%;">
	         				<td style="width:100%;background-color: #00305D;">
	         					<ul style="list-style: none;padding:1; margin:0;" id="BESTVACS"></ul>
	         				</td>
	         				<td style="width:100%;background-color: #00305D;">
	         					
	         				</td>
	         			</tr>
	         		</table>
	         		<table id="statsworstcard" style="width: 95%; height: 100%;">
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;border-radius:10px"><br/></td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%">
	         				<td style="width:100%;background-color: #FF9C00;color:#00305D"><br><b>Least Performing VACs</b><br><font size="1"> (As per Avg.TAT)</span></font></td>
	         				<td style="width:100%;background-color: #FF9C00;border-top-right-radius:0.5em;"><br><i></i>&nbsp;&nbsp;&nbsp;</td>
	         			</tr>
	         			<tr style="width: 100%; height: 100%;">
	         				<td style="width:100%;background-color: #00305D;">
	         					<ul style="list-style: none;padding:1; margin:0;" id="WORSTVACS"></ul>
	         				</td>
	         				<td style="width:100%;background-color: #00305D;">	         					
	         				</td>
	         			</tr>
	         		</table>
         		</div>
         		<div id="mapcard"><br/>
                	<div id="mapdiv"></div>
            	</div>
            	<div id="mainvactab"><br/>
            		<marquee behavior="scroll" direction="up" height="700" scrollamount="2" onmouseover="this.stop();" onmouseout="this.start();">         	
            		<div id="vaccard"></div>
	         		</marquee>	
            	</div>
         	</td> 
        </tr>
	</table>	
</body>