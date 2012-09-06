{* Will be deleted for 1.5 version and more *}
{if !isset($formatedAddressFieldsValuesList)}
	{$ignoreList.0 = "id_address"}
	{$ignoreList.1 = "id_country"}
	{$ignoreList.2 = "id_state"}
	{$ignoreList.3 = "id_customer"}
	{$ignoreList.4 = "id_manufacturer"}
	{$ignoreList.5 = "id_supplier"}
	{$ignoreList.6 = "date_add"}
	{$ignoreList.7 = "date_upd"}
	{$ignoreList.8 = "active"}
	{$ignoreList.9 = "deleted"}	
	
	{* PrestaShop 1.4.0.17 compatibility *}
	{if isset($addresses)}
		{foreach from=$addresses key=k item=address}
			{counter start=0 skip=1 assign=address_key_number}
			{$id_address = $address.id_address}
			{foreach from=$address key=address_key item=address_content}
				{if !in_array($address_key, $ignoreList)}
					{$formatedAddressFieldsValuesList.$id_address.ordered_fields.$address_key_number = $address_key}
					{$formatedAddressFieldsValuesList.$id_address.formated_fields_values.$address_key = $address_content}
					{counter}
				{/if}
			{/foreach}
		{/foreach}
	{/if}
{/if}

<script type="text/javascript">
// <![CDATA[
	{if !$opc}
	var orderProcess = 'order';
	var currencySign = '{$currencySign|html_entity_decode:2:"UTF-8"}';
	var currencyRate = '{$currencyRate|floatval}';
	var currencyFormat = '{$currencyFormat|intval}';
	var currencyBlank = '{$currencyBlank|intval}';
	var txtProduct = "{l s='product'}";
	var txtProducts = "{l s='products'}";
	{/if}

	var formatedAddressFieldsValuesList = new Array();
{if isset($formatedAddressFieldsValuesList)}
	{foreach from=$formatedAddressFieldsValuesList key=id_address item=type}
		formatedAddressFieldsValuesList[{$id_address}] =
		{ldelim}
			'ordered_fields':[
				{foreach from=$type.ordered_fields key=num_field item=field_name name=inv_loop}
					{if !$smarty.foreach.inv_loop.first},{/if}"{$field_name}"
				{/foreach}
			],
			'formated_fields_values':{ldelim}
					{foreach from=$type.formated_fields_values key=pattern_name item=field_name name=inv_loop}
						{if !$smarty.foreach.inv_loop.first},{/if}"{$pattern_name}":"{$field_name|escape:'htmlall':'UTF-8'}"
					{/foreach}
				{rdelim}
		{rdelim}
	{/foreach}
	{/if}

	function getAddressesTitles()
	{ldelim}
		return {ldelim}
						'invoice': "{l s='Your billing address'}",
						'delivery': "{l s='Your delivery address'}"
			{rdelim};

	{rdelim}


	function buildAddressBlock(id_address, address_type, dest_comp)
	{ldelim}
		var adr_titles_vals = getAddressesTitles();
		var li_content = formatedAddressFieldsValuesList[id_address]['formated_fields_values'];
		var ordered_fields_name = ['title'];

		ordered_fields_name = ordered_fields_name.concat(formatedAddressFieldsValuesList[id_address]['ordered_fields']);
		ordered_fields_name = ordered_fields_name.concat(['update']);
		
		dest_comp.html('');

		li_content['title'] = adr_titles_vals[address_type];
		li_content['update'] = '<a href="{$link->getPageLink('address.php', true)}?id_address='+id_address+'&amp;back={$back_order_page}?step=1{if $back}&mod={$back}{/if}" title="{l s='Update'}">{l s='Update'}</a>';

		appendAddressList(dest_comp, li_content, ordered_fields_name);
	{rdelim}

	function appendAddressList(dest_comp, values, fields_name)
	{ldelim}
		for (var item in fields_name)
		{ldelim}
			var name = fields_name[item];
			var value = getFieldValue(name, values);
			if (value != "")
			{ldelim}
				var new_li = document.createElement('li');
				new_li.className = 'address_'+ name;
				new_li.innerHTML = getFieldValue(name, values);
				dest_comp.append(new_li);
			{rdelim}
		{rdelim}
	{rdelim}

	function getFieldValue(field_name, values)
	{ldelim}
		var reg=new RegExp("[ ]+", "g");

		var items = field_name.split(reg);
		var vals = new Array();

		for (var field_item in items)
			vals.push(values[items[field_item]]);
		return vals.join(" ");
	{rdelim}

