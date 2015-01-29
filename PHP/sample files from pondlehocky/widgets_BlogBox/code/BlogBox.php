<?php

	class BlogBox extends Widget{

			private static $db = array(
					'Header' => 'Text'

			);

		private static $description = 'Blog Feed For Pond';

		private static $cmsTitle = 'Blog Reader'; 

		// public function getCMSFields(){

		// 		return new FieldList(
		// 					new TextField('Header', 'Social Text Header')
		// 			);
		// }

	

	}

	class BlogBox_Controller extends Widget_Controller{
				public function getBlog(){
			return BlogEntry::get();
		}
	}


?>