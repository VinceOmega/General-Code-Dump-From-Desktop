<?php

class SuccessStories_VideoTestimonialsHolder extends Page{

				
			
			private static $allowed_children = array(
					'SuccessStories_VideoTestimonialsEntry'

			);

		private static $description = 'Success Stories Video Testimonial Section';

		private static $singular_name = 'Success Stories Video Testimonial Holder';

				public function getCMSFields(){
					$fields = parent::getCMSFields();

				return $fields;
				}

}



class SuccessStories_VideoTestimonialsHolder_Controller extends Page_Controller{



}

?>