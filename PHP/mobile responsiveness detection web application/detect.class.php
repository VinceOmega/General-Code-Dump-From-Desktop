<?php
ini_set('display_errors', 1); error_reporting(E_ALL);


/* CLASS START */

	class detect{

		public /*.string.*/ $uri;
		public /*.string.*/ $status;
		public /*.string.*/ $results;
		public /*.class.*/ $janitor;
	




	/**
	* consutructor for class, defines flobal properties
	* @name __construct()
	*/
	public function __construct(){
		 $this->uri = "";
		 $this->status = "";
		 $this->results = array(

		 		'value' => '',
		 		'domain' => '',
		 		'message' => 

		 	);
		 $this->janitor = new maintence();
	}

 	public function detectURL($uri){
 			$nameLoaded = "";
 			$nameChanged = "";
 			$this->uri = $uri;
 			$pattern = '/\A[httpHTTP:\/]{0,7}.?[mMoObBiIlLeE]{1,6}.{1}[a-zA-Z]+.{1}[a-zA-Z]{1,9}\z/';

 			exec("../phantomjs/bin/phantomjs ../console/phantom/redirectsniff.js $uri", $output, $results);
 				foreach($output as $key => $value){
 					$http = trim(substr($value, 0, 6)); $httpcmp = strcmp($http,'http'); //echo "number ".$httpcmp."<br>";
 					$www = trim(substr($value, 0, 5)); $wwwcmp = strcmp($www,'www'); //echo "number ".$wwwcmp."<br>";
 					if( $httpcmp === 0 || $wwwcmp === 0){
 						echo 'ello gurl'; echo $value."<br>";
 						echo "Before divviString ".$this->uri; echo $value."<br>"; 
 										$nameLoaded = $this->janitor->divviString(trim($this->uri)); 
 										$nameChanged = $this->janitor->divviString(trim($value));
 						echo "After divviString ".$nameLoaded; echo $nameChanged."<br>"; 
 										$flag = strcmp($nameLoaded, $nameChanged);
 											if($flag === 0 && preg_match($pattern, $value) === 0){
 				//echo $flag;
 				$this->results['value'] = false;
 				$this->results['domain'] = $value;
 			 	$this->results['message'] =  "Your site doesn't switch at all.";
 				echo $this->results['message'];
 				return $this->results;	
 		
 						}else if($flag != 0 && preg_match($pattern, $value) === 1){
 				// echo $flag;
 				// echo $nameLoaded;
 				// echo $nameChanged;
 				echo preg_match($pattern, $value);
 				
 				$this->results['value'] = true;
 				$this->results['domain'] = $value;
 				$this->results['message'] =  "Your site switches to an mobile domain.
 				";
 				echo $this->results['message'];
 				return $this->results;	

 		
 		
 		
 						} else  {

 				$this->results['value'] = true;
 				$this->results['domain'] = $value;
 				$this->results['message'] = "Although this site didn't switch to a m.domain or anything similar to that, you still had a redirect to another page on your site.";
 				echo $this->results['message'];
 				return $this->results;		
 						}
 					}
 				}
 		
			}

}

/* CLASS END */