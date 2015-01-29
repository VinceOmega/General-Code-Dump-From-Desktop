<?php

class Resources_News_CaseLaw extends Page{


				private static $db = array(

				'Date' => 'Date',
				'Title of News Article' => 'Text',
				'Description of Article' => 'HTMLText',
				'HeaderThreeText' => 'Text'
			);

				private static $has_one = array(
					'MyWidgetArea' => 'WidgetArea' 
					);
		
				public function getCMSFields(){
					$fields = parent::getCMSFields();

				$fields->addFieldToTab('Root.RightHandRail', new WidgetAreaEditor('MyWidgetArea'));
				$fields->addFieldToTab('Root.Main', new TextField('HeaderThreeText', 'Header Text For Eye Catch Images'), 'Content');					
				$fields->removeByName('Content');

				return $fields;
				}

		public function getNews($type){
 			return NewsPage::get()->filter('Type', $type)->sort('Date', 'DESC');
 		}

 		public function getBlogWidget(){
 			return BlogEntry::get();
 		}

 		public function getFAQS(){
 			return Resources_FAQs::get();
 		}


}

class Resources_News_CaseLaw_Controller extends Page_Controller{



}



?>