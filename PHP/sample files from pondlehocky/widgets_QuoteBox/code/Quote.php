<?php

	class Quote extends Widget{

			private static $db = array(
				'Header' => 'Varchar(80)'

			);

			static $has_one = array(

					'Quote' => 'Quotes'
				);

		private static $description = 'Quotes from Clients';

		private static $cmsTitle = 'Testimonal Widget';



		

		public function getCMSFields(){

			return new FieldList(
				new TextField('Header', 'Quotes Box Text Header')


				);
		 }

		  public function clientsQuotes(){ 

		  	$quotes = SuccessStories_ClientReviewsEntry::get()->sort('RAND()');
		  	$quotes->limit(10);
		  	// foreach ($quotes as $key => $value) {
		  	// 	$value;
		  	// }
		  	return $quotes;
		  	//print_r($quotes->database_fields);

		 // 	$sql = new SQLQuery();
		 // 	$sql->setFrom('SuccessStories_ClientReviewsEntry');
		 // 	$sql->setSelect('SortOrder','NameOfIndividual');

		 // // 	$raw = $sql->sql();
		 // // return	 $raw;

		 // 	  $results = $sql->execute()->map();
	
		 	 
		 // 	 foreach($results as $key => $value){
		 // 	 		echo	"<span".$value."><p> ".$key.$value." </p></span>";
		 // 	 }
 		// }
		
	}
	
}



?>