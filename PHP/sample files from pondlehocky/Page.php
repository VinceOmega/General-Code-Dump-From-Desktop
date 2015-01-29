<?php


 //require_once '/Volumes/www/vhosts/pondlehocky/html/pl/framework/thirdparty/constant-contact-sdk-php/src/Ctct/autoload.php';
//require_once '/Volumes/www/vhosts/pondlehocky/html/pl/framework/thirdparty/constant_contact_old_api/ConstantContact.php';
//require_once '/Volumes/www/vhosts/pondlehocky/html/pl/framework/thirdparty/constant_contact_old_api/cc_class.php';

//use Ctct\ConstantContact;
//use Ctct\Components\Contacts\Contact;
//use Ctct\Components\Contacts\ContactList;
//use Ctct\Components\Contacts\EmailAddress;
//use Ctct\Exceptions\CtctException;
//use Ctct\Auth\CtctOAuth2;
//use Ctct\Exceptions\OAuth2Exception;



define('API_KEY', 'sebsuad42dyn3795f4kwk7r9');
define('TOKEN', '8a34a5af-2d3f-4d20-ae12-2a09094f6583');
define('ALTTOKEN', '2d68abf5-7cea-450b-91fc-ec8062ce41b3');
define('CONSUMER', '3b3337652ee348199861ae05a806b7dc');
define('OLD_KEY', 'e0705d1a-fe37-40b3-9837-834e3e1ca6d4');

class Page extends SiteTree {

	private static $db = array(

		'CaseName' => 'Text',
		'CaseEmail' => 'Text',
		'CasePhone' => 'Text',
		'CaseWorkersBox' => 'Int',
		'CaseSocialBox' => 'Int',
		'CaseMessage' => 'Text',
		'HandName' => 'Text',
		'HandEmail' => 'Text',
		'HandPhone' => 'Text',
		'HandMessage' => 'Text'


	);

	private static $has_one = array(
	);






}
class Page_Controller extends ContentController {

	/**
	 * An array of actions that can be accessed via a request. Each array element should be an action name, and the
	 * permissions or conditions required to allow the user to access it.
	 *
	 * <code>
	 * array (
	 *     'action', // anyone can access this action
	 *     'action' => true, // same as above
	 *     'action' => 'ADMIN', // you must have ADMIN permissions to access this action
	 *     'action' => '->checkAction' // you can only access this action if $this->checkAction() returns true
	 * );
	 * </code>
	 *
	 * @var array
	 */


	private static $allowed_actions = array('caseEvaluationForms', 'doActionCase',
	'handbookForms',  'doHandCase', 'emailForms', 'doEmail', 'formContactUs', 'doContacts');

	

