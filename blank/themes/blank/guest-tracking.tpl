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

{capture name=path}{l s='Guest tracking'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}

<div class="grid_12">
<h1 class="nadpis">{l s='Guest Tracking'}</h1>

{if isset($order)}
	<div id="block-history">
		<div id="" class="std">
		{include file="$tpl_dir./order-detail.tpl"}
		</div>
	</div>
	
	
{else}
	{include file="$tpl_dir./errors.tpl"}
	<form method="POST" action="{$action|escape:'htmlall':'UTF-8'}" class="std">
	<div style="padding:20px 0px 10px 0px">{l s='To track your order, please enter the following information:'}</div>
		<table class="table-5"><thead>
			<tr>
			<th>
			
				<label>{l s='Order ID:'} </label></th><th>
				<label>{l s='E-mail:'}</label></th>
			</tr>
			</thead>
			<tr><td>
				<input type="text" name="id_order" value="{if isset($smarty.get.id_order)}{$smarty.get.id_order|escape:'htmlall':'UTF-8'}{else}{if isset($smarty.post.id_order)}{$smarty.post.id_order|escape:'htmlall':'UTF-8'}{/if}{/if}" size="30" />
				<i>{l s='For example: 010123'}</i>
			</td><td>
				<input type="text" size="30" name="email" value="{if isset($smarty.get.email)}{$smarty.get.email|escape:'htmlall':'UTF-8'}{else}{if isset($smarty.post.email)}{$smarty.post.email|escape:'htmlall':'UTF-8'}{/if}{/if}" />
			</td></tr>
		<tr><td colspan="2">
			<p class="center"><input type="submit" class="button" name="submitGuestTracking" value="{l s='Send'}" /></p>
		</fieldset></td></tr></table>
	</form>
{/if}


</div>