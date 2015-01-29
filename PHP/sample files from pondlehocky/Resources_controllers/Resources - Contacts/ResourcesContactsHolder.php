<?php

class Resources_ContactsHolder extends Page{


			private static $allowed_children = array(
					'Resources_Important_Contacts'

			);


		private static $description = 'Resources Important Contacts Section';

		private static $singular_name = 'Resources Important Contacts Holder';

				public function getCMSFields(){
					$fields = parent::getCMSFields();
					$fields->removeByName('Content');

				return $fields;
				}

}



class Resources_ContactsHolder_Controller extends Page_Controller{



}



?>