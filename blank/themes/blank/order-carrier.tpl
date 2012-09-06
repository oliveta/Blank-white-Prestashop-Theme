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

{if !$opc}
	<script type="text/javascript">
	<!--
		var baseDir = '{$base_dir_ssl}';
	-->
	</script>
	<script type="text/javascript">
	var msg = "{l s='You must agree to the terms of service before continuing.' js=1}";
	{literal}
	function acceptCGV()
	{
		if ($('#cgv').length && !$('input#cgv:checked').length)
		{
			alert(msg);
			return false;
		}
		else
			return true;
	}
	{/literal}
	</script>
{/if}

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

{if !$opc}
{capture name=path}{l s='Shipping'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}
{/if}


{if !$opc}
{assign var='current_step' value='shipping'}
{if !$opc}<div class="table_block grid_12">{/if}

{include file="$tpl_dir./order-steps.tpl"}

{include file="$tpl_dir./errors.tpl"}

<form id="form" action="{$link->getPageLink('order.php', true)}" method="post">
{else}
 <div id="opc_delivery_methods-overlay" class="opc-overlay" style="display: none;"></div>
{/if}


<div id="opc_delivery_methods" class="opc-main-block">
{if !$opc}<h1 class="nadpis">4. {l s='Shipping'}</h1>{/if}
 {if $opc}<h1>2. {l s='Delivery methods'}</h1>{/if}
<div class="table-5">
{if $conditions AND $cms_id}
	<h2 class="condition_title">{l s='Terms of service'}</h2>
	<p class="checkbox">
		<input type="checkbox" name="cgv" id="cgv" value="1" {if $checkedTOS}checked="checked"{/if} />
		<label for="cgv">{l s='I agree to the terms of service and adhere to them unconditionally.'}</label> <a href="{$link_conditions}" class="iframe">{l s='(read)'}</a>
	</p>
	<script type="text/javascript">$('a.iframe').fancybox();</script>
{/if}
<div class="clear"></div>
{if $virtual_cart}
	<input id="input_virtual_carrier" class="hidden" type="hidden" name="id_carrier" value="0" />
{else}
	<h2 class="carrier_title">{l s='Choose your delivery method'}</h2>
	
	<div id="HOOK_BEFORECARRIER">{if isset($carriers)}{$HOOK_BEFORECARRIER}{/if}</div>
	{if isset($isVirtualCart) && $isVirtualCart}
	<p class="warning">{l s='No carrier needed for this order'}</p>
	{else}
	{if $recyclablePackAllowed}
	<p class="checkbox">
		<input type="checkbox" name="recyclable" id="recyclable" value="1" {if $recyclable == 1}checked="checked"{/if} />
		<label for="recyclable">{l s='I agree to receive my order in recycled packaging'}.</label>
	</p>
	{/if}
	<p class="warning" id="noCarrierWarning" {if (isset($carriers) && $carriers && count($carriers)) || !empty($HOOK_EXTRACARRIER)}style="display:none;"{/if}>
     {l s='There are no carriers available that deliver to this address.'}
    </p></div>
     <div class="clear"></div>
     <br />
     
	<table id="carrierTable" class="table-5 std" {if ( !isset($carriers) || !$carriers || !count($carriers)) && empty($HOOK_EXTRACARRIER)}style="display:none;"{/if}>
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
						<input type="radio" name="id_carrier" value="{$carrier.id_carrier|intval}" id="id_carrier{$carrier.id_carrier|intval}"  {if $opc}onclick="updateCarrierSelectionAndGift();"{/if} {if $carrier.id_carrier == $checked || $carriers|@count == 1}checked="checked"{/if}/>
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
		{$HOOK_EXTRACARRIER}
		</tbody>
	</table>
	<div style="display: none;" id="extra_carrier"></div>
	<div class="table-5">
		{if $giftAllowed}
       	<div class="clear" style="margin-bottom:1.5em"></div>
		<h2 class="gift_title">{l s='Gift'}</h2>
		<p class="checkbox">
			<input type="checkbox" name="gift" id="gift" value="1" {if $cart->gift == 1}checked="checked"{/if} onclick="$('#gift_div').toggle('slow');" />
			<label for="gift">{l s='I would like the order to be gift-wrapped.'}</label>
			<br />
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			{if $gift_wrapping_price > 0}
				({l s='Additional cost of'}
				<span class="price" id="gift-price">
					{if $priceDisplay == 1}{convertPrice price=$total_wrapping_tax_exc_cost}{else}{convertPrice price=$total_wrapping_cost}{/if}
				</span>
				{if $use_taxes}{if $priceDisplay == 1} {l s='(tax excl.)'}{else} {l s='(tax incl.)'}{/if}{/if})
			{/if}
		</p>
		
		{/if}
	{/if}
{/if}

{if !$opc}
	<p class="cart_navigation submit">
     <span>
		<input type="hidden" name="step" value="3" />
		<input type="hidden" name="back" value="{$back}" />
		<a href="{$link->getPageLink('order.php', true)}{if !$is_guest}?step=1{if $back}&back={$back}{/if}{/if}" title="{l s='Previous'}" class="button_large" >&laquo; {l s='Previous'}</a>
		<input style="display:none" type="submit" name="processCarrier" value="{l s='Next'} &raquo;" class="exclusive" />
	 <a id="submit_form" href="{$link->getPageLink('order.php', true)}?step=3{if $back}&amp;back={$back}{/if}" title="{l s='Next'}" class="continue upper cufon size3">{l s='Next'} &raquo;</a>
	 
	 </span>
    </p>
</form>
<div class="clearfix"></div>
{literal}
  
 <script type="text/javascript" charset="utf-8">

		$(function() {
		
        $("#submit_form").click(function()
        {
        if (acceptCGV())
        {
        $("#form").submit();
        }
        
        return false;
        });
     
    
      });
      </script>
{/literal}
{else}
	<h2>{l s='Leave a message'}</h2>
	<div>
		<label>{l s='If you would like to add a comment about your order, please write it below.'}</label>
		<p><textarea cols="120" rows="3" name="message" id="message">{if isset($oldMessage)}{$oldMessage}{/if}</textarea></p>
	</div>
{/if}
</div>
</div>
{if !$opc}</div>{/if}

</div>