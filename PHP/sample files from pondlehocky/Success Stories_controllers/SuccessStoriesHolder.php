<?php


class SuccessStoriesHolder extends Page{

				private static $db = array(
					'HeaderThreeText' => 'Text'
				);
			
			private static $allowed_children = array(
					'NewsHolder',
					'NewsPage',
					'SuccessStories_AwardsHolder',
					'SuccessStories_ClientReviewsHolder',
					'SuccessStories_VideoTestimonialsHolder',
					'SuccessStories_AwardsEntry',
					'SuccessStories_ClientReviewsEntry',
					'SuccessStories_VideoTestimonialsEntry',
					'SSCRE'


			);

				private static $has_one = array(
					'MyWidgetArea' => 'WidgetArea',
					);

		private static $description = 'Success Stories Section';

		private static $singular_name = 'Success Stories';

				public function getCMSFields(){
					$fields = parent::getCMSFields();
										$fields->addFieldToTab('Root.RightHandRail', new WidgetAreaEditor('MyWidgetArea'));
										$fields->addFieldToTab('Root.Main', new TextField('HeaderThreeText', 'Header Text For Eye Catch Images'), 'Content');
										$fields->removeByName('Content');

				return $fields;
				}

				// public function returnVideoData(){

				// 	return SuccessStoriesVideoTestimonials::get()->filter(

				// 		);
				// }

				public function videoDisplay(){

						return SuccessStories_VideoTestimonialsEntry::get()->sort('RAND()');
				}


		
		 public function clientsQuotes(){ 
		return SuccessStories_ClientReviewsEntry::get()->sort('RAND()');
				
 		}

 		public function getNews(){
 			return NewsPage::get()->filter(
 				array(
 					"Type" => "3"
 					))->sort('CaseAmount', 'DESC')->limit(4);
 			
 		}


}



class SuccessStoriesHolder_Controller extends Page_Controller{

	
					public function init() {
		        		parent::init();
		        		
					}



}




?>