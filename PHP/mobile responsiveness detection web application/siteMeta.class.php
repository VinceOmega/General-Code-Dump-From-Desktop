<?php
ini_set('display_errors',1);  error_reporting(E_ALL);


/* CLASS START */

  class siteMeta{
  	public /*.string.*/ $uri;
  	public /*.string.*/ $status;
  	public /*.string.*/ $results;
    public /*.object.*/ $dom;
    public /*.object.*/ $xp;
    public /*.class.*/  $janitor;


  	/**
  	* consutructor for class, defines global properties
  	* @name __construct()
  	*/
  		public function __construct(){
  				$this->uri = "";
  				$this->status = "";
  				$this->results = "";
          $this->dom = "";
          $this->xp = "";
          $this->janitor = new maintence();

  		}

      /**
      * pingMe
      * @name pingMe()
      * @param (url)[string] url of the site the info is going to be sent to
      * @return [html]
      */

  		public function pingMe($url){
  			$this->uri = $url;
  			$curl = curl_init($this->uri);
          if(curl_errno($curl)){
              echo 'Curl error: '.curr_error($curl);
          }
        curl_setopt($curl, CURLOPT_HEADER, true);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
          if(!$data = curl_exec($curl)){
              $this->status = curl_getinfo($curl);
              return $this->status;
          }
          curl_close($curl);

          $this->results = $this->scrapeMe($data);
          return $this->results;
  		}

      /**
      * scrapeMe
      * @name scrapeMe()
      * @param (site)[string] HTML mark up for the site retreived by cURL
      * @return [html]
      */

      public function scrapeMe($site){
          libxml_use_internal_errors(true);
          $this->dom = new DOMDocument();
          $this->dom->loadHTML($site);
          libxml_clear_errors();
          $this->xp = new DOMXPath($this->dom);
          $import = array(
                        'meta' => ''
                  );
          $metaArray = $this->dom->getElementsByTagName('meta');
          $viewportArrayData = array();
              foreach($metaArray as $key => $value){

                $attr = strtolower($value->attributes->item(0)->value);
                if($attr === 'viewport'){
                        $viewport_text = 'Viewport has been found. <br/>';
                        $viewport_text .= 'Here are the settings for the meta tag, Viewport <br/>';
                     $viewportArrayData = $this->parseViewport($value);
                      }
                if($attr === 'mobileoptimized'){
                        $mobileoptimized_text = 'mobile_optimized has been found. <br/>';
                        $mobileoptimized_text .= 'Here are the settings for meta tag, mobileOptimized <br/>';
                        $contentMO = $value->getAttribute('content');                      
                      }
                if($attr === 'handheldfriendly'){
                        $handheldfriendly_text = 'handheldFriendly has been found. <br/>';
                        $handheldfriendly_text .= 'Here are the settings for the meta tag handheldFriendly <br/>';
                      $contentHF = $value->getAttribute('content');
         
                      }
                if($attr === 'apple-mobile-web-app-capable'){
                      $apple_capable_text = 'Apple Meta tag: Web App Capable, has been found. <br/>';
                      $apple_capable_text .= 'Here are the settings for the meta tag, Apple Meta Web App Capable. <br/>';
                      $contentAMWAC = $value->getAttribute('content');
         
                      }

                if($attr === 'apple-mobile-web-app-status'){
                      $apple_status_text = 'Apple Meta tag: Web App Status Box Style, has been found. <br/>';
                      $apple_status_text .= 'Here are the settings for the meta tag, Apple Meta tag: Web App Statu Box Style <br/>';
                      $contentAMWSBS = $value->getAttribute('content');
                     }
                  }
                $html = "<div id='meta-data-container'>";
                $viewportArrayData = array_filter($viewportArrayData);
                
                if(!empty($viewportArrayData)){
                  $html .= "<div class='viewport-data-text'>$viewport_text</div>";
                  $html .= "<ul class='viewport-data-list'>";
                foreach($viewportArrayData as $arraykey => $subarray){
                        $html .= "<li class='viewport-data-attribute-value'>$subarray[attribute] = $subarray[value]</li>";
                       // $html .= "<li class='viewport-data-value'>$</li>";
                    }
                  $html .= "</ul></div>";

                }

                if(isset($contentMO) != null){
                  $html  .= "<div class='mobileopt-data-text'>$mobileoptimized_text</div>";
                  $html .= "<div class='mobileopt-data-content'>$contentMO</div>";
                }

                if(isset($contentHF) != null){
                  $html  .= "<div class='handheld-data-text'>$handheldfriendly_text</div>";
                  $html .= "<div class='handheld-data-content'>$contentHF</div>";
                }

                if(isset($contentAMWAC) != null){
                  $html  .= "<div class='apple-capable-data-text'>$apple_capable_text</div>";
                  $html .= "<div class='apple-capable-data-content'>$contentAMWAC</div>";
                }

                if(isset($contentAMWSBS) != null){
                  $html  .= "<div class='apple-status-data-text'>$apple_status_text</div>";
                  $html .= "<div class='apple-status-data-content'>$contentAMWSBS</div>";
                }

                $html .="</div>";
                $date = str_replace("/", ".", $this->janitor->date);
               // $time = str_replace(":", ".", $this->janitor->time);
                $name = $date."_".$this->janitor->divviString($this->uri);
                $path = $this->janitor->profilepath."/".$name.".xml";
                $import['meta'] = $html;
               // $this->janitor->appendsProfile($this->uri, $import, $path);

                return $html;
            }

      public function parseViewport($data){
          $content = $data->getAttribute('content');
          $temp = explode(",", $content);
          $tp = "";
          $optionsArray = array(

                0 => array(
                  
                    "attribute" => "",
                    "value" => "" 

                  ));
              foreach($temp as $key => $value){
                  $tp .= $value;
                  $tmp = explode(" ", $tp);
                  $i = 0;
                  unset($temp);
                  $k = sizeof($tmp);
                  for($j = 0; $j < $k; $j++){
                      $sml = explode("=", $tmp[$j]);
                      $options[$j]['attribute'] = $sml[0];
                      $options[$j]['value'] = $sml[1];
                  }
              }
            return $options;
          }



  }

/* CLASS END */


?>