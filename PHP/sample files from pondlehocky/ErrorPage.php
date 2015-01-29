<?php
class ErrorPage extends Page {

	private static $db = array(
	);

	private static $has_one = array(
	);

		public function getCMSFields(){
		
		$fields = parent::getCMSFields();
					
		$fields->removeByName('Content');
		
		return $fields;
	

}
class ErrorPage_Controller extends Page_Controller {

		private static $allowed_actions = array (
	);

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