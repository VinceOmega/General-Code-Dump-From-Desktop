<?php
include 'tcpdf/tcpdf_import.php';
include 'maintence.class.php';
include 'siteMeta.class.php';
include 'casper.class.php';
include 'detect.class.php';
include 'sugar_rest.php';
include 'pamphlet.class.php';
include 'PHPMailer/class.phpmailer.php';
include 'config.php';
ini_set('display_errors',1);  error_reporting(E_ALL);
$_POST['first_name'] = "Larry";
$_POST['last_name'] = "Stanfield";
$_POST['email'] = 'vince.omega@gmail.com';
$_POST['uri'] = 'http://www.arifleet.com';
$_POST['phone'] = '215-847-5012';
$_POST['companyname'] = 'Zeus!';

/**
* main function for program
* @name main()
* @param void
* @return none
*/


function main(){



if($_POST['first_name'] != null &&
	$_POST['last_name'] != null &&
	$_POST['email'] != null &&
	$_POST['uri'] != null){

	foreach($_POST as $key => $value){
			$$key = htmlspecialchars(trim($value)); 

	}
	//echo $uri;

	
	$janitor = new maintence();
	//$janitor->mrClean();
	$um = $janitor->readProfile($uri);
	
		if($um === 0){
			//echo 'no profile';
			$data = array(
						'meta' => '',
						'mobile' => '',
						'tablet' => '',
						'redirect' => array(
								'value' => '',
								'domain' => ''
							),
						'document' => ''
				);
	



	$meta = new siteMeta();
	$metaHTML = $meta->pingMe($uri);
	$data['meta'] = $metaHTML;



	$screenies = new casper();
	$screeniesHTML = $screenies->phantomPlz($uri);
	$data['mobile'] = $screeniesHTML['mobile'];
	$data['tablet'] = $screeniesHTML['tablet'];


	$detection = new detect();
	$detectionData = $detection->detectURL($uri);
	$data['redirect']['value'] = $detectionData['value'];
	$data['redirect']['domain'] = $detectionData['domain'];

	$full = $first_name + $last_name;
	$doc = new pamphlet();
	$doc->create($uri, $data, $full);

	//mailer($first_name, $last_name, $phone, $companyname, $email, $uri);
	//sendToSugar($first_name, $last_name, $phone, $companyname, $email, $uri, $config['assignedUserID']);
	

	//$janitor->makeProfile($uri, $data);



	echo $metaHTML;
	echo $screeniesHTML['html'];
	} else {
	echo $um;
}
		}


		die();
}


function mailer($first_name, $last_name, $phone, $companyname, $email, $uri){


	$mail = new PHPMailer();
	$mail->From = "noreply@d4creative.com";
	$mail->FromName = "D4Website";
	$mail->AddAddress("stauffer@d4creative.com");
	//$mail->AddCC("shore@d4creative.com", "teitelman@d4creative.com");
	$mail->AddBCC("stanfield@d4creative.com");
	$mail->Subject = "Mobile Application Lead";
	$body = "Name: ".$first_name." ".$last_name."<br>";
	$body .= "Email: ".$email."<br>";
	$body .= "Phone: ".$phone."<br>";
	$body .= "Company: ".$companyname."<br>";
	$body .= "Message: ".$uri."<br>";
	$mail->Body = $mail->MsgHTML($body);

	if(!$mail->Send()){
			echo 'Message not sent';
			echo 'Mailer error: '.$mail->ErrorInfo;
	}else{
			//header("Location: ".$_SERVER['HTTP_REFERER']);
	}

}

function sendToSugar($first_name, $last_name, $phone, $companyname, $email, $uri, $assignedUserID){
		
		$sugar = new Sugar_REST();

		$entry = array(
		array("name"=>"first_name",		"value"=>$first_name),
		array("name"=>"last_name",		"value"=>$last_name),
		array("name"=>"status", 		"value"=>"New"),
		array("name"=>"phone_work", 	"value"=>$phone),
		array("name"=>"account_name",	"value"=>$companyname),
		array("name"=>"email1",			"value"=>$email),
		array("name"=>"email1_optin_mc_c","value"=> "N/A"),
		array("name"=>"lead_source",	"value"=>"Mobile Responsiveness Application."),
		array("name"=>"description",	"value"=>"website: ".$uri),		
		array("name"=>"assigned_user_id","value"=>$assignedUserID) //-value set in config.php.
	);

		$store = $sugar->set("Leads", $entry);
}

main();


?>