	public function init() {
		parent::init();

		// Note: you should use SS template require tags inside your templates 
		// instead of putting Requirements calls here.  However these are 
		// included so that our older themes still work
		Requirements::themedCSS('reset');
		//Requirements::themedCSS('layout'); 
		//Requirements::themedCSS('typography'); 
		//Requirements::themedCSS('form');
		// Requirements::javascript("framework/thirdparty/jquery/jquery.min.js");
		// Requirements::javascript("framework/thirdparty/jquery-ui/jquery-ui.min.js");
		//Requirements::javascript("framework/thirdparty/jquery-cycle2/jquery.cycle2.min.js");
		// Requirements::javascript("mysite/js/pond.js");

	}




public function failState($var){
		
			echo "It appears that something went wrong. Please try again or call toll-free at 800-568-7500.";
			echo "The following is for debugging purposes only.";
			echo 'Array count - '. $var;
			// if(isset($data['CasePhone'])){
			// 	var_dump($data['CasePhone']);
			// }
			
			// if(isset($data['HandPhone'])){
			// 	var_dump($data['HandPhone']);
			// }
			die();
		
}

public function caseEvaluationForms(){

$casename =  new TextField('CaseName', '');
$casename->setAttribute('placeholder', 'Your Name*');
$casename->setAttribute('required', 'required');
$caselast = new TextField('CaseLast', '');
$caselast->setAttribute('placeholder', 'Last Name*');
$caselast->setAttribute('required', 'required');
$caseemail = new EmailField('CaseEmail', '');
$caseemail->setAttribute('placeholder', 'Your Email*');
$caseemail->setAttribute('required', 'required');
$casephone = new PhoneNumberField('CasePhone', '');
$casephone->setAttribute('placeholder', 'Your Phone*');
$casephone->setAttribute('required', 'required');
$casephone->addExtraClass('form-hand-phone');
$casemessage = 	new TextareaField(
 						$name = 'CaseMessage',
 						$title = ''
 						);
$casemessage->setAttribute('placeholder', 'Your Message*');
$casemessage->setAttribute('required', 'required');
$action = new FormAction('doActionCase', ' ');
$trapfield = new TextField('Time', '');
$trapfield->setAttribute('class', 'unseen');
$action->actionName('Submit');



				
					$form = new Form(
						$this, 'caseEvaluationForms',
							new FieldList(
								$casename,
								$caseemail,
								$casephone,
					new CheckboxField('CaseWorkersBox', "Workers' Compensation"),
 					new CheckboxField('CaseSocialBox', "Social Security"),
 					$casemessage,
 					$trapfield
 				),
				 new FieldList(
				 	$action),
				 	new RequiredFields('CaseName', 'CaseEmail', 
				 		'CasePhone')
				 		
				

				 	);
 				
			 return $form;

				
	
}

public function doActionCase($data, $form){

		function sendMail($email, $data){

				  $from = 'donotreply@pondlehocky.com';

    $to = $email;

    $subject = "New Case Study Submission";

    $body = "The following individual is requesting a case evaluation."."<br/><br/>";
    $body .= "Name: ".$data['CaseName'] . "<br/>";
    $body .= "Email: ".$data['CaseEmail'] . "<br/> Phone: ";
    foreach($data['CasePhone'] as $key => $value){
    $body .= $value;
    }
    $body .= "<br/>";
    if(isset($data['CaseWorkersBox'])){
    $body .= "Is interested in Workers' Compensation" . "<br/>";
}
    if(isset($data['CaseSocialBox'])){
    $body .= "Is interested in Social Security" . "<rbr/>";
}
    $body .= "<br/> "."Message: ".$data['CaseMessage'] . "<br/>";



    $email = new Email($from, $to, $subject, $body);

    $email->send();
	}

$count = 0;
foreach($data['CasePhone'] as $key => $value){
	$count = count(str_split($value));
	
}

if($count < 10){
	$this->failState($count);
}


	if(isset($data['Time']) & $data['Time'] != ''){
			$this->failState();
	}else{
//	sendMail('stauffer@d4creative.com', $data);
	sendMail('info@pondlehocky.com', $data);
	//sendMail('intake@pondlehocky.com', $data);
//	sendMail('jdonovan@pondlehocky.com', $data);
//	sendMail('asioutis@pondlehocky.com', $data);
//	sendMail('stanfield@d4creative.com', $data);
}


			$form->saveInto($applicationCase = new CaseHandler());
			$applicationCase->write();

			return array(
				'ApplicationCase' => $applicationCase
				);

					
	
			 return $this->redirectBack();

}

public function handbookForms(){

$handname = new TextField('HandName', '');
$handname->setAttribute('placeholder', 'Your Name*');
$handname->setAttribute('required', 'required');
$handlast = new TextField('HandLast', '');
$handlast->setAttribute('placeholder', 'Last Name*');
$handlast->setAttribute('required', 'required');
$handemail = new EmailField('HandEmail', '');
$handemail->setAttribute('placeholder', 'Your Email*');
$handemail->setAttribute('required', 'required');
$handphone = new PhoneNumberField('HandPhone', '');
$handphone->setAttribute('placeholder', 'Your Phone*');
$handphone->setAttribute('required', 'required');
$handphone->addExtraClass('form-hand-phone');
$handmessage = 		new TextareaField(
 						$name = 'HandMessage',
 						$title = ''
 						);
$handmessage->setAttribute('placeholder', 'Your Mailing Address*');
$handmessage->setAttribute('required', 'required');
$trapfield = new TextField('Time', '');
$trapfield->setAttribute('class', 'unseen');
$action = new FormAction('doHandCase', ' ');
$action->actionName('Submit');




 					
				
					$form = new Form(
						$this, 'handbookForms',
							new FieldList(
								$handname,
								$handemail,
								$handphone,
 								$handmessage,
 								$trapfield
 				),
				 new FieldList(
				 	$action),
				 	new RequiredFields('HandName', 'HandEmail', 
				 		'HandPhone')
				 		
				

				 	);
 				
			 return $form;

				
	
}

public function doHandCase($data, $form){


	function sendMail($email, $data){

				  $from = 'donotreply@pondlehocky.com';

    $to = $email;

    $subject = "New Handbook Submission";

    $body  = "The following individual is requesting a free handbook. "."<br/><br/>";
    $body .= "Name: ". $data['HandName'] . "<br/>";
    $body .= "Email: ".$data['HandEmail'] . "<br/> Phone:";
    foreach($data['HandPhone'] as $key => $value){
    $body .= $value;
    }
    $body .= "<br/>". " Your Mailing Address: ". $data['HandMessage'] . "\<br/>";



    $email = new Email($from, $to, $subject, $body);

    $email->send();
	}
$count = 0;
foreach($data['HandPhone'] as $key => $value){
	$count = count(str_split($value));
	
}

if($count < 10){
	$this->failState($count);
}


if(isset($data['Time']) & $data['Time'] != ''){
			$this->failState();
	}else{
//	sendMail('stauffer@d4creative.com', $data);
	sendMail('info@pondlehocky.com', $data);
	//sendMail('intake@pondlehocky.com', $data);
//	sendMail('jdonovan@pondlehocky.com', $data);
//	sendMail('asioutis@pondlehocky.com', $data);
//	sendMail('stanfield@d4creative.com', $data);
}

			$form->saveInto($applicationHand = new HandbookHandler());
			$applicationHand->write();

			return array(
				'ApplicationHand' => $applicationHand
				);
					
		
			 return $this->redirectBack();
}


public function emailForms(){

$emailfield = new EmailField('Email', '');
$emailfield->setAttribute('placeholder', 'Your Email*');
$emailfield->setAttribute('required', 'required');
$trapfield = new TextField('Time', '');
$trapfield->setAttribute('class', 'unseen');
$action = new FormAction('doEmail', ' ');
$action->setAttribute('id', 'submit_signup');
$action->actionName('Submit');



				
					$form = new Form(
						$this, 'emailForms',
							new FieldList(
								$emailfield,
								$trapfield
 				),
				 new FieldList(
				 	$action),
				 	new RequiredFields('Email')
				 		
				

				 	);
 				
			 return $form;

				
	
	}

public function doEmail($data, $form){

	function sendMail($email, $data){

				  $from = 'donotreply@pondlehocky.com';

    $to = $email;

    $subject = "New Email List Submission";

    $body  = "The following individual is signing up for the mailing list. Check the admin reports section for the latest signups. "."<br/><br/>";
    $body .= "Email: ".$data['Email'] . "<br/> Phone:";


    $email = new Email($from, $to, $subject, $body);

    $email->send();
	}


	if(isset($data['Time']) & $data['Time'] != ''){
			$this->failState();
	}else{
//	sendMail('stauffer@d4creative.com', $data);
	// sendMail('info@pondlehocky.com', $data);
	// sendMail('intake@pondlehocky.com', $data);
	// sendMail('jdonovan@pondlehocky.com', $data);
	// sendMail('asioutis@pondlehocky.com', $data);
//	sendMail('stanfield@d4creative.com', $data);
}
	
	// $email = array();
	// $list =  array();
	// $first = array();
	// $last =  array();
	// $param = array();
	
	// $_POST['email'] = $data['Email'];
	// $_POST['list'] = 'Primary Marketing List';
	// $_POST['first_name'] = 'Website';
	// $_POST['last_name'] = 'Submission';

	// array_push($param, $_POST['email']);
	// array_push($param, $_POST['list']);
	// array_push($param, $_POST['first_name']);
	// array_push($param, $_POST['last_name']);


	//print_r($data);
	//print_r($_POST);
	// print_r($param);

	 //$this->sendToAccount('basic', API_KEY, 'pondlehocky', $_POST['email']);
	//$this->sendToAccount($param);

			
			$form->saveInto($applicationEmail = new EmailHandler());
			$applicationEmail->write();

			return array(
				'ApplicationEmail' => $applicationEmail
				);


			 return $this->redirectBack();






	}

public function tokenForPL($API_KEY){

}

public function sendToAccount($param){

	// $contain = array();

	// foreach($param as $key){
	// 		array_push($contain, $key);
	// }


			$cc = new ConstantContact(OLD_KEY);
			$date = date('Y-m-d\TH:i:s\.000\Z', strtotime("+1 month"));

			$action = "Getting Contact By Email Address";

			try{
				//check to see if the contact exists in the 
				$response = $cc->getContactByEmail(ALTTOKEN, $param[0]);

				//create a new contact if NULL
				if(empty($response->results)){
					$action = "Creating Contaact";
					$contact = new Contact();
					$email = $param[0];
					$contact->addEmail($_POST['email']);
					$contact->addList($param[1]);
					$contact->first_name = $param[2];
					$contact->last_name = 	$param[3];
					// $cc->updateContact->email_addresses = $_POST['email'];

					$returnContact = $cc->addContact(ALTTOKEN, $contact);
					// print_r($param[0]);
				print_r($returnContact);

				} else {
					$action = "Updating Contact";
					$contact = $response->results[0];
					$contact->addList($param[1]);
					$contact->first_name = $param[2];
					$contact->last_name = $param[3];
					// $cc->updateContact->email_addresses = $_POST['email'];
					$returnContact = $cc->updateContact(ALTTOKEN, $contact);
					print_r($returnContact);
				}
			} catch (CtctException $e){

		echo '<span class="label label-important">Error ' . $action . '</span>';
        echo '<div class="container alert-error"><pre class="failure-pre">';
        print_r($e->getErrors());
        echo '</pre></div>';
        die();
			}
}

// public function sendToAccount($authType, $apiKey, $username, $param){
// $consumerSecret = 'f7a900d9e8274457814b28807aed90de';
// //$DatastoreUser = $Datastore->lookupUser($username);
// $Contact = new CC_Contact();
// $contactlist = new CC_List();
// $disabled = null;
// $list = $contactlist->getLists('https://ui.constantcontact.com/rnavmap/em/contacts/browse?listId=81');
// //$allstates = $Contact->getStates();
// //$allcountries = $Contact->getCountries();


//  $_POST['list'] = 'Primary Marketing List';
// // $Contact->emailAddress = $param;
// // $Contact->firstName = 'Website';
// // $Contact->lastName = 'Submission';
// // $Contact->lists = 'Primary Marketing List';
//  $postFields = array();
//  $postFields["email_address"] = $param;
//  $postFields["first_name"] = 'Website';
//  $postFields["last_name"] = 'Submission';
//  $postFields["middle_name"] = '';
//  $postFields["company_name"] = 'Pond LeHocky';
//  $postFields["job_title"]= '';
//  $postFields["home_number"] = '';
//  $postFields["work_number"] = '';
//  $postFields["address_line_1"] = '';
//  $postFields["address_line_2"] = '';
//  $postFields["address_line_3"] = '';
//  $postFields["city_name"] = 'Philadelphia';
//  $postFields["state_code"] = 'PA';
//  // The Code is looking for a State Code For Example TX instead of Texas
//  $postFields["state_name"] = 'Pennsylvania';
//  $postFields["country_code"] = '';
//  $postFields["zip_code"] = '19103';
//  $postFields["sub_zip_code"] = '';
//  $postFields["notes"] = '';
//  $postFields["mail_type"] = "HTML";
//  $postFields["lists"] =  array($_POST['list']);
//  $postFields["id"] = '81';
//  $postFields["custom_fields"] = array();
//                 foreach($_POST as $key => $val) {
                        
//                         if (strncmp($key, 'custom_field_', strlen('custom_field_')) === 0) {
//                                 $postFields["custom_fields"][substr($key, strlen('custom_field_'), strlen($key)-1)] = $val;
//                         }

//                 }

//                  $contactXML = $Contact->createContactXML(null,$postFields);

//                 if (!$Contact->addSubscriber($contactXML)) {
//                         $error = true;
//                 } else {
//                         $error = false;
//                         $_POST = array();
//                 }


// }

public function getDate(){
	 return date('Y');
}

public function getSitemapData(){

	return SitemapPage::get();
}

public function getPrivacyPolicy(){

	return Page::get()->byID(40);
	}
public function getTermsofUse(){

	return Page::get()->byID(41);
	}

