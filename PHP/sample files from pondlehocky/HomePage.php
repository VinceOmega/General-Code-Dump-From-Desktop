<?php
class HomePage extends Page {

	private static $db = array(
	);

	private static $has_one = array(
	);

		public function getCMSFields(){
		
		$fields = parent::getCMSFields();
					
		$fields->removeByName('Content');
		
		return $fields;
				}

		public function returnLawyers($type){
				return Attorney::get()->filter(array(
							"TypeID" => $type
					));
		}

		public function getNews(){
			  return NewsPage::get()->filter(
			  	array(
			  		"Type" => "1",
			  		"ShowOnFeed" => "2"
			  		))->sort('Date', 'DESC');
		}

		public function getBlog(){
			  return BlogEntry::get()->filter(
			  		array(
			  			"ShowOnFeed" => "2"
			  			)
			  	)->sort('Date', 'DESC');
		}

}
class HomePage_Controller extends Page_Controller {

			private static $allowed_actions = array('caseEvaluationForms', 'doActionCase',
	'handbookForms',  'doHandCase', 'emailForms', 'doEmail', 'formContactUs', 'doContacts');

public function init() {
		parent::init();

		// Note: you should use SS template require tags inside your templates 
		// instead of putting Requirements calls here.  However these are 
		// included so that our older themes still work
		Requirements::themedCSS('reset');
		Requirements::themedCSS('layout'); 
		Requirements::themedCSS('typography'); 
		Requirements::themedCSS('form'); 
	}
}