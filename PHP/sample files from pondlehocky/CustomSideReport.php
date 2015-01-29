<?php

	class CustomSideReport_EmailSignups extends SS_Report{

		// public function init(){
		// 	parent::init();
		// }


		 public function title(){
		 		return 'Email Signups';
		 }


		public function sourceRecords($params, $sort, $limit){
				return EmailHandler::get()->sort("Email");
		}

		public function columns(){


			return array(
					 "Email" => array("NestedTitle", array("2")),
				);

		}

		

	}


	class CustomSideReport_CaseEvaluation extends SS_Report{

		// public function init(){
		// 	parent::init();
		// }


		 public function title(){
		 		return 'Case Evaluation Submissions';
		 }


		public function sourceRecords($params, $sort, $limit){
				return CaseHandler::get()->sort("CaseEmail");
		}

		public function columns(){


			return array(
				 "CaseName" => array("NestedTitle", array("2")),
				 "CaseEmail" => array("NestedTitle", array("2")),
				"CasePhone" => array("NestedTitle", array("2")),
				 "CaseWorkersBox" => array("NestedTitle", array("2")),
				  "CaseSocialBox" => array("NestedTitle", array("2")),
				   "CaseMessage" => array("NestedTitle", array("2"))
				);

		}

		

	}


	class CustomSideReport_HandbookSignups extends SS_Report{

		// public function init(){
		// 	parent::init();
		// }


		 public function title(){
		 		return 'Handbook Signups';
		 }


		public function sourceRecords($params, $sort, $limit){
				return HandbookHandler::get()->sort("HandEmail");
		}

		public function columns(){


			return array(
					 "HandName" => array("NestedTitle", array("2")),
					 "HandEmail" => array("NestedTitle", array("2")),
					 "HandPhone" => array("NestedTitle", array("2")),
					 "HandMessage" => array("NestedTitle", array("2"))



				);

		}

		

	}

	class CustomSideReport_ContactUSForm extends SS_Report{

		public function title(){
			 return 'Contact Us Form';
		}

		public function sourceRecords($params, $sort, $limit){
			return ContactUsHandler::get()->sort("Email");
		}

		public function columns(){

				return array(
						"Name" => array("NestedTitle", array("2")),
						"Email" => array("NestedTitle", array("2")),
						"Phone" => array("NestedTitle", array("2")),
						"Message" => array("NestedTitle", array("2")),
						"Reason" => array("NestedTtile", array("2"))
					);
			}
	}




?>