<?php


class AboutUsHolder extends Page{

				
			private static $db = array(
					'HeaderThreeText' => 'Text'
				);
			
			private static $allowed_children = array(
					'ContentPage'
			);

		private static $description = 'About Us Section';

		private static $singular_name = 'About Us';

		private static $plural_name = 'About All Of Us';

				public function getCMSFields(){
					$fields = parent::getCMSFields();
					$fields->addFieldToTab('Root.Main', new TextField('HeaderThreeText', 'Header Text For Eye Catch Images'), 'Content');
					$fields->removeByName('Content');

				return $fields;
				}

}



class AboutUsHolder_Controller extends Page_Controller{



}




?>