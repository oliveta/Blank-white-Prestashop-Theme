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
{if $status == 'ok'}
	<p>{l s='Your order on' mod='bankwire'} <span class="bold">{$shop_name}</span> {l s='is complete.' mod='bankwire'}
		<br /><br />
		{l s='Please send us a bank wire with:' mod='bankwire'}
		<table class="table-5" ><tbody ><tr ><th scope="row">{l s='an amount of' mod='bankwire'}</th><td style=""><span class="price">{$total_to_pay}</span></td></tr><tr ><th scope="row">{l s='to this bank' mod='bankwire'}</th><td style="">{$bankwireAddress}</td></tr><tr ><th scope="row">{l s='with these details' mod='bankwire'}</th><td style="">{$bankwireDetails}</td></tr><tr ><th scope="row">Variabiln&iacute; symbol</th><td style="">{$id_order}</td></tr></tbody></table>
	
		<br /><br />{l s='An e-mail has been sent to you with this information.' mod='bankwire'}
		<br /><br /><span class="bold">{l s='Your order will be sent as soon as we receive your settlement.' mod='bankwire'}</span>
		<br /><br />{l s='For any questions or for further information, please contact our' mod='bankwire'} <a href="{$link->getPageLink('contact-form.php', true)}">{l s='customer support' mod='bankwire'}</a>.
	</p>
{else}
	<p class="warning">
		{l s='We noticed a problem with your order. If you think this is an error, you can contact our' mod='bankwire'} 
		<a href="{$link->getPageLink('contact-form.php', true)}">{l s='customer support' mod='bankwire'}</a>.
	</p>
{/if}
