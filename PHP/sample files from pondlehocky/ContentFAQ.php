<?php

class ContentFAQ extends Page{


				private static $db = array(
				'Short Description' => 'HTMLText',
				'Long Description' => 'HTMLText',
				'Header' => 'HTMLText',
				'Type' => 'Text'

			);
		
				private static $has_one = array(
					'MyWidgetArea'  => 'WidgetArea',
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

					$fields->addFieldToTab('Root.Main', new FileField('Photo'), 'Content');
					//$fields->addFieldToTab('Root.Main', $tinyMCE_short, 'Content');
					$fields->addFieldToTab('Root.Main', new TextareaField('Header'), 'Content');
					$fields->addFieldToTab('Root.Main', new DropdownField('Type', 'Type',
						array(
							'1' => 'Workers Comp',
							'2' => 'Social Security'
							)

						), 'Content');
					//$fields->addFieldToTab('Root.Main', $tinyMCE_long, 'Content');
					$fields->addFieldToTab('Root.RightHandRail', new WidgetAreaEditor('MyWidgetArea'));
					
					//$fields->removeByName('Content');
				return $fields;
				}

}

class ContentFAQ_Controller extends Page_Controller{



}



?>