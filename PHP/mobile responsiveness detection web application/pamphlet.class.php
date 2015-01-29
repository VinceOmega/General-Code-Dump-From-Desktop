<?php
ini_set('display_errors',1);  error_reporting(E_ALL);
ob_start();
/* CLASS START */

		class pamphlet{

			public /*.string.*/ $uri;
			public /*.string.*/ $status;
			public /*.string.*/ $results;
			public /*.string.*/ $timestamp;
			public /*.string.*/ $pdf;
			public /*.class.*/ $janitor;
			public /*.class.*/ $name;
			public /*.string.*/ $lorem;



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
				$this->lorem = <<<lorem
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin bibendum sagittis sagittis. Nam at libero quis ex molestie semper. Donec viverra gravida elit vitae cursus. Morbi tristique risus et porttitor finibus. Sed tellus mi, ultricies et massa quis, rutrum accumsan nisl. Mauris fringilla ligula at tempor scelerisque. Suspendisse bibendum lacus in maximus aliquam. Etiam id turpis placerat, vestibulum dolor eu, sagittis erat. Cras malesuada tincidunt volutpat. Nulla eget bibendum lectus, a efficitur felis. Vestibulum ut feugiat velit. Suspendisse diam justo, dictum nec enim quis, ornare egestas dolor.

Aliquam erat volutpat. Curabitur pharetra aliquet maximus. Fusce luctus imperdiet libero id dapibus. Etiam turpis nisi, ornare vel ultricies ac, venenatis nec quam. Nullam vitae felis lacus. In auctor purus eleifend magna maximus accumsan. Donec pretium et orci quis gravida.				
lorem;
			}


			/**
			* set up an instance of tcpdf
			* @name create()
			* @param (url) (data) (author) [string] [array] [string]
			* @return (status) [string, on failure] 
			*/
			public function create($uri, $data, $author){
				$this->name = $this->janitor->divviString($uri);
				$title = "Your mobile readiness results, from D4";
				$this->pdf = new TCPDF('L', 'mm', 'A4', true, 'UTF-8', false, false);
				$this->pdf->SetCreator(PDF_CREATOR);
				$this->pdf->SetAuthor($author);
				$this->pdf->SetTitle($this->name);
				$this->pdf->SetSubject();
				$this->pdf->SetKeywords("mobile, results, seo, web, progressive, practices");
				$this->pdf->SetHeaderData('tcpdf_logo.jpg', '100', $title, '');
				$this->pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
				$this->pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));
				$this->pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
				$this->pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
				$this->pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
				$this->pdf->SetFooterMargin(PDF_MARGIN_FOOTER);
				$this->pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
				$this->pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
				$this->pdf->SetFont('helvetica', 'B', 20);
				$this->makeContent($data, $author);

			}

			/**
			* create content for the pamphlet
			* @name makeContent()
			* @param (data) [array] (author) [string]
			* @return (status) [string, on failure]
			*/
			public function makeContent($data, $author){
				$this->pdf->AddPage();
				$this->pdf->Write(0, 'Results', '', 0, 'L', true, 0, false, false, 0);
				$tbl = <<<TBL
<table cellspacing="0"	cellpadding="1" border="
1">
	<tr>
		<td colspan="4"><img src="../gfx/d4_logo_main.png"></td>
		<td colspan="16">$this->name</td>
	<tr>
	<tr>
		<td colspan="4">$this->lorem</td>
		<td colspan="8">
		<div id="top-middle-col">
			<div class="test-transparency-mobile">
				<img src="iphone_mock.png">
			</div>
			<div class="website-transparency-mobile">
				<img src="img/$data[mobile]"></img>
			</div>
			<div class="test-transparency-tablet">
				<img src="tablet_mock.png">
			</div>
			<div class="website-transparency-tablet">
				<img src="img/$data[tablet]"</img>
			</div>
		</div>
		<div id="bottom-middle-col">
		</div>
		</td>
		<td colspan="4">$this->lorem</td>




</table>		
TBL;

$this->pdf->writeHTML($tbl, true, false, false, false, '');

ob_flush();
ob_end_clean();
$this->pdf->Output('../doc/'.$this->timestamp.'_'.$this->name);
$this->pdf->Close();

			}



			
		}
		

/* CLASS END */

?>