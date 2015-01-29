<?php

class SuccessStories_AwardsEntry extends Page{


				private static $db = array(
				'AwardName' => 'Text',
				'AwardGraphic' => 'Text',
				'URL' => 'Text',
				'SortOrder' => 'Int'
			);
		
				public function getCMSFields(){
					$fields = parent::getCMSFields();

					$fields->addFieldToTab('Root.Main', new TextField('AwardName' , 'Award Name'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('AwardGraphic', 'Award Graphic'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('URL'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('SortOrder', 'Sort Order'), 'Content');
					$fields->removeByName('Content');

				return $fields;
				}

}

class SuccessStories_AwardsEntry_Controller extends Page_Controller{



}



?>