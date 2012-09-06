<?php
/*
* The patterns used in the module BLANK_BANNERS are from Evan Eckard and his DinPattern.
*/
if (!defined('_CAN_LOAD_FILES_'))
	exit;

class blank_banners extends Module
{
	/** @var max image size */
	protected $maxImageSize = 307200;

	public function __construct()
	{
		$this->name = 'blank_banners';
		$this->tab = 'front_office_features';
		$this->version = '0.1';
		$this->author = 'Oliveta';
		$this->need_instance = 0;
		
		parent::__construct();

		$this->displayName = $this->l('Blank banner');
		$this->description = $this->l('Adds  banners on the right of the page');
		$path = dirname(__FILE__);
		if (strpos(__FILE__, 'Module.php') !== false)
			$path .= '/../modules/'.$this->name;
			include_once($path.'/BannersClass.php');
		}

	public function install()
	{
	
		if (!parent::install() OR !$this->registerHook('rightColumn') OR !$this->registerHook('header'))
			return false;
		
		if (!Db::getInstance()->Execute('
		CREATE TABLE `'._DB_PREFIX_.'banners` (
		`id_banners` int(10) unsigned NOT NULL auto_increment,
		`id_category` varchar(30)  NOT NULL,
		`transition` varchar(100)  NOT NULL,
	    `style` text NOT NULL,
		PRIMARY KEY (`id_banners`))
		ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8'))
			return false;
			
		if (!Db::getInstance()->Execute('
		CREATE TABLE `'._DB_PREFIX_.'banners_lang` (
		`id_banners` int(10) unsigned NOT NULL,
		`id_lang` int(10) unsigned NOT NULL,
		`text` text NOT NULL,
		`name` varchar(255) NOT NULL,
		`active` int(2) unsigned NOT NULL,
		PRIMARY KEY (`id_banners`,`id_lang`))
		ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8'))
			return false;
		
		
		
		
		return true;
	}
	
	public function uninstall()
	{
		if (!parent::uninstall())
			return false;
		return (Db::getInstance()->Execute('DROP TABLE `'._DB_PREFIX_.'banners`') AND
				Db::getInstance()->Execute('DROP TABLE `'._DB_PREFIX_.'banners_lang`'));
	}
	
	public function getContent()
	{
		global $cookie;
		$id=0;
		/* display the module name */
		$this->_html = '<h2>'.$this->displayName.'</h2>';
		$errors = '';

		// Delete editorial
		if (Tools::getValue('removeBanner'))
		{
		
		
			$e=new BannersClass(Tools::getValue('removeBanner'));
			$e->_delete();
			
		}
		

		/* update the editorial xml */
		
		if (Tools::isSubmit('submitUpdate') )
		{
			// Forbidden key
			$forbidden = array('submitUpdate');
			
			
			$id=Tools::getValue('id_banners');
			
			$promotion = new BannersClass($id);
			
			$promotion->copyFromPost();
			
			if (Tools::getValue('id_banners')==0)
			{
			
			$promotion->add();
			
			}
			else {
			$promotion->update();
			}

			/* upload the image */
			
		}

		/* display the editorial's form */
		if (Tools::getValue('showBanner'))
		{
			$id=Tools::getValue('showBanner');
			
		}
		$this->_displayListing();
		$this->_displayForm($id);
	
		return $this->_html;
	}
	
	 public function getCategoryOption1($id_category, $id_lang, $editorial, $children = true)
  {
    $categorie = new Category($id_category, $id_lang);
    if(is_null($categorie->id))
      return;
    if(count(explode('.', $categorie->name)) > 1)
      $name = str_replace('.', '', strstr($categorie->name, '.'));
    else
      $name = $categorie->name;
    $this->_html .= '<option '.
					(isset($editorial->id_category) && $editorial->id_category=="CAT".$categorie->id? "selected='selected'": '').' value="CAT'.$categorie->id.'" style="margin-left:'.(($children) ? round(15+(15*(int)$categorie->level_depth)) : 0).'px;">'.$name.'</option>';
    if($children)
    {
      $childrens = Category::getChildren($id_category, $id_lang);
      if(count($childrens))
        foreach($childrens as $children)
          $this->getCategoryOption1($children['id_category'], $id_lang);
    }
  }
  
	
	private function _displayListing()
	{
	global $cookie;
	
	
	$rows=Db::getInstance()->ExecuteS("SELECT t1.name as title, t2.id_banners as id from "._DB_PREFIX_."banners_lang as t1,"._DB_PREFIX_."banners as t2 where t1.id_banners=t2.id_banners and t1.id_lang='".$cookie->id_lang."'");
	
	
	
	$r='<a href="'.$_SERVER['REQUEST_URI'].'" >New banner</a>';
	if ($rows)
	{
	$r.='<form id="form_listing" method="post" action="'.$_SERVER['REQUEST_URI'].'">
	<input type="hidden" value="" name="removeBanner" id="removeBanner" />
	<input type="hidden" value="" name="showBanner" id="showBanner" />';
	$r.='<table class="list">';
	foreach ($rows as $row)
	{
	extract($row);
	$r.="<tr><td>".$id."</td><td><a href='#' class='show'>".$title."</a><input type='hidden' value='".$id."' /> <span class='remove'>remove</span></td></tr>";
	}
	$r.="</form></table>";
	}
	$this->_html=$r;
	
	}
	
	private function _displayForm($id)
	{
		global $cookie;
		/* Languages preliminaries */
		$defaultLanguage = (int)(Configuration::get('PS_LANG_DEFAULT'));
		$languages = Language::getLanguages(false);
		$iso = Language::getIsoById((int)($cookie->id_lang));
		$divLangName = 'title|subheading|para|logo_subheading';

		$editorial = new BannersClass($id);
		// TinyMCE
		global $cookie;
		$iso = Language::getIsoById((int)($cookie->id_lang));
		$isoTinyMCE = (file_exists(_PS_ROOT_DIR_.'/js/tiny_mce/langs/'.$iso.'.js') ? $iso : 'en');
		$ad = dirname($_SERVER["PHP_SELF"]);
		
		$this->_html .=  '
		<style>
		
		.list {
		width:500px;
		}
		.list td{
		padding:10px;
		border:solid 1px #cccccc;
	
		}
		
		.remove {
		position:relative;
		z-index:5000;
		cursor:pointer;
		
		}
		
		
		.list a {
		text-decoration:underline;
		}
		.list span {
		display:block;
		float:right;
		color:red;
		font-size:10px;
		}
		
		</style>
			<script type="text/javascript">	
			
			$(document).ready(function(){
			
			
			
			
			$("#form").submit(function()
			{
			
			});
			$(".show").click(function(event) {
			event.preventDefault();
			
			$("#showBanner").val($(this).next("input").val());
			$("#form_listing").submit();
			});
			
			$(".remove").click(function(event) {
			event.preventDefault();
			$("#removeBanner").val($(this).prev("input").val());
			$("#form_listing").submit();
			});
			
			});
			var iso = \''.$isoTinyMCE.'\' ;
			var pathCSS = \''._THEME_CSS_DIR_.'\' ;
			var ad = \''.$ad.'\' ;
			</script>
			<script type="text/javascript" src="'.__PS_BASE_URI__.'js/tiny_mce/tiny_mce.js"></script>
			<script type="text/javascript" src="'.__PS_BASE_URI__.'js/tinymce.inc.js"></script>';
			
			;
		$this->_html .= '
		<script type="text/javascript">id_language = Number('.$defaultLanguage.');</script>
		<form method="post" action="'.$_SERVER['REQUEST_URI'].'" enctype="multipart/form-data" id="form">';
	$divLangName="title¤label_text0¤label_text1¤label_text2¤label_text3¤label_text4";
		$this->_html .= '<br /><br /><input type="hidden" name="id_banners" value="'.$id.'" id="id_banners" />
			<fieldset style="width: 905px;">
				<legend><img src="'.$this->_path.'logo.gif" alt="" title="" /> '.$this->displayName.'</legend>
				<label>'.$this->l('Main title').'</label>
				<div class="margin-form">';
				
		
				
				foreach ($languages as $language)
				{
					$this->_html .= '
					<div id="title_'.$language['id_lang'].'" style="display: '.($language['id_lang'] == $defaultLanguage ? 'block' : 'none').';float: left;">
						<input type="text" name="name_'.$language['id_lang'].'" id="name_'.$language['id_lang'].'" size="64" value="'.(isset($editorial->name[$language['id_lang']]) ? $editorial->name[$language['id_lang']] : '').'" />
					</div>';
				}
				
				$page_names=array('cms','index','category','product','order','order-opc','my-account','module-cashondeliverywithfee-validation','module-paypal-payment-submit');
				
				$this->_html .= $this->displayFlags($languages, $defaultLanguage, $divLangName, 'title', true);
				
				$this->_html.=' </div><p class="clear"></p><label>'.$this->l('Page').'</label><div class="margin-form">
				<select  id="availableItems" name="id_category" style="">';
				foreach ($page_names as $page)
				{
				$this->_html.='<option  '.
					(isset($editorial->id_category) && $editorial->id_category==$page? "selected='selected'": '').'
					value="'.$page.'">'.$page.'</option>';
				}
				
				
				
		$this->_html .= '</select></div>
					
				<p class="clear"></p>
				
				';
				
				for ($i=0;$i<5;$i++)
				{
				$this->_html .= '
					<label>'.$this->l('Text '.$i).'</label><div class="margin-form">';
					$style=explode("|",$editorial->style);
					
				foreach ($languages as $language)
				{
				$texty=explode("|",$editorial->text[$language['id_lang']]);
				
					$this->_html .= '
					<div id="label_text'.$i.'_'.$language['id_lang'].'" style="display: '.($language['id_lang'] == $defaultLanguage ? 'block' : 'none').';float: left;">
						<textarea class="rte" type="text" name="text'.$i.'_'.$language['id_lang'].'" id="text'.$i.'_'.$language['id_lang'].'"  >'.(isset($texty[$i]) ? $texty[$i]: '').'</textarea>
					</div>
					';
				 }
				  $this->_html .= $this->displayFlags($languages, $defaultLanguage, $divLangName, 'label_text'.$i, true);
				
				 $this->_html.='<p class="clear"></p><label>'.$this->l('Style').'</label><div class="margin-form">
						<select name="style'.$i.'" id="style'.$i.'">
						<option '.(isset($style[$i]) && $style[$i]=='none'?'selected="selected"':'').' value="none">none</option>
						<option '.(isset($style[$i]) && $style[$i]=='yellow'?'selected="selected"':'').' value="yellow">yellow waves</option>
						<option '.(isset($style[$i]) && $style[$i]=='green'?'selected="selected"':'').' value="green">green waves</option>
						<option '.(isset($style[$i]) && $style[$i]=='light-tile'?'selected="selected"':'').' value="light-tile">Light Tile</option>
						<option '.(isset($style[$i]) && $style[$i]=='dark-tile'?'selected="selected"':'').' value="dark-tile">Dark Tile</option>
						<option '.(isset($style[$i]) && $style[$i]=='cabin'?'selected="selected"':'').' value="cabin">Cabin</option>
						<
						</select>
						</div>';
				 $this->_html.='</div><p class="clear"></p>';
				 }
				
				
		$this->_html .= '
					
				
				<label>'.$this->l('Active').'</label>
				<div class="margin-form">';

				foreach ($languages as $language)
				{
					$this->_html .= '
					<div id="cpara_'.$language['id_lang'].'" style="display: '.($language['id_lang'] == $defaultLanguage ? 'block' : 'none').';float: left;">
					<select name="active_'.$language['id_lang'].'">
					<option value="1" '.
					(isset($editorial->active[$language['id_lang']]) && $editorial->active[$language['id_lang']]==1? "selected='selected'": '').'
					>'.$this->l('enable').'</option>
					<option '.
					(!isset($editorial->active[$language['id_lang']]) || $editorial->active[$language['id_lang']]==0? "selected='selected'": '').' value="0">'.$this->l('disable').'</option></select>
					
						</div>';
				 }
				
				
				
				$this->_html .= '
					</div><p class="clear"></p>
				
				<div class="clear pspace"></div>
				<div class="margin-form clear"><input type="submit" name="submitUpdate" value="'.$this->l('Update the editor').'" class="button" /></div>
			</fieldset>
		</form>';
	}
	
	
	public function hookHeader()
	{global $smarty;
	global $cookie;
	$pn=$smarty->getTemplateVars("page_name");
		
		$rows=Db::getInstance()->ExecuteS("SELECT t1.text as text, t2.transition as transition  from "._DB_PREFIX_."banners_lang as t1,"._DB_PREFIX_."banners as t2 where t1.id_banners=t2.id_banners and t1.id_lang='".$cookie->id_lang."' and t2.id_category='".$pn."' and t1.active=1");
	
		if (count($rows))
		{
		Tools::addCSS(($this->_path).'css/style.css','all');
		Tools::addCSS('http://fonts.googleapis.com/css?family=Economica:700,400|Lobster|Dancing+Script|Josefin+Sans|Arvo','all');
		

		}
	
	}
	
	public function hookRightColumn()
	{
	
	global $smarty;
	global $cookie;
	$smarty->assign("active",0);
	$pn=$smarty->get_template_vars("page_name");
	
	$smarty->assign("t",$pn);
		$rows=Db::getInstance()->ExecuteS("SELECT t1.text as text, t2.transition as transition, t2.style as style  from "._DB_PREFIX_."banners_lang as t1,"._DB_PREFIX_."banners as t2 where t1.id_banners=t2.id_banners and t1.id_lang='".$cookie->id_lang."' and t2.id_category='".$pn."' and t1.active=1");
	if (count($rows))
	{
	foreach ($rows as $row)
	{
	
	extract($row);
	$texty=explode("|",$text);
	$smarty->assign("texty",array_filter($texty));
	}
	$smarty->assign("active",1);
	$smarty->assign("transition",$transition);
	$styles=explode("|",$style);
	$smarty->assign("style",array_filter($styles));
	 return $this->display(__FILE__, 'blank_banners.tpl');
	}
	
   
	
	

	}
	
	
}

