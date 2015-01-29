<?php


class ResourcesHolder extends Page{

				
				private static $db = array(

				'Date' => 'Date',
				'Title of News Article' => 'Text',
				'Description of Article' => 'HTMLText',
				'HeaderThreeText' => 'Text'
			);

				private static $description = 'Resources Section';

				private static $singular_name = 'Resources Section';


				private static $has_one = array(
					'MyWidgetArea' => 'WidgetArea' 
					);
		
				public function getCMSFields(){
					$fields = parent::getCMSFields();

					$tinyMCE_desc = new HtmlEditorField('Description of Article');
				
					$setting = HtmlEditorConfig::get('cms');


					$tinyMCE_desc->Field($setting->set_active());

					$dateField = new DateField('Date');
					$dateField->setConfig('showcalendar', true);
					$fields->addFieldToTab('Root.Main', $dateField, 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('Title of News Article'), 'Content');
					$fields->addFieldToTab('Root.Main', $tinyMCE_desc, 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('HeaderThreeText', 'Header Text For Eye Catch Images'), 'Content');
					$fields->addFieldToTab('Root.RightHandRail', new WidgetAreaEditor('MyWidgetArea'));
										
				

				return $fields;
				}


}



class ResourcesHolder_Controller extends Page_Controller{



}




?>