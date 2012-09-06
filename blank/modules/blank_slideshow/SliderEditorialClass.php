<?php
/*
* Blank&White
* Copyright 2012: Oliveta <oliveta@gmail.com>
* Source: http://leben.cz/blank
*/

class	SliderEditorialClass extends ObjectModel
{
	/** @var integer editorial id*/
	protected $maxImageSize = 307200;
	protected $maxImageWidth = 680;
	protected $maxImageHeight = 310;
	public		$id;
	
	/** @var string body_title*/
	public		$body_home_logo_link;

	/** @var string body_title*/
	public		$body_title;

	/** @var string body_title*/
	public		$body_subheading;

	/** @var string body_title*/
	public		$body_paragraph;

	/** @var string body_title*/
	public		$body_logo_subheading;
	public		$slider_active;
	public		$body_home_logo;
	
	public $errors;
	protected 	$table = 'blank_slideshow';
	protected 	$identifier = 'id_editorial';
	

	protected 	$fieldsValidateLang = array(
		'body_title' => 'isGenericName',
		'body_home_logo_link'=>'isUrl',
		'body_subheading' => 'isGenericName',
		'body_paragraph' => 'isCleanHtml',
		'body_logo_subheading' => 'isGenericName');
	
	/**
	  * Check then return multilingual fields for database interaction
	  *
	  * @return array Multilingual fields
	  */
	  
	 public function _delete()
	 {
		Db::getInstance()->Execute('DELETE from `'._DB_PREFIX_.$this->table.'_lang` where id_editorial="'.$this->id.'"');
        Db::getInstance()->Execute('DELETE from `'._DB_PREFIX_.$this->table.'` where id_editorial="'.$this->id.'"');
		if (strpos($this->body_home_logo,".")>0)
		{
		
		$name=substr($this->body_home_logo,0,strpos($this->body_home_logo,"."));
		
		$t=1;
		foreach(glob(dirname(__FILE__).'/img/'.$name.'.*') as $fn) { 
        $t*=unlink($fn); 
        
        }
        if (!$t)
        {
        $this->errors.=Tools::displayError('An error occurred and the slider image was not deleted.');
        }
        } 	
		
	 unset($this);
	 }
	 
	 public function __construct($id = NULL, $id_lang = NULL)
	{
		global $cookie;
		if ((int)$id!=0)
		{
		$rows=Db::getInstance()->ExecuteS('SELECT * from `'._DB_PREFIX_.$this->table.'_lang` as t1,`'._DB_PREFIX_.$this->table.'` as t2 where t2.id_editorial=t1.id_editorial and t2.id_editorial="'.$id.'"');
		if ($rows)
		{
		foreach ($rows as $row)
		{
		$t=$row;
		$this->id=$id;
		$this->body_title[$t['id_lang']]=$t['body_title'];
		$this->body_subheading[$t['id_lang']]=$t['body_subheading'];
		$this->body_paragraph[$t['id_lang']]=$t['body_paragraph'];
		$this->body_logo_subheading[$t['id_lang']]=$t['body_logo_subheading'];
		$this->body_home_logo_link[$t['id_lang']]=$t['body_home_logo_link'];
		$this->body_home_logo=$t['body_home_logo'];
		$this->slider_active=$t['slider_active'];
		}
		}
		}
	} 
	public function getTranslationsFieldsChild()
	{
		parent::validateFieldsLang();

		$fieldsArray = array('body_title', 'body_subheading', 'body_paragraph', 'body_logo_subheading','body_home_logo_link');
		$fields = array();
		$languages = Language::getLanguages(false);
		$defaultLanguage = (int)(Configuration::get('PS_LANG_DEFAULT'));
		foreach ($languages as $language)
		{
			$fields[$language['id_lang']]['id_lang'] = (int)($language['id_lang']);
			$fields[$language['id_lang']][$this->identifier] = (int)($this->id);
			foreach ($fieldsArray as $field)
			{
				if (!Validate::isTableOrIdentifier($field))
					die(Tools::displayError());
				if (isset($this->{$field}[$language['id_lang']]) AND !empty($this->{$field}[$language['id_lang']]))
					$fields[$language['id_lang']][$field] = pSQL($this->{$field}[$language['id_lang']], true);
				elseif (in_array($field, $this->fieldsRequiredLang))
					$fields[$language['id_lang']][$field] = pSQL($this->{$field}[$defaultLanguage], true);
				else
					$fields[$language['id_lang']][$field] = '';
			}
		}
		return $fields;
	}
	
