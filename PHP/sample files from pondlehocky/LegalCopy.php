<?php

class LegalCopy extends Page{


				private static $db = array(
				

			);
		

				public function getCMSFields(){
					$fields = parent::getCMSFields();

					//$tinyMCE_short = new HtmlEditorField('Header');
					//$tinyMCE_short->saveInto($this->ShortDescription);
					//$tinyMCE_long = new HtmlEditorField('Long Description');
					// $setting = HtmlEditorConfig::get('cms');
					// // $setting->get('cms')
					// $tinyMCE_short->Field($setting->set_active(),
					// 	$setting->removeButtons('advcode', 'visualaid')
					// 	);
					//$tinyMCE_long->Field($setting->set_active());

					// $fields->addFieldToTab('Root.Main', new FileField('Photo'), 'Content');
					//$fields->addFieldToTab('Root.Main', $tinyMCE_short, 'Content');
					// $fields->addFieldToTab('Root.Main', new TextareaField('Header'), 'Content');
					//$fields->addFieldToTab('Root.Main', $tinyMCE_long, 'Content');
	
					//$fields->removeByName('Content');
				return $fields;
				}

}

class LegalCopy_Controller extends Page_Controller{



}



?>