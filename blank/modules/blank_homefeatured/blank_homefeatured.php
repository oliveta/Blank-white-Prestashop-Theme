<?php
/*
* 2007-2011 PrestaShop 
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2011 PrestaShop SA
*  @version  Release: $Revision: 6594 $
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA

* Modified by Oliveta for the theme Blank&White
*/

if (!defined('_CAN_LOAD_FILES_'))
	exit;

class blank_homeFeatured extends Module
{
	private $_html = '';
	private $_postErrors = array();

	function __construct()
	{
		$this->name = 'blank_homefeatured';
		$this->tab = 'front_office_features';
		$this->version = '0.1';
		$this->author = 'Oliveta';
		$this->need_instance = 0;

		parent::__construct();
		$path = dirname(__FILE__);
		if (strpos(__FILE__, 'Module.php') !== false)
			$path .= '/../modules/'.$this->name;
		$this->displayName = $this->l('Blank Featured Products on the homepage');
		$this->description = $this->l('Displays Featured Products in the middle of your homepage.');
	}

	function install()
	{
		if (!Configuration::updateValue('BLANK_HOMEFEATURED', 'standart') OR !Configuration::updateValue('HOME_FEATURED_NBR', 8) OR !parent::install() OR !$this->registerHook('home') OR !$this->registerHook('header'))
			return false;
		return true;
	}

	public function getContent()
	{
		$output = '<h2>'.$this->displayName.'</h2>';
		if (Tools::isSubmit('submitHomeFeatured'))
		{
			$nbr = (int)(Tools::getValue('nbr'));
			$size = (Tools::getValue('size'));
			if (!$nbr OR $nbr <= 0 OR !Validate::isInt($nbr))
				$errors[] = $this->l('Invalid number of products');
			else
				Configuration::updateValue('HOME_FEATURED_NBR', (int)($nbr));
				Configuration::updateValue('BLANK_HOMEFEATURED', $size);
			if (isset($errors) AND sizeof($errors))
				$output .= $this->displayError(implode('<br />', $errors));
			else
				$output .= $this->displayConfirmation($this->l('Settings updated'));
		}
		return $output.$this->displayForm();
	}

	public function displayForm()
	{
		$output = '
		<form action="'.$_SERVER['REQUEST_URI'].'" method="post">
			<fieldset><legend><img src="'.$this->_path.'logo.gif" alt="" title="" />'.$this->l('Settings').'</legend>
				<p>'.$this->l('In order to add products to your homepage, just add them to the "home" category.').'</p><br />
				<label>'.$this->l('Number of products displayed').'</label>
				<div class="margin-form">
					<input type="text" size="5" name="nbr" value="'.Tools::getValue('nbr', (int)(Configuration::get('HOME_FEATURED_NBR'))).'" />
					<p class="clear">'.$this->l('The number of products displayed on homepage (default: 11).').'</p>
					
				</div>
				<div class="margin-form">
				     <select name="size" id="font">
				     <option value="big" '.(Tools::getValue('size', Configuration::get('BLANK_HOMEFEATURED'))=="big" ? 'selected="selected" ' : '').'>'.$this->l('Big').'</option>
				     <option value="standart" '.(Tools::getValue('size', Configuration::get('BLANK_HOMEFEATURED'))=="standart" ? 'selected="selected" ' : '').'>'.$this->l('Standart').'</option>
				     <option value="small" '.(Tools::getValue('size', Configuration::get('BLANK_HOMEFEATURED'))=="small" ? 'selected="selected" ' : '').'>'.$this->l('Small').'</option>
				     </select>
				    
				</div>
				<center><input type="submit" name="submitHomeFeatured" value="'.$this->l('Save').'" class="button" /></center>
			</fieldset>
		</form>';
		return $output;
	}

	function hookHome($params)
	{global $smarty;

		$category = new Category(1, Configuration::get('PS_LANG_DEFAULT'));
		$nb = (int)(Configuration::get('HOME_FEATURED_NBR'));
		$products = $category->getProducts((int)($params['cookie']->id_lang), 1, ($nb ? $nb : 10));
		$images=array();
		if ($products)
		{
		foreach ($products as $product)
		{
		$r=Db::getInstance()->ExecuteS('
		SELECT i.`cover`, i.`id_image`, il.`legend`, i.`position`
		FROM `'._DB_PREFIX_.'image` i
		LEFT JOIN `'._DB_PREFIX_.'image_lang` il ON (i.`id_image` = il.`id_image` AND il.`id_lang` = '.(int)($params['cookie']->id_lang).')
		WHERE i.`id_product` = '.$product['id_product'].'
		ORDER BY `position`');
		
		
		$images[]=$r;
		
		}
		}
		
		$smarty->assign(array(
		'products' => $products,
		'images' => $images,
		'add_prod_display' => Configuration::get('PS_ATTRIBUTE_CATEGORY_DISPLAY'),
		'homeSize' => Image::getSize('home')));

		return $this->display(__FILE__, 'blank_homefeatured.tpl');
	}
	
	
	public function hookHeader()
	{
	global $cookie;
	if ( Configuration::get('BLANK_HOMEFEATURED'))
	{
	Tools::addCSS(($this->_path).'css/'.Configuration::get('BLANK_HOMEFEATURED').'/style.css','all');
		}
		else 
		Tools::addCSS(($this->_path).'css/big/style.css','all');
	
		
		
		
	}
}