	public function MetaTags($includeTitle = true) {
		$tags = "";
		if($includeTitle === true || $includeTitle == 'true') {
			$tags .= "<title>" . $this->Title . "</title>\n";
		}

		// $generator = trim(Config::inst()->get('SiteTree', 'meta_generator'));
		// if (!empty($generator)) {
		// 	$tags .= "<meta name=\"generator\" content=\"" . Convert::raw2att($generator) . "\" />\n";
		// }

		$charset = Config::inst()->get('ContentNegotiator', 'encoding');
		$tags .= "<meta http-equiv=\"Content-type\" content=\"text/html; charset=$charset\" />\n";
		if($this->MetaDescription) {
			$tags .= "<meta name=\"description\" content=\"" . Convert::raw2att($this->MetaDescription) . "\" />\n";
		}
		if($this->ExtraMeta) { 
			$tags .= $this->ExtraMeta . "\n";
		} 
		
		if(Permission::check('CMS_ACCESS_CMSMain') && in_array('CMSPreviewable', class_implements($this)) && !$this instanceof ErrorPage) {
			$tags .= "<meta name=\"x-page-id\" content=\"{$this->ID}\" />\n";
			$tags .= "<meta name=\"x-cms-edit-link\" content=\"" . $this->CMSEditLink() . "\" />\n";
		}

		$this->extend('MetaTags', $tags);

		return $tags;
	}


}

class CaseHandler extends DataObject{


	private static $db = array(

		'CaseName' => 'Text',
		'CaseLast' => 'Text',
		'CaseEmail' => 'Text',
		'CasePhone' => 'Text',
		'CaseWorkersBox' => 'Int',
		'CaseSocialBox' => 'Int',
		'CaseMessage' => 'Text',
		 'HoneePot' => 'Text',
		  'Time' => 'Text'


	);

}


class HandbookHandler extends DataObject{


	private static $db = array(


		'HandName' => 'Text',
		'HandLAst' => 'Text',
		'HandEmail' => 'Text',
		'HandPhone' => 'Text',
		'HandMessage' => 'Text',
		 'HoneePot' => 'Text',
		  'Time' => 'Text'


	);
}


class EmailHandler extends DataObject{


	private static $db = array(


		'Email' => 'Text',
		'HoneePot' => 'Text',
		 'Time' => 'Text'



	);
}

