<?php


class OurPeople extends Page{

				/*Keep the DB vars in, SS breaks if you don't for this page */
				private static $db = array(
				'First Name of Attorney' => 'Text',
				'Last Name of Attorney' => 'Text',
				'Type' => 'Text',
				'Sort Order' => 'Int',
				'Email' => 'Text',
				'Phone' => 'Text',
				'Linkedin' => 'Text',
				'Bio Description' => 'HTMLText',
				'Quotation Entry' => 'HTMLText',
				'HeaderThreeText' => 'Text'
				
			);

				private static $has_one = array(
						'MyWidgetArea' => 'WidgetArea'
					);

					private static $allowed_children = array(
					'Attorney'
			);

		private static $description = 'Displays listing of Pond LeHocky Attornies';

		private static $singular_name = 'Our People';

				public function getCMSFields(){
					$fields = parent::getCMSFields();
					$fields->addFieldToTab('Root.RightHandRail', new WidgetAreaEditor('MyWidgetArea'));
					$fields->addFieldToTab('Root.Main', new TextField('HeaderThreeText', 'Header Text For Eye Catch Images'), 'Content');
					$fields->removeByName('Content');

				return $fields;
				}

				public function displayLawyers($type){
			// 		$sql = new SQLQuery();
			// 	$sql->setFrom('attorney');
			// 	$sql->setSelect('FullName', 'LastNameofAttorney');
			// 	$sql->addWhere("TypeID = '" . $type."'");

			// 	 $rawSQL = $sql->sql();

			// 	// echo $rawSQL;

			// 	$result = $sql->execute()->map();

			// 	// print_r(print_r($result));

			// 	// foreach($result as $value){
			// 	// 	echo $value;
			// 	// }


			// 	switch ($type) {

			// 		case 1:
				
			// 		$field  = new DropdownField('SearchLawyerNamePartner', 'Search Lawyer Name Partner', $result);




			// 		break;
					
			// 		case 2:
						
			// 	$field  = new DropdownField('SearchLawyerNameWorkers', 'Search Lawyer Name Workers', $result);
	
			// 		break;

			// 		case 3:

			// 	$field  = new DropdownField('SearchLawyerNameSocial', 'Search Lawyer Name Social', $result);

			// 		break;

			// 		case 4:

			// 	$field  = new DropdownField('SearchLawyerNameGeneral', 'Search Lawyer Name General', $result);	

			// 		break;
			// 	}
			// return $field;

					
		 		return Attorney::get()->filter(array(

						"TypeID" => $type
						
					))->sort("SortOrder");
		 
		
		}


		public function thumbs4Lawyers($type){

				return Attorney::get()->filter(array(

						"TypeID" => $type
							
					))->sort("SortOrder");

		}
				

}



class OurPeople_Controller extends Page_Controller{



}




?>