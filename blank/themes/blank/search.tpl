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

{capture name=path}{l s='Search'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}

{if $where=="products"}

<div class="cms">
<div class="list_categorie_product extra_list_categorie_product">

<h1 {if isset($instantSearch) && $instantSearch}id="instant_search_results"{/if}>
{l s='Search'}&nbsp;{if $nbProducts > 0}"{if isset($search_query) && $search_query}{$search_query|escape:'htmlall':'UTF-8'}{elseif $search_tag}{$search_tag|escape:'htmlall':'UTF-8'}{elseif $ref}{$ref|escape:'htmlall':'UTF-8'}{/if}"{/if}
{if isset($instantSearch) && $instantSearch}<a href="#" class="close">{l s='Return to previous page'}</a>{/if}
</h1>

{include file="$tpl_dir./errors.tpl"}
{if !$nbProducts}
	<p class="warning">
		{if isset($search_query) && $search_query}
			{l s='No results found for your search'}&nbsp;"{if isset($search_query)}{$search_query|escape:'htmlall':'UTF-8'}{/if}"
		{elseif isset($search_tag) && $search_tag}
			{l s='No results found for your search'}&nbsp;"{$tag|escape:'htmlall':'UTF-8'}"
		{else}
			{l s='Please type a search keyword'}
		{/if}
	</p>
{else}
	<h3 style="margin-top:0; font-weight:normal; text-transform:uppercase; font-size:11px">
     <span class="big"></span>&nbsp;{if $nbProducts == 1}{l s='result has been found.'}{else}{l s='results have been found.'}{/if}
    {$nbProducts|intval}</h3>
	{if !isset($instantSearch) || (isset($instantSearch) && !$instantSearch)}{include file="$tpl_dir./product-sort.tpl"}{/if}
    <div class="clear"></div>
	{include file="$tpl_dir./product-list.tpl" products=$search_products}
	{if !isset($instantSearch) || (isset($instantSearch) && !$instantSearch)}{include file="$tpl_dir./pagination.tpl"}{/if}
{/if}
</div>
</div>
{else}
<div class=" cms{if $content_only} content_only{/if} odsad_cms">
<h1 {if isset($instantSearch) && $instantSearch}id="instant_search_results"{/if}>
{l s='Search'}&nbsp;{if count($cms_pages) > 0}"{if isset($search_query) && $search_query}{$search_query|escape:'htmlall':'UTF-8'}{elseif $search_tag}{$search_tag|escape:'htmlall':'UTF-8'}{elseif $ref}{$ref|escape:'htmlall':'UTF-8'}{/if}"{/if}
{if isset($instantSearch) && $instantSearch}<a href="#" class="close">{l s='Return to previous page'}</a>{/if}
</h1>

{if count($cms_pages)==0}
	<p class="warning">
		{if isset($search_query) && $search_query}
			{l s='No results found for your search'}&nbsp;"{if isset($search_query)}{$search_query|escape:'htmlall':'UTF-8'}{/if}"
		{elseif isset($search_tag) && $search_tag}
			{l s='No results found for your search'}&nbsp;"{$tag|escape:'htmlall':'UTF-8'}"
		{else}
			{l s='Please type a search keyword'}
		{/if}
	</p>
{else}
	<h3 style="margin-top:0; font-weight:normal; text-transform:uppercase; font-size:11px">
     <span class="big"></span>&nbsp;{if count($cms_pages) == 1}{l s='result has been found.'}{else}{l s='results have been found.'}{/if}
    {count($cms_pages)|intval}</h3>
{/if}


		{if isset($cms_pages) & !empty($cms_pages)}
		
		
		
		{foreach from=$cms_pages item=cmspages name="cms_pages"}
		
			{if $smarty.foreach.cms_pages.total<3}
		
					<div class="cms_post cms_search">
						<h1 class="title">{$cmspages->meta_title}</h1>
					   <div class="entry">
					   
					   {if isset($cmspages->image_medium) & !empty($cmspages->image_medium)}<div class="post_image_big"><img alt="{if empty($cmspages->alt)}{$cmspages->meta_title}{else}{$cmspages->alt}{/if}"  class="captify" src="{$cmspages->image_medium}" /></div>{/if}{$cmspages->content}
					
					</div>
					</div>
					{else}
		<div class="cms_post cms_search">
						<h2 class="title"><a class="permlink" href="{$link->getCMSLink($cmspages)}">{$cmspages->meta_title}</a></h2>
					   <div class="entry">
					    {if isset($cmspages->image_small) & !empty($cmspages->image_small)}<div class="post_image"><img src="{$cmspages->image_small}" /></div>{/if}{$cmspages->excerpt}
					</div>
					<div class="clear"></div>
					</div>
					{/if}
					
				{/foreach}
				{/if}
				</div>
{/if}
