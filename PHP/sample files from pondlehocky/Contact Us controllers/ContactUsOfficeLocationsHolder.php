<?php


class ContactUsOfficeLocationsHolder extends Page{

				
			
			private static $allowed_children = array(
					'Contact_Us_Office_Locations'
			);

		private static $description = 'Contact Us Office Locations Holder';

		private static $singular_name = 'Office Locations Section Holder';

				public function getCMSFields(){
					$fields = parent::getCMSFields();
					$fields->removeByName('Content');

				return $fields;
				}

}



class ContactUsOfficeLocationsHolder_Controller extends Page_Controller{



}




?>