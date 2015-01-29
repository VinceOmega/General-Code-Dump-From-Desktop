<?php

class Resources_FAQs extends Page{


				private static $db = array(
				'Questions Field' => 'Text',
				'Answers Field' => 'HTMLText'
			);
		
				public function getCMSFields(){
					$fields = parent::getCMSFields();

					$tinyMCE_qna = new HtmlEditorField('Answers Field');
				
					$setting = HtmlEditorConfig::get('default');


					$tinyMCE_qna->Field($setting->set_active());

					$fields->addFieldToTab('Root.Main', new TextField('Questions Field'), 'Content');
					$fields->addFieldToTab('Root.Main', $tinyMCE_qna, 'Content');

					$fields->removeByName('Content');

				return $fields;
				}

}

class Resources_FAQs_Controller extends Page_Controller{



}



?>