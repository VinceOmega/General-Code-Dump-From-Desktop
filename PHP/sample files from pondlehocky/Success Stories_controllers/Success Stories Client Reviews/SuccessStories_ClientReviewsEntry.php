<?php

class SuccessStories_ClientReviewsEntry extends Page{


				private static $db = array(
				'TestimonialText' => 'HTMLText',
				'NameOfIndividual' => 'Text',
				'SortOrder' => 'Int',
				'Abstract' => 'Text'
			);

				private static $description = "Client Review Entry";

				private static $singular_name = "Success Stories Client Review Entry";
		
				public function getCMSFields(){
					$fields = parent::getCMSFields();

					// $tinyMCE_testText = new HtmlEditorField('Testimonial Text');
				
					// $setting = HtmlEditorConfig::get('cms');


					// $tinyMCE_testText->Field($setting->set_active());

					//$fields->addFieldToTab('Root.Main', $tinyMCE_testText, 'Content');
					$fields->addFieldToTab('Root.Main', new TextareaField('Abstract', 'Abstract'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('NameOfIndividual', 'Name of Individual'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('SortOrder', 'Sort Order'), 'Content');
				
					$fields->removeByName('Content');

				return $fields;
				}

}

class SuccessStories_ClientReviewsEntry_Controller extends Page_Controller{


					public function init() {
		        		parent::init();
		        		
					}


}

class SuccessStories_ClientReviewsDataObject extends DataObject{


}



?>