<!DOCTYPE html>
<html>
<lang en="us">
<head>


	<script type="text/javascript">
		$('.modal-img-exit').click(function(){
	$('.modal-page').fadeOut(500,function(){
		//animation complete
	})
});
	</script>

<style type="text/css">


/*.modal-input-style{
	width: 180px;
	-moz-border-radius: 6px;
	-webkit-border-radius: 6px;
	border-radius: 6px;
	background-color: #fff;
	border: 1px solid #000;
	padding: 10px 5px 5px 10px;
	font-weight: 900;
}*/

/*.modal-input-position{
		position: relative;
}*/

/*.modal-select-style{
	width: 180px;
	-webkit-appearance: none;
	background-color: #fff;
	padding: 10px 5px 10px 10px;
	font-weight: 900;
}*/

/*.modal-select-position{
		position: relative;
}

.modal-textarea-style{
	width: 180px;
	-moz-border-radius: 6px;
	-webkit-border-radius: 6px;
	border-radius: 6px;
	background-color: #fff;
}

.modal-textarea-position{
	position: relative;
}

.modal-btn-style{
	width: 90px;
	-webkit-appearance: none;
	-moz-border-radius: 6px;
	-webkit-border-radius: 6px;
	border-radius: 6px;
	background-color: #fff;
	color: #990000;
	border: 1px solid #990000;
	text-align: center;
	font-weight: 900;
	font-size: 14px;
	padding: 5px 5px 5px 10px;

}

.modal-btn-position{
	position: relative;

}*/
</style>


</head>
<body>

<?php
$thanks_flag = '0';

if(
isset($_GET['thanks'])
){
$thanks_flag = $_GET['thanks'];
}


?>


		<?php
if( $thanks_flag == '1'){

echo "<div class='sumbit-message'>

			<p>Thanks for sumbitting your information. A design consultant will contact you shortly.</p>
	</div>";
} elseif ($thanks_flag == '2'){

echo "<div class='sumbit-message'>
           <p>Please fill all fields with relevant information</p>
      <div>";
}
 elseif ($thanks_flag == '3'){
 	echo "<div class='sumbit-message'>
 			<p>Special characters are not allowed</p>
 		<div>";
 }

?>
<div id="modal-img-close">
	<a href="#" class="modal-img-exit">
	<img src="gfx/modal_close.png" alt="close">
	</a>
</div>

<div class="header_text">
<center>Request an appointment</center>
</div>
<div id="modal-appointment-form">
	<form id="apptField" method="post" action="/wordpress2/mail.php">
		<fieldset>
			<label for="location" style="position: relative; top: 10px" class="modal-label-position " >Choose a location
				<br />
				<select name="location" class="modal-select-style modal-select-position">
				
					<option value="" >Choose A Location</option>
						<option value="allentown">Allentown, PA</option>
						<option value="collegeville">Collegeville, PA</option>
						<option value="reading">Reading, PA</option>
						<option value="willow_grove">West Chester, PA</option>
						<!-- <option value="lancaster">Lancaster,PA</option> -->
						<option value="willow_grove">Willow Grove, PA</option>
						<option value="collingswood">Collingswood, NJ</option>
						<option value="egg_harbor">Egg Harbor Township, NJ</option>
						<option value="rio_grande">Rio Grade, NJ</option>
						<option value="somers_point">Somers Point, NJ</option>										
				</select></label>
		</fieldset>
		<fieldset>
			<label for="first_name">First Name
				<br />
				<input type="text" id="first_name" name="first_name" value="" class="modal-input-style modal-input-position">
			</label>
		</fieldset>
		<fieldset>
			<label for="last_name">Last Name
				<br />
				<input type="text" name="last_name" id="last_name" value="" class="modal-input-style modal-input-position">
			</label>
		</fieldset>
		<fieldset>
			<label for="email">Email
				<br />
				<input type="text" name="email" id="email" value="" class="modal-input-style modal-input-position">
			</label>
		</fieldset>
		<fieldset>
			<label for="companyname">Telephone
				<br />
				<input type="text" name="telephone" id="telephone" class="modal-input-style modal-input-position">
			</label>
		</fieldset>
		<fieldset>
			<label for="phone">Best time to call
				<br />
				<input type="text" name="time" id="time" class="modal-input-style modal-input-position">
			</label>
		</fieldset>
		<fieldset>
			<label for="rooms">Rooms
				<br />
				<select name="rooms" class="modal-select-style modal-select-position">
					<option value="bathroom">Bathroom</option>
					<option value="kitchen">Kitchen</option>
				</select></label>
		</fieldset>
		<fieldset id="message">
			<label for="project">Message
				<br />
				<textarea type="text" name="project" style="height:85px;" class="modal-textarea-style modal-textarea-position"></textarea></label>
		</fieldset>
		<fieldset style="margin-right: 45px; margin-top: 10px">
			<button type="submit" name="btn-submit" value="submit" class="modal-btn-style modal-btn-position">
				Submit &#10142;
			</button>
		</fieldset>
	</form>
	</div>
</body>
</html>