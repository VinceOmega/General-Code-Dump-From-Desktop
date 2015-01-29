<?php

class ContentPage extends Page{


				private static $db = array(
				'Short Description' => 'HTMLText',
				'Long Description' => 'HTMLText',
				'Header' => 'HTMLText',
				'HeaderThreeText' => 'Text'

			);
		
				private static $has_one = array(
					'MyWidgetArea' => 'WidgetArea',
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
					$fields->addFieldToTab('Root.Main', new TextareaField('Header', 'Intro Text'), 'Content');
					//$fields->addFieldToTab('Root.Main', $tinyMCE_long, 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('HeaderThreeText', 'Header Text For Eye Catch Images'), 'Content');
					$fields->addFieldToTab('Root.RightHandRail', new WidgetAreaEditor('MyWidgetArea'));
					
					//$fields->removeByName('Content');
				return $fields;
				}

}

class ContentPage_Controller extends Page_Controller{



}



?>