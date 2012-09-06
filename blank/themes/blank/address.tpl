{*
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
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2011 PrestaShop SA
*  @version  Release: $Revision: 1.4 $
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

<script type="text/javascript">
// <![CDATA[
	var baseDir = '{$base_dir_ssl}';
//]]>
</script>

<script type="text/javascript">
// <![CDATA[
idSelectedCountry = {if isset($smarty.post.id_state)}{$smarty.post.id_state|intval}{elseif isset($address->id_state)}{$address->id_state|intval}{else}false{/if};
countries = new Array();
countriesNeedIDNumber = new Array();
countriesNeedZipCode = new Array();
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

$(function(){ldelim}
	$('.id_state option[value={if isset($smarty.post.id_state)}{$smarty.post.id_state}{else}{if isset($address->id_state)}{$address->id_state|escape:'htmlall':'UTF-8'}{/if}{/if}]').attr('selected', 'selected');
{rdelim});
{literal}
$(document).ready(function() {
	
	$("#add_update_adress input").height('20');
	$("#add_update_adress input.text").width('300');
	$("#add_update_adress label").height('22');
	
	$("#add_update_adress textarea").focus(function()
	{
	$(this).prev("p").addClass("focus");
	$(this).addClass("focus");
	});
	
	$("#add_update_adress textarea").blur(function()
	{
	$(this).prev("p").removeClass("focus");
	$(this).removeClass("focus");
	});
	});
	{/literal}
{if $vat_management}

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
		});
	
{/literal}
{/if}



//]]>
</script>

{capture name=path}{l s='Your addresses'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}
<div class="grid_12">
<h1 class="nadpis">{if isset($id_address)}{l s='Modify address'} {if isset($smarty.post.alias)}"{$smarty.post.alias}"{elseif isset($address->alias)}"{$address->alias|escape:'htmlall':'UTF-8'}"{/if}{else}{l s='To add a new address, please fill out the form below.'}{/if}</h1>

<div class="table-5"> 

{include file="$tpl_dir./errors.tpl"}

