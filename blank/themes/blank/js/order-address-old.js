/*
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
*/

$(document).ready(function()
{
	updateAddressesDisplay(true);
	
});


//update the display of the addresses
function updateAddressesDisplay(first_view)
{
	// update content of delivery address
	updateAddressDisplay('delivery');

	// update content of invoice address
	//if addresses have to be equals...
	var txtInvoiceTitle = $('ul#address_invoice li.address_title').html();	
	if ($('input[type=checkbox]#addressesAreEquals:checked').length == 1)
	{
		$('#address_invoice_form:visible').hide('fast');
		$('ul#address_invoice').html($('ul#address_delivery').html());
		$('ul#address_invoice li.address_title').html(txtInvoiceTitle);
	}
	else
	{
		$('#address_invoice_form:hidden').show('fast');
		if ($('select#id_address_invoice').val())
			updateAddressDisplay('invoice');
		else
		{
			$('ul#address_invoice').html($('ul#address_delivery').html());
			$('ul#address_invoice li.address_title').html(txtInvoiceTitle);
		}	
	}
	
	if(!first_view)
	{
		if (orderProcess == 'order')
			updateAddresses();
	}
	
	return true;
}

function updateAddressDisplay(addressType)
{	
	if (typeof addresses=='undefined' || addresses.length <= 0)
		return false;
	
	var idAddress = $('select#id_address_' + addressType + '').val();
	$('ul#address_' + addressType + ' li.address_company').html(addresses[idAddress][0]);
	if(addresses[idAddress][0] == '')
		$('ul#address_' + addressType + ' li.address_company').hide();
	else
		$('ul#address_' + addressType + ' li.address_company').show();
	$('ul#address_' + addressType + ' li.address_name').html(addresses[idAddress][1] + ' ' + addresses[idAddress][2]);
	$('ul#address_' + addressType + ' li.address_address1').html(addresses[idAddress][3]);
	$('ul#address_' + addressType + ' li.address_address2').html(addresses[idAddress][4]);
	if(addresses[idAddress][4] == '')
		$('ul#address_' + addressType + ' li.address_address2').hide();
	else
		$('ul#address_' + addressType + ' li.address_address2').show();
	$('ul#address_' + addressType + ' li.address_city').html(addresses[idAddress][5] + ' ' + addresses[idAddress][6]);
	$('ul#address_' + addressType + ' li.address_country').html(addresses[idAddress][7] + (addresses[idAddress][8] != '' ? ' (' + addresses[idAddress][8] +')' : ''));
	// change update link
	var link = $('ul#address_' + addressType + ' li.address_update a').attr('href');
	var expression = /id_address=\d+/;
	link = link.replace(expression, 'id_address='+idAddress);
	$('ul#address_' + addressType + ' li.address_update a').attr('href', link);
}

function updateAddresses()
{
	var ajaxQuery=$('#ajaxQuery').val();
	
	var idAddress_delivery = $('select#id_address_delivery').val();
	var idAddress_invoice = $('input[type=checkbox]#addressesAreEquals:checked').length == 1 ? idAddress_delivery : $('select#id_address_invoice').val();
	
$.loader({
						className:"blue-with-image-2",
						content:''
					});

   $.ajax({
           type: 'POST',
           url: ajaxQuery,
           async: true,
           cache: false,
           data: 'processAddress=true&step=2&ajax=true&id_address_delivery=' + idAddress_delivery + '&id_address_invoice=' + idAddress_invoice+ '&token=' + static_token ,
           success: function(jsonData)
           {			
           		if (jsonData.hasError)
				{
					var errors = '';
					for(error in jsonData.errors)
						//IE6 bug fix
						if(error != 'indexOf')
							errors += jsonData.errors[error] + "\n";
					alert(errors);
				}
			$.loader('close');					
			},
           error: function(XMLHttpRequest, textStatus, errorThrown) {$.loader('close');alert("TECHNICAL ERROR: unable to save adresses \n\nDetails:\nError thrown: " + errorThrown + "\n" + 'Text status: ' + textStatus);}
       });
}

//Ajax loader

var jQueryLoaderOptions=null;
(function(a){a.loader=function(d){switch(d){case"close":if(jQueryLoaderOptions){if(a("#"+jQueryLoaderOptions.id)){a("#"+jQueryLoaderOptions.id+", #"+jQueryLoaderOptions.background.id).remove()
}}return;
break;
case"setContent":if(jQueryLoaderOptions){if(a("#"+jQueryLoaderOptions.id)){if(a.loader.arguments.length==2){a("#"+jQueryLoaderOptions.id).html(a.loader.arguments[1])
}else{if(console){console.error("setContent method must have 2 arguments $.loader('setContent', 'new content');")
}else{alert("setContent method must have 2 arguments $.loader('setContent', 'new content');")
}}}}return;
break;
default:var b=a.extend({content:"<div>Loading ...</div>",className:"loader",id:"jquery-loader",height:60,width:200,zIndex:30000,background:{opacity:0.4,id:"jquery-loader-background"}},d)
}jQueryLoaderOptions=b;
var c=a(document).height();
var e=a(window).width();
var g=a('<div id="'+b.background.id+'"/>');
g.css({zIndex:b.zIndex,position:"absolute",top:"0px",left:"0px",width:e,height:c,opacity:b.background.opacity});
g.appendTo("body");
if(jQuery.bgiframe){g.bgiframe()
}var f=a('<div id="'+b.id+'" class="'+b.className+'"></div>');
f.css({zIndex:b.zIndex+1,width:b.width,height:b.height});
f.appendTo("body");
f.center();
a(b.content).appendTo(f)
};
a.fn.center=function(){this.css("position","absolute");
this.css("top",(a(window).height()-this.outerHeight())/2+a(window).scrollTop()+"px");
this.css("left",(a(window).width()-this.outerWidth())/2+a(window).scrollLeft()+"px");
return this
}
})(jQuery);



