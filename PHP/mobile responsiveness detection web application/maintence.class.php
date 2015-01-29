<?php
ini_set('display_errors',1);  error_reporting(E_ALL);

	/* CLASS START */

		class maintence {

			public /*.string.*/ $uri;
			public /*.string.*/ $status;
			public /*.string.*/ $results;
			public /*.string.*/ $date;
			public /*.string.*/ $time;
			public /*.string.*/ $filename;
			public /*.string.*/ $imgpath;
			public /*.string.*/ $profilepath;
			public /*.string.*/ $docpath;


		

		/**
		* constructor for class, defines global prooperties
		* @name __construct()
		*/

		public function __construct(){
			$this->uri = "";
			$this->status = "";
			$this->results = "";
			$this->date = Date('Y/m/d');
			$this->time = Date('H:i:s');
			$this->imgpath = '../img';
			$this->profilepath = '../profile';
			$this->docpath = '../doc';
			$this->tags = array(
							'website' => '',
							'date' => '',
							'time' => '',
							'meta' => '',
							'mobile-pic' => '',
							'tablet-pic' => '',
							'redirect' => array(
									'value' => '',
									'domain' => ''
								),
							'document' => ''
					);
		}



		/**
		* This function is to be called once a day at 12:00 AM by
		* a cron job.
		* Maintains the img and profile folder
		* @name mrClean()
		* @param [void]
		* @return [void]
		*/

		public function mrClean(){
				$imgArray = scandir($this->imgpath);
				$profileArray = scandir($this->profilepath);
				$docArray = scandir($this->docpath);
					$this->mrcFileHelper($imgArray);
					$this->mrcFileHelper($profileArray);
					$this->mrcFileHelper($docArray);


				$this->results =  "The filty picker upper has cleaned the img and profile directories of yesterday's mess!";
				return $this->results;
		}

		/**
		* This function is a helper function for mrClean, 
		* @name mrcFileHelper()
		* @param($fileArray) [array]
		* @return [void]
		*/

		public function mrcFileHelper($fileArray){
					foreach($fileArray as $key => $value){
						$value;
					$ext = pathinfo($value, PATHINFO_EXTENSION);
					//echo $ext;
					if($ext === 'png' || $ext === 'xml' || $ext === 'pdf'){

						$date = substr($value, 0 ,10);
						//echo $date; 
						$cmp = new DateTime(str_replace(".", "/", $date));
						$cmp2 = new DateTime($this->date);

						$l = $cmp2->diff($cmp);
						//echo $l->format('%R%a');
							
						if($ext === 'png'){
							if($l->format('%R%a') != "+0"){
								unlink($this->imgpath."/".$value);
								}
							} else if($ext === 'xml'){
							if($l->format('%R%a') != "+0"){
								unlink($this->profilepath."/".$value);
								}
							} else {
							if($l->format('%R%a') != "+0"){
								unlink($this->docpath."/".$value);
								}
							}
						}
					}
			}

		/**
		* Makes Profile of website                      
		* @name makeProfile()
		* @param($uri, $data) [string, 2Darray]
		* @return [void]
		*/


		public function makeProfile($uri, $data){
			
					$date = str_replace("/", ".", $this->date);
					//$time = str_replace(":", ".", $this->time);
					$name = $date."_".$this->divviString($uri);
					$path = $this->profilepath."/".$name.".xml";

					$value = $data['redirect']['value'];
					$domain = $data['redirect']['domain'];

					$xml = <<<xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log SYSTEM "profile.dtd">
<site>
<website>$uri</website>
<date>$this->date</date>
<time>$this->time</time>
<meta>$data[meta]</meta>
<mobile-pic>$data[mobile]</mobile-pic>
<tablet-pic>$data[tablet]</tablet-pic>
<redirect>
<value>$value</value>
<domain>$domain</domain>
</redirect>
<document>$data[document]</document>
</site>
xml;
					$file = fopen($path, "a+");
					fwrite($file, $xml);
					fclose($file);


		}

		/**
		* Reads Profile of website
		* @name readProfile()
		* @param ($uri)
		* @return ($status) [string] (on failure) | ($html) [string] (on success)
		*/

		public function readProfile($uri){
					$date = str_replace("/", ".", $this->date);
					//$time = str_replace(":", ".", $this->time);
					$shortname = $this->divviString($uri);
					$name = $date."_".$this->divviString($uri);
					$path = $this->profilepath."/".$name.".xml";
					$profileArray = scandir($this->profilepath);
					//print_r($profileArray);
					$html = $this->readProfileHelper($profileArray, $shortname);
					return $html;


		}

		/**
		* A helper for the readProfile method
		* because, holy shit...it needs one.
		* @name readProfileHelper()
		* @param ($profileArray) [array]
		* @return ($status) [string] (on failure)
		*/


		public function readProfileHelper($profileArray, $shortname){
			//print_r($profileArray);
			foreach($profileArray as $key => $value){
				// echo $key;
						$ext = pathinfo($value, PATHINFO_EXTENSION);
					//	echo $ext."<br>";
						if($ext === 'xml'){
								$temp = explode("_", $value);
								//echo $temp[1];
								$tp = substr($temp[1], 0 , -4);
								//echo $shortname;
							//	echo $tp."-vs.-".$shortname."||";
								if($shortname === $tp){
						$filedate = substr($value, 0 ,10);
						//echo $filedate;
						$cmp = new DateTime(str_replace(".", "/", $filedate));
						$cmp2 = new DateTime($this->date);

						$l = $cmp2->diff($cmp);
						//echo $l->format('%R%a');
							if( $l->format('%R%a') === "+0" ){
									return $this->xmlReader($this->profilepath."/".$value);
									//echo 'you got this far kid';
										//return $this->status = 1;
										} else {
											//echo $this->profilepath."/".$value;
											unlink($this->profilepath."/".$value);
										}

									} 

									//$files = true;
									return $this->status = 1;
								}

							}

						return $this->status = 0;

					}

		/** 
		* xml reader, also another secondary 
		* helper function for the readProfile
		* function
		* @name xmlReader()
		* @param ($path) [string]
		* @return ($html) [string]
		*/


		public function xmlReader($path){
			//echo $path;
				libxml_use_internal_errors(true);
				$dom = new DOMDocument();
				$dom->loadHTMLFile($path);
				libxml_clear_errors();
				$xp = new DOMXPath($dom);
				$els = $xp->query('//site');
			//	var_dump($els);
				$html = "Seems like you've used our application already today."; 
				$html .= "Here is the information we have on file for you."."<br/>";
					
				// $elements = array();
				// $nodes = array();
					 foreach($els as $elements){
					 	foreach($elements->childNodes as $node){
					 			$html .= "$node->nodeName : $node->nodeValue"."<br/>";
					 		if($node->nodeName === 'redirect'){
					 				foreach($node->childNodes as $sub){
					 						$html .= "$sub->nodeName : $sub->nodeValue"."<br/>";
					 				}
					 		}
					 	}
					 }
				return $html;
			}


		

		/**
		* deletes a profile manually 
		* @name deleteProfile()
		* @param ($uri) [string]
		* @return  ($status) [string]
		*/

		public function deleteProfile($uri){
					$date = str_replace("/", ".", $this->date);
					$time = str_replace(":", ".", $this->time);
					$name = $date."_".$this->divviString($uri);
					$path = $this->profilepath."/".$name.".xml";
					unlink($path);

		}

		/**
		* checkURI
		* @name checkURI
		* @param (uri)  [string]
		* @return (uri) [string]
		*/

		public function checkURI($uri){
			//$test = substr($uri, 0, 7);
			//echo $test;
			if(substr($uri, 0, 7) != "http://"){
				$uri = "http://".$uri;	
			}
			return $uri;
		}

		/**
		* Devide URI into chunks into to make a filename for temp image file
		* @name divviString()
		* @param (uri)
		* @return [string]
		*/

		public function divviString($uri){
		
			$this->uri = $this->checkURI($uri);
			$uri = $this->uri;
			//echo $uri;
			$tmp = explode("www.", $uri);
			//echo sizeof($tmp);
			//echo $this->uri;
			if(sizeof($tmp) < 2){
				$tmp = explode("http://", $uri);
				$tp = $tmp[1];

				}else{
				$tp = $tmp[1];
				}
				$tp = substr($tp, 0, -4);
			return $tp;
	}

}
	/* CLASS END */


?>