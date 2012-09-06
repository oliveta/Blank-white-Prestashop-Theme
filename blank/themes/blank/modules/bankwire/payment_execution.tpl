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
*  @version  Release: $Revision: 6594 $
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
<div class="grid_12">
{capture name=path}{l s='Bank wire payment' mod='bankwire'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}

<div class="table_block">
{include file="$tpl_dir./shopping-cart-summary.tpl"}
<script type="text/javascript">
$(function() {
$(".validation").css('opacity',0);
})
</script>

{if $nbProducts <= 0}
	<p class="warning">{l s='Your shopping cart is empty.'}</p>
{else}
<h1 id="valid" class="nadpis">{l s='Order Confirmation' mod='bankwire'}</h1>
<h3>{l s='Bank wire payment' mod='bankwire'}</h3>
<form action="{$this_path_ssl}validation.php" method="post">
<p>
	<img src="{$this_path}bankwire.jpg" alt="{l s='bank wire' mod='bankwire'}" width="86" height="49" style="float:left; margin: 0px 10px 5px 0px;" />
	{l s='You have chosen to pay by bank wire.' mod='bankwire'}
</p>
<p style="margin-top:20px;">
	{l s='The total amount of your order is' mod='bankwire'}
	<span id="amount" class="price">{displayPrice price=$total}</span>
	{if $use_taxes == 1}
    	{l s='(tax incl.)' mod='bankwire'}
    {/if}
</p>
<p>
	{l s='Bank wire account information will be displayed on the next page.' mod='bankwire'}
	<br /><br />
	<b>{l s='Please confirm your order by clicking \'I confirm my order\'' mod='bankwire'}.</b>
</p>

<p id="validation" >
			<span class="cufon upper size5">{l s='I confirm my order' mod='bankwire'}</span>
             <input type="submit" name="submit" value="{l s='I confirm my order' mod='bankwire'}" class="validation" />
            </p>
			
<p class="cart_navigation">
	<a href="{$base_dir_ssl}order.php?step=3" class="button_large">&laquo; {l s='Other payment methods' mod='bankwire'}</a>
	
</p>



</form>
{/if}
</div></div></div>