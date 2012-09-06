<?php

if (!defined('_CAN_LOAD_FILES_'))
	exit;

class blank_slideshow extends Module
{
	/** @var max image size */
	

	public function __construct()
	{
		$this->name = 'blank_slideshow';
		$this->tab = 'front_office_features';
		$this->version = '0.1';
		$this->author = 'Oliveta';
		$this->need_instance = 0;
		
		parent::__construct();

		$this->displayName = $this->l('Home Slider');
		$this->description = $this->l('A  rhinoslider slideshow  for your homepage.');
		$path = dirname(__FILE__);
		if (strpos(__FILE__, 'Module.php') !== false)
			$path .= '/../modules/'.$this->name;
		include_once($path.'/SliderEditorialClass.php');
		
	}
	

	public function install()
	{
		if (!parent::install() OR !$this->registerHook('home') OR !$this->registerHook('header') OR !Configuration::updateValue('BLANK_SLIDER_EFFECT','none'))
			return false;
		
		if (!Db::getInstance()->Execute('
		CREATE TABLE `'._DB_PREFIX_.'blank_slideshow` (
		`id_editorial` int(10) unsigned NOT NULL auto_increment,
		`body_home_logo` varchar(255) NOT NULL,
		`slider_active` int(2) NOT NULL,
		PRIMARY KEY (`id_editorial`))
		ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8'))
			return false;
		
		if (!Db::getInstance()->Execute('
		CREATE TABLE `'._DB_PREFIX_.'blank_slideshow_lang` (
		`id_editorial` int(10) unsigned NOT NULL,
		`id_lang` int(10) unsigned NOT NULL,
		`body_title` varchar(255) NOT NULL,
		`body_subheading` varchar(255) NOT NULL,
		`body_paragraph` text NOT NULL,
		`body_logo_subheading` varchar(255) NOT NULL,
		`body_home_logo_link` varchar(255) NOT NULL,
		PRIMARY KEY (`id_editorial`, `id_lang`))
		ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8'))
			return false;
		
		
		return true;
	}
	
	public function uninstall()
	{
		if (!parent::uninstall())
			return false;
		$t=1;	
		foreach(glob(dirname(__FILE__).'/img/*.*') as $fn) { 
        $t*=unlink($fn); 
        } 	
		return ($t AND Db::getInstance()->Execute('DROP TABLE `'._DB_PREFIX_.'blank_slideshow`') AND
				Db::getInstance()->Execute('DROP TABLE `'._DB_PREFIX_.'blank_slideshow_lang`') AND 
				Configuration::deleteByName('BLANK_SLIDER_EFFECT'));
	}
	
	

	public function getContent()
	{
		global $cookie;
		$id=0;
		/* display the module name */
		$this->_html = '<h2>'.$this->displayName.'</h2>';
		$errors = '';
		
		
		if (Tools::getValue('effect'))
		{
		
			Configuration::updateValue("BLANK_SLIDER_EFFECT",Tools::getValue('effect'));
			
			
		}
		// Delete slider
		if (Tools::getValue('removeEditorial'))
		{
		
		
			$editorial=new SliderEditorialClass(Tools::getValue('removeEditorial'));
			
			$editorial->_delete();
			
		}
		// Delete slider image
		if (Tools::isSubmit('deleteImage') &&  Tools::getValue('deleteImage')==1 && Tools::getValue('id_editorial'))
		{
		
		$id=Tools::getValue('id_editorial');
		
		$editorial=new SliderEditorialClass($id);
		
		 $editorial->eraseImage();
		 
		}
		
		/* update or create a slider */
		
		if (Tools::isSubmit('submitUpdate') )
		{
			// Forbidden key
			$id=Tools::getValue('id_editorial');
			$editorial = new SliderEditorialClass($id);
			$editorial->copyFromPost();
			
			if (Tools::getValue('id_editorial')==0)
			{
			$editorial->add();
			$id=$editorial->id;
			}
			else {
			$editorial->update();
			}
		
			/* upload the image */
			$editorial->addImage();
			
			
		}

		/* display the editorial's form */
		if (Tools::getValue('showEditorial'))
		{
			$id=Tools::getValue('showEditorial');
			
		}
		if (isset($editorial) && isset($editorial->errors) && $editorial->errors!='')
			{
				$this->_html .= '<div class="warning">'.$editorial->errors.'</div>';}
			elseif (isset($editorial) && $editorial->errors=='')
				$this->_html .= $this->displayConfirmation($this->l('Slider updated'));
			
		$this->_displayListing();
		$this->_displayForm($id);
	
		return $this->_html;
	}
	
	
	
	private function _displayListing()
	{
	global $cookie;
	$effects=array('none', 'fade', 'slide', 'kick', 'transfer', 'shuffle', 'explode', 'turnOver', 'chewyBars');
	$rows=Db::getInstance()->ExecuteS("SELECT t1.body_title as title,t2.slider_active as active, t2.id_editorial as id from "._DB_PREFIX_."blank_slideshow_lang as t1,"._DB_PREFIX_."blank_slideshow as t2 where t1.id_editorial=t2.id_editorial and t1.id_lang='".$cookie->id_lang."'");
	
	$r='<a href="'.$_SERVER['REQUEST_URI'].'" >&raquo; New slide</a><br /><br />';
	if ($rows)
	{
	$r.='<form id="form_listing" method="post" action="'.$_SERVER['REQUEST_URI'].'">	<fieldset style="width: 905px;">
				<legend><img src="'.$this->_path.'logo.gif" alt="" title="" /> '.$this->l('Listing').'</legend>
				
	<input type="hidden" value="" name="removeEditorial" id="removeEditorial" />
	<input type="hidden" value="" name="showEditorial" id="showEditorial" />';
	$r.='<table class="table-5"><thead><tr><td>'.$this->l('ID').'</td><td>'.$this->l('Title').'</td><td>'.$this->l('Active').'</td><td></td></tr></thead><tbody>';
	foreach ($rows as $row)
	{
	extract($row);
	$r.="<tr><td>".$id."</td><td><a href='#' class='show'>".$title."</a><input type='hidden' value='".$id."' /></td><td>".($active?$this->l('Yes'):$this->l('No'))."</td><td><input type='hidden' value='".$id."' /> <span class='remove'>remove</span></td></tr>";
	}
	$r.='</tbody></table>
	<p><label>'.$this->l('Select effect to be used').' </label><select name="effect" id="effect">';
	foreach ($effects as $ef)
	{
	$r .= '<option '.(Configuration::get("BLANK_SLIDER_EFFECT")==$ef?'selected="selected"':'').' name="'.$ef.'">'.$ef.'</option>';
	}
	
		$r .= '</select></p><br /><br /></fieldset></form><br /><br />';
	}
	$this->_html.=$r;
	
	}

	private function _displayForm($id)
	{
		global $cookie;
		/* Languages preliminaries */
		$defaultLanguage = (int)(Configuration::get('PS_LANG_DEFAULT'));
		$languages = Language::getLanguages(false);
		$iso = Language::getIsoById((int)($cookie->id_lang));
		
		$editorial = new SliderEditorialClass($id);
		// TinyMCE
		global $cookie;
		$iso = Language::getIsoById((int)($cookie->id_lang));
		$isoTinyMCE = (file_exists(_PS_ROOT_DIR_.'/js/tiny_mce/langs/'.$iso.'.js') ? $iso : 'en');
		$ad = dirname($_SERVER["PHP_SELF"]);
		$divs="title¤subheading¤cpara¤body_home_logo_link¤logo_subheading";
		$this->_html .=  '
		<style>
		
		.list {
		width:500px;
		}
		.list td{
		padding:10px;
		border:solid 1px #cccccc;
		
		}
		table.table-5 {
		width:100%;
		
		padding: 5px;
		
		border: 1px solid #ebebeb;
		}
		
		
		.table-5 td, .table-5 th {
		padding: 5px 10px;
		font-weight:normal;
		}
		
		
		
		.table-5 thead {
		font-size:12px;
		text-transform:uppercase;
		font-weight:normal;
		text-shadow: 0 1px 0 white;
		color: #658799;
		
		}
		.table-5 th {
		text-align: left;
		border-bottom: 1px solid #fff;
		}
		.table-5 td {
		font-size: 12px;
		}
		
		.table-5 tfoot td {
		text-align:right;
		}
		
		
		
		.remove {
		position:relative;
		z-index:5000;
		cursor:pointer;
		
		}
		
		
		a:hover {
		color:#ccdd00;
		}
		.table-5 span {
		display:block;
		float:right;
		color:red;
		font-size:10px;
		}
		
		
		
		</style>
			<script type="text/javascript">	
			
			$(document).ready(function(){
			
			$("#delete").click(function()
			{
			$t=confirm(\''.$this->l('Are you sure?', __CLASS__, true, false).'\');
			if ($t)
			{
			$("#deleteImage").val(1);
			$("#form").submit();
			}
			return false;
			});
			
			$("#effect").change(function()
			{
			$("#form_listing").submit();
			});
			
			
			$("#form").submit(function()
			{
			
			});
			$(".show").click(function(event) {
			event.preventDefault();
			
			$("#showEditorial").val($(this).next("input").val());
			$("#form_listing").submit();
			});
			
			$(".remove").click(function(event) {
			event.preventDefault();
			$("#removeEditorial").val($(this).prev("input").val());
			$("#form_listing").submit();
			});
			
			});
			var iso = \''.$isoTinyMCE.'\' ;
			var pathCSS = \''._THEME_CSS_DIR_.'\' ;
			var ad = \''.$ad.'\' ;
			</script>
			<script type="text/javascript" src="'.__PS_BASE_URI__.'js/tiny_mce/tiny_mce.js"></script>
			<script type="text/javascript" src="'.__PS_BASE_URI__.'js/tinymce.inc.js"></script>';
		$this->_html .= '
		<script type="text/javascript">id_language = Number('.$defaultLanguage.');</script>
		<form method="post" action="'.$_SERVER['REQUEST_URI'].'" enctype="multipart/form-data" id="form">
		<input type="hidden" name="id_editorial" value="'.$id.'" id="id_editorial" />
			<fieldset style="width: 905px;">
				<legend><img src="'.$this->_path.'logo.gif" alt="" title="" /> '.$this->displayName.'</legend>
				<label>'.$this->l('Main title').'</label>
				<div class="margin-form" >';
				
				foreach ($languages as $language)
				{
					$this->_html .= '
					<div id="title_'.$language['id_lang'].'" style="display: '.($language['id_lang'] == $defaultLanguage ? 'block' : 'none').';float: left;">
						<input type="text" name="body_title_'.$language['id_lang'].'" id="body_title_'.$language['id_lang'].'" size="64" value="'.(isset($editorial->body_title[$language['id_lang']]) ? $editorial->body_title[$language['id_lang']] : '').'" />
					</div>';
				}
				$this->_html .= $this->displayFlags($languages, $defaultLanguage, $divs, 'title', true).'';
				
				
		$this->_html .= '
					<p class="clear">'.$this->l('Appears along top of the slide').'</p>
				</div>
				<label>'.$this->l('Subheading').'</label>
				<div class="margin-form">';
				
				foreach ($languages as $language)
				{
					$this->_html .= '
					<div id="subheading_'.$language['id_lang'].'" style="display: '.($language['id_lang'] == $defaultLanguage ? 'block' : 'none').';float: left;">
						<input type="text" name="body_subheading_'.$language['id_lang'].'" id="body_subheading_'.$language['id_lang'].'" size="64" value="'.(isset($editorial->body_subheading[$language['id_lang']]) ? $editorial->body_subheading[$language['id_lang']] : '').'" />
					</div>';
				 }
				$this->_html .= $this->displayFlags($languages, $defaultLanguage, $divs, 'subheading', true);
				
		$this->_html .= '
					<div class="clear">'.$this->l('Appears under the main title').'</div>
				</div>
				<label>'.$this->l('Text').'</label>
				<div class="margin-form">';
		
				foreach ($languages as $language)
				{
					$this->_html .= '
					<div id="cpara_'.$language['id_lang'].'" style="display: '.($language['id_lang'] == $defaultLanguage ? 'block' : 'none').';float: left;">
						<textarea class="rte" cols="50" rows="30" id="body_paragraph_'.$language['id_lang'].'" name="body_paragraph_'.$language['id_lang'].'">'.(isset($editorial->body_paragraph[$language['id_lang']]) ? $editorial->body_paragraph[$language['id_lang']] : '').'</textarea>
					</div>';
				 }
				
				$this->_html .= $this->displayFlags($languages, $defaultLanguage, $divs, 'cpara', true);
				
				$this->_html .= '
					<p class="clear">'.$this->l('Text of your choice; for example, explain your mission, highlight a new product, or describe a recent event.').'</p>
				</div>
				<label>'.$this->l('Image (680x310px)').' </label>
				<div class="margin-form">';
				$name='img/'.$editorial->body_home_logo;
				if (file_exists(dirname(__FILE__).'/'.$name) && is_file(dirname(__FILE__).'/'.$name))
				{
				list($width,$height,$t,$s)=getimagesize(dirname(__FILE__).'/'.$name);
				$max_width=400;
				if ($width>$max_width) {
				$q=$max_width/$width;
				$width=400;
				$height=floor($q*$height);
				}
						$this->_html .= '<div id="image" >
							<img style="width:'.$width.'px;height:'.$height.'px" src="'.$this->_path.$name.'?t='.time().'" />
							<p align="center">'.$this->l('Filesize').' '.(filesize(dirname(__FILE__).'/'.$name) / 1000).'kb</p>
							<a href="'.$_SERVER['REQUEST_URI'].'&deleteImage=1&amp;id_editorial='.$id.'" id="delete" >
							<input type="hidden" value="0" id="deleteImage" name="deleteImage" />
							<img src="../img/admin/delete.gif" alt="'.$this->l('Delete').'" /> '.$this->l('Delete').'</a>
						</div>';
						}
				$this->_html .= '<input type="file" name="body_homepage_logo" />
					<p style="clear: both">'.$this->l('Will appear next to the  text above').'</p>
					
				</div>
				
				<label>'.$this->l('Homepage logo link').'</label><div class="margin-form">';
				foreach ($languages as $language)
				{
					$this->_html .= '
					<div id="body_home_logo_link_'.$language['id_lang'].'" style="display: '.($language['id_lang'] == $defaultLanguage ? 'block' : 'none').';float: left;">
						<input type="text"  size="64" id="body_home_logo_link_'.$language['id_lang'].'" name="body_home_logo_link_'.$language['id_lang'].'" value="'.(isset($editorial->body_home_logo_link[$language['id_lang']]) ? $editorial->body_home_logo_link[$language['id_lang']] : '').'" />
					</div>';
				 }
				
				$this->_html .= $this->displayFlags($languages, $defaultLanguage, $divs, 'body_home_logo_link', true);
				
				
				
				$this->_html.='	<p class="clear"></p>
				</div>
				
				<label>'.$this->l('Homepage link text').'</label>
				<div class="margin-form">';
				
				foreach ($languages as $language)
				{
					$this->_html .= '
					<div id="logo_subheading_'.$language['id_lang'].'" style="display: '.($language['id_lang'] == $defaultLanguage ? 'block' : 'none').';float: left;">
						<input type="text" name="body_logo_subheading_'.$language['id_lang'].'" id="logo_subheading_'.$language['id_lang'].'" size="64" value="'.(isset($editorial->body_logo_subheading[$language['id_lang']]) ? $editorial->body_logo_subheading[$language['id_lang']] : '').'" />
					</div>';
				 }
				
				$this->_html .= $this->displayFlags($languages, $defaultLanguage, $divs, 'logo_subheading', true);
				
				$this->_html .= '<div class="clear"></div></div><label>'.$this->l('Active').'</label><div class=""margin-form">
				
				<select name="slider_active" >
				<option value="0" '.((isset($editorial->slider_active)&& $editorial->slider_active==0)?"selected='selected'":'').' >'.$this->l('No').'</option>
				
				<option value="1" '.((isset($editorial->slider_active)&& $editorial->slider_active==1)?"selected='selected'":'').' >'.$this->l('Yes').'</option>
				</select>
					<div class="clear"></div>
				</div>
				<div class="clear pspace"></div>
				<div class="margin-form clear"><input type="submit" name="submitUpdate" value="'.$this->l('Update the editor').'" class="button" /></div>
			</fieldset>
		</form>';
	}

	public function hookHome($params)
	{
		global $cookie, $smarty;
		
	
	
		$rows=Db::getInstance()->ExecuteS("SELECT t1.body_subheading as body_subheading,t1.body_title as body_title, t2.id_editorial as id_editorial, t1.body_home_logo_link as body_home_logo_link, t2.body_home_logo as body_home_logo, t1.body_logo_subheading as body_logo_subheading,t1.body_paragraph as body_paragraph from "._DB_PREFIX_."blank_slideshow_lang as t1,"._DB_PREFIX_."blank_slideshow as t2 where t1.id_editorial=t2.id_editorial and t1.id_lang='".$cookie->id_lang."' and t2.slider_active=1 order by id_editorial");
	
		$cufon=in_array( Configuration::get('BLANK_FONT'),array("almelo","jura","gabo"));
		
		$smarty->assign(array(
			'editorial' => $rows,
			'default_lang' => (int)$cookie->id_lang,
			'id_lang' => $cookie->id_lang,
			'effect'=>Configuration::get("BLANK_SLIDER_EFFECT"),
			'path'=>$this->_path,
			'cufon'=>$cufon
		));
		
		return $this->display(__FILE__, 'blank_slideshow.tpl');
		
	}
	
	public function hookHeader()
	{
	global $cookie,$smarty;
	
	$rows=Db::getInstance()->ExecuteS("SELECT t1.body_subheading as body_subheading,t1.body_title as body_title, t2.id_editorial as id_editorial, t1.body_home_logo_link as body_home_logo_link, t2.body_home_logo as body_home_logo, t1.body_logo_subheading as body_logo_subheading,t1.body_paragraph as body_paragraph from "._DB_PREFIX_."blank_slideshow_lang as t1,"._DB_PREFIX_."blank_slideshow as t2 where t1.id_editorial=t2.id_editorial and t1.id_lang='".$cookie->id_lang."' and t2.slider_active=1  order by id_editorial");
	$tpl_vars = $smarty->getTemplateVars();
	
	$page_name=$tpl_vars['page_name'];
	if ($page_name=="index" && $rows && count($rows)>0)
	{
	
	if (Module::getInstanceByName('blank_theamer') && Module::getInstanceByName('blank_theamer')->active && Configuration::get('BLANK_COLOUR'))
	{
	Tools::addCSS(($this->_path).'css/themes/'.Configuration::get('BLANK_COLOUR').'/style.css','all');
		}
		else 
		Tools::addCSS(($this->_path).'css/themes/white/style.css','all');

	if(!preg_match('/msie [1-7]/i',$_SERVER['HTTP_USER_AGENT'])) {


	Tools::addCSS(($this->_path).'css/rhinoslider-1.05.css','all');
		Tools::addJS(($this->_path).'js/rhinoslider-1.05.min.js');
		Tools::addJS(($this->_path).'js/mousewheel.js');
		Tools::addJS(($this->_path).'js/easing.js');
		}
		else {
		Tools::addCSS(($this->_path).'css/jquery.cycle.css','all');
		Tools::addJS(($this->_path).'js/jquery.cycle.js');
		}
		
		
	}
	}
	
	
	

}