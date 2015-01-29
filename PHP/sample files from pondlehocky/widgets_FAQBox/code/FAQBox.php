<?php

	class FAQBox extends Widget{

			
			private static $db = array(


			);

		private static $description = 'FAQ Box';

		private static $cmsTitle = 'Displays FAQs'; 

		public function getCMSFields(){
				return new FieldList(
						
					);
		}

	}

	class FAQBox_Controller extends Widget_Controller{

			public function getQuestions(){

					return ContentFAQ::get()->sort('RAND()');
			}

			public function getQuestionsType($type){

					return ContentFAQ::get()->sort('RAND()')->filter(
						array('Type' => $type
						));
			}
	}


?>