//]]>
</script>
<div id="opc_new_account">
	
	<h1 id="account_toggler" class="nadpis">2. {l s='Your credentials'}<p> <span id="credentials_message_ko" class="big">{l s='Please, fill in information'}</span><span id="credentials_message_ok" class="big">{l s='Address is correct'}</span></p></h1>
	<div id="account_slider">
	{if !$virtual_cart && $giftAllowed && $cart->gift == 1}
<script type="text/javascript">
{literal}
// <![CDATA[
    $('document').ready( function(){
        $('#gift_div').toggle('slow');
    });
//]]>
{/literal}
</script>
{/if}











	
	<div id="HOOK_BEFORECARRIER">{if isset($carriers)}{$HOOK_BEFORECARRIER}{/if}</div>
	<p class="warning" id="noCarrierWarning" {if (isset($carriers) && $carriers && count($carriers)) || !empty($HOOK_EXTRACARRIER)}style="display:none;"{/if}>
     {l s='There are no carriers available that deliver to this address.'}
    </p>
     <div class="clear"></div>
     <br />
	<table id="carrierTable" class="table-5" {if ( !isset($carriers) || !$carriers || !count($carriers)) && empty($pickup)}style="display:none;"{/if}>
		<thead>
			<tr>
				<th class="carrier_action first_item"></th>
				<th class="carrier_name item">{l s='Carrier'}</th>
				<th class="carrier_infos item">{l s='Information'}</th>
				<th class="carrier_price last_item">{l s='Price'}</th>
			</tr>
		</thead>
		<tbody>
		
		{if isset($carriers)}
			{foreach from=$carriers item=carrier name=myLoop}
			
				<tr id="carrier{$carrier.id_carrier|intval}" class="{if $smarty.foreach.myLoop.index % 2 == 0}carrier_odd{else}carrier_even{/if}">
					<td class="carrier_action radio">
						<input type="radio" name="id_carrier" value="{$carrier.id_carrier|intval}" id="id_carrier{$carrier.id_carrier|intval}"  {if $opc}onclick="updateCarrierSelectionAndGift();"{/if} {if $carrier.id_carrier == $checked}checked="checked"{/if}/>
					</td>
					<td class="carrier_name">
						<label for="id_carrier{$carrier.id_carrier|intval}">
							{if $carrier.img}<img src="{$carrier.img|escape:'htmlall':'UTF-8'}" alt="{$carrier.name|escape:'htmlall':'UTF-8'}" />{else}{$carrier.name|escape:'htmlall':'UTF-8'}{/if}
						</label>
					</td>
					<td class="carrier_infos">{$carrier.delay|escape:'htmlall':'UTF-8'}</td>
					<td class="carrier_price">
						{if $carrier.price}
							<span class="price">
								{if $priceDisplay == 1}{convertPrice price=$carrier.price_tax_exc}{else}{convertPrice price=$carrier.price}{/if}
							</span>
							{if $use_taxes}{if $priceDisplay == 1} {l s='(tax excl.)'}{else} {l s='(tax incl.)'}{/if}{/if}
						{else}
						<span class="price">
							{l s='Free!'}</span>
							
						{/if}
					</td>
				</tr>
			{/foreach}
			
		{/if}
		{$pickup}
		
		</tbody>
	</table>
	<div style="display: none;" id="extra_carrier"></div>

		
	






	
	<table class="table-5">
	<tr><td>
	
	<form action="{$link->getPageLink('authentication.php', true)}?back=order-opc.php" method="post" id="login_form" class="std">
		<fieldset class="registred">
			<h3>{l s='Already registered?'} <a href="#" id="openLoginFormBlock">{l s='Click here'}</a></h3>
			<div id="login_form_content" style="display:none;">
				<!-- Error return block -->
				<div id="opc_login_errors" class="error" style="display:none;"></div>
				<!-- END Error return block -->
				<p class="required text">
					<label for="email">{l s='E-mail'}</label>
					<input type="text" class="text" id="login_email" name="email"/>
					<sup>*</sup>
				</p>
				<p class="required text">
					<label for="passwd">{l s='Password'}</label>
					<input type="password" class="text" id="login_passwd" name="passwd"/>
					<sup>*</sup>
				</p>
				<p class="submit">
					{if isset($back)}<input type="hidden" class="hidden" name="back" value="{$back|escape:'htmlall':'UTF-8'}" />{/if}
					<input type="submit" id="SubmitLogin" name="SubmitLogin" class="button" value="{l s='Log in'}" />
				</p>
				<p class="lost_password"><a href="{$link->getPageLink('password.php', true)}">{l s='Forgot your password?'}</a></p>
			</div>
		</fieldset>
	</form>
	<form action="#" method="post" id="new_account_form" class="std">
	<fieldset style="display:none">
			<h3 id="new_account_title">{l s='New Customer'}</h3>
			<div id="opc_account_choice">
				<div class="opc_float">
					<h4>{l s='Instant Checkout'}</h4>
					<p>
						<input type="button" class="exclusive_large" id="opc_guestCheckout" value="{l s='Checkout as guest'}" />
					</p>
				</div>

				<div class="opc_float">
					<h4>{l s='Create your account today and enjoy:'}</h4>
					<ul class="bullet">
						<li>{l s='Personalized and secure access'}</li>
						<li>{l s='Fast and easy check out'}</li>
						<li>{l s='Separate billing and shipping addresses'}</li>
					</ul>
					<p>
						<input type="button" class="button_large" id="opc_createAccount" value="{l s='Create an account'}" />
					</p>
				</div>
				<div class="clear"></div>
			</div>
			</fieldset>
			<div id="opc_account_form">
			
			
			
				<script type="text/javascript">
				// <![CDATA[
				idSelectedCountry = {if isset($guestInformations) && $guestInformations.id_state}{$guestInformations.id_state|intval}{else}false{/if};
				{if isset($countries)}
					{foreach from=$countries item='country'}
						{if isset($country.states) && $country.contains_states}
							countries[{$country.id_country|intval}] = new Array();
							{foreach from=$country.states item='state' name='states'}
								countries[{$country.id_country|intval}].push({ldelim}'id' : '{$state.id_state}', 'name' : '{$state.name|escape:'htmlall':'UTF-8'}'{rdelim});
							{/foreach}
						{/if}
						{if $country.need_identification_number}
							countriesNeedIDNumber.push({$country.id_country|intval});
						{/if}	
						{if isset($country.need_zip_code)}
							countriesNeedZipCode[{$country.id_country|intval}] = {$country.need_zip_code};
						{/if}
					{/foreach}
				{/if}
				//]]>
				
				

	{literal}
	$(document).ready(function() {
	
		$('#company').blur(function(){
		
			vat_number();
		});
		vat_number();
		function vat_number()
		{
			if ($('#company').val() != '')
				{
				
				$('#vat_number_input').removeAttr("disabled");
				$('#vat_number').fadeTo('fast','1');
				$('#dni_number_input').removeAttr("disabled");
				$('#dni_number').fadeTo('fast','1');
				}
			else
				{
				$('#vat_number_input').attr("disabled","disabled");
				$('#vat_number').fadeTo('fast','0.3');
				$('#dni_number_input').attr("disabled","disabled");
				$('#dni_number').fadeTo('fast','0.3');
				}
		}
		
		
		$('#company_invoice').blur(function(){
		
			vat_number_invoice();
			
		});
		vat_number_invoice();
		function vat_number_invoice()
		{
			if ($('#company_invoice').val() != '')
				{
				
				$('#vat_number_invoice').removeAttr("disabled");
				$('#vat_number_invoice_p').fadeTo('fast','1');
				$('#dni_invoice').removeAttr("disabled");
				$('#dni_number_invoice_p').fadeTo('fast','1');
				}
			else
				{
				$('#vat_number_invoice').attr("disabled","disabled");
				$('#vat_number_invoice_p').fadeTo('fast','0.3');
				$('#dni_invoice').attr("disabled","disabled");
				$('#dni_number_invoice_p').fadeTo('fast','0.3');
				}
		}
		
		
		});
	
