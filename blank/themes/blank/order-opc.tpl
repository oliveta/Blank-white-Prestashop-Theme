{if $PS_CATALOG_MODE}
	<h2 id="cart_title">{l s='Your shopping cart'}</h2>
	<p class="warning">{l s='This store has not accepted your new order.'}</p>
{else}
{if $opc}
	{assign var="back_order_page" value="order-opc.php"}
	{else}
	{assign var="back_order_page" value="order.php"}
{/if}
<script type="text/javascript">
	// <![CDATA[
	var price_free_text="Free";
	var error_message="There have been the following errors:";
	var baseDir = '{$base_dir_ssl}';
	var imgDir = '{$img_dir}';
	var authenticationUrl = '{$link->getPageLink("authentication.php", true)}';
	var orderOpcUrl = '{$link->getPageLink("order-opc.php", true)}';
	var historyUrl = '{$link->getPageLink("history.php", true)}';
	var guestTrackingUrl = '{$link->getPageLink("guest-tracking.php", true)}';
	var addressUrl = '{$link->getPageLink("address.php", true)}';
	var orderProcess = 'order-opc';
	var guestCheckoutEnabled = {$PS_GUEST_CHECKOUT_ENABLED|intval};
	var currencySign = '{$currencySign|html_entity_decode:2:"UTF-8"}';
	var currencyRate = '{$currencyRate|floatval}';
	var currencyFormat = '{$currencyFormat|intval}';
	var currencyBlank = '{$currencyBlank|intval}';
	var displayPrice = {$priceDisplay};
	var taxEnabled = {$use_taxes};
	var conditionEnabled = {$conditions|intval};
	var countries = new Array();
	var countriesNeedIDNumber = new Array();
	var countriesNeedZipCode = new Array();
	var vat_management = {$vat_management|intval};
	
	var txtWithTax = "{l s='(tax incl.)'}";
	var txtWithoutTax = "{l s='(tax excl.)'}";
	var txtHasBeenSelected = "{l s='has been selected'}";
	var txtNoCarrierIsSelected = "{l s='No carrier has been selected'}";
	var txtNoCarrierIsNeeded = "{l s='No carrier is needed for this order'}";
	var txtConditionsIsNotNeeded = "{l s='No terms of service must be accepted'}";
	var txtTOSIsAccepted = "{l s='Terms of service is accepted'}";
	var txtTOSIsNotAccepted = "{l s='Terms of service have not been accepted'}";
	var txtThereis = "{l s='There is'}";
	var txtErrors = "{l s='error(s)'}";
	var txtDeliveryAddress = "{l s='Delivery address'}";
	var txtInvoiceAddress = "{l s='Invoice address'}";
	var txtModifyMyAddress = "{l s='Modify my address'}";
	var txtInstantCheckout = "{l s='Instant checkout'}";
	var errorCarrier = "{$errorCarrier}";
	var errorTOS = "{$errorTOS}";
	var checkedCarrier = "{if isset($checked)}{$checked}{else}0{/if}";

	var addresses = new Array();
	var isLogged = {$isLogged|intval};
	var isGuest = {$isGuest|intval};
	var isVirtualCart = {$isVirtualCart|intval};
	var isPaymentStep = {$isPaymentStep|intval};
	//]]>
</script>

<div id="opc-overlay" class="opc-overlay" style="display: none;"></div>
<div id="center_column" class="grid_12" >
<div id="emptyCartWarning">
{capture name=path}{l s='Your shopping cart'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}
		<h1 class="nadpis">{l s='Your shopping cart'}</h1>
		<table class="table-5"><tr><td>
		<p class="warning" >{l s='Your shopping cart is empty.'}</p></td></tr>
		
		<tr><td>
		<p class="">{l s='Please continue shopping at'} <a href='{$link->getPageLink("index.php", true)}'>{l s='product page'}</a></p></td></tr>
		</table>
</div>
	{if $productNumber}
		<!-- Shopping Cart -->
		{include file="$tpl_dir./shopping-cart-opc.tpl"}
		<!-- Shopping Cart -->
		{if $isLogged AND !$isGuest}
			{include file="$tpl_dir./order-address.tpl"}
		{else}
			<!-- Create account / Guest account / Login block -->
			
			{include file="$tpl_dir./order-credentials.tpl"}
			<!-- END Create account / Guest account / Login block -->
		{/if}
		
		
			<!-- Create account / Guest account / Login block -->
			{include file="$tpl_dir./order-payment-opc.tpl"}
			<!-- END Create account / Guest account / Login block -->
		
	{else}
	{capture name=path}{l s='Your shopping cart'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}
		<h1 class="nadpis">{l s='Your shopping cart'}</h1>
		<table class="table-5"><tr><td>
		<p class="warning">{l s='Your shopping cart is empty.'}</p></td></tr>
		
		<tr><td>
		<p class="">{l s='Please continue shopping at'} <a href='{$link->getPageLink("index.php", true)}'>{l s='product page'}</a></p></td></tr>
		</table>
	{/if}
	
	
		
		<!-- Carrier -->
		
		<!-- END Carrier -->
</div>
{/if}

