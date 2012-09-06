
<!-- Left -->
{if isset($category)}
{if $category->id AND $category->active}


{if $category->id_image}
{assign var='image' value=$link->getCatImageLink($category->link_rewrite, $category->id, 'category')}

{literal}

<script>
$(function() {
$css=$(".ajax_block_product").css("float");

if ($css!="left")
{
$("head").append("<link href='{/literal}{$css_dir}{literal}blank/styles/standart/style.css' type='text/css' rel='stylesheet' />");

}

$theme=$("#document").css("background-image").indexOf("beige");
if ($theme>=0)
{
$("head").append("<link href='{/literal}{$css_dir}{literal}blank/themes/beige/style_category.css' type='text/css' rel='stylesheet' />");
}
else $("head").append("<link href='{/literal}{$css_dir}{literal}blank/style_category.css' type='text/css' rel='stylesheet' />");

});
</script>

{/literal}

<div style="position: relative;" id="cycle" class="grid_15">
		
	<div >

		<div class="slide-content grid_5" >
		
			<h2 class="cufon size3" style="color:#ffffff">{$category->name}</h2>
			{$category->description|truncate:100:'...'}
			<div class="clear"></div>
			
		</div>
		
		<div class="slide-banner"><div class="slideinner">
		<img class="slidepic" src="{$image}" alt=""/></div>
		</div>
		<div class="clear"></div>
	</div>
	
	
</div>
<div class="list_product"  style="width:864px;float:left;">
	{include file="$tpl_dir./breadcrumb.tpl"}
{include file="$tpl_dir./errors.tpl"}
{else}

{include file="$tpl_dir./breadcrumb.tpl"}
{include file="$tpl_dir./errors.tpl"}

<div class="list_product"  style="width:864px;float:left;">
	

		<h1 class="category_title cufon upper">
        {strip}
		{$category->name|escape:'htmlall':'UTF-8'}
		 <span>
			&nbsp;&raquo;&nbsp;{if $nb_products == 0}{l s='There are no products.'}
			{/if}
		 </span>
        {/strip}
		</h1>

        {if $category->description}
         <div class="cat_desc">{$category->description}</div>
        {/if}

{/if}	
	{if $products}
            <div class="list_categorie_product">
            
                {if $products}
                    {include file="$tpl_dir./product-sort.tpl"}
                   
                {/if}
          
				{include file="$tpl_dir./product-list.tpl" products=$products}
                {if $products}
                    {include file="$tpl_dir./pagination.tpl"}
                {/if}
            </div>
			{elseif !isset($subcategories)}
				<p class="warning">{l s='There are no products in this category.'}</p>
			{/if}
		
  	{elseif $category->id}
		<div class="list_product"  style="width:864px;float:left;"><p class="warning">{l s='This category is currently unavailable.'}</p>
	
	{/if}
	
</div>	
{/if}
