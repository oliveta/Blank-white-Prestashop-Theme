{if $active==1}

<div id="banners">
	{foreach from=$texty item=text name=texty}
	{if $style[$smarty.foreach.texty.index]!="none"}
	<div class="{$style[$smarty.foreach.texty.index]} banner">
    {$text}
    </div>
    {else}
      {$text}
      {/if}
{/foreach}
		
   </div>
{/if}
