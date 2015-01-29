<?php

class SuccessStories_ClientReviewsHolder extends Page{

				
			
			private static $allowed_children = array(
					'SuccessStories_ClientReviewsEntry',
					'SSCREntry'

			);

		private static $description = 'Success Stories Client Reviews Section';

		private static $singular_name = 'Success Stories Client Reviews Holder';

				public function getCMSFields(){
					$fields = parent::getCMSFields();

					$fields->removeByName('Content');
				return $fields;
				}

}



class SuccessStories_ClientReviewsHolder_Controller extends Page_Controller{


					public function init() {
		        		parent::init();
		        		
					}


}

?>