{/literal}

					
				</script>
				
				<!-- Error return block -->
				
				<div id="opc_account_errors" class="error" style="display:none;"></div>
				<!-- END Error return block -->
				<!-- Account -->
				<h3>{l s='Your credentials'}</h3>
				<input type="hidden" id="is_new_customer" name="is_new_customer" value="0" />
				<input type="hidden" id="delivery_provisional" value="" autocomplete="off"/>
				<input type="hidden" id="opc_id_customer" name="opc_id_customer" value="{if isset($guestInformations) && $guestInformations.id_customer}{$guestInformations.id_customer}{else}0{/if}" />
				<input type="hidden" id="opc_id_address_delivery" name="opc_id_address_delivery" value="{if isset($guestInformations) && $guestInformations.id_address_delivery}{$guestInformations.id_address_delivery}{else}0{/if}" />
				<input type="hidden" id="opc_id_address_invoice" name="opc_id_address_invoice" value="{if isset($guestInformations) && $guestInformations.id_address_delivery}{$guestInformations.id_address_delivery}{else}0{/if}" />
              <input type="text" class="text hide" name="passwd" id="passwd" value="{$password}"/> 
				<p class="required text">
					<label for="email">{l s='E-mail'}</label>
					<input type="text" class="text" id="email" name="email" value="{if isset($guestInformations) && $guestInformations.email}{$guestInformations.email}{/if}" />
					<sup>*</sup>
				</p>
				
					
					
					
				
				<p class="required text">
					<label for="firstname">{l s='First name'}</label>
					<input type="text" class="text" id="customer_firstname" name="customer_firstname" onblur="$('#firstname').val($(this).val());" value="{if isset($guestInformations) && $guestInformations.customer_firstname}{$guestInformations.customer_firstname}{/if}" />
					<sup>*</sup>
				</p>
				<p class="required text">
					<label for="lastname">{l s='Last name'}</label>
					<input type="text" class="text" id="customer_lastname" name="customer_lastname" onblur="$('#lastname').val($(this).val());" value="{if isset($guestInformations) && $guestInformations.customer_lastname}{$guestInformations.customer_lastname}{/if}" />
					<sup>*</sup>
				</p>
				
                <br class="clear" />
             
				
				<div id="address_toggle">
				<h3>{l s='Delivery address'}</h3>
				
				<p class="required text">
					<label for="firstname">{l s='First name'}</label>
					<input type="text" class="text" id="firstname" name="firstname" value="{if isset($guestInformations) && $guestInformations.firstname}{$guestInformations.firstname}{/if}" />
					<sup>*</sup>
				</p>
				<p class="required text">
					<label for="lastname">{l s='Last name'}</label>
					<input type="text" class="text" id="lastname" name="lastname" value="{if isset($guestInformations) && $guestInformations.lastname}{$guestInformations.lastname}{/if}" />
					<sup>*</sup>
				</p>
				<p class="required text">
					<label for="address1">{l s='Address'}</label>
					<input type="text" class="text" name="address1" id="address1" value="{if isset($guestInformations) && $guestInformations.address1}{$guestInformations.address1}{/if}" />
					<sup>*</sup>
				</p>
			
				<p class="required text">
					<label for="city">{l s='City'}</label>
					<input type="text" class="text" name="city" id="city" value="{if isset($guestInformations) && $guestInformations.city}{$guestInformations.city}{/if}" />
					<sup>*</sup>
				</p>
					<p class="required postcode text">
					<label for="postcode">{l s='Zip / Postal code'}</label>
					<input type="text" class="text" name="postcode" id="postcode" value="{if isset($guestInformations) && $guestInformations.postcode}{$guestInformations.postcode}{/if}" onkeyup="$('#postcode').val($('#postcode').val().toUpperCase());" />
					<sup>*</sup>
				</p>
		{if count($countries)>1}		
		<p class="required select">
			<label for="id_country">{l s='Country'}</label>
			<select id="id_country" name="id_country" >
			{foreach from=$countries item='country'}
			<option value="{$country.id_country}" {if isset($guestInformations) && $guestInformations.id_country==$country.id_country}selected='selected'{/if} >{$country.name}</option>
			{/foreach}
			</select>
			<sup>*</sup>
		</p>
		{else}
		{if count($countries)==1}
		
		<input type="hidden" name="id_country" id="id_country" value="{$countries[0].id_country}" />
		{/if}
		{/if}
		
	         <input type="hidden" name="address2" id="address2" value="" />
	         <input type="hidden" value="0"  name="id_state" id="id_state" />
					
					<input type="hidden" value="123456"  name="phone_mobile" id="phone_mobile" />
				<p class="required text">
					<label for="phone">{l s='Home phone'}</label>
					<input type="text" class="text" name="phone" id="phone" value="{if isset($guestInformations) && $guestInformations.phone}{$guestInformations.phone}{/if}" />
                     <sup>*</sup>
				</p>
				<p class="text">
					<label for="company">{l s='Company'}</label>
					<input type="text" class="text" id="company" name="company" value="{if isset($guestInformations) && $guestInformations.company}{$guestInformations.company}{/if}" />
				</p>
				
				<p id="vat_number" class="text">
				<label for="vat_number">{l s='VAT number'}</label>
				<input  title="{l s='Set the VAT number of your company.'}" id="vat_number_input" type="text" class="text" name="vat_number" value="{if isset($smarty.post.vat_number)}{$smarty.post.vat_number}{else}{if isset($address->vat_number)}{$address->vat_number|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			</p>
			
		
		<p class=" text " id="dni_number">
			<label for="dni">{l s='Identification number'}</label>
			<input  id="dni_number_input" title="{l s='Set the Company Identification Number.'}" type="text" class="text" name="dni" id="dni" value="{if isset($smarty.post.dni)}{$smarty.post.dni}{else}{if isset($address->dni)}{$address->dni|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			
		</p>
		</div><!-- END address toggle -->
				
				<input type="hidden" name="alias" id="alias" value="{l s='My address'}" />
				
				<p class="checkbox ">
					<input type="checkbox" name="invoice_address" id="invoice_address" />
					<label for="invoice_address">{l s='Please use another address for invoice'}</label>
				</p>
				<br class="clear" />
				<div id="opc_invoice_address" class="is_customer_param">
					<h3>{l s='Invoice address'}</h3>
					<p class="text">
						<label for="company_invoice">{l s='Company'}</label>
						<input type="text" class="text" id="company_invoice" name="company_invoice" value="" />
					</p>
					<p id="vat_number_invoice_p" class="text">
				<label for="vat_number_invoice">{l s='VAT number'}</label>
				<input  title="{l s='Set the VAT number of your company.'}" id="vat_number_invoice" type="text" class="text" name="vat_number_invoice" value="{if isset($smarty.post.vat_number)}{$smarty.post.vat_number}{else}{if isset($address->vat_number)}{$address->vat_number|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			</p>
		
		<p class="text " id="dni_number_invoice_p">
			<label for="dni">{l s='Identification number'}</label>
			<input   title="{l s='Set the Company Identification Number.'}" type="text" class="text" name="dni_invoice" id="dni_invoice" value="{if isset($smarty.post.dni)}{$smarty.post.dni}{else}{if isset($address->dni)}{$address->dni|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			
		</p>
					
					<p class="required text">
						<label for="firstname_invoice">{l s='First name'}</label>
						<input type="text" class="text" id="firstname_invoice" name="firstname_invoice" value="" />
						<sup>*</sup>
					</p>
					<p class="required text">
						<label for="lastname_invoice">{l s='Last name'}</label>
						<input type="text" class="text" id="lastname_invoice" name="lastname_invoice" value="" />
						<sup>*</sup>
					</p>
					<p class="required text">
						<label for="address1_invoice">{l s='Address'}</label>
						<input type="text" class="text" name="address1_invoice" id="address1_invoice" value="" />
						<sup>*</sup>
					</p>
					
					<p class="required postcode text">
						<label for="postcode_invoice">{l s='Zip / Postal Code'}</label>
						<input type="text" class="text" name="postcode_invoice" id="postcode_invoice" value="" onkeyup="$('#postcode').val($('#postcode').val().toUpperCase());" />
						<sup>*</sup>
					</p>
					<p class="required text">
						<label for="city_invoice">{l s='City'}</label>
						<input type="text" class="text" name="city_invoice" id="city_invoice" value="" />
						<sup>*</sup>
					</p>
						{if count($countries)>1}		
		<p class="required select">
			<label for="id_country_invoice">{l s='Country'}</label>
			<select id="id_country_invoice" name="id_country_invoice" >
			{foreach from=$countries item='country'}
			<option value="{$country.id_country}" {if isset($guestInformations) && $guestInformations.id_country==$country.id_country_invoice}selected='selected'{/if} >{$country.name}</option>
			{/foreach}
			</select>
			<sup>*</sup>
		</p>
		{else}
		{if count($countries)==1}
		
		<input type="hidden" name="id_country_invoice" id="id_country_invoice" value="{$countries[0].id_country}" />
		{/if}
		{/if}
					<input type="hidden" value="0"  name="id_state_invoice" id="id_state_invoice" />
					<input type="hidden" value="123456"  name="phone_mobile_invoice" id="phone_mobile_invoice" />
					<input type="hidden" name="address2_invoice" id="address2_invoice" value="" />
					
					
					<p class="text required">
						<label for="phone_invoice">{l s='Home phone'}</label>
						<input type="text" class="text" name="phone_invoice" id="phone_invoice" value="" /> <sup>*</sup>
					</p>
					
					
					<input type="hidden" name="alias_invoice" id="alias_invoice" value="{l s='My Invoice address'}" />
				</div><!-- END Invoice -->
				
				<p>
				
				<input type="submit"  name="submitAccount" id="submitAccount" value="{l s='Save'}" />
				<sup>*</sup>{l s='Required field'}
				</p>
				<p style="color: green;display: none;" id="opc_account_saved">
					{l s='Account informations saved successfully'}
				</p>
				<!-- END Account -->
			</div>
		
	</form>
	</td></tr></table>
	</div>
	<div class="clear"></div>
