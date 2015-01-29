<?php

class Resources_FAQsHolder extends Page{


		

		private static $description = 'Resources FAQs Section';

		private static $singular_name = 'Resources FAQs Holder';

				public function getCMSFields(){
					$fields = parent::getCMSFields();
					$fields->removeByName('Content');

				return $fields;
				}

}



class Resources_FAQsHolder_Controller extends Page_Controller{



}



?>