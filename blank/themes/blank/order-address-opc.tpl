{*
* 2007-2012 PrestaShop
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
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2012 PrestaShop SA
*  @version  Release: $Revision: 14430 $
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{if $opc}
	{assign var="back_order_page" value="order-opc.php"}
{else}
	{assign var="back_order_page" value="order.php"}
{/if}

{*
** Retro compatibility for PrestaShop version < 1.4.2.5 with a recent theme
** Syntax smarty for v2
*}

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
	
	<h1 id="account_toggler" class="nadpis">2. {l s='Your credentials'}<p> <span id="" class="big">{l s='Address is correct'}</span></p></h1>
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




<h2>{l s='Addresses'}</h2>


<div id="opc_account" class="">
	<div id="opc_account-overlay" class="opc-overlay" style="display:none;"></div>

	<div class="addresses">
		<p class="address_delivery select">
			<label for="id_address_delivery">{l s='Choose a delivery address:'}</label>
			<select name="id_address_delivery" id="id_address_delivery" class="address_select" onchange="updateAddressesDisplay();{if $opc}updateAddressSelection();{/if}">

			{foreach from=$addresses key=k item=address}
				<option value="{$address.id_address|intval}" {if $address.id_address == $cart->id_address_delivery}selected="selected"{/if}>{$address.alias|escape:'htmlall':'UTF-8'}</option>
			{/foreach}
			
			</select>
		</p>
		<p class="checkbox" {if $cart->isVirtualCart()}style="display:none;"{/if}>
			<input type="checkbox" name="same" id="addressesAreEquals" value="1" onclick="updateAddressesDisplay();{if $opc}updateAddressSelection();{/if}" {if $cart->id_address_invoice == $cart->id_address_delivery || $addresses|@count == 1}checked="checked"{/if} />
			<label for="addressesAreEquals">{l s='Use the same address for billing.'}</label>
		</p>
		
		<p id="address_invoice_form" class="select" {if $cart->id_address_invoice == $cart->id_address_delivery}style="display: none;"{/if}>
		
		{if $addresses|@count > 1}
			<label for="id_address_invoice" class="strong">{l s='Choose a billing address:'}</label>
			<select name="id_address_invoice" id="id_address_invoice" class="address_select" onchange="updateAddressesDisplay();{if $opc}updateAddressSelection();{/if}">
			{section loop=$addresses step=-1 name=address}
				<option value="{$addresses[address].id_address|intval}" {if $addresses[address].id_address == $cart->id_address_invoice && $cart->id_address_delivery != $cart->id_address_invoice}selected="selected"{/if}>{$addresses[address].alias|escape:'htmlall':'UTF-8'}</option>
			{/section}
			</select>
			{else}
				<a style="margin-left: 221px;" href="{$link->getPageLink('address.php', true)}?back={$back_order_page}?step=1&select_address=1{if $back}&mod={$back}{/if}" title="{l s='Add'}" class="button_large">{l s='Add a new address'}</a>
			{/if}
		</p>
		<div class="clear"></div>
		<ul class="address item" id="address_delivery" {if $cart->isVirtualCart()}style="display:none;"{/if}>
		</ul>
		<ul class="address alternate_item {if $cart->isVirtualCart()}full_width{/if}" id="address_invoice">
		</ul>
		<br class="clear" />
		<p class="address_add submit">
			<a href="{$link->getPageLink('address.php', true)}?back={$back_order_page}?step=1{if $back}&mod={$back}{/if}" title="{l s='Add'}" class="button_large">{l s='Add a new address'}</a>
		</p>
		
	</div>

</div>


</td></tr></table>
</div>
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
		
		});
		</script>
{/literal}