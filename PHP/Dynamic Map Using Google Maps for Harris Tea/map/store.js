//Mobile dectection.
var Mobile = { 
  Android: function(){
      return /Android/i.test(navigator.userAgent);
  },
  Blackberry: function(){
      return /Blackberry/i.test(navigator.userAgent);
  },
  iOS: function(){
     return /iPhone|iPad|iPod/i.test(navigator.userAgent);
  },
  Windows: function(){
     return /IEMobile/i.test(navigator.userAgent);
  },
  any: function(){
    return (Mobile.Android() || Mobile.Blackberry() ||  Mobile.OS() || Mobile.Windows());
  }
};


//Object for street information

function dirPerson(Zip, Directions, Lat, Long, Miles){
	
	//Dem Props

	this.Zip = Zip;
  this.Directions = Directions;
  this.Lat = Lat;
  this.Long = Long;
  this.Miles = Miles;

	//Dem Methods

	this.setZip = setZip;
  this.setDirections = setDirections;
  this.setLat = setLat;
  this.setLong = setLong;
  this.setMiles = setMiles;
}

function setZip(Zip){
	this.Zip = Zip;
}

function setDirections(Directions){
  this.Directions = Directions;
}

function setLat(Lat){
  this.Lat = Lat;
}

function setLong(Long){
  this.Long = Long;
}

function setMiles(Miles){
    this.Miles = Miles;
}




var directions = new dirPerson();

var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
var map;
var stepDisplay;
var markerArray = [];

function initialize() {

var yourLoc = new google.maps.LatLng(directions.Lat, directions.Long);
        var myOptions = {         
          zoom: 12,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
		  center:yourLoc
        }
        map = new google.maps.Map(document.getElementById("map"),
            myOptions);
			
      var bounds = new google.maps.LatLngBounds();
			var rendererOptions = {
			map: map,
      suppressMarkers: true
	}
			
		 directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions)
		 stepDisplay = new google.maps.InfoWindow();

    // google.maps.event.trigger(map, 'resize');
     map.fitBounds(bounds);

      }
	  
function calcRoute(location) {
 //clear markers
 for (i = 0; i < markerArray.length; i++) {
    markerArray[i].setMap(null);
  }
 
 //alert(location);
 //alert(directions.Zip);

  var start = directions.Zip;
  var end = location;
  var request = {
    origin:start,
    destination:end,
    travelMode: google.maps.TravelMode.DRIVING
  } ;

  
   // Route the directions and pass the response to a
  // function to create markers for each step.
  directionsService.route(request, function(response, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      //var warnings = document.getElementById("warning_panel");
     // warnings.innerHTML = "" + response.routes[0].warnings + "";
      directionsDisplay.setDirections(response);
      //makeMarker(leg.end_location, icons.end, 'Sweet Tea');
      showSteps(response);
    }
  });
}

// function makeMarker(position, icon, title){
//     new google.maps.Marker({
//       position: position,
//       map: map,
//       icon: icon,
//       title: title
//     });
// }

function showSteps(directionResult) {
  // For each step, place a marker, and add the text to the marker's
  // info window. Also attach the marker to an array so we
  // can keep track of it and remove it when calculating new
  // routes.

  var myRoute = directionResult.routes[0].legs[0];
  
 var dir;
   var starting = new google.maps.Marker({
      position: myRoute.steps[0].start_point,
      map: map,
      icon: '/map/Home.png'
  });



  for (var i = 0; i < myRoute.steps.length; i++) {
      // var marker = new google.maps.Marker({
      //   position: myRoute.steps[i].start_point,
      //   map: map,
		    // icons: '/blank.png'
      // });

      //attachInstructionText(marker, myRoute.steps[i].instructions);
	  dir += myRoute.steps[i].instructions + "<br/>";
     // markerArray[i] = marker;
  }

  //  alert(i);
    var ending = new google.maps.Marker({
      position: myRoute.steps[i - 1].end_point,
      map: map,
      icon: '/map/Jar.png'
  });


  directions.setDirections(dir);
  $("#directions-text").html(directions.Directions.replace("undefinedHead", "Head"));
  //alert(directions.Directions);
}

function attachInstructionText(marker, text) {
  google.maps.event.addListener(marker, 'click', function() {
    stepDisplay.setContent(text);
    stepDisplay.open(map, marker);
  });
}



