<script type="text/javascript">
<!--
	var baseDir = '{$base_dir_ssl}';
	{literal}
	$(document).ready(function() {
	
	$("#identity input").height('20');
	$("#identity label").height('22');
	
	
	$("#identity input").focus(function()
	{
	
	$(this).prev("label").addClass("focus");
	$(this).addClass("focus");
	});
	
	$("#identity input").blur(function()
	{
	$(this).prev("label").removeClass("focus");
	$(this).removeClass("focus");
	});
	});
	{/literal}
-->
</script>

{capture name=path}<a href="{$link->getPageLink('my-account.php', true)}">{l s='My account'}</a><span class="navigation-pipe">{$navigationPipe}</span>{l s='Your personal information'}{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}
<div class="grid_12">
<h1 class="nadpis">{l s='Your personal information'}</h1>
<div class="table-5">
{include file="$tpl_dir./errors.tpl"}

{if isset($confirmation) && $confirmation}
	<p class="success">
		{l s='Your personal information has been successfully updated.'}
		{if isset($pwd_changed)}<br />{l s='Your password has been sent to your e-mail:'} {$email|escape:'htmlall':'UTF-8'}{/if}
	</p>
{else}
	
	
	<form action="{$link->getPageLink('identity.php', true)}" method="post" class="std" id="identity">
		<fieldset>
			<p class="required text">
				<label for="firstname">{l s='First name'}</label>
				<input class="titles" title="{l s='Your first name'}" type="text" id="firstname" name="firstname" value="{$smarty.post.firstname}" /> <sup>*</sup>
			</p>
			<p class="required text">
				<label for="lastname">{l s='Last name'}</label>
				<input class="titles" title="{l s='Your last name'}" type="text" name="lastname" id="lastname" value="{$smarty.post.lastname}" /> <sup>*</sup>
			</p>
			<p class="required text">
				<label for="email">{l s='E-mail'}</label>
				<input class="titles" title="{l s='Your email'}" type="text" name="email" id="email" value="{$smarty.post.email}" /> <sup>*</sup>
			</p>
			<p class="password text">
				<label for="passwd">{l s='New Password'}</label>
				<input class="titles" title="{l s='Your new password'}" type="password" name="passwd" id="passwd" />
			</p>
			<p class="password text">
				<label for="confirmation">{l s='Confirmation'}</label>
				<input class="titles" title="{l s='Please re-type your new password'}" type="password" name="confirmation" id="confirmation" />
			</p>
			<p class="checkbox">
				<input type="checkbox" id="newsletter" name="newsletter" value="1" {if isset($smarty.post.newsletter) && $smarty.post.newsletter == 1} checked="checked"{/if} />
				<label for="newsletter">{l s='Sign up for our newsletter'}</label>
			</p>
			<p style="padding:1em 0 0 12.2em">
 		     <input type="submit" id="submitIdentity" name="submitIdentity" value="{l s='Save'}" />
             <em class="required"><sup>*</sup>{l s='Required field'}</em>
			</p>
		</fieldset>
	</form>
	<p id="security_informations">
		{l s='[Insert customer data privacy clause or law here, if applicable]'}
	</p>
{/if}
</div>

<ul class="footer_links">
	<li><a href="{$link->getPageLink('my-account.php', true)}"><img src="{$img_dir}icon/my-account.gif" alt="" class="icon" /></a><a href="{$link->getPageLink('my-account.php', true)}">{l s='Back to Your Account'}</a></li>
	<li><a href="{$base_dir}"><img src="{$img_dir}icon/home.gif" alt="" class="icon" /></a><a href="{$base_dir}">{l s='Home'}</a></li>
</ul>
</div>