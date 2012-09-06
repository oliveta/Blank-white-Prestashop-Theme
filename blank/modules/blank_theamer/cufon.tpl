{literal}
 <script type="text/javascript" charset="utf-8">
  
ajaxCart.hideOldProducts=function(jsonData) {
		$(['left_column', 'right_column']).each(function(id, parentId)
		{
			//delete an eventually removed product of the displayed cart (only if cart is not empty!)
			if($('#cart_block #cart_block_list dl.products').length > 0)
			{
				var removedProductId = null;
				var removedProductData = null;
				var removedProductDomId = null;
				//look for a product to delete...
				$('#'+parentId+' #cart_block_list dl.products dt').each(function()
				{
					//retrieve idProduct and idCombination from the displayed product in the block cart
					var domIdProduct = $(this).attr('id');
					var firstCut =  domIdProduct.replace('cart_block_product_', '');
					var ids = firstCut.split('_');

					//try to know if the current product is still in the new list
					var stayInTheCart = false;
					for (aProduct in jsonData.products)
					{
						//we've called the variable aProduct because IE6 bug if this variable is called product
						//if product has attributes
						if (jsonData.products[aProduct]['id'] == ids[0] && (!ids[1] || jsonData.products[aProduct]['idCombination'] == ids[1]))
						{
							stayInTheCart = true;
							// update the product customization display (when the product is still in the cart)
							ajaxCart.hideOldProductCustomizations(jsonData.products[aProduct], domIdProduct);
						}
					}
					//remove product if it's no more in the cart
					if(!stayInTheCart)
					{
						removedProductId = $(this).attr('id');
						//return false; // Regarding that the customer can only remove products one by one, we break the loop
					}

					//if there is a removed product, delete it from the displayed block cart
					if (removedProductId != null)
					{
						var firstCut =  removedProductId.replace('cart_block_product_', '');
						var ids = firstCut.split('_');

						$('#'+parentId+' #'+removedProductId).addClass('strike').fadeTo('slow', 0, function(){
						
							$(this).slideUp('slow', function(){
							$("#button_order_cart").hide();$("#button_order_cart").show();
								$(this).remove();
								//if the cart is now empty, show the 'no product in the cart' message
								if($('#'+parentId+' #cart_block dl.products dt').length == 0)
								{
									$('#'+parentId+' p#cart_block_no_products').slideDown('fast');
									$('#'+parentId+' div#cart_block dl.products').remove();
								}
							});
						});
						
						$('#'+parentId+' dd#cart_block_combination_of_' + ids[0] + (ids[1] ? '_'+ids[1] : '') ).fadeTo('fast', 0, function(){
						
							$(this).slideUp('fast', function(){
								$(this).remove();$("#button_order_cart").hide();$("#button_order_cart").show();
							});
						});
					}
				});
			}
		});
	};

		ajaxCart.displayNewProducts=function(jsonData) {
		$("#button_order_cart").hide();$("#button_order_cart").show();
		$(['left_column', 'right_column']).each(function(id, parentId)
		{
			//add every new products or update displaying of every updated products
			$(jsonData.products).each(function(){
				//fix ie6 bug (one more item 'undefined' in IE6)
				if (this.id != undefined)
				{
					//create a container for listing the products and hide the 'no product in the cart' message (only if the cart was empty)
					if ($('#'+parentId+' div#cart_block dl.products').length == 0)
						$('#'+parentId+' p#cart_block_no_products').fadeTo('fast', 0, function(){
							$(this).slideUp('fast').fadeTo(0, 1);
						}).before('<dl class="products"></dl>');

					//if product is not in the displayed cart, add a new product's line
					var domIdProduct = this.id + (this.idCombination ? '_' + this.idCombination : '');
					var domIdProductAttribute = this.id + '_' + (this.idCombination ? this.idCombination : '0');
					if($('#'+parentId+' #cart_block dt#cart_block_product_'+ domIdProduct ).length == 0)
					{
						var productId = parseInt(this.id);
						var productAttributeId = (this.hasAttributes ? parseInt(this.attributes) : 0);
						var content =  '<dt class="hidden" id="cart_block_product_' + domIdProduct + '">';
							content += '<span class="quantity-formated"><span class="quantity">' + this.quantity + '</span>x</span>';
							var name = (this.name.length > 12 ? this.name.substring(0, 10) + '...' : this.name);
							content += '<a href="' + this.link + '" title="' + this.name + '">' + name + '</a>';
							content += '<span class="remove_link"><a rel="nofollow" class="ajax_cart_block_remove_link" href="' + baseDir + 'cart.php?delete&amp;id_product=' + productId + '&amp;token=' + static_token + (this.hasAttributes ? '&amp;ipa=' + parseInt(this.idCombination) : '') + '"> </a></span>';
							content += '<span class="price">' + this.priceByLine + '</span>';
							content += '</dt>';
						if (this.hasAttributes)
							content += '<dd id="cart_block_combination_of_' + domIdProduct + '" class="hidden"><a href="' + this.link + '" title="' + this.name + '">' + this.attributes + '</a>';
						if (this.hasCustomizedDatas)
							content += ajaxCart.displayNewCustomizedDatas(this);
						if (this.hasAttributes) content += '</dd>';
						$('#'+parentId+' #cart_block dl.products').append(content);
					}
					//else update the product's line
					else
					{
						var jsonProduct = this;
						if($('#'+parentId+' dt#cart_block_product_' + domIdProduct + ' .quantity').text() != jsonProduct.quantity || $('dt#cart_block_product_' + domIdProduct + ' .price').text() != jsonProduct.priceByLine)
						{
							// Usual product
							$('#'+parentId+' dt#cart_block_product_' + domIdProduct + ' .price').text(jsonProduct.priceByLine);
							ajaxCart.updateProductQuantity(jsonProduct, jsonProduct.quantity);

							// Customized product
							if (jsonProduct.hasCustomizedDatas)
							{
								customizationFormatedDatas = ajaxCart.displayNewCustomizedDatas(jsonProduct);
								if (!$('#'+parentId+' #cart_block ul#customization_' + domIdProductAttribute).length)
								{
									if (jsonProduct.hasAttributes)
										$('#'+parentId+' #cart_block dd#cart_block_combination_of_' + domIdProduct).append(customizationFormatedDatas);
									else
										$('#'+parentId+' #cart_block dl.products').append(customizationFormatedDatas);
								}
								else
									$('#'+parentId+' #cart_block ul#customization_' + domIdProductAttribute).append(customizationFormatedDatas);
							}
						}
					}
					
					$('#'+parentId+' #cart_block dl.products .hidden').slideDown('slow',function() {$(this).removeClass('hidden');$("#button_order_cart").hide();$("#button_order_cart").show();});

				var removeLinks = $('#'+parentId+' #cart_block_product_' + domIdProduct).find('a.ajax_cart_block_remove_link');
				if (this.hasCustomizedDatas && removeLinks.length)
					$(removeLinks).each(function() {
						$(this).remove();
					});
				}
			});
		});
	};
		jQuery(document).ready(function () {
		Cufon.replace('.cufon',{hover:true});
        
     });
    
     
</script>
{/literal}