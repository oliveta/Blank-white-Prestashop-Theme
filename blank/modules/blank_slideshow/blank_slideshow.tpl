{if $editorial && count($editorial)>0}
<div style="position: relative;" id="cycle" class="grid_15">
		
	{foreach from=$editorial item=e name="editorial"}
 {if isset($e.body_home_logo) & $e.body_home_logo!=""}

	<div class="slide">
		<div class="slide-content grid_5">
		<div>
			<h2 class="cufon size3">{$e.body_title}</h2>
			{if $e.body_subheading!=""}
			<h3 class="subhead size2">{$e.body_subheading}</h3>
			{/if}
			{$e.body_paragraph|truncate:120:'...'}
			<div class="clear"></div>
			{if isset($e.body_home_logo_link) & $e.body_home_logo_link!=""}<a class="sl-more" href="{$e.body_home_logo_link}">{if isset($e.body_logo_subheading) & $e.body_logo_subheading!=""}{$e.body_logo_subheading}{else}Read more{/if}</a>	{/if}
			</div>
		</div>
		
		<div class="slide-banner"><div class="slideinner">
		<img class="slidepic" src="{$path}img/{$e.body_home_logo}" alt=""/></div>
		</div>
		<div class="clear"></div>
	</div>
	{/if}
		 {/foreach}
	
</div>
{literal}
<script type="text/javascript">

jQuery(document).ready(function() {
if (!$.browser.msie || ($.browser.msie && parseInt($.browser.version) >= 8))
{


et=1000;
sv=150;
p='5,3';
st=5000;
if ({/literal}'{$effect}'{literal}=="chewyBars")
{
et=3500;
sv=50;
p='15';
st=7000;
}

				$('#cycle').rhinoslider({
				controlsPlayPause:false,
				autoPlay:true,
				effect:{/literal}'{$effect}'{literal},
				showTime:st,
				effectTime: et,
				controlsMousewheel:false,
				shiftValue: sv,
			parts: p,
			additionalResets: function() { {/literal}{if $cufon}{literal}Cufon.replace('.slide-content .cufon');{/literal}{/if}
		{literal}return false;}
				});
				}
else {
$('#cycle').css('background-image','none');
$('#cycle').cycle({ 
    fx:     'fade', 
    timeout: 6000, 
    delay:  -2000 
});
}			
			});
			
</script>

{/literal}
{/if}