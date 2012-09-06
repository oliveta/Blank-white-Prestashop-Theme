{if count($categoryProducts) > 0}
<div class="products_block accessories_block" id="idTab15">
<h6><b>{$categoryProducts|@count}</b> {l s='other products in the same category:' mod='productscategory'}</h6>
	<ul>
		{foreach from=$categoryProducts item='categoryProduct' name=categoryProduct}
		<li>
         <p id="product_list_stuffs">
          {if $categoryProduct.new == 1}<span class="new_product"><strong>{l s='new'}</strong><br /></span>{/if}
          {if $categoryProduct.on_sale}
		  <span class="on_sale"><strong>{l s='On sale!'}</strong></span>
		  <span class="on_sale"><strong>{l s='Price lowered!'} <strike>{convertPrice price=$categoryProduct.price_without_reduction}</strike></strong><br /></span>
          {/if}
         </p>
			<a href="{$categoryProduct.link}" title="{$categoryProduct.name|htmlspecialchars}">
				<img src="{$link->getImageLink($categoryProduct.link_rewrite, $categoryProduct.id_image, 'large')}" alt="{$categoryProduct.name|htmlspecialchars}" />
			</a>
			<h5>
             <a href="{$categoryProduct.link}" title="{$categoryProduct.name|htmlspecialchars}">
			  {$categoryProduct.name|truncate:25:'...'|escape:'htmlall':'UTF-8'}
             </a>
            </h5>
         <p><a href="{$categoryProduct.link}" title="{$categoryProduct.name|htmlspecialchars}" title="{l s='More' mod='productscategory'}">{$categoryProduct.description_short|strip_tags|truncate:140s:'...'}</a></p>
            <p class="pprice">
             {if $ProdDisplayPrice AND $categoryProduct.show_price == 1 AND !isset($restricted_country_mode) AND !$PS_CATALOG_MODE}
              <span>{displayWtPrice p=$categoryProduct.price}</span>
             {/if}
             <a href="{$categoryProduct.link}" title="{$categoryProduct.name|htmlspecialchars}" title="{l s='View' mod='productscategory'}">
              {l s='View' mod='productscategory'}
             </a>
            </p>
		</li>
		{/foreach}
	</ul>
</div>
{/if}
