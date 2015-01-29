<?php


class PracticeAreasHolder extends Page{

				private static $db = array(
					'HeaderThreeText' => 'Text'
				);
			
			
			private static $allowed_children = array(
					'ContentPage'
			);
			private static $has_one = array(
					'MyWidgetArea' => 'WidgetArea',
				);

		private static $description = 'Practice Area Section';

		private static $singular_name = 'Practice Area Section';


				public function getCMSFields(){
					$fields = parent::getCMSFields();
					$fields->addFieldToTab('Root.RightHandRail', new WidgetAreaEditor('MyWidgetArea'));
					$fields->addFieldToTab('Root.Main', new TextField('HeaderThreeText', 'Header Text For Eye Catch Images'), 'Content');
					$fields->removeByName('Content');
				return $fields;
				}

}



class PracticeAreasHolder_Controller extends Page_Controller{



}




?>