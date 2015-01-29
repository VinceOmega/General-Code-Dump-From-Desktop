<?php

class SuccessStories_AwardsHolder extends Page{

				
			
			private static $allowed_children = array(
					'SuccessStories_AwardsEntry'

			);

		private static $description = 'Success Stories Awards Section';

		private static $singular_name = 'Success Stories Awards Holder';

				public function getCMSFields(){
					$fields = parent::getCMSFields();
					$fields->removeByName('Content');
					
				return $fields;
				}

}



class SuccessStories_AwardsHolder_Controller extends Page_Controller{



}

?>