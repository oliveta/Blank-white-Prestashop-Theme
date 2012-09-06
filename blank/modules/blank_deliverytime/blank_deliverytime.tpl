{l s='Order this product now and you will have it at home on: ' mod='blank_deliverytime'}{$delivery}


<h5 class="cufon">{l s='Delivery methods'}</h5>
	<table class="table-5" {if ( !isset($carriers) || !$carriers || !count($carriers)) && empty($HOOK_EXTRACARRIER)}style="display:none;"{/if}>
		<thead>
			<tr>
				<th>{l s='Carrier'}</th>
				
				<th >{l s='Price'}</th>
			</tr>
		</thead>
		<tbody>
		
		{if isset($carriers)}
			{foreach from=$carriers item=carrier name=myLoop}
		
				<tr id="carrier{$carrier.id_carrier|intval}" class="{if $smarty.foreach.myLoop.index % 2 == 0}carrier_odd{else}carrier_even{/if}">
					
					<td>
						<label for="id_carrier{$carrier.id_carrier|intval}">
							{if isset($carrier.img)}<img src="{$carrier.img|escape:'htmlall':'UTF-8'}" alt="{$carrier.name|escape:'htmlall':'UTF-8'}" />{else}{$carrier.name|escape:'htmlall':'UTF-8'}{/if}
						</label>
					</td>
					
					<td >
						{if $carrier.price}
							<span class="price">
								{if $priceDisplay == 1}{convertPrice price=$carrier.price_tax_exc}{else}{convertPrice price=$carrier.price}{/if}
							</span>
							{if $use_taxes}{if $priceDisplay == 1} {l s='(tax excl.)'}{else} {l s='(tax incl.)'}{/if}{/if}
						{else}
						<span class="price">
							{l s='Free!'}</span>
							
						{/if}
					</td>
				</tr>
			{/foreach}
			
		{/if}
		
		</tbody>
	</table>
	{if $free>0}
<p id="availability_statut">
			{l s='Free shipping from: '}<b>{convertPrice price=$free}</b>
			</p>
			{/if}