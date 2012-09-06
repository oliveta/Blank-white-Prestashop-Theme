<?php

if (!defined('_PS_VERSION_'))
	exit;

class blank_deliverytime extends Module
{
	public function __construct()
	{
		$this->name = 'blank_deliverytime';
		$this->tab = 'front_office_features';
		$this->version = '0.1';
		$this->author = 'Oliveta';
		$this->need_instance = 0;

		parent::__construct();

		$this->displayName = $this->l('Delivery Time');
		$this->description = $this->l('Delivery time and Carrier table under product info');
	}

	
	

	

	public function install()
	{
		if
		(
			parent::install() == false
			OR $this->registerHook('productfooter') == false OR 
			!Configuration::updateValue('BLANK_UNTILTIME','11:00') OR 
			!Configuration::updateValue('BLANK_DELIVERYTIME','2') OR 
			!Configuration::updateValue('BLANK_PUBLICHOLIDAYS','')
		)
			return false;
		return true;
	}

	public function isweekend($date){
$date = date("l", $date);
$date = strtolower($date);
if($date == "saturday" || $date == "sunday"){return true;} 
return false;
}

public function getContent()
	{
		$output = '<h2>'.$this->displayName.'</h2>';
		if (Tools::isSubmit('submitDeliverytime'))
		{
			$untilTime = Tools::getValue('untilTime');
			$deliveryTime = Tools::getValue('deliveryTime');
			$publicHolidays = Tools::getValue('holidayDates');
			
			
			Configuration::updateValue('BLANK_UNTILTIME', $untilTime);
			Configuration::updateValue('BLANK_DELIVERYTIME', $deliveryTime);
			Configuration::updateValue('BLANK_PUBLICHOLIDAYS', $publicHolidays);
			$output .= '<div class="conf confirm"><img src="../img/admin/ok.gif" alt="'.$this->l('Confirmation').'" />'.$this->l('Settings updated').'</div>';
		}
		return $output.$this->displayForm();
	}

