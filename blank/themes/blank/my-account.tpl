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
<!--
	var baseDir = '{$base_dir_ssl}';
-->
</script>

{capture name=path}{l s='My account'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}
<div class="grid_12">
<h1 class="nadpis">{l s='My account'}</h1>
<div class="table-5">
<ul class="account">
 <ol>
	<li><a id="history_orders" href="{$link->getPageLink('history.php', true)}" title="{l s='Orders'}">{l s='History and details of my orders'}</a>
	<p>{l s='Here you can view all your past, current and future orders. Note that the future orders are visible only for those who are already in the future.'}</p>
	</li>
	<li><a id="history_addrbook" href="{$link->getPageLink('addresses.php', true)}" title="{l s='Addresses'}">{l s='My addresses'}</a>
	<p>{l s='Do not worry if you do not know what credit slip is. You can still choose this link and change your address or add a new one.'}</p>
	</li>
	<li><a id="history_userinfo" "href="{$link->getPageLink('identity.php', true)}" title="{l s='Information'}">{l s='My personal information'}</a>
	<p>{l s='Here you can change your password, e-mail and name.'}</p>
	</li>
	{if $voucherAllowed}
		<li><a id="history_voucher" href="{$link->getPageLink('discount.php', true)}" title="{l s='Vouchers'}">{l s='My vouchers'}</a>
		<p>{l s='This is nice feature. Here you can find how much money have you saved by using our vouchers.'}
		
		</p>
	
		</li>
	{/if}
	{$HOOK_CUSTOMER_ACCOUNT}
 </ol>
</ul>
</div>
<ul class="footer_links">
	<li><a href="{$link->getPageLink('my-account.php', true)}"><img src="{$img_dir}icon/my-account.gif" alt="" class="icon" /></a><a href="{$link->getPageLink('my-account.php', true)}">{l s='Back to Your Account'}</a></li>
	<li><a href="{$base_dir}"><img src="{$img_dir}icon/home.gif" alt="" class="icon" /></a><a href="{$base_dir}">{l s='Home'}</a></li>
</ul>
</div>