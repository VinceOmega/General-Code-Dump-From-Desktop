<?php

	class PartnerBox extends Widget{

			private static $db = array(
				'Education' => 'Varchar(100)',
				'Education2' => 'Varchar(100)',
				'MemberOne' => 'Varchar(100)',
				'MemberTwo' => 'Varchar(100)',
				'MemberThree' => 'Varchar(100)',
				'MemberFour' => 'Varchar(100)',
				'MemberFive' => 'Varchar(100)',
				'MemberSix' => 'Varchar(100)',
				'MemberSeven' => 'Varchar(100)',
				'MemberEight' => 'Varchar(100)',
				'MemberNine' => 'Varchar(100)',
				'MemberTen' => 'Varchar(100)',
				'MemberEleven' => 'Varchar(100)',
				'MemberTwelve' => 'Varchar(100)',
				'MemberThirteen' => 'Varchar(100)',
				'MemberFourteen' => 'Varchar(100)',
				'MemberFifthteen' => 'Varchar(100)',
				'MemberSixteen' => 'Varchar(100)',
				'MemberSeventeen' => 'Varchar(100)',
				'MemberEighteen' => 'Varchar(100)',
				'MemberNineteen' => 'Varchar(100)',
				'MemberTwenty' => 'Varchar(100)',


			);

		private static $description = 'Use this widget to display your credentials on your bio';

		private static $cmsTitle = 'Education'; 

		public function getCMSFields(){

			return new FieldList(
				new TextField('Education', 'Education Description'),
				new TextField('Education2', 'Education Description (2nd Line'),
				new TextField('MemberOne', 'Member Listing One'),
				new TextField('MemberTwo', 'Member Listing Two'),
				new TextField('MemberThree', 'Member Listing Three'),
				new TextField('MemberFour', 'Member Listing Four'),
				new TextField('MemberFive', 'Member Listing Five'),
				new TextField('MemberSix', 'Mebmer Listing Six'),
				new TextField('MemberSeven', 'Member Listing Seven'),
				new TextField('MemberEight', 'Member Listing Eight'),
				new TextField('MemberNine', 'Member Listing Nine'),
				new TextField('MemberTen', 'Member Listing Ten'),
				new TextField('MemberEleven', 'Member Listing Eleven'),
				new TextField('MemberTwelve', 'Member Listing Twelve'),
				new TextField('MemberThirteen', 'Member Listing Thirteen'),
				new TextField('MemberFourteen', 'Member Listing Fourteen'),
				new TextField('MemberFifthteen', 'Member Listing Fifthteen'),
				new TextField('MemberSixteen', 'Member Listing Sixteen'),
				new TextField('MemberSeventeen', 'Member Listing Seventeen'),
				new TextField('MemberEighteen', 'Member Listing Eighteen'),
				new TextField('MemberNineteen', 'Member Listing Nineteen'),
				new TextField('MemberTwenty', 'Member Listing Twenty')

				);
		}

	}


?>