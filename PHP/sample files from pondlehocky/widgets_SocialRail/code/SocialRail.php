<?php

	class SocialRail extends Widget{

			private static $db = array(
				'Header' => 'Varchar(40)',
				'SocialText' => 'Varchar(400)'

			);

		private static $description = 'Social Security Info Box, Allows people to read about SSD, SSDI, SSI.';

		private static $cmsTitle = 'Social Security Info Box';

		public function getCMSFields(){

			return new FieldList(
				new TextField('Header', 'Social Text Header'),
				new TextareaField('SocialText', 'Social Text Box')

				);
		}

	}


?>