</div>
{literal}
  <script type="text/javascript" charset="utf-8">
  


		$(function() {
		
		
		if ($(".pickupstoreextra").length>0)
		{
		p=$('input[name="id_carrier"]:checked').parents('tr[id^="extra"]');
	if (p.length==1) {$('#address_toggle').slideUp('slow');
	val=p.find('input[id^="extraaddress"]').val();
	
	populateAddress(val,false);
	
	}
	if (p.length==0) {
	eraseAddress();
	$('#address_toggle').slideDown('slow');
	val=$("#delivery_provisional").val();
	
	}
	}
	
	
	
	function close_sliders(id)
	{
	names=$('.nadpis[id!="'+id+'"]');
	names.each(function(i,e)
	{
	$(e).addClass('closed');
	$(e).next().slideUp('slow');
	
	});
	
	}
	$(".nadpis").each(function(i,e)
	{
	
	$(e).bind('click',function()
	{
	
$.scrollTo({ top: '0px', left: '0px' }, 0);


	close_sliders($(e).attr('id'));
	if ($(e).attr('id')=="payment_toggler") AddressTrigger(null,true,false);
    
	$(e).removeClass('closed');
	$(e).next().slideDown('slow');
	});
	
	
	});
	
	
		if (isback) $('#payment_toggler').trigger('click');
		else $('#account_toggler').trigger('click');
		AddressTrigger(null,false,false);
		
		
		$("#opc_createAccount").trigger('click');
		});
		</script>
{/literal}
