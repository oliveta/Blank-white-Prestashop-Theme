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

{include file="$tpl_dir./breadcrumb.tpl"}
{include file="$tpl_dir./errors.tpl"}

<div class="cms" style="clear:both">
<h1 style="padding-top:1.2em">{l s='Product Comparison'}</h1>

{if $hasProduct}
<div class="products_block">
	<table id="product_comparison">
			<td width="20%"></td>
			{assign var='taxes_behavior' value=false}
			{if $use_taxes && (!$priceDisplay  || $priceDisplay == 2)}
				{assign var='taxes_behavior' value=true}
			{/if}
		{foreach from=$products item=product name=for_products}
			{assign var='replace_id' value=$product->id|cat:'|'}

			<td width="{$width}%" class="ajax_block_product comparison_infos">
			<div class="inner">
				<h5 style="height:45px"><a href="{$product->getLink()}" title="{$product->name|truncate:32:'...'|escape:'htmlall':'UTF-8'}">{$product->name|truncate:45:'...'|escape:'htmlall':'UTF-8'}</a></h5>
				<div class="product_desc"><a href="{$product->getLink()}" title="{l s='More'}">{$product->description_short|strip_tags|truncate:130:'...'}</a></div>
				<a href="{$product->getLink()|escape:'htmlall':'UTF-8'}" class="product_img_link" title="{$product->name|escape:'htmlall':'UTF-8'}">
           <img src="{$link->getImageLink($product->link_rewrite, $product->id_image, 'large')}" alt="{$product->legend|escape:'htmlall':'UTF-8'}" {if isset($homeSize)} width="{$homeSize.width}" height="{$homeSize.height}"{/if} />
          </a>
				<div class="comparison_product_infos">
				
				{if isset($product->show_price) && $product->show_price && !isset($restricted_country_mode) && !$PS_CATALOG_MODE}
					<p class="price_container"><span class="price">{convertPrice price=$product->getPrice($taxes_behavior)}</span></p>
					<div class="product_discount">
					{if $product->on_sale}
						<span class="new_product"><strong>{l s='On sale!'}</strong></span>
					{elseif $product->specificPrice AND $product->specificPrice.reduction}
						<span class="discount">{l s='Reduced price!'}</span>
					{/if}
					</div>

					{if !empty($product->unity) && $product->unit_price_ratio > 0.000000}
						    {math equation="pprice / punit_price"  pprice=$product->getPrice($taxes_behavior)  punit_price=$product->unit_price_ratio assign=unit_price}
						<p class="comparison_unit_price">{convertPrice price=$unit_price} {l s='per'} {$product->unity|escape:'htmlall':'UTF-8'}</p>
					{else}
					&nbsp;
					{/if}
				{/if}
				<!-- availability -->
				
					<a class="cmp_remove" href="{$request_uri|replace:$replace_id:''}">{l s='Remove'}</a>
					<a class="button" href="{$product->getLink()}" title="{l s='View'}">{l s='View'}</a>
					{if (!$product->hasAttributes() OR (isset($add_prod_display) AND ($add_prod_display == 1))) AND !$PS_CATALOG_MODE}
						{if ($product->quantity > 0 OR $product->allow_oosp) AND $product->customizable != 2}
							<a class="ajax_add_to_cart_button exclusive " rel="ajax_id_product_{$product->id}" href="{$base_dir}cart.php?qty=1&amp;id_product={$product->id}&amp;token={$static_token}&amp;add" title="{l s='Add to cart'}">{l s='Add to cart'}</a>
						{else}
							<span class="exclusive">{l s='Add to cart'}</span>
						{/if}
					{else}
						<div style="height:23px;"></div>
					{/if}
				</div>
				</div>
			</td>
		{/foreach}
		</tr>

		<tr class="comparison_header">
			<td>
				{l s='Features'}
			</td>
			{section loop=$products|count step=1 start=0 name=td}
			<td></td>
			{/section}
		</tr>
		<tr>
		<td class="comparison_feature_even">
				Hmotnost
				
				
			</td>
		{foreach from=$products item=product name=for_products}
		<td  width="{$width}%" class="comparison_feature_even comparison_infos">
		{$product->weight} kg
		</td>
			{/foreach}
		</tr>

		{if $ordered_features}
		{foreach from=$ordered_features item=feature}
		<tr>
		
			
			
			{cycle values='comparison_feature_odd,comparison_feature_even' assign='classname'}
			<td class="{$classname}" >
				{$feature.name|escape:'htmlall':'UTF-8'}
			</td>

				{foreach from=$products item=product name=for_products}
					{assign var='product_id' value=$product->id}
					{assign var='feature_id' value=$feature.id_feature}
					
					{if  isset($product_features[$product_id])}
					{assign var='tab' value=$product_features[$product_id]}
					{else}
					{assign var='tab' value=0}
					{/if}
					<td  width="{$width}%" class="{$classname} comparison_infos">
					{if isset($tab) & isset($tab[$feature_id]) & $tab[$feature_id]!=''}
					{$tab[$feature_id]|escape:'htmlall':'UTF-8'}
					{else}
					-
					{/if}
					</td>
				{/foreach}
		</tr>
		{/foreach}
		{else}
			<tr>
				<td></td>
				<td colspan="{$products|@count + 1}">{l s='No features to compare'}</td>
			</tr>
		{/if}

		{$HOOK_EXTRA_PRODUCT_COMPARISON}
	</table>
</div>
{else}
	<p class="warning">{l s='There is no product in the comparator'}</p>
{/if}
</div>
</div>