<div class="clearfix"></div>
<form action="{$link->getPageLink('address.php', true)}" method="post" class="std" id="add_update_adress">
	<fieldset>
		<h3>{if isset($id_address)}{l s='Your address'}{else}{l s='New address'}{/if}</h3>
		<p class="required text" id="adress_alias">
		<label class="name_label">{l s='Assign an address title for future reference'}</label>
			<input  class="text" title="{l s='Set the identificator for this address. The address will be stored under this name in your profile.'}" type="text" id="alias" name="alias" value="{if isset($smarty.post.alias)}{$smarty.post.alias}{elseif isset($address->alias)}{$address->alias|escape:'htmlall':'UTF-8'}{elseif isset($select_address)}{else}{l s='My address'}{/if}" style="width:364px" />
			<sup>*</sup>
		</p>
		<p class="text">
			<input type="hidden" name="token" value="{$token}" />
			<label for="company">{l s='Company'}</label>
			<input type="text"  class="text" title="{l s='Set the name of your company. If you do not have company (yet), just leave it blank.'}" id="company" name="company" value="{if isset($smarty.post.company)}{$smarty.post.company}{else}{if isset($address->company)}{$address->company|escape:'htmlall':'UTF-8'}{/if}{/if}" />
		</p>

		
			<p id="vat_number" class="text">
				<label for="vat_number">{l s='VAT number'}</label>
				<input  class="text" title="{l s='Set the VAT number of your company.'}" id="vat_number_input" type="text" name="vat_number" value="{if isset($smarty.post.vat_number)}{$smarty.post.vat_number}{else}{if isset($address->vat_number)}{$address->vat_number|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			</p>
		
		<p class="required text " id="dni_number">
			<label for="dni">{l s='Identification number'}</label>
			<input  class="text" id="dni_number_input" title="{l s='Set the Company Identification Number.'}" type="text"  name="dni" id="dni" value="{if isset($smarty.post.dni)}{$smarty.post.dni}{else}{if isset($address->dni)}{$address->dni|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			
		</p>
		<p class="required text">
			<label for="firstname">{l s='First name'}</label>
			<input type="text" name="firstname"  class="text" title="{l s='Your first name. We will need it in order to send your order to you and not to your brother.'}" id="firstname" value="{if isset($smarty.post.firstname)}{$smarty.post.firstname}{else}{if isset($address->firstname)}{$address->firstname|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			<sup>*</sup>
		</p>
		<p class="required text">
			<label for="lastname">{l s='Last name'}</label>
			<input type="text" id="lastname"  class="text" title="{l s='Your last name. In case that you are keen on your middle names you can put them here as well.'}" name="lastname" value="{if isset($smarty.post.lastname)}{$smarty.post.lastname}{else}{if isset($address->lastname)}{$address->lastname|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			<sup>*</sup>
		</p>
       <p class="required text">
			<label for="address1">{l s='Address'}</label>
			<input type="text"  class="text" title="{l s='This is the point where it is starting to be tricky. Can you remember the name of the street and the number of the house where you live?'}" id="address1" name="address1" value="{if isset($smarty.post.address1)}{$smarty.post.address1}{else}{if isset($address->address1)}{$address->address1|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			<sup>*</sup>
		</p>
			<p class="required postcode text">
			<label for="postcode">{l s='Zip / Postal Code'}</label>
			<input type="text"  class="text" title="{l s='We are really sorry, but you need to fill in this most difficult entry. If you miss, there is still hope that the city might be right.'}" id="postcode" name="postcode" value="{if isset($smarty.post.postcode)}{$smarty.post.postcode}{else}{if isset($address->postcode)}{$address->postcode|escape:'htmlall':'UTF-8'}{/if}{/if}" onkeyup="$('#postcode').val($('#postcode').val().toUpperCase());" />
			<sup>*</sup>
		</p>
		<p class="required text">
			<label for="city">{l s='City'}</label>
			<input type="text" name="city"  class="text" title="{l s='Last in your address but not least for the postman.'}" id="city" value="{if isset($smarty.post.city)}{$smarty.post.city}{else}{if isset($address->city)}{$address->city|escape:'htmlall':'UTF-8'}{/if}{/if}" maxlength="64" />
			<sup>*</sup>
		</p>
		
			{if count($countries)>1}		
		<p class="required select">
			<label for="id_country">{l s='Country'}</label>
			<select id="id_country" name="id_country" >
			{foreach from=$countries item='country'}
			<option value="{$country.id_country}" {if $smarty.post.id_country==$country.id_country || $address->id_country==$country.id_country}selected='selected'{/if} >{$country.name}</option>
			{/foreach}
			</select>
			<sup>*</sup>
		</p>
		{else}
		{if count($countries)==1}
		
		<input type="hidden" name="id_country" id="id_country" value="{$countries[0].id_country}" />
		{/if}
		{/if}
		
		<p class="textarea">
			<p for="other" style="background:#EEEEEE;padding:6px;margin:0;width:363px">{l s='Additional information'}</p>
			<textarea  class="text" title="{l s='This is absolutly unnecessary but if you have something in mind, please do not be afraid to write it.'}"  id="other" name="other" cols="26" rows="3"  style="width:367px">{if isset($smarty.post.other)}{$smarty.post.other}{else}{if isset($address->other) && $address->other!="undefined"}{$address->other|escape:'htmlall':'UTF-8'}{/if}{/if}</textarea>
		</p>
		<p>{l s='You must register at least one phone number'} <sup style="color:red;">*</sup></p>
		<p class="text">
			<label for="phone">{l s='Home phone'}</label>
			<input type="text"  class="text" title="{l s='We know that this is your privacy but your phone number will allow us to reach you when your order will be arriving to you.'}" id="phone" name="phone" value="{if isset($smarty.post.phone)}{$smarty.post.phone}{else}{if isset($address->phone)}{$address->phone|escape:'htmlall':'UTF-8'}{/if}{/if}" />
		</p>
		<p class="text">
			<label for="phone_mobile">{l s='Mobile phone'}</label>
			<input type="text"  class="text" title="{l s='So you have a mobile phone as well, huh? Cool!'}" id="phone_mobile" name="phone_mobile" value="{if isset($smarty.post.phone_mobile)}{$smarty.post.phone_mobile}{else}{if isset($address->phone_mobile)}{$address->phone_mobile|escape:'htmlall':'UTF-8'}{/if}{/if}" />
		</p>
	</fieldset>
	<p>
		{if isset($id_address)}<input type="hidden" name="id_address" value="{$id_address|intval}" />{/if}
		{if isset($back)}<input type="hidden" name="back" value="{$back}?step=1" />{/if}
		{if isset($mod)}<input type="hidden" name="mod" value="{$mod}" />{/if}
		{if isset($select_address)}<input type="hidden" name="select_address" value="{$select_address|intval}" />{/if}
		<input type="submit" name="submitAddress" id="submitaddress" value="{l s='Save'}" />
	<span class="required"><sup>*</sup>{l s='Required field'}</span>
	</p>
</form>
</div>
</div>
