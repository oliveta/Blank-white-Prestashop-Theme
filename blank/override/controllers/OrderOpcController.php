<?php 
class OrderOpcController extends OrderOpcControllerCore
{
function generatePassword($length=9, $strength=0) {
	$vowels = 'aeuy';
	$consonants = 'bdghjmnpqrstvz';
	if ($strength & 1) {
		$consonants .= 'BDGHJLMNPQRSTVWXZ';
	}
	if ($strength & 2) {
		$vowels .= "AEUY";
	}
	if ($strength & 4) {
		$consonants .= '23456789';
	}
	if ($strength & 8) {
		$consonants .= '@#$%';
	}
 
	$password = '';
	$alt = time() % 2;
	for ($i = 0; $i < $length; $i++) {
		if ($alt == 1) {
			$password .= $consonants[(rand() % strlen($consonants))];
			$alt = 0;
		} else {
			$password .= $vowels[(rand() % strlen($vowels))];
			$alt = 1;
		}
	}
	return $password;
}

public function process()
	{
	global $smarty;
	
	self::$smarty->assign('password',$this->generatePassword());
	
	self::$smarty->assign('pickup', Module::hookExec('extraCarrier'));
	
	parent::process();
	
	}
	
protected function _getPaymentMethods()
	{
		
		if (self::$cart->OrderExists())
			return '<p class="warning">'.Tools::displayError('Error: this order is already validated').'</p>';
		if (self::$cart->id_customer AND (!Customer::customerIdExistsStatic(self::$cart->id_customer) OR Customer::isBanned(self::$cart->id_customer)))
			return '<p class="warning">'.Tools::displayError('Error: no customer').'</p>';
			
		$address_delivery = new Address(self::$cart->id_address_delivery);
		$address_invoice = (self::$cart->id_address_delivery == self::$cart->id_address_invoice ? $address_delivery : new Address(self::$cart->id_address_invoice));
		
		if (!self::$cart->id_carrier AND !self::$cart->isVirtualCart())
			return '<p class="warning">'.Tools::displayError('Error: please choose a carrier').'</p>';
		elseif (self::$cart->id_carrier != 0)
		{
			$carrier = new Carrier((int)(self::$cart->id_carrier));
			if (!Validate::isLoadedObject($carrier) OR $carrier->deleted OR !$carrier->active)
				return '<p class="warning">'.Tools::displayError('Error: the carrier is invalid').'</p>';
		}
		if (!self::$cart->id_currency)
			return '<p class="warning">'.Tools::displayError('Error: no currency has been selected').'</p>';
	

		/* If some products have disappear */
		if (!self::$cart->checkQuantities())
			return '<p class="warning">'.Tools::displayError('An item in your cart is no longer available, you cannot proceed with your order.').'</p>';

		/* Check minimal amount */
		$currency = Currency::getCurrency((int)self::$cart->id_currency);

		$minimalPurchase = Tools::convertPrice((float)Configuration::get('PS_PURCHASE_MINIMUM'), $currency);
		if (self::$cart->getOrderTotal(false, Cart::ONLY_PRODUCTS) < $minimalPurchase)
			return '<p class="warning">'.Tools::displayError('A minimum purchase total of').' '.Tools::displayPrice($minimalPurchase, $currency).
			' '.Tools::displayError('is required in order to validate your order.').'</p>';

		/* Bypass payment step if total is 0 */
		if (self::$cart->getOrderTotal() <= 0)
			return '<p class="center"><input type="button" class="exclusive_large" name="confirmOrder" id="confirmOrder" value="'.Tools::displayError('I confirm my order').'" onclick="confirmFreeOrder();" /></p>';
	
		$return = Module::hookExecPayment();
		if (!$return) {
			return '<p class="warning">'.Tools::displayError('No payment method is available').'</p>';}
			
		return $return;
	}	
	
public function preProcess()
	{
		parent::preProcess();
		
		if ($this->nbProducts)
			self::$smarty->assign('virtual_cart', false);
		$this->isLogged = (bool)((int)(self::$cookie->id_customer) AND Customer::customerIdExistsStatic((int)(self::$cookie->id_customer)));

		if (self::$cart->nbProducts())
		{
			if (Tools::isSubmit('ajax'))
			{
				if (Tools::isSubmit('method'))
				{
					switch (Tools::getValue('method'))
					{
						case 'updateMessage':
							if (Tools::isSubmit('message'))
							{
								$txtMessage = urldecode(Tools::getValue('message'));
								$this->_updateMessage($txtMessage);
						    	if (sizeof($this->errors))
									die('{"hasError" : true, "errors" : ["'.implode('\',\'', $this->errors).'"]}');
								die(true);
							}
							break;
						case 'updateCarrierAndGetPayments':
							if (Tools::isSubmit('id_carrier') AND Tools::isSubmit('recyclable') AND Tools::isSubmit('gift') AND Tools::isSubmit('gift_message'))
							{
								if ($this->_processCarrier())
								{
									$return = array(
										'summary' => self::$cart->getSummaryDetails(),
										'HOOK_TOP_PAYMENT' => Module::hookExec('paymentTop'),
										'HOOK_PAYMENT' => $this->_getPaymentMethods()
									);
									die(Tools::jsonEncode($return));
								}
								else
									$this->errors[] = Tools::displayError('Error occurred updating cart.');
								if (sizeof($this->errors))
									die('{"hasError" : true, "errors" : ["'.implode('\',\'', $this->errors).'"]}');
								exit;
							}
							break;
						case 'updateTOSStatusAndGetPayments':
							if (Tools::isSubmit('checked'))
							{
								self::$cookie->checkedTOS = (int)(Tools::getValue('checked'));
								die(Tools::jsonEncode(array(
									'HOOK_TOP_PAYMENT' => Module::hookExec('paymentTop'),
									'HOOK_PAYMENT' => $this->_getPaymentMethods()
								)));
							}
							break;
						case 'getCarrierList':
							die(Tools::jsonEncode($this->_getCarrierList()));
							break;
						case 'editCustomer':
							if (!$this->isLogged)
								exit;
							$customer = new Customer((int)self::$cookie->id_customer);
							if (Tools::getValue('years'))
								$customer->birthday = (int)Tools::getValue('years').'-'.(int)Tools::getValue('months').'-'.(int)Tools::getValue('days');
							$_POST['lastname'] = $_POST['customer_lastname'];
							$_POST['firstname'] = $_POST['customer_firstname'];
							$this->errors = $customer->validateControler();
							$customer->newsletter = (int)Tools::isSubmit('newsletter');
							$customer->optin = (int)Tools::isSubmit('optin');
							$return = array(
								'hasError' => !empty($this->errors),
								'errors' => $this->errors,
								'id_customer' => (int)self::$cookie->id_customer,
								'token' => Tools::getToken(false)
							);
							if (!sizeof($this->errors))
								$return['isSaved'] = (bool)$customer->update();
							else
								$return['isSaved'] = false;
							die(Tools::jsonEncode($return));
							break;
						case 'getAddressBlockAndCarriersAndPayments':
							if (self::$cookie->isLogged())
							{
								// check if customer have addresses
								if (!Customer::getAddressesTotalById((int)(self::$cookie->id_customer)))
									die(Tools::jsonEncode(array('no_address' => 1)));
								if (file_exists(_PS_MODULE_DIR_.'blockuserinfo/blockuserinfo.php'))
								{
									include_once(_PS_MODULE_DIR_.'blockuserinfo/blockuserinfo.php');
									$blockUserInfo = new BlockUserInfo();
								}
								self::$smarty->assign('isVirtualCart', self::$cart->isVirtualCart());
								$this->_processAddressFormat();
								$this->_assignAddress();
								// Wrapping fees
								$wrapping_fees = (float)(Configuration::get('PS_GIFT_WRAPPING_PRICE'));
								$wrapping_fees_tax = new Tax((int)(Configuration::get('PS_GIFT_WRAPPING_TAX')));
								$wrapping_fees_tax_inc = $wrapping_fees * (1 + (((float)($wrapping_fees_tax->rate) / 100)));
								$return = array(
									'summary' => self::$cart->getSummaryDetails(),
									'order_opc_adress' => self::$smarty->fetch(_PS_THEME_DIR_.'order-address.tpl'),
									'block_user_info' => (isset($blockUserInfo) ? $blockUserInfo->hookTop(array()) : ''),
									'carrier_list' => $this->_getCarrierList(),
									'HOOK_TOP_PAYMENT' => Module::hookExec('paymentTop'),
									'HOOK_PAYMENT' => $this->_getPaymentMethods(),
									'no_address' => 0,
									'gift_price' => Tools::displayPrice(Tools::convertPrice(Product::getTaxCalculationMethod() == 1 ? $wrapping_fees : $wrapping_fees_tax_inc, new Currency((int)(self::$cookie->id_currency))))
								);
								die(Tools::jsonEncode($return));
							}
							die(Tools::displayError());
							break;
						case 'makeFreeOrder':
							/* Bypass payment step if total is 0 */
							if (($id_order = $this->_checkFreeOrder()) AND $id_order)
							{
								$email = self::$cookie->email;
								if (self::$cookie->is_guest)
									self::$cookie->logout(); // If guest we clear the cookie for security reason
								die('freeorder:'.$id_order.':'.$email);
							}
							exit;
							break;
						case 'updateAddressesSelected':
							if (self::$cookie->isLogged(true))
							{
								$id_address_delivery = (int)(Tools::getValue('id_address_delivery'));
								$id_address_invoice = (int)(Tools::getValue('id_address_invoice'));
								$address_delivery = new Address((int)(Tools::getValue('id_address_delivery')));
								$address_invoice = ((int)(Tools::getValue('id_address_delivery')) == (int)(Tools::getValue('id_address_invoice')) ? $address_delivery : new Address((int)(Tools::getValue('id_address_invoice'))));

								if ($address_delivery->id_customer != self::$cookie->id_customer || $address_invoice->id_customer != self::$cookie->id_customer)
									$this->errors[] = Tools::displayError('This address is not yours.');
								elseif (!Address::isCountryActiveById((int)(Tools::getValue('id_address_delivery'))))
									$this->errors[] = Tools::displayError('This address is not in a valid area.');
								elseif (!Validate::isLoadedObject($address_delivery) OR !Validate::isLoadedObject($address_invoice) OR $address_invoice->deleted OR $address_delivery->deleted)
									$this->errors[] = Tools::displayError('This address is invalid.');
								else
								{
									self::$cart->id_address_delivery = (int)(Tools::getValue('id_address_delivery'));
									self::$cart->id_address_invoice = Tools::isSubmit('same') ? self::$cart->id_address_delivery : (int)(Tools::getValue('id_address_invoice'));
									if (!self::$cart->update())
										$this->errors[] = Tools::displayError('An error occurred while updating your cart.');
									if (!sizeof($this->errors))
									{
										if (self::$cookie->id_customer)
										{
											$customer = new Customer((int)(self::$cookie->id_customer));
											$groups = $customer->getGroups();
										}
										else
											$groups = array(1);
										$result = $this->_getCarrierList();
										// Wrapping fees
										$wrapping_fees = (float)(Configuration::get('PS_GIFT_WRAPPING_PRICE'));
										$wrapping_fees_tax = new Tax((int)(Configuration::get('PS_GIFT_WRAPPING_TAX')));
										$wrapping_fees_tax_inc = $wrapping_fees * (1 + (((float)($wrapping_fees_tax->rate) / 100)));
										$result = array_merge($result, array(
											'summary' => self::$cart->getSummaryDetails(),
											'HOOK_TOP_PAYMENT' => Module::hookExec('paymentTop'),
											'HOOK_PAYMENT' => $this->_getPaymentMethods(),
											'gift_price' => Tools::displayPrice(Tools::convertPrice(Product::getTaxCalculationMethod() == 1 ? $wrapping_fees : $wrapping_fees_tax_inc, new Currency((int)(self::$cookie->id_currency))))
										));
										die(Tools::jsonEncode($result));
									}
								}
								if (sizeof($this->errors))
									die('{"hasError" : true, "errors" : ["'.implode('\',\'', $this->errors).'"]}');
							}
							die(Tools::displayError());
							break;
						default:
							exit;
					}
				}
				exit;
			}
		}
		elseif (Tools::isSubmit('ajax'))
			exit;
	}	
}