	public function displayForm()
	{
		return '<script type="text/javascript" src="'.__PS_BASE_URI__.'modules/blank_deliverytime/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="'.__PS_BASE_URI__.'modules/blank_deliverytime/js/jquery.ui.core.js"></script>
		<script type="text/javascript" src="'.__PS_BASE_URI__.'modules/blank_deliverytime/js/jquery.ui.datepicker.js"></script>
		
		<script type="text/javascript" src="'.__PS_BASE_URI__.'modules/blank_deliverytime/js/jquery-ui.multidatespicker.js"></script>
		<link rel="stylesheet" type="text/css" href="'.__PS_BASE_URI__.'modules/blank_deliverytime/css/mdp.css">
		<link rel="stylesheet" type="text/css" href="'.__PS_BASE_URI__.'modules/blank_deliverytime/css/prettify.css">
		<script type="text/javascript" src="'.__PS_BASE_URI__.'modules/blank_deliverytime/js/prettify.js"></script>
		<script type="text/javascript" src="'.__PS_BASE_URI__.'modules/blank_deliverytime/js/lang-css.js"></script>
		
		<!-- mdp demo code -->
		<script type="text/javascript">$(function() {
		prettyPrint();
		$("#simpliest-usage").multiDatesPicker();
		mystr="'.Tools::getValue('holidayDates', Configuration::get('BLANK_PUBLICHOLIDAYS')).'";
		if (mystr!="")
		{
		$("#simpliest-usage").multiDatesPicker("addDates",mystr.split(","));
		}
		$("#form").submit(function()
			{
			dates = $("#simpliest-usage").multiDatesPicker("getDates");
			$("#holidayDates").val(dates);
			return true;
			});
		
		
		});</script>
		<form action="'.Tools::safeOutput($_SERVER['REQUEST_URI']).'" method="post" id="form">
			<fieldset>
				<legend><img src="'.$this->_path.'logo.gif" alt="" title="" />'.$this->l('Settings').'</legend>

				<label>'.$this->l('Order time closure (eg: 11:00)').'</label>
				<div class="margin-form">
				<select name="untilTime" id="untilTime">
				  <option value="08:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="08:00:00" ? 'selected="selected" ' : '').'>'.$this->l('8 am').'</option>
				  <option value="09:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="09:00:00" ? 'selected="selected" ' : '').'>'.$this->l('9 am').'</option>
				  <option value="10:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="10:00:00" ? 'selected="selected" ' : '').'>'.$this->l('10 am').'</option>
				  <option value="11:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="11:00:00" ? 'selected="selected" ' : '').'>'.$this->l('11 am').'</option>
				  <option value="12:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="12:00:00" ? 'selected="selected" ' : '').'>'.$this->l('12 am').'</option>
				  <option value="13:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="13:00:00" ? 'selected="selected" ' : '').'>'.$this->l('1 pm').'</option>
				  <option value="14:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="14:00:00" ? 'selected="selected" ' : '').'>'.$this->l('2 pm').'</option>
				  <option value="15:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="15:00:00" ? 'selected="selected" ' : '').'>'.$this->l('3 pm').'</option>
				  <option value="16:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="16:00:00" ? 'selected="selected" ' : '').'>'.$this->l('4 pm').'</option>
				  <option value="17:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="17:00:00" ? 'selected="selected" ' : '').'>'.$this->l('5 pm').'</option>
				  <option value="18:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="18:00:00" ? 'selected="selected" ' : '').'>'.$this->l('6 pm').'</option>
				  <option value="19:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="19:00:00" ? 'selected="selected" ' : '').'>'.$this->l('7 pm').'</option>
				  <option value="20:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="20:00:00" ? 'selected="selected" ' : '').'>'.$this->l('8 pm').'</option>
				  <option value="21:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="21:00:00" ? 'selected="selected" ' : '').'>'.$this->l('9 pm').'</option>
				  <option value="22:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="22:00:00" ? 'selected="selected" ' : '').'>'.$this->l('10 pm').'</option>
				  <option value="23:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="23:00:00" ? 'selected="selected" ' : '').'>'.$this->l('11 pm').'</option>
				  <option value="00:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="00:00:00" ? 'selected="selected" ' : '').'>'.$this->l('0 am').'</option>
				  <option value="01:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="01:00:00" ? 'selected="selected" ' : '').'>'.$this->l('1 am').'</option>
				  <option value="02:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="02:00:00" ? 'selected="selected" ' : '').'>'.$this->l('2 am').'</option>
				  <option value="03:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="03:00:00" ? 'selected="selected" ' : '').'>'.$this->l('3 am').'</option>
				  <option value="04:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="04:00:00" ? 'selected="selected" ' : '').'>'.$this->l('4 am').'</option>
				  <option value="05:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="05:00:00" ? 'selected="selected" ' : '').'>'.$this->l('5 am').'</option>
				  <option value="06:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="06:00:00" ? 'selected="selected" ' : '').'>'.$this->l('6 am').'</option>
				  <option value="07:00:00" '.(Tools::getValue('untilTime', Configuration::get('BLANK_UNTILTIME'))=="07:00:00" ? 'selected="selected" ' : '').'>'.$this->l('7 am').'</option>
				  
				
				</select>
				 </div>
				<label>'.$this->l('Delivery time (in days): ').'</label>
				<div class="margin-form">
				
				<select name="deliveryTime" id="deliveryTime">
				  <option value="1" '.(Tools::getValue('deliveryTime', Configuration::get('BLANK_DELIVERYTIME'))=="1" ? 'selected="selected" ' : '').'>'.$this->l('Today').'</option>
				   <option value="2" '.(Tools::getValue('deliveryTime', Configuration::get('BLANK_DELIVERYTIME'))=="2" ? 'selected="selected" ' : '').'>'.$this->l('Tomorrow').'</option>
				  <option value="3" '.(Tools::getValue('deliveryTime', Configuration::get('BLANK_DELIVERYTIME'))=="3" ? 'selected="selected" ' : '').'>'.$this->l('+2 days').'</option>
				  <option value="4" '.(Tools::getValue('deliveryTime', Configuration::get('BLANK_DELIVERYTIME'))=="4" ? 'selected="selected" ' : '').'>'.$this->l('+3 days').'</option>
				  <option value="5" '.(Tools::getValue('deliveryTime', Configuration::get('BLANK_DELIVERYTIME'))=="5" ? 'selected="selected" ' : '').'>'.$this->l('+4 days').'</option>
				  <option value="6" '.(Tools::getValue('deliveryTime', Configuration::get('BLANK_DELIVERYTIME'))=="6" ? 'selected="selected" ' : '').'>'.$this->l('+5 days').'</option>
				    <option value="7" '.(Tools::getValue('deliveryTime', Configuration::get('BLANK_DELIVERYTIME'))=="7" ? 'selected="selected" ' : '').'>'.$this->l('+6 days').'</option>
				 
				</select>
				 <legend>In case that order is placed until order time closure the order will be delivered in selected delivery time. Otherwise in delivery time+1 day
				</legend>
				
				 		</div>
				<label>'.$this->l('Holidays: ').'</label>
					<div class="margin-form">
					<input type="hidden" name="holidayDates" id="holidayDates" value="'.Tools::getValue('holidayDates', Configuration::get('BLANK_PUBLICHOLIDAYS')).'" />
				     <div id="simpliest-usage" class="box"></div>
				    
				</div>

				<center><input type="submit" name="submitDeliverytime" value="'.$this->l('Save').'" class="button" /></center>
			</fieldset>
		</form>';
	}
	

public function doruceni_recurse($d,$n,$i,$holiday)
{
if ($n==$i) return $d-24*60*60;

if (in_array($d,$holiday) || $this->isweekend($d)) {$e=$this->doruceni_recurse($d+24*60*60,$n,$i,$holiday);}

else $e=$this->doruceni_recurse($d+24*60*60,$n,$i+1,$holiday);


return $e;
}

