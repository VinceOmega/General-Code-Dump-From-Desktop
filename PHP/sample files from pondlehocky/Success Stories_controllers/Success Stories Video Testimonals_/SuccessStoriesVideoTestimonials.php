<?php

class SuccessStories_VideoTestimonialsEntry extends Page{


				private static $db = array(
				'VideoEmbed' => 'Text',
				'NameOfIndividual' => 'Text',
				'URL' => 'Text',
				'SortOrder' => 'Int',
				'Abstract' => 'Text'
			);


				private static $has_one = array(
			
					'Thumbnail' => 'Image',
				
					);
		
				public function getCMSFields(){
					$fields = parent::getCMSFields();

					$imageField = new UploadField(
								'Thumbnail',
								'Video Thumbnail',
								$this->UploadImage
						);

					$imageField->setAllowedFileCategories('image');
					$imageField->setFolderName("Uploads/profileImages/");
					$imageField->setAllowedMaxFileNumber(1);
					$imageField->setCanAttachExisting(false);
					$fields->addFieldToTab('Root.Main', $imageField, 'Content');
					$fields->addFieldToTab('Root.Main', new TextareaField('Abstract', 'Abstract'), 'Content');
	
					$fields->addFieldToTab('Root.Main', new TextField('VideoEmbed', 'Video Embed'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('NameOfIndividual', 'Name of Individual'), 'Content');
					$fields->addFieldToTab('Root.Main', new TextField('SortOrder', 'Sort Order'), 'Content');
					//$fields->removeByName('Content');

				return $fields;
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

    public function ThumbSized($x=200) {
        return $this->Thumbnail()->setWidth($x);
    }

}




class SuccessStories_VideoTestimonialsEntry_Controller extends Page_Controller{



}



?>