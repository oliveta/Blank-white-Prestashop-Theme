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

		
		
{if isset($cms) && !isset($category)}
{if $cms->id != $cgv_id}
	{include file="$tpl_dir./breadcrumb.tpl"}
{/if}
	{if !$cms->active}
		<div id="admin-action-cms">
			<p>{l s='This CMS page is not visible to your customers.'}
			<input type="hidden" id="admin-action-cms-id" value="{$cms->id}" />
			<input type="submit" value="{l s='Publish'}" class="exclusive" onclick="submitPublishCMS('{$base_dir}{$smarty.get.ad}', 0)"/>			
			<input type="submit" value="{l s='Back'}" class="exclusive" onclick="submitPublishCMS('{$base_dir}{$smarty.get.ad}', 1)"/>			
			</p>
			<div class="clear" ></div>
			<p id="admin-action-result"></p>
			
		</div>
	{else}
	<div class="cms{if $content_only} content_only{/if} grid_12">
		<div class="cms_post">
		<h1 class="title">{$cms->meta_title}</h1>
		<div class="entry">
		
		 {if isset($cms->image_medium) & !empty($cms->image_medium)}
		 <div class="post_image_big"><img class="captify" src="{$cms->image_medium}" alt="{if empty($cms->alt)}{$cms->meta_title}{else}{$cms->alt}{/if}" /></div>
		 {/if}
		
		 
		{$cms->content}
		</div></div>
	</div>
	{/if}

{elseif isset($category)}{include file="$tpl_dir./breadcrumb.tpl"}
	<div class=" cms{if $content_only} content_only{/if} grid_12">
		{if isset($cms_pages) & !empty($cms_pages)}
		
		
		
		{foreach from=$cms_pages item=cmspages name="cms_pages"}
		
			{if $smarty.foreach.cms_pages.total<3}
		
					<div class="cms_post">
						<h1 class="title">{$cmspages->meta_title}</h1>
					   <div class="entry ">
					   
					   {if isset($cmspages->image_medium) & !empty($cmspages->image_medium)}<div class="post_image_big"><img alt="{if empty($cmspages->alt)}{$cmspages->meta_title}{else}{$cmspages->alt}{/if}"  class="captify" src="{$cmspages->image_medium}" /></div>{/if}{$cmspages->content}
					
					</div>
					</div>
					{else}
		<div class="cms_post hover">
						<h2 class="title"><a class="permlink" href="{$link->getCMSLink($cmspages)}">{$cmspages->meta_title}</a></h2>
					   <div class="entry excerpt">
					    {if isset($cmspages->image_small) & !empty($cmspages->image_small)}<div class="post_image"><img src="{$cmspages->image_small}" /></div>{/if}{$cmspages->excerpt}
					</div>
					<div class="clear"></div>
					</div>
					{/if}
					
				{/foreach}
		
		{else}
		{if isset($sub_category) & !empty($sub_category)}
		{foreach from=$sub_category item=sub_cat name="sub_cat"}
		<div class="cms_post ">
						<h1 class="title"><a class="permlink" href="{$link->getCMSCategoryLink($sub_cat.id_cms_category)}">{$sub_cat.name}</a></h1>
					   <div class="entry">
					{$sub_cat.description}
					<a class="more" href="{$link->getCMSCategoryLink($sub_cat.id_cms_category)}">{l s='More'}</a>
					</div>
					<div class="clear"></div>
					</div>
		{/foreach}
		{/if}
		
		{/if}
		
		
	</div>
{else}
	{l s='This page does not exist.'}
{/if}
