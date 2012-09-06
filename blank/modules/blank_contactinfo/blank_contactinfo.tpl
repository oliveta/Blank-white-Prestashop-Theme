<div id="contact">
<div class="kontakt">{l s='Contact' mod='blockcartview'}</div>
		<div class="c_column ">
		{if $info_name}
   <p class="name">{$shop_name|escape:'htmlall':'UTF-8'}</p>{/if}
   {if $info_address}
   <p class="address">{$info_address}</p>{/if}
   {if $info_phone}
   <p class="phone">{l s="Telephone:" module="blank_contactinfo"} {$info_phone}</p>{/if}
   {if $info_email}
   <p class="email"><a href="mailto:{$info_email}">{$info_email}</a></p>{/if}
   </div>
   <div class="c_column">
   
   {if $info_hours}
   <p class="hours"><b>{l s="Customer service:" module="blank_contactinfo"} <br /></b>{$info_hours}</p>{/if}
   
   {if $info_facebook!=""}
  
   <div class="facebook">
   <div class="addthis_toolbox addthis_default_style">
   <a href="{$info_facebook}" target="_blank" id="facebook"><span>Facebook</span></a>
   <iframe src="//www.facebook.com/plugins/like.php?href={$info_facebook|urlencode}&amp;send=false&amp;layout=button_count&amp;width=150&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:150px; height:21px;" allowTransparency="true"></iframe>

</div>
   </div>
    {/if}
  </div>
   </div>