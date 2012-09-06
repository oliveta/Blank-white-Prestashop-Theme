<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="{$lang_iso}" xml:lang="{$lang_iso}">
	<head>
		<title>{$meta_title|escape:'htmlall':'UTF-8'}</title>
{if isset($meta_description) AND $meta_description}
		<meta name="description" content="{$meta_description|escape:html:'UTF-8'}" />
{/if}
{if isset($meta_keywords) AND $meta_keywords}
		<meta name="keywords" content="{$meta_keywords|escape:html:'UTF-8'}" />
{/if}
		<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
		<meta name="generator" content="PrestaShop" />
		<meta name="robots" content="{if isset($nobots)}no{/if}index,follow" />
		<link rel="icon" type="image/vnd.microsoft.icon" href="{$img_ps_dir}favicon.ico?{$time}" />
		<link rel="shortcut icon" type="image/x-icon" href="{$img_ps_dir}favicon.ico?{$time}" />
		
		{if ($page_name=="module-cashondeliverywithfee-validation" || $page_name=="module-paypal-payment-submit") || $page_name=="module-bankwire-payment"}
		<link type="text/css" href="{$css_dir}order-opc.css" rel="stylesheet" media="all" />{/if}
		<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Ubuntu">
		
		<script type="text/javascript">
			var baseDir = '{$content_dir}';
			var static_token = '{$static_token}';
			var token = '{$token}';
			var priceDisplayPrecision = {$priceDisplayPrecision*$currency->decimals};
			var priceDisplayMethod = {$priceDisplay};
			var roundMode = {$roundMode};
		</script>
{if isset($css_files)}
	{foreach from=$css_files key=css_uri item=media}
	<link href="{$css_uri}" rel="stylesheet" type="text/css" media="{$media}" />
	{/foreach}
{/if}
{if isset($js_files)}
	{foreach from=$js_files item=js_uri}
	<script type="text/javascript" src="{$js_uri}"></script>
	{/foreach}
{/if}

		{$HOOK_HEADER}
	</head>
	<body {if $page_name}id="{$page_name|escape:'htmlall':'UTF-8'}"{/if}>
	
<div id="document">
	{if !$content_only}
		{if isset($restricted_country_mode) && $restricted_country_mode}
		<div id="restricted-country">
			<p>{l s='You cannot place a new order from your country.'} <span class="bold">{$geolocation_country}</span></p>
		</div>
		{/if}
	<div id="main" class="container_15">
		<div id="header" class="">
			<div id="logo" class="">
				<h1><a href="{$base_dir}" title="{$shop_name|escape:'htmlall':'UTF-8'}" class="size4 grid_3 cufon"><span>{$shop_name|escape:'htmlall':'UTF-8'}</span></a></h1>
				<h2>{$meta_description}</h2>
			</div>
			{$HOOK_LEFT_COLUMN}
			
		</div><!--header -->
		<div class="clear"></div>
		<div id="mainMenu">
		{$HOOK_TOP}
		
		</div>
		
		 {/if}
		<div class="clear"></div>