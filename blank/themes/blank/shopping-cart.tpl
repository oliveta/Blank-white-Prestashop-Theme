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


{capture name=path}{l s='Your shopping cart'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}

{assign var='current_step' value="summary"}

<div id="shopping_cart_show" class="grid_12">
{include file="$tpl_dir./order-steps.tpl"}
<h1 id="cart_title" class="nadpis">{l s='1. Shopping cart summary'}<p><span id="summary_products_quantity">{if !isset($empty)}{$productNumber} {if $productNumber == 1}{l s='product'}{elseif $productNumber > 1 & $productNumber < 5}{l s='productss'}{else}{l s='products'}{/if}{/if}</span> <span id="" class="big total_price">{if !isset($empty)}{displayPrice price=$total_price}{/if}</span></p></h1>
<div  id="shopping_cart_slide">
<div id="center_column">
{if isset($empty)}
<div class="table-5">
	<p class="warning">{l s='Your shopping cart is empty.'}</p></div>
{elseif $PS_CATALOG_MODE}
	<p class="warning">{l s='This store has not accepted your new order.'}</p>
{else}
	<script type="text/javascript">
	// <![CDATA[
	var baseDir = '{$base_dir_ssl}';
	var currencySign = '{$currencySign|html_entity_decode:2:"UTF-8"}';
	var currencyRate = '{$currencyRate|floatval}';
	var currencyFormat = '{$currencyFormat|intval}';
	var currencyBlank = '{$currencyBlank|intval}';
	var txtProduct = "{l s='product'}";
	var txtProducts = "{l s='products'}";
	{if $smarty.get.isPaymentStep}
	var isback=true;
	{else}
	var isback=false;
	{/if}
	
	// ]]>
	</script>
	<div class="table-5" id="emptyCartWarning"  style="display:none"  ><p class="warning ">{l s='Your shopping cart is empty.'}</p></div>
{if isset($lastProductAdded) AND $lastProductAdded}
	{foreach from=$products item=product}
		{if $product.id_product == $lastProductAdded.id_product AND (!$product.id_product_attribute OR ($product.id_product_attribute == $lastProductAdded.id_product_attribute))}
			<div class="cart_last_product" style="display:none">
				<div class="cart_last_product_header">
					<div class="left">{l s='Last added product'}</div>
				</div>
				<a  class="cart_last_product_img" href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category)|escape:'htmlall':'UTF-8'}"><img src="{$link->getImageLink($product.link_rewrite, $product.id_image, 'small')}" alt="{$product.name|escape:'htmlall':'UTF-8'}"/></a>
				<div class="cart_last_product_content">
					<h5><a href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category)|escape:'htmlall':'UTF-8'}">{$product.name|escape:'htmlall':'UTF-8'}</a></h5>
					{if isset($product.attributes) && $product.attributes}<a href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category)|escape:'htmlall':'UTF-8'}">{$product.attributes|escape:'htmlall':'UTF-8'}</a>{/if}
				</div>
				<br class="clear" />
			</div>
		{/if}
	{/foreach}
{/if}

{if $voucherAllowed}

<div id="cart_voucher" class="table_block">
	{if isset($errors) && $errors}
	<div class="error_label">
	{l s='There has been the following errors:'}</div>
		<ul class="error">
		{foreach from=$errors key=k item=error}
			<li>{$error}</li>
		{/foreach}
		</ul>
	{/if}
	<form action="{if $opc}{$link->getPageLink('order-opc.php', true)}{else}{$link->getPageLink('order.php', true)}{/if}" method="post" id="voucher">
		<fieldset>
			<h4 class="cufon upper">{l s='Voucher: '}</h4>
			<p>
				
				<input type="text" id="discount_name" name="discount_name" class="voucher_code" value="{if isset($discount_name) && $discount_name}{$discount_name}{/if}" />
			</p>
			<p class="submit"><input type="hidden" name="submitDiscount" /><input type="submit" name="submitAddDiscount" value="{l s='Add'}" class="voucher_submit" style="border:none; padding:7px;background-color:#658799; color:#ffffff; text-transform:uppercase" /></p>
		
		</fieldset>
	</form>
