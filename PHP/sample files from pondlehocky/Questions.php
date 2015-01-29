<?php
class Questions extends Page {

	private static $description = 'FAQs Content Holder';


	private static $singular_name = 'FAQs Content Holder';

	private static $db = array(
	);

	private static $has_one = array(
		'MyWidgetArea'  => 'WidgetArea'
	);

		public function getCMSFields(){
		
		$fields = parent::getCMSFields();
		$fields->addFieldToTab('Root.RightHandRail', new WidgetAreaEditor('MyWidgetArea'));
		$fields->removeByName('Content');
		
		return $fields;
	

	}


}
class Questions_Controller extends Page_Controller {
 public function init(){
	parent::init();
}


	public function getQuestions($type){
			return ContentFAQ::get()->filter( array(

				'Type' => $type
				));
	}

}