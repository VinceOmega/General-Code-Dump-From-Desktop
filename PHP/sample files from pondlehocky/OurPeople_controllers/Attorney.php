<?php

class Attorney extends Page{


				private static $db = array(
				'FullName' => 'VARCHAR(100)',
				'FirstNameofAttorney' => 'VARCHAR(50)',
				'LastNameofAttorney' => 'VARCHAR(50)',
				'TypeID' => 'Int',
				'SortOrder' => 'Int',
				'Email' => 'Text',
				'Phone' => 'Text',
				'Linkedin' => 'Text',
				'AreaofPractice' => 'VARCHAR(80)',
				'BioDescription' => 'HTMLText',
				'QuotationEntry' => 'HTMLText',
				'ProfileHeadLineTag' => 'VARCHAR(70)',
				'SecondaryTag' => 'VARCHAR(70)',
				'HeaderThreeText' => 'Text'
			);

				private static $has_one = array(
					'VCF' => 'File',
					'UploadImage' => 'Image',
					'Thumbnail' => 'Image',
					'MobilePic' => 'Image',
					'First Name of Attorney' => 'FirstNameofAttorney',
					'Last Name of Attorney' => 'LastNameofAttorney',
					'Bio Description' => 'BioDescription',
					'Quotation Entry' => 'QuotationEntry',
					'MyWidgetArea' => 'WidgetArea',
					'EducationWidget' => 'WidgetArea'

					);


				/**
				* Is WYSIWYG editing allowed?
				* @var boolean
				*/
				static $allow_wysiwyg_editing = true;



     // function Form() {
     //            $fields = new FieldList(
     //                    new FileField('VCF')
     //            );
     //            $actions = new FieldList(
     //                    new FormAction('doUpload', 'Upload file')
     //            );
   		// 		$validator = new RequiredFields(array('VCF'));

     //            return new Form($this, 'Form', $fields, $actions, $validator);
     //    }

     //    function doUpload($data, $form) {
     //            $file = $data['VCF'];
     //            $content = file_get_contents($file['tmp_name']);
     //            // ... process content
     //    }


				
		