</div>
{/if}

    <table id="cart_summary" class="std table-5">
		<thead>
			<tr>
				<th class="cart_product first_item">{l s='Product'}</th>
				<th class="cart_description item">{l s='Description'}</th>
				
				<th class="cart_availability item">{l s='Avail.'}</th>
				<th class="cart_unit item">{l s='Unit price'}</th>
				<th class="cart_quantity item">{l s='Qty'}</th>
				<th class="cart_total last_item">{l s='Total'}</th>
			</tr>
		</thead>
		<tfoot>
			{if $use_taxes}
				{if $priceDisplay}
					<tr class="cart_total_price">
						<td colspan="5">{l s='Total products (tax excl.):'}</td>
						<td class="price" id="total_product">{displayPrice price=$total_products}</td>
					</tr>
				{else}
					<tr class="cart_total_price">
						<td colspan="5">{l s='Total products (tax incl.):'}</td>
						<td class="price" id="total_product">{displayPrice price=$total_products_wt}</td>
					</tr>
				{/if}
			{else}
				<tr class="cart_total_price">
					<td colspan="5">{l s='Total products:'}</td>
					<td class="price" id="total_product">{displayPrice price=$total_products}</td>
				</tr>
			{/if}
			<tr class="cart_total_voucher" {if $total_discounts == 0}style="display: none;"{/if}>
				<td colspan="5">
				{if $use_taxes}
					{if $priceDisplay}
						{l s='Total vouchers (tax excl.):'}
					{else}
						{l s='Total vouchers (tax incl.):'}
					{/if}
				{else}
					{l s='Total vouchers:'}
				{/if}
				</td>
				<td class="price-discount" id="total_discount">
				{if $use_taxes}
					{if $priceDisplay}
						{displayPrice price=$total_discounts_tax_exc}
					{else}
						{displayPrice price=$total_discounts}
					{/if}
				{else}
					{displayPrice price=$total_discounts_tax_exc}
				{/if}
				</td>
			</tr>
			<tr class="cart_total_voucher" {if $total_wrapping == 0}style="display: none;"{/if}>
				<td colspan="5">
				{if $use_taxes}
					{if $priceDisplay}
						{l s='Total gift-wrapping (tax excl.):'}
					{else}
						{l s='Total gift-wrapping (tax incl.):'}
					{/if}
				{else}
					{l s='Total gift-wrapping:'}
				{/if}
				</td>
				<td class="price-discount" id="total_wrapping">
				{if $use_taxes}
					{if $priceDisplay}
						{displayPrice price=$total_wrapping_tax_exc}
					{else}
						{displayPrice price=$total_wrapping}
					{/if}
				{else}
					{displayPrice price=$total_wrapping_tax_exc}
				{/if}
				</td>
			</tr>
			{if $use_taxes}
				{if $priceDisplay}
					<tr class="cart_total_delivery" {if $shippingCost <= 0} style="display:none;"{/if}>
						<td colspan="5">{l s='Total shipping (tax excl.):'}</td>
						<td class="price" id="total_shipping">{displayPrice price=$shippingCostTaxExc}</td>
					</tr>
				{else}
					<tr class="cart_total_delivery"{if $shippingCost <= 0} style="display:none;"{/if}>
						<td colspan="5">{l s='Total shipping (tax incl.):'}</td>
						<td class="price" id="total_shipping" >{displayPrice price=$shippingCost}</td>
					</tr>
				{/if}
			{else}
				<tr class="cart_total_delivery"{if $shippingCost <= 0} style="display:none;"{/if}>
					<td colspan="5">{l s='Total shipping:'}</td>
					<td class="price" id="total_shipping" >{displayPrice price=$shippingCostTaxExc}</td>
				</tr>
			{/if}

			{if $use_taxes}
			<tr class="cart_total_price">
				<td colspan="5">{l s='Total (tax excl.):'}</td>
				<td class="price" id="total_price_without_tax">{displayPrice price=$total_price_without_tax}</td>
			</tr>
			<tr class="cart_total_tax">
				<td colspan="5">{l s='Total tax:'}</td>
				<td class="price" id="total_tax">{displayPrice price=$total_tax}</td>
			</tr>
			<tr class="cart_total_price">
				<td colspan="5">{l s='Total (tax incl.):'}</td>
				<td class="price" ><span class="total_price">{displayPrice price=$total_price}</span></td>
			</tr>
			{else}
			<tr class="cart_total_price">
				<td colspan="5">{l s='Total:'}</td>
				<td class="price"><span class="total_price">{displayPrice price=$total_price_without_tax}</span></td>
			</tr>
			{/if}
			
		</tfoot>
		<tbody>
		{foreach from=$products item=product name=productLoop}
			{assign var='productId' value=$product.id_product}
			{assign var='productAttributeId' value=$product.id_product_attribute}
			{assign var='quantityDisplayed' value=0}
			{assign var='index' value=$smarty.foreach.productLoop.index}
			{* Display the product line *}
			{include file="$tpl_dir./shopping-cart-product-line.tpl"}
			{* Then the customized datas ones*}
			{if isset($customizedDatas.$productId.$productAttributeId)}
				{foreach from=$customizedDatas.$productId.$productAttributeId key='id_customization' item='customization'}
					<tr id="product_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}" class="alternate_item cart_item">
						<td colspan="5">
							{foreach from=$customization.datas key='type' item='datas'}
								{if $type == $CUSTOMIZE_FILE}
									<div class="customizationUploaded">
										<ul class="customizationUploaded">
											{foreach from=$datas item='picture'}<li><img src="{$pic_dir}{$picture.value}_small" alt="" class="customizationUploaded" /></li>{/foreach}
										</ul>
									</div>
								{elseif $type == $CUSTOMIZE_TEXTFIELD}
									<ul class="typedText">
										{foreach from=$datas item='textField' name='typedText'}<li>{if $textField.name}{$textField.name}{else}{l s='Text #'}{$smarty.foreach.typedText.index+1}{/if}{l s=':'} {$textField.value}</li>{/foreach}
									</ul>
								{/if}
							{/foreach}
						</td>
						<td class="cart_quantity">
							<div style="float:right">
								<a rel="nofollow" class="cart_quantity_delete" id="{$product.id_product}_{$product.id_product_attribute}_{$id_customization}" href="{$link->getPageLink('cart.php', true)}?delete&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_customization={$id_customization}&amp;token={$token_cart}"><img src="{$img_dir}icon/delete.gif" alt="{l s='Delete'}" title="{l s='Delete this customization'}" width="11" height="13" class="icon" /></a>
							</div>
							<div id="cart_quantity_button" style="float:left">
							<a rel="nofollow" class="cart_quantity_up" id="cart_quantity_up_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}" href="{$link->getPageLink('cart.php', true)}?add&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_customization={$id_customization}&amp;token={$token_cart}" title="{l s='Add'}"><img src="{$img_dir}icon/quantity_up.gif" alt="{l s='Add'}" width="14" height="9" /></a><br />
							{if $product.minimal_quantity < ($customization.quantity -$quantityDisplayed) OR $product.minimal_quantity <= 1}
							<a rel="nofollow" class="cart_quantity_down" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}" href="{$link->getPageLink('cart.php', true)}?add&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_customization={$id_customization}&amp;op=down&amp;token={$token_cart}" title="{l s='Subtract'}">
								<img src="{$img_dir}icon/quantity_down.gif" alt="{l s='Subtract'}" width="14" height="9" />
							</a>
							{else}
							<a class="cart_quantity_down" style="opacity: 0.3;" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}" href="#" title="{l s='Subtract'}">
								<img src="{$img_dir}icon/quantity_down.gif" alt="{l s='Subtract'}" width="14" height="9" />
							</a>
							{/if}
							</div>
							<input type="hidden" value="{$customization.quantity}" name="quantity_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}_hidden"/>
							<input size="2" type="text" value="{$customization.quantity}" class="cart_quantity_input" name="quantity_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}"/>
						</td>
						<td class="cart_total"></td>
					</tr>
					{assign var='quantityDisplayed' value=$quantityDisplayed+$customization.quantity}
				{/foreach}
				{* If it exists also some uncustomized products *}
				{if $product.quantity-$quantityDisplayed > 0}{include file="$tpl_dir./shopping-cart-product-line.tpl"}{/if}
			{/if}
		{/foreach}
		</tbody>
	{if sizeof($discounts)}
		<tbody>
		{foreach from=$discounts item=discount name=discountLoop}
			<tr class="cart_discount {if $smarty.foreach.discountLoop.last}last_item{elseif $smarty.foreach.discountLoop.first}first_item{else}item{/if}" id="cart_discount_{$discount.id_discount}">
				<td class="cart_discount_name" colspan="2">{$discount.name}</td>
				<td class="cart_discount_description" colspan="3">{$discount.description}</td>
				<td class="cart_discount_delete"><a href="{if $opc}{$link->getPageLink('order-opc.php', true)}{else}{$link->getPageLink('order.php', true)}{/if}?deleteDiscount={$discount.id_discount}" title="{l s='Delete'}"><img src="{$img_dir}icon/delete.gif" alt="{l s='Delete'}" class="icon" width="11" height="13" /></a></td>
				<td class="cart_discount_price"><span class="price-discount">
					{if $discount.value_real > 0}
						{if !$priceDisplay}{displayPrice price=$discount.value_real*-1}{else}{displayPrice price=$discount.value_tax_exc*-1}{/if}
					{/if}
				</span></td>
			</tr>
		{/foreach}
		</tbody>
	{/if}
	</table>
	
	
