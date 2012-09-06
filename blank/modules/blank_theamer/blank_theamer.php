<?php

if (!defined('_PS_VERSION_'))
	exit;

class blank_theamer extends Module
{
	public function __construct()
	{
		$this->name = 'blank_theamer';
		$this->tab = 'front_office_features';
		$this->version = '0.0';
		$this->author = 'Oliveta';
		$this->need_instance = 0;

		parent::__construct();

		$this->displayName = $this->l('Theamer');
		$this->description = $this->l('Switch the font and colour scheme of the theme');
	}

	
	

	public function getContent()
	{
		$output = '<h2>'.$this->displayName.'</h2>';
		if (Tools::isSubmit('submitTheamer'))
		{
			$font = Tools::getValue('font');
			$colour = Tools::getValue('colour');
			
				Configuration::updateValue('BLANK_FONT', $font);
			Configuration::updateValue('BLANK_COLOUR', $colour);
			$output .= '<div class="conf confirm"><img src="../img/admin/ok.gif" alt="'.$this->l('Confirmation').'" />'.$this->l('Settings updated').'</div>';
		}
		return $output.$this->displayForm();
	}

	public function displayForm()
	{
		return '
		<form action="'.Tools::safeOutput($_SERVER['REQUEST_URI']).'" method="post">
			<fieldset>
				<legend><img src="'.$this->_path.'logo.gif" alt="" title="" />'.$this->l('Settings').'</legend>

				<label>'.$this->l('Theamer').'</label>
				<div class="margin-form">
				     <select name="font" id="font">
				     <option value="almelo" '.(Tools::getValue('font', Configuration::get('BLANK_FONT'))=="almelo" ? 'selected="selected" ' : '').'>'.$this->l('Almelo').'</option>
				     <option value="jura" '.(Tools::getValue('font', Configuration::get('BLANK_FONT'))=="jura" ? 'selected="selected" ' : '').'>'.$this->l('Jura').'</option>
				     <option value="gabo" '.(Tools::getValue('font', Configuration::get('BLANK_FONT'))=="gabo" ? 'selected="selected" ' : '').'>'.$this->l('Gabo').'</option>
				     <option value="economica" '.(Tools::getValue('font', Configuration::get('BLANK_FONT'))=="economica" ? 'selected="selected" ' : '').'>'.$this->l('Economica').'</option>
				     <option value="ubuntu" '.(Tools::getValue('font', Configuration::get('BLANK_FONT'))=="ubuntu" ? 'selected="selected" ' : '').'>'.$this->l('Ubuntu').'</option>
				     
				     </select>
				    
				</div>
					<div class="margin-form">
				     <select name="colour" id="colour">
				     <option value="white" '.(Tools::getValue('colour', Configuration::get('BLANK_COLOUR'))=="white" ? 'selected="selected" ' : '').'>'.$this->l('White').'</option>
				     <option value="beige" '.(Tools::getValue('colour', Configuration::get('BLANK_COLOUR'))=="beige" ? 'selected="selected" ' : '').'>'.$this->l('Beige').'</option>
				     </select>
				    
				</div>

				<center><input type="submit" name="submitTheamer" value="'.$this->l('Save').'" class="button" /></center>
			</fieldset>
		</form>';
	}

	public function install()
	{
		if
		(
			parent::install() == false
			OR $this->registerHook('header') == false
			OR $this->registerHook('footer') == false
			OR Configuration::updateValue('BLANK_FONT', 'Almelo') == false
			OR Configuration::updateValue('BLANK_COLOUR', 'white') == false
		)
			return false;
		return true;
	}

public function is_https()
    {
        return strtolower(substr($_SERVER["SERVER_PROTOCOL"],0,5))=='https'? true : false;
    }
	public function hookHeader()
	{
	global $cookie;
$shopUrl =  __PS_BASE_URI__;
$themeUrl = $shopUrl.'themes/'._THEME_NAME_.'/';


if (in_array( Configuration::get('BLANK_FONT'),array("almelo","jura","gabo")))
{
Tools::addJS($themeUrl.'js/cufon-yui.js');
		Tools::addCSS($themeUrl.'css/blank/themes/'.Configuration::get('BLANK_COLOUR').'/style.css', 'all');
		Tools::addJS($themeUrl.'js/fonts/'. Configuration::get('BLANK_FONT').'/font.js');
		
		
}
else {
Tools::addCSS($themeUrl.'css/blank/themes/'.Configuration::get('BLANK_COLOUR').'/style.css', 'all');
		
Tools::addCSS($themeUrl.'css/blank/themes/'.Configuration::get('BLANK_COLOUR').'/'. Configuration::get('BLANK_FONT').'/style.css', 'all');
}
	}
	
	public function hookFooter()
	{
	global $cookie;
	if (in_array(Configuration::get('BLANK_FONT'),array("almelo","jura","gabo")))
{
	return $this->display(__FILE__, 'cufon.tpl');
	}
	}
}

