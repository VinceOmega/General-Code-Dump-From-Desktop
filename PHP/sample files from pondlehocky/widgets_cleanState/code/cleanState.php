<?php

	class cleanState extends Widget{

			private static $db = array(
				'Header' => 'Varchar(40)',
				'Text' => 'Varchar(400)',
				'LinkText' => 'Varchar(400)'

			);

		private static $description = "Widget used to add text to the sidebar.";

		private static $cmsTitle = "Clean State";

		public function getCMSFields(){

			return new FieldList(



				new TextField('Header', 'Header'),
				new TextareaField("Text", "Text"),
				new TextField("LinkText", "Link")

				);
		}

		public function getLink(){
			return $this->Link;
		}

	}


?>