				public function getCMSFields(){
					$fields = parent::getCMSFields();

					$tinyMCE_bio = new HtmlEditorField(
						'BioDescription', 
						'Bio Description',
						'Bio of Attorney goes here.');
					$tinyMCE_quote = new HtmlEditorField(
						'QuotationEntry', 
						'Quotation Entry',
						'Quotation of Attorney goes here.');
					$setting = HtmlEditorConfig::get('cms');


					$tinyMCE_bio->Field( array(
						$setting->set_active(),
						$setting->setOption('browser_spellcheck', true)
						)

						);
					$tinyMCE_quote->Field( array(
						$setting->set_active(),
						$setting->setOption('browser_spellcheck', true)
						)

						);

					$uploadField = UploadField::create('VCF')->setTitle("Upload Your VCF File");
					// $uploadField = new UploadField(
					// 			'VCF',
					// 			'Upload Your VCF File'
								
					// 	);

					$uploadField->getValidator()->allowedExtensions = array('vcf');
					$uploadField->setAllowedMaxFileNumber(1);
					$uploadField->folderName = "Uploads/vcfFiles/";
					$uploadField->setCanAttachExisting(false);
					// $uploadField->setRecord('VCF');
					// $uploadField->saveInto('VCF');

					$imageField = new UploadField(
								'UploadImage',
								'Upload Your Image File',
								$this->UploadImage
						);

					$imageField->setAllowedFileCategories('image');
					$imageField->setFolderName("Uploads/profileImages/");
					$imageField->setAllowedMaxFileNumber(1);
					$imageField->setCanAttachExisting(false);

					$thumbField = new UploadField(
								'Thumbnail',
								'Upload Your Thumbnail Here',
								$this->UploadImage
						);

					$thumbField->setAllowedFileCategories('image');
					$thumbField->setFolderName("Uploads/profileThumb/");
					$thumbField->setAllowedMaxFileNumber(1);
					$thumbField->setCanAttachExisting(false);

					$mobileField = new UploadField(
								'MobilePic',
								'Upload Your Mobile Picture',
								$this->UploadImage
						);

					$mobileField->setAllowedFileCategories('image');
					$mobileField->setFolderName("Uploads/profileMobile/");
					$mobileField->setAllowedMaxFileNumber(1);
					$mobileField->setCanAttachExisting(false);

					$fields->addFieldToTab('Root.Main', new TextField('FullName', 'Full Name'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('FirstNameofAttorney', 'First Name of Attorney'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('LastNameofAttorney', 'Last Name of Attorney'), 'Content');
					$fields->addFieldToTab('Root.Main', new DropdownField('TypeID', 'Type', array(
						'1' => 'Partner',
						 '2' => "PA Worker's Compensation",
						'3' => 'Social Security Disabilty' ,
						'4' => 'General Law' 
						)), 'Content');
					$fields->addFieldToTab('Root.Main', new NumericField('SortOrder', 'Sort Order'), 'Content');
					$fields->addFieldToTab('Root.Main', new EmailField('Email', 'Email'), 'Content');
					$fields->addFieldToTab('Root.Main', new PhoneNumberField('Phone', 'Phone'), 'Content');
					//$fields->addFieldToTab('Root.Media', $this->Form());
					//$fields->addFieldToTab('Root.Media', $uploadField);
					$fields->addFieldToTab('Root.Main', new TextField('Linkedin', 'LinkedIn'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('AreaofPractice', 'Area Of Pratice'), 'Content');
					//$fields->addFieldToTab('Root.Main', new TextField('ProfileHeadLineTag', 'Tag Line'), 'Content');
					//$fields->addFieldToTab('Root.Main', new TextField('SecondaryTag', 'Secondary Tag Line'), 'Content');
					//$fields->addFieldToTab('Root.Main', $tinyMCE_bio, 'Content');
					$fields->addFieldToTab('Root.Media', $imageField);
					$fields->addFieldToTab('Root.Media', $thumbField);
					//$fields->addFieldToTab('Root.Media', $mobileField);
					$fields->addFieldToTab('Root.RightHandRail', new WidgetAreaEditor('MyWidgetArea'));
					$fields->addFieldToTab('Root.Education', new WidgetAreaEditor('EducationWidget'));
					//$fields->addFieldToTab('Root.Main', $tinyMCE_quote, 'Content');
				
					//$fields->removeByName('Content');

					//$fields->addFieldToTab('Root.Main', new TextField('HeaderThreeText', 'Header Text For Eye Catch Images'), 'Content');

				return $fields;
				}


  public function FeaturePhotoCropped($x=140,$y=140) {
        if($this->UploadImage()->exists()) {
            return $this->UploadImage()->CroppedImage($x,$y);
        }
        elseif($this->Parent()->getComponent('DefaultPhoto')->exists()) {
            return $this->Parent()->getComponent('DefaultPhoto')->CroppedImage($x,$y);
        }
        else {
            return false;
        }
    }

	public function NoFeaturePhoto() {
        if($this->UploadImage()->exists() || $this->Parent()->getComponent('DefaultPhoto')->exists()) {
            return false;
        }
        else 
            return true; 
    }

    public function PhotoSized($x, $y) {
        return $this->UploadImage()->setWidth($x)->setHeight($y);
    }




  public function FeatureThumbCropped($x=60,$y=60) {
        if($this->Thumbnail()->exists()) {
            return $this->Thumbnail()->CroppedImage($x,$y);
        }
        elseif($this->Parent()->getComponent('DefaultPhoto')->exists()) {
            return $this->Parent()->getComponent('DefaultPhoto')->CroppedImage($x,$y);
        }
        else {
            return false;
        }
    }

	public function NoFeatureThumb() {
        if($this->Mobile()->exists() || $this->Parent()->getComponent('DefaultPhoto')->exists()) {
            return false;
        }
        else 
            return true; 
    }

    public function ThumbSized($x=151) {
        return $this->Thumbnail()->setWidth($x);
    }


  public function FeatureMobileCropped($x=60,$y=60) {
        if($this->Mobile()->exists()) {
            return $this->Mobile()->CroppedImage($x,$y);
        }
        elseif($this->Parent()->getComponent('DefaultPhoto')->exists()) {
            return $this->Parent()->getComponent('DefaultPhoto')->CroppedImage($x,$y);
        }
        else {
            return false;
        }
    }

	public function NoMobileThumb() {
        if($this->Mobile()->exists() || $this->Parent()->getComponent('DefaultPhoto')->exists()) {
            return false;
        }
        else 
            return true; 
    }

    public function MobileSized($x=151) {
        return $this->Mobile()->setWidth($x);
    }

}

class Attorney_Controller extends Page_Controller{



					public function init() {
		        		parent::init();
		        		
					}

}

class AttorneyPage extends DataObject{

			// private static $has_one = array(
			// 		"TypeID" => ""
			// 	);

}



?>