<?php

class blank_contactinfo extends Module
{
private $_html = '';
	private $_values=array('name'=>'Name','ico'=>'VAT','banka'=>'Banc account','phone'=>'Phone','hours'=>'Assistance hours','email'=>'Email','address'=>'Address','facebook'=>'Facebook','twitter'=>'Twitter');
	
	function __construct()
	{
	
		$this->name = 'blank_contactinfo';
		$this->tab = 'Blocks';
		$this->version = '0.1';
		$this->author = 'Oliveta';
		$this->need_instance = 0;

		parent::__construct();
		
		$this->displayName = $this->l('Contact info block');
		$this->description = $this->l('Adds a block that displays information about the shop');
	$path = dirname(__FILE__);
		if (strpos(__FILE__, 'Module.php') !== false)
			$path .= '/../modules/'.$this->name;
		
	}

	function install()
	{
		if (!parent::install())
			return false;
		if (!$this->registerHook('leftColumn') OR !$this->registerHook('footer') OR !$this->registerHook('header'))
			return false;
		return true;
	}

	/**
	* Returns module content for header
	*
	* @param array $params Parameters
	* @return string Content
	*/
	
	public function getContent()
{
	if (Tools::isSubmit('submit'))
	{
	foreach ($this->_values as $key=>$value)
	{
		Configuration::updateValue($this->name.'_'.$key, Tools::getValue($key));
		}
	}

	$this->_displayForm();

	return $this->_html;
}


private function _displayForm()
{
$this->_html .= '<form action="'.$_SERVER['REQUEST_URI'].'" method="post">';
foreach ($this->_values as $key=>$value)
{
$this->_html.='<label>'.$value.'</label>
			<div class="margin-form">
				<input type="text" name="'.$key.'" value="'.Configuration::get($this->name.'_'.$key).'"/>
			</div>';
			
}
$this->_html .= '<input type="submit" name="submit" value="'.$this->l('Update').'" class="button" />
	</form>';
}





	
	function hookHeader()
	{
	
	Tools::addCSS(($this->_path).'style.css','all');
	
	}
	function hookleftColumn($params)
	{
		global $smarty, $cookie, $cart;
		foreach ($this->_values as $key=>$value)
	{
		$smarty->assign(array(
			'info_'.$key => Configuration::get($this->name.'_'.$key) 
		));
	}
		
		return $this->display(__FILE__, 'blank_contactinfo.tpl');
	}
	
	function hookFooter($params)
	{
		global $smarty, $cookie, $cart;
		foreach ($this->_values as $key=>$value)
	{
		$smarty->assign(array(
			'info_'.$key => Configuration::get($this->name.'_'.$key) 
		));
	}
		
		return $this->display(__FILE__, 'blank_contactinfo_footer.tpl');
	}
	
	
}

?>
