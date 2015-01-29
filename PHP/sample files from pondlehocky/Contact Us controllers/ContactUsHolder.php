<?php


class ContactUsHolder extends Page{

				
			
			private static $allowed_children = array(
					'ContactUsOfficeLocationsHolder',
					'Contact_Us_Office_Locations'

			);

		private static $description = 'Contact Us Section';

		private static $singular_name = 'Contact Us';

				public function getCMSFields(){
					$fields = parent::getCMSFields();
					$fields->removeByName('Content');

				return $fields;
				}

}



class ContactUsHolder_Controller extends Page_Controller{
private static $allowed_actions = array('formContactUs', 'doContacts');

	public function init(){
		parent::init();
	}
	public function formContactUs(){
		$name = new TextField('Name', '');
		$name->setAttribute('placeholder', 'Your Name*');
		$name->setAttribute('required', 'required');
		$email = new EmailField('Email', '');
		$email->setAttribute('placeholder', 'Your Email*');
		$email->setAttribute('required', 'required');
		$phone = new PhoneNumberField('Phone', '');
		$phone->setAttribute('placeholder', 'Your Phone*');
		$phone->setAttribute('required', 'required');
		$message = new TextareaField(
			'Message',
			'');
		$message->setAttribute('placeholder', 'Your Message*');
		$message->setAttribute('required', 'required');
		$select = new DropdownField('Reason',
			'', 
			array(
				"" => "How Can We Help You?",
				"1" => "Legal Help",
				"2" => "Customer Service",
				"3" => "Website Issues"
			));
		$trapfield = new TextField('Time', '');
		$trapfield->setAttribute('class', 'unseen');
		$action = new FormAction('doContacts', ' ');
		$action->actionName('Submit');
		$action->setAttribute('id', 'submit_signup');

			$form = new Form(
					$this, 'formContactUs',
						new FieldList(
							$name,
							$email,
							$phone,
							$select,
							$message,
							$trapfield

							),

						new FieldList(
							$action

							),
						new RequiredFields('Name', 'Email', 'Phone', 'Message')







				);

			return $form;
	}

	public function doContacts($data, $form){

		function sendMail($email, $data){
				$form = 'donotreply@pondlehocky.com';
				$to = $email;

				$subject = "New Contact Us Request";

				$body = "Name: ".$data['Name']."<br/>";
				$body .= "Email: ".$data['Email']."<br/>";
				
				$body .= "Contact #: ";
				foreach($data['Phone'] as $key => $value){
				$body .= $value;

					}
				$body .= "<br/>";
				switch($data['Reason']){
				case '1':
				$body .= "Reason : "."Legal Help "."<br/>";
				break;

				case '2':
				$body .= "Reason : "."Customer Service "."<br/>";
				break;

				case '3':
				$body .= "Reason : "."Website Issues "."<br/>";
				break;
				}

				foreach($data['Phone'] as $key => $value){
					$body .= $value;
				}
					$body .= "<br/>"."Your Message: ".$data['Message']."\<br/>";

				$email = new Email($form, $to, $subject, $body);

				$email->send();
			}

			$count = 0;
foreach($data['Phone'] as $key => $value){
	$count = count(str_split($value));
	
}

if($count < 10){
	$this->failState($count);
}

					if(isset($data['Time']) && $data['Time'] != ''){
					$this->failState();
		}else{
				
				// sendMail('stauffer@d4creative.com', $data);
				sendMail('info@pondlehocky.com', $data);
				//sendMail('intake@pondlehocky.com', $data);
				// sendMail('jdonovan@pondlehocky.com', $data);
				// sendMail('asioutis@pondlehocky.com', $data);
				// sendMail('stanfield@d4creative.com', $data);
			}

	
	

			$form->saveInto($applicationContact = new ContactUsHandler());
			$applicationContact->write();

			return array(
				'ApplicationContact' => $applicationContact
				);

			 return $this->redirectBack();

	}



}

class ContactUsHandler extends DataObject{

		private static $db = array(
			'Name' => 'Text',
			'Email' => 'Text',
			'Phone' => 'Text',
			'Message' => 'Text',
			'Reason' => 'Text',
			'Time' => 'Text'
			);
}




?>