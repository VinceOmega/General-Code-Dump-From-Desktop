<!DOCTYPE html>

<html>
	<head>
	<meta charset="utf-8"> 
	<meta content="yes" name="apple-mobile-web-app-capable" />
	<title>Southern Breeze Store Locator prototype</title>

	<style text="text/css">
			#form-store-loc{
				display: block;
			}

			#listing-store-loc{
				display: block;
				 height: 900px !important;
    			width: 900px !important;
			}

			#map-store-loc{
				display: block;
				 height: 900px !important;
    			width: 900px !important;
			}

			#listing-store-loc ul{
				display: block;
			}

			#listing-store-loc .left-col{
				position: relative;
				float: left;
			}
			
			#listing-store-loc .right-col{
				position: relative;
				float: right;
			}

			#map{

				height: 1000px;
				width: 800px;
				float: left;
			}

			.hidden{
				display: none;
			}



	</style>

	</head>
	<body>

			<div id="store-loc-title">
				Store Locator
			</div>
	<div id="form-store-loc">
			
		<form name="store_locator" id="southern-breeze-store-locator" post="post" action="javascript:transition();">
				<input type="text" name="zip_code" placeholder="Zip Code"/>
				<input type="submit" name="Submit" value="Submit"/>				
		</form>

	</div>
	<div id="listing-store-loc">

			<ul>
				<div class="left-col">
					
					&nbsp;&nbsp;&nbsp;&nbsp;
				</div>

				<div class="right-col">
					&nbsp;&nbsp;&nbsp;&nbsp;
				</div>
			</ul>
	</div>
	<div id="map-store-loc">
			<div id="map">
			</div>
			<div id="directions">

			</div>
	</div>


	<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDnP1tifroOyEyh69MZcTuedjA3RA4pd68&amp;sensor=false" style=""></script>
	<script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.1/jquery.min.js" ></script>
	<script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js" ></script>
	<script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.2/modernizr.min.js"></script>
	<script type="text/javascript" src="store.js"></script>
		<script type="text/javascript">
	/* Get current location from navigator object */

	var lat = "";
	var long = "";
	function getLocation(){
		navigator.geolocation.getCurrentPosition(function(pos){

			lat = pos.coords.latitude;
			long = pos.coords.longitude;
		
			directions.setLat(lat); 
			directions.setLong(long);
		
		}, function(err){
			if(err.code === 1){
				
			
			}
		});

		
		return true;
	}

	

	getLocation();

//	alert(latcord);

	
	
</script>
	</body>
</html>