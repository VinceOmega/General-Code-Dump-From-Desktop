<?php

class Resources_Important_Contacts extends Page{


				private static $db = array(

				'Name of Location' => 'Text',
				'Mailing Address' => 'Text',
				'Phone Number' => 'Text',
				'Email Address' => 'Text'
			);
		
				public function getCMSFields(){
					$fields = parent::getCMSFields();

					$phone = new PhoneNumberField('Phone Number');
					$phone->validate(true);

					$email = new EmailField('Email Address');
					$email->validate(true);

					$fields->addFieldToTab('Root.Main', new TextField('Name of Location'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextareaField('Mailing Address'), 'Content');
					$fields->addFieldToTab('Root.Main', $phone, 'Content');
					$fields->addFieldToTab('Root.Main', $email, 'Content');
			
					$fields->removeByName('Content');
				
					
				return $fields;
				}

}

class Resources_Important_Contacts_Controller extends Page_Controller{



}



?>