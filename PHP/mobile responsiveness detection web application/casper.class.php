<?php
ini_set('display_errors',1);  error_reporting(E_ALL);


/*CLASS START */

	class casper{

		public /*.string.*/ $uri;
		public /*.string.*/ $status;
		public /*string.*/ $results;
		public /*.datetime.*/ $timestamp;
		public /*.string.*/ $name;
		public /*.class.*/ $janitor;




		/**
		* consutructor for class, defines global properties
		* @name __construct()
		*/
		public function __construct(){
			$this->uri = "";
			$this->status = "";
			$this->results = "";
			$this->timestamp = Date('Y.m.d');
			$this->janitor = new maintence();

		}


		/**
		* phantomPlz acts as the casper classes main function aka main().
		* @name phantomPlz()
		* @param (url) [string]
		* @return (htmlArray) [array]
		*/

		public function phantomPlz($url){
			$this->uri = $url;
			$name = $this->divviString($this->uri);
			$this->name = $this->timestamp."_".$name;
			$this->mobileSelfie($this->uri, $this->name);
			$this->tabletSelfie($this->uri, $this->name);
			$htmlArray = array( 'html' => '', 'mobile' => '', 'tablet' => '');
			$html = "<div id='website-right'>";
			$html .= "<div class='test-transparency-mobile'>";
			$html .= "<img src='iphone_mock.png'>";
			$html .= "</div>";
			$html .= "<div class='website-transparency-mobile'>";
			$html .= "<img src='img/".$this->name."_mobile.png'></img>";
			$html .= "</div>";
			$html .= "<div class='test-transparency-tablet'>";
			$html .= "<img src='tablet_mock.png'>";
			$html .= "</div>";
			$html .= "<div class='website-transparency-tablet'>";
			$html .= "<img src='img/".$this->name."_tablet.png'></img>";
			$html .= "</div></div>";
			$htmlArray['html'] = $html; 
			$htmlArray['mobile'] = $this->name."_mobile.png";
			$htmlArray['tablet'] = $this->name."_tablet.png";
			return $htmlArray;

		}

		/**
		* checkURI
		* @name checkURI
		* @param (uri)
		* @return [string]
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
				$tp = $tmp[0];
				}
				$tp = substr($tp, 0, -4);
			return $tp;
		}


		/**
		* Call phantomJS to produce a image for the mobile site
		* @name mobileSelfie()
		* @param (uri, name)
		* @return none
		*/

		public function mobileSelfie($uri, $name){
			//echo $uri;
			   $import = array(
              
                        'mobile-pic' => ''
                  );

			
			$name_mobile = $name."_mobile";
			$import['mobile-pic'] = $name_mobile.".png";
			//$this->janitor->appendsProfile($uri, $import, $this->janitor->profilepath."/".$name.".xml");
			exec("../phantomjs/bin/phantomjs ../console/phantom/screenshot.js $uri ../img/$name_mobile.png 174px*288px", $output, $results);
			//print_r($output);
			//echo $results;
		}

		/**
		* refer to mobileSelfie for tableSelfie
		* @name tableSelfie()
		* @param (uri, name)
		* @return none
		*/

		public function tabletSelfie($uri, $name){
			//echo $uri;
			   $import = array(
           
                        'tablet-pic' => ''
                  );

			$name_tablet = $name."_tablet";
			$import['tablet-pic'] = $name_tablet.".png";
			//$this->janitor->appendsProfile($uri, $import, $this->janitor->profilepath."/".$name.".xml");
			exec("../phantomjs/bin/phantomjs ../console/phantom/screenshot.js $uri ../img/$name_tablet.png 570px*373px", $output, $results);
			//print_r($output);
			//echo $results;
		}

	/* CLASS END */

	}