<?php

	class WorkersRail extends Widget{

			private static $db = array(
				'Header' => 'Varchar(40)',
				'WorkersText' => 'Varchar(400)'

			);

		private static $description = "Worker's Compenstation Info Box, Allows people to read about worker's compensation.";

		private static $cmsTitle = "Worker's Compenstation Info Box";

		public function getCMSFields(){

			return new FieldList(
				new TextField('Header', 'Workers Text Header'),
				new TextareaField('WorkersText', 'Workers Text Box')

				);
		}

		public function compLink(){
				return ContentPage::get()->filter(array(
					"ID" => 13));
		}

	}

	class WorkersRailWidget extends WidgetController{



		public function init(){


		}
	
		

		
	}


?>