    public  function doruceni()
	{
	global $cookie,$smarty;
	
	
	$until_time=strtotime("Today, ".Configuration::get('BLANK_UNTILTIME'));
	$time_add=strtotime("Today, 00:00:00");
	$time=mktime();
	$day=date("w");
	
	$year1=date('Y');
	$year2=date('Y',strtotime('+1 year'));
	$add1=0;
	$add2=0;
	
	$holiday_date=explode(",",Configuration::get('BLANK_PUBLICHOLIDAYS'));
	
	$holiday=array();
	foreach ($holiday_date as $d)
	{
	$holiday[]=strtotime($d);
	}
	$holiday[]=easter_date((int)$year1);
	
	$d1=$this->doruceni_recurse($time_add,(int)Configuration::get('BLANK_DELIVERYTIME'),0,$holiday);
	
	$d2=$this->doruceni_recurse($time_add,(int)Configuration::get('BLANK_DELIVERYTIME')+1,0,$holiday);
	
	

	
	
	if ($time<=$until_time || $this->isweekend($time_add) )
	{
	return Tools::dateFormat(array('date'=>date("Y-m-d H:i:s",$d1)),$smarty);
	
	}
	return Tools::dateFormat(array('date'=>date("Y-m-d H:i:s",$d2)),$smarty);
	}
	
	public function hookProductFooter($params)
	{
global $cookie, $smarty;
		
	$pr=new Product($params['product']->id);
	$carriers=Carrier::getCarriers($cookie->id_lang);
	$c=array();
	foreach ($carriers as $carrier)
	{
	$a=new Carrier($carrier['id_carrier']);
	if (!Tax::excludeTaxeOption())
			$carrierTax = Tax::getCarrierTaxRate((int)$a->id);
	$price=$a->getDeliveryPriceByPrice($pr->getPrice(true,null),1)*(1+$carrierTax/100);		
	$c[]=array('name'=>$a->name,'price'=>$price);
	}
	$smarty->assign('carriers',$c);
	$smarty->assign('free',(int)Configuration::get('PS_SHIPPING_FREE_PRICE'));
		
		
		$smarty->assign(array(
			'delivery' => $this->doruceni()
		));
		
		return $this->display(__FILE__, 'blank_deliverytime.tpl');
		
	}
	

}