<div class="table-5">

<div id="HOOK_SHOPPING_CART">{$HOOK_SHOPPING_CART}</div>
{if (($carrier->id AND !isset($virtualCart)) OR $delivery->id OR $invoice->id) AND !$opc}
<div class="order_delivery">
	{if $delivery->id}
	<ul id="delivery_address" class="address item">
		<li class="address_title">{l s='Delivery address'}</li>
		{if $delivery->company}<li class="address_company">{$delivery->company|escape:'htmlall':'UTF-8'}</li>{/if}
		<li class="address_name">{$delivery->firstname|escape:'htmlall':'UTF-8'} {$delivery->lastname|escape:'htmlall':'UTF-8'}</li>
		<li class="address_address1">{$delivery->address1|escape:'htmlall':'UTF-8'}</li>
		{if $delivery->address2}<li class="address_address2">{$delivery->address2|escape:'htmlall':'UTF-8'}</li>{/if}
		<li class="address_city">{$delivery->postcode|escape:'htmlall':'UTF-8'} {$delivery->city|escape:'htmlall':'UTF-8'}</li>
		<li class="address_country">{$delivery->country|escape:'htmlall':'UTF-8'} {if $delivery_state}({$delivery_state|escape:'htmlall':'UTF-8'}){/if}</li>
	</ul>
	{/if}
	{if $invoice->id}
	<ul id="invoice_address" class="address alternate_item">
		<li class="address_title">{l s='Invoice address'}</li>
		{if $invoice->company}<li class="address_company">{$invoice->company|escape:'htmlall':'UTF-8'}</li>{/if}
		<li class="address_name">{$invoice->firstname|escape:'htmlall':'UTF-8'} {$invoice->lastname|escape:'htmlall':'UTF-8'}</li>
		<li class="address_address1">{$invoice->address1|escape:'htmlall':'UTF-8'}</li>
		{if $invoice->address2}<li class="address_address2">{$invoice->address2|escape:'htmlall':'UTF-8'}</li>{/if}
		<li class="address_city">{$invoice->postcode|escape:'htmlall':'UTF-8'} {$invoice->city|escape:'htmlall':'UTF-8'}</li>
		<li class="address_country">{$invoice->country|escape:'htmlall':'UTF-8'} {if $invoice_state}({$invoice_state|escape:'htmlall':'UTF-8'}){/if}</li>
	</ul>
	{/if}
	
</div>
{/if}
<div class="clear"></div>
<p class="cart_navigation ">
	<a href="{$link->getPageLink('index.php')}" class="button_large" title="{l s='Continue shopping'}" style="padding:5px 7px 5px 7px;">&laquo; {l s='Continue shopping'}</a>
	{if !$opc}<a href="{$link->getPageLink('order.php', true)}?step=1{if $back}&amp;back={$back}{/if}" title="{l s='Next'}" class="continue upper cufon size3">{l s='Next'} &raquo;</a>{/if}
</p>
<p class="clear"></p>
<p class="cart_navigation">
	<span id="HOOK_SHOPPING_CART_EXTRA">{$HOOK_SHOPPING_CART_EXTRA}</span>
</p>
</div>
{/if}

</div>
</div>
</div>