	public function copyFromPost()
	{
		/* Classical fields */
		foreach ($_POST AS $key => $value)
			if (key_exists($key, $this) AND $key != 'id_'.$this->table)
				$this->{$key} = $value;

		/* Multilingual fields */
		if (sizeof($this->fieldsValidateLang))
		{
			$languages = Language::getLanguages(false);
			foreach ($languages AS $language)
				foreach ($this->fieldsValidateLang AS $field => $validation)
					if (isset($_POST[$field.'_'.(int)($language['id_lang'])]))
						$this->{$field}[(int)($language['id_lang'])] = $_POST[$field.'_'.(int)($language['id_lang'])];
		}
	}
	
	public function getFields()
	{
		parent::validateFields();
		$fields['body_home_logo'] = $this->body_home_logo;
		$fields['slider_active'] = $this->slider_active;
		return $fields;
	}
	
	public function extension($filename) 
	{ 
		$filename = strtolower($filename) ; 
		$exts = split("[/\\.]", $filename) ; 
		$n = count($exts)-1; 
		$exts = $exts[$n]; 
		return $exts; 
	} 

public function eraseImage()
	{
	
	if (!file_exists(dirname(__FILE__).'/img/'.$this->body_home_logo))
				$this->errors .=Tools::displayError('This action cannot be taken.');
			else
			{
				unlink(dirname(__FILE__).'/img/'.$this->body_home_logo);
			}
	
	return 0;
	}
	
	public function addImage()
	{

	if (isset($_FILES['body_homepage_logo']) AND isset($_FILES['body_homepage_logo']['tmp_name']) AND !empty($_FILES['body_homepage_logo']['tmp_name']))
			{
			$name="homepage_logo_".$this->id.".".$this->extension(basename($_FILES['body_homepage_logo']['name']));	
				$name1="homepage_logo_".$this->id;
				$t=1;
		foreach(glob(dirname(__FILE__).'/img/'.$name1.'.*') as $fn) { 
        $t*=unlink($fn); 
        } 
				
					if (!$t) {
					$this->errors .= Tools::displayError('An error occurred during the image upload.');
					return false;}
					
				if ($error = checkImage($_FILES['body_homepage_logo'], $this->maxImageSize)){
					$this->errors .= $error; return false;}
				elseif (!$tmpName = tempnam(_PS_TMP_IMG_DIR_, 'PS') OR !move_uploaded_file($_FILES['body_homepage_logo']['tmp_name'], $tmpName)) {
					$this->errors .= Tools::displayError('An error occurred during the image upload.');return false;}
				else
				{
				
				list($width,$height,$t,$s)=getimagesize($tmpName);
				
				$q1=$this->maxImageWidth/$width;
				$q2=$this->maxImageHeight/$height;
				
				if ($q1>$q2 && $q1<1) $t=imageResize($tmpName, dirname(__FILE__).'/img/'.$name,$this->maxImageWidth,null);
				elseif ($q2<1) $t=imageResize($tmpName, dirname(__FILE__).'/img/'.$name,null,$this->maxImageHeight);
				else $t=imageResize($tmpName, dirname(__FILE__).'/img/'.$name,$this->maxImageWidth,$this->maxImageHeight);
				if (!$t)
					{$this->errors .= Tools::displayError('An error occurred during the image upload.');return false;}
				}
				if (isset($tmpName))
					unlink($tmpName);
			if (file_exists(dirname(__FILE__).'/img/'.$name))
			{
			
				Db::getInstance()->ExecuteS('UPDATE  `'._DB_PREFIX_.$this->table.'` set `body_home_logo`="'.$name.'" where id_editorial="'.$this->id.'"');
		
			}
				
			
			}
		else 	
	    $this->errors .= Tools::displayError('The image cannot be uploaded.');
	}
}
