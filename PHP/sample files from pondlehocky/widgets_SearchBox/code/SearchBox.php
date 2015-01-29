<?php

	class SearchBox extends Widget{

			private static $db = array(
				'Header' => 'Varchar(40)',
				'FirstLine' => 'Varchar(60)',
				'LastLine' => 'Varchar(60)'

			);

			static $has_one = array(
					'LawyerNameList' => 'LawyerName'
				);

		private static $description = 'Search For Laywer by Practice';

		private static $cmsTitle = 'Search Box';

		// public function getCMSFields(){

		// 	return new FieldList(
		// 		new TextField('Header', 'Search Box Text Header'),
		// 		new TextField('FirstLine', 'First Line Text Box'),
		// 		new TextField('LastLine', 'Second Line Text Box')


		// 		);
		// }

		// public function getPartner(){
		// 	$partners =	DataObject::get('OurPeople', )
		// }

// 		public function getLawyers(){
// 		// $lawyers =  DataObject::get('Attorney')->filter(array(
// 		// 			'TypeID' => 'Partner'
					
// 		// 	 ));
// 		// return $lawyers;
// }

		 public function getChildren($type){ 



		 		return Attorney::get()->filter(array(

						"TypeID" => $type
					))->sort('LastNameofAttorney', 'ASC');



		
 		}


		 public function clientsQuotes(){ 

		 
		 	$sql = new SQLQuery();
		 	$sql->setFrom('SuccessStories_ClientReviewsEntry');
		 	$sql->setSelect('SortOrder','NameOfIndividual');

		 	$raw = $sql->sql();
		  return	 $raw;

		 	 // $results = $sql->execute()->map();
	
		 	 //return $results;
 		}

 




	}

	class SearchBoxWidget extends WidgetController{



		// return new FieldList(
		// 		foreach($laywers as $key => $value){
		// 			new DropdownField('LawyerNameList', 'LawyerName');
		// 		}
			
			// foreach($lawyers as $lawyer){
			// 	echo "<option value='$LinkingMode'>$lawyer</option>";
			// }

		public function init(){


		}
	
		

		
	}


?>