function distance(lat1, lon1, lat2, lon2) {
    var radlat1 = Math.PI * lat1/180;
    var radlat2 = Math.PI * lat2/180;
    var radlon1 = Math.PI * lon1/180;
    var radlon2 = Math.PI * lon2/180;
    var theta = lon1-lon2;
    var radtheta = Math.PI * theta/180;
    var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
    dist = Math.acos(dist);
    dist = dist * 180/Math.PI;
    dist = dist * 60 * 1.1515;
    return Math.floor(dist);
  } 

if (window.XMLHttpRequest)
    {// code for IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp=new XMLHttpRequest();
    }
  else
    {// code for IE6, IE5
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
  xmlhttp.open("GET","/map/store_test.xml",false);
  xmlhttp.send();
  xmlDoc=xmlhttp.responseXML;
  
  var prodObj;
  var xmlPowa = xmlDoc.getElementsByTagName("storeLocatorViewNew");
  var requestedLat = "";
  var requestedLong = "";
  var myStoreList = new Array();
  

    requestedLat = directions.Lat;
    requestedLong = directions.Long;

//    console.log(requestedLat); console.log(requestedLong);


function getStoreList(){
    for (var i = 0; i < xmlPowa.length; i++) {
      createObj(xmlPowa[i]);

    }

getStoreListLocation();
  
    
  }

  function createObj(objToCreate){
    myStoreList[objToCreate.getAttribute("id")] = new Object();
    myStoreList[objToCreate.getAttribute("id")].storeName = objToCreate.getAttribute("storeName");
    myStoreList[objToCreate.getAttribute("id")].address = objToCreate.getAttribute("address");
    myStoreList[objToCreate.getAttribute("id")].city = objToCreate.getAttribute("city");
    myStoreList[objToCreate.getAttribute("id")].state = objToCreate.getAttribute("state");
    myStoreList[objToCreate.getAttribute("id")].zipcode = objToCreate.getAttribute("zip");
    myStoreList[objToCreate.getAttribute("id")].lat = objToCreate.getAttribute('lat');
    myStoreList[objToCreate.getAttribute("id")].long = objToCreate.getAttribute('long');

  }
  

  function getStoreListLocation(){

    var resultsD = new Array(100,100,100,100,100);
    var resultsI = new Array("","","","","");
          // alert(directions.Lat);
          // alert(directions.Long);
    for (var i=0; i<xmlPowa.length;i++) {

    

      var tempDist = distance(xmlPowa[i].getAttribute("lat") ,xmlPowa[i].getAttribute("long"),directions.Lat,directions.Long);
       for(var x in resultsD){
        if(tempDist < resultsD[x]){
          for(var y=4; y>x; y--){
            resultsD[y] = resultsD[y-1];
            resultsI[y] = resultsI[y-1];
          }
          resultsD[x] = tempDist;
        //  $('#store-loc-title').append(resultsI[x]);
          resultsI[x] = xmlPowa[i].getAttribute("id");

         break;
        }
      }

    }

 
      
    
    if(resultsI.length > 0){
     $('.left-col').empty(); $('.right-col').empty();
    } else {
      //document.getElementById("storeList").innerHTML = 'No stores found.';
     
    }

  

    var num = 0;
    for(var z=0; z<=4; z++) {
     // alert(resultsI[z]);
    if(resultsI[z]){
      printStore(resultsI[z],resultsD[z], num);
      num++;
      }
      
    }
    $('#form-store-loc').removeClass('step1');
    $('.map-container').removeClass('step1');
    $('.col-1').addClass('step2');
   // alert($('.left-col').html());
    if($('.left-col').html() === ""){  $('.left-col').html('No stores found within 100 miles near you. Bummer.'); }
    //var css = 'display: block; margin-top: 250px; margin-left: 20px; font-size: 50px;';
    //$("#map").append("<span style='" + css + "'>Click the <span style='text-decoration: underline;'> directions</span> <br/> to show the map.</span>");
  }

  function printStore(storeID, storeDistance, num){
//alert(storeID);
      var soon = '';
   if(myStoreList[storeID].storeName.trim() === 'FOOD LION'){
      soon = ' (Coming in 2015!) ';
   }
    var outputString = "<span class='result-" +  (num + 1) + " '>";
    if (storeDistance) {
      outputString += "<li class='distance'><strong> <span class='number'>"+ storeDistance.toFixed(1) +"</span> miles </strong></li>";
    } else {
      outputString += "<li class='distance'><strong> <span class='number'>"+ "Under a mile" +"</span> </strong></li>";
  
    }
    outputString += "<li class='name'>" + myStoreList[storeID].storeName + soon + "</li>";
    outputString += "<li class='address'>" + myStoreList[storeID].address + "</li>";

    outputString += "<li class='zip'>" + myStoreList[storeID].city + ", ";
    outputString += myStoreList[storeID].state+ " ";
    outputString += myStoreList[storeID].zipcode+"<br />";
    //outputString += "<a href='tel:"+myStoreList[storeID].phone+"'>"+myStoreList[storeID].phone+"</a><br />";
    //var tempAddress = myStoreList[storeID].address1+","+myStoreList[storeID].address2+","+myStoreList[storeID].city+","+myStoreList[storeID].state+"+"+myStoreList[storeID].zipcode;
    //tempAddress = tempAddress.split(' ').join('+');
    outputString += "<li class='desktop result-" + (num + 1) + "' onmousedown='transition();' ><a href='#' >Directions</a></li>";
   if(Mobile.Android()){
    outputString += "<li class='mobile'><a href='geo:" + directions.Lat + "," + directions.Long + "?q=" + myStoreList[storeID].lat + "," + myStoreList[storeID].long + "'>Click to launch app. </a></li>";
    } else{
    outputString += "<li class='mobile'><a href='http://maps.apple.com/maps?q=" + myStoreList[storeID].lat + "," + myStoreList[storeID].long +  "'>Click to launch app. </a></li>";
    }
    outputString += "<li class='lat hidden'>" + myStoreList[storeID].lat + "</li>";
    outputString += "<li class='long hidden'>" + myStoreList[storeID].long + "</li>";
    
    outputString += "</span>";
    

    $('.left-col').append(outputString);
    

   
          
  }

  function checkCoords(lat, long){
  



      if(lat === "" || long === ""){
        //  alert('Powering up the Soronous Cannon');
          var zip = directions.Zip;
         // alert(zip);
          var geocoder = new google.maps.Geocoder();
        
          geocoder.geocode( {'address': zip}, function(results, status){
          

             if(status == google.maps.GeocoderStatus.OK){
           //      alert('Fire');
                directions.setLat(results[0].geometry.location.lat());
                directions.setLong(results[0].geometry.location.lng());

             } else {
                Console.log("Geocode was no successful for the following reason: " + status);
             } 
          });
      }
  }

  
function getStores(){
      directions.setZip($("input[name='zip_code']").val());
      checkCoords(lat, long);
      //alert(directions.Lat);
      window.setTimeout(getStoreList, 2000);
}

function transition(){


$('#listing-store-loc ul li a').click(function(){
        //alert('fired');
        $("#map").empty();
        var type = $(this).parent().attr('class');
        tmp = type.split("desktop"); //alert(tmp[1]);
        type = tmp[1];
        tmp = type.split(" ");
        type = tmp[1];
        //alert(type);
        var selector = '#listing-store-loc .left-col span' + "." + type;
       //alert(selector);
        var address_selector = selector + ' li.address';
        var zip_selector = selector + '  li.zip';
        var lat_selector = selector + ' li.lat';
        var long_selector = selector + ' li.long';
        var dist_selector = selector + ' li.distance span.number';

        //alert(address_selector);
        var address = $(address_selector).html();
        //alert(address);
        var zip = $(zip_selector).html();
        var latnum = parseInt($(lat_selector).html());
        var longnum = parseInt($(long_selector).html());
        //alert(latnum); alert(longnum);
        var full_address = address +  " " + zip;
        //alert(full_address);
        initialize();
        calcRoute(full_address);
        var dist = parseInt($(dist_selector).html());
        //var dist = distance(parseInt(latnum), parseInt(longnum), directions.Lat, directions.Long);
        //alert(dist + ' miles.');
       // window.setTimeout(alert(directions.Directions), 3000);
        $('#directions').delay(500).html("<div id='directions-miles'>" + dist + " miles </div><div id='directions-text'> </div>" );
        
    }); 

		
}

$("form[name='store_locator']").validate({
  rules: {
    zip_code: "required"
  },
  messages: {
    zip_code: "We need your zip code in order to locate a store for you."

  }
});


$(document).ready(function(){
    if(Mobile.Windows) window.onerror = null;
});

//alert(Mobile.iOS());


//alert(map.data.getStyle());