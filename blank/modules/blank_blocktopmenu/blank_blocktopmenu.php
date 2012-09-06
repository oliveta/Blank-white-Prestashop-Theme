
<?php
/*
*Modified Julien Breux top horizontal Menu 
*http://www.julien-breux.com/2009/08/25/menu-horizontal-v-1-0/
*/
include _PS_MODULE_DIR_.'blank_blocktopmenu/menutoplinks.class.php';



class blank_blocktopmenu extends Module
{
  private $_menu = '';
  private $_html = '';
 

  public function __construct()
  {
    $this->name = 'blank_blocktopmenu';
    $this->author = 'Oliveta';
    $this->version = 0.1;
    parent::__construct();
    $this->displayName = $this->l('Flexible Top horizontal menu ');
    $this->description = $this->l('Add a new customizable menu on top of your shop.');
    $this->path = __PS_BASE_URI__.'modules/'.$this->name;
  }

  public function install()
  {
    if(!parent::install() || 
       !$this->registerHook('top') || 
       !$this->registerHook('header') || 
       !Configuration::updateValue('MOD_blocktopmenu_SEARCH', '1') || 
       !$this->installDb())
      return false;
    return true;
  }

  public function installDb()
  {
    Db::getInstance()->ExecuteS('
    CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'linksmenutop` (
      `id_link` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
      `new_window` TINYINT( 1 ) NOT NULL,
      `link` VARCHAR( 128 ) NOT NULL
    ) ENGINE = MYISAM CHARACTER SET utf8 COLLATE utf8_general_ci;');
    Db::getInstance()->ExecuteS('
    CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'linksmenutop_lang` (
    `id_link` INT NOT NULL ,
    `id_lang` INT NOT NULL ,
    `label` VARCHAR( 128 ) NOT NULL ,
    INDEX ( `id_link` , `id_lang` )
    ) ENGINE = MYISAM CHARACTER SET utf8 COLLATE utf8_general_ci;');
     Db::getInstance()->ExecuteS('
    CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'wpblocktopmenu` (
      `id` INT UNSIGNED NOT NULL PRIMARY KEY ,
      `id_ref` INT NOT NULL ,
      `type` varchar(10) ,
      `parent_id` INT,
      `order` INT NOT NULL ,
      `depth` INT NOT NULL 
    ) ENGINE = MYISAM CHARACTER SET utf8 COLLATE utf8_general_ci;');
    return true;
  }

  public function uninstall()
  {
    if(!parent::uninstall() || 
       !Configuration::deleteByName('MOD_wpblocktopmenu_SEARCH') || 
       !$this->uninstallDB())
      return false;
    return true;
  }

  private function uninstallDb()
  {
    Db::getInstance()->ExecuteS('DROP TABLE `'._DB_PREFIX_.'linksmenutop`');
    Db::getInstance()->ExecuteS('DROP TABLE `'._DB_PREFIX_.'linksmenutop_lang`');
    Db::getInstance()->ExecuteS('DROP TABLE `'._DB_PREFIX_.'wpblocktopmenu`');
    return true;
  }
  
  private function _unserializeJQuery($rubble = NULL) {
  $bricks = explode("&", $rubble);
 foreach ($bricks as $key => $value) {
$walls = preg_split("/=/", $value);
$built[urldecode($walls[0])] = urldecode($walls[1]);
 }

return $built;
}

private function menuCMSCategory($categories, $current, $id_cms_category = 1, $id_selected = 1, $is_html = 0, $pref_value='')
	{
		$html = '<option  value="'.$pref_value.$id_cms_category.'"'.(($id_selected == $id_cms_category) ? ' selected="selected"' : '').'><div>'.
		str_repeat('&nbsp;', $current['infos']['level_depth'] * 5).CMSCategory::hideCMSCategoryPosition(stripslashes($current['infos']['name'])).'</div></option>';
		if ($is_html == 0)
			echo $html;
		if (isset($categories[$id_cms_category]))
			foreach (array_keys($categories[$id_cms_category]) AS $key)
				$html .= $this->menuCMSCategory($categories, $categories[$id_cms_category][$key], $key, $id_selected, $is_html,$pref_value);
		return $html;
	}
 
 public function getContent()
  {
    global $cookie;

    if(Tools::isSubmit('submitwpblocktopmenu'))
    {
    $data=Tools::getValue('items');
   
    if ($data!='')
    {
    $data_array=$this->_unserializeJQuery($data);
    $q=array();
    $order=1;
    foreach ($data_array as $key=>$value)
    {
    $values=explode("|",$value);
    $q[]="(".$key.",".($values[2]=='root'?"NULL":$values[2]).",'".$values[0]."',".$values[1].",".($order++).",".($values[3]).")";
    }
  
     Db::getInstance()->Execute('TRUNCATE TABLE `'._DB_PREFIX_.'wpblocktopmenu`');
  $result=Db::getInstance()->Execute('INSERT INTO '._DB_PREFIX_.'wpblocktopmenu(`id`,`parent_id`,`type`,`id_ref`,`order`,`depth`) VALUES '.implode(",",$q).'  ON DUPLICATE KEY UPDATE `type`=VALUES(`type`),`parent_id`=VALUES(`parent_id`),`order`=VALUES(`order`),`depth`=VALUES(`depth`)');
    }
     }
    if(Tools::isSubmit('submitwpblocktopmenuLinks'))
    {
      if(Tools::getValue('link') == '')
      {
        $this->_html .= $this->displayError($this->l('Unable to add this link'));
      }
      else
      {
        WPMenuTopLinks::add(Tools::getValue('link'), Tools::getValue('label'), Tools::getValue('new_window', 0));
        $this->_html .= $this->displayConfirmation($this->l('The link has been added'));
      }
    }
  
    $this->_html .= '
    <script type="text/javascript" src="'.$this->_path.'js/jquery-ui-1.8.11.custom.min.js"></script>
    <script type="text/javascript" src="'.$this->_path.'js/jquery.ui.nestedSortable.js"></script>
   <script type="text/javascript" src="'.$this->_path.'js/backend.js"></script>
   <script>
    function add()
          {
            $("#availableItems option:selected").each(function(i){
              var val = $(this).val();
              var text = $(this).text();
              if(val == "PRODUCT")
              {
                val = prompt("'.$this->l('Set ID product').'");
                if(val == null || val == "" || isNaN(val))
                  return;
                text = "'.$this->l('Product ID').' "+val;
                val = "PRD"+val;
              }
              var id=val.substring(3);
              $("#wp_menu").append("<li id=\"list_"+(no_menu_items++)+"\"><div>"+text+"<input type=\"hidden\" class=\"type\" value=\""+val.substring(0,3)+"\" /><input type=\"hidden\" class=\"parent_id\" value=\"0\" /><input type=\"hidden\" class=\"id_ref\" value=\""+id+"\" /></div>");
            
           
           });
           
            return false;
          }
          </script>
     <style type="text/css">
     optgroup {
    
     }
     
     .remove {
     cursor:pointer;
     }
     #availableItems {
      width:300px;
      padding:10px;
     }
     
     option {
     
     
     }
     
     .option  {
    
     }
     #menu_items {
    
     }
     #menu_items h1 {
     padding:5px 40px;
     background:transparent url("'.$this->_path.'img/menu.png") 0 0 no-repeat;
     border-bottom:solid 1px #cccccc;
     }
     
     .box {
     
     border:solid 1px #cccccc;
     padding:10px;
     float:left;
     margin-right:2em;
     border-radius: 10px;

-ms-border-radius: 10px;

-moz-border-radius: 10px;

-webkit-border-radius: 10px;

-khtml-border-radius: 10px;
   background: #fafad2; /* for non-css3 browsers */

     }
     
     .box_submit {
     width:150px;
	 float:right;
     }
     #wp_menu {
     margin:0px;
     }
     
     ol {
			margin: 0;
			padding: 0;
			padding-left: 30px;
			
		}

		ol.sortable, ol.sortable ol {
			margin: 0 0 0 25px;
			padding: 0;
			list-style-type: none;
		}

		ol.sortable {
			margin: 4em 0;
			width:300px;
		}
		
		.sortable li span.remove {
		font-size:10px;
		color:#ffcc00;
		display:block;
		text-align:right;
		padding:0px;
		margin:0px;
		}

		.sortable li {
		
			margin: 7px 0 7px 0;
			padding: 0;
			
		}

		.sortable li div  {
		
			
			 border-radius: 10px;

-ms-border-radius: 10px;

-moz-border-radius: 10px;

-webkit-border-radius: 10px;

-khtml-border-radius: 10px;
background-color:#ffffff;
			padding: 7px;
			margin: 0;
			cursor: move;
		}
		
		#availableItems {
		overflow:visible;
		}
		#addItem {
		border:solid 1px #666666;
		background:#ffffff url("'.$this->_path.'img/popup_footer.gif") 0 0 repeat;
		padding:10px;
		display:block;
		margin:10px 0px;
		text-align:center;
		font-weight:bold;
		 border-radius: 10px;

-ms-border-radius: 10px;

-moz-border-radius: 10px;

-webkit-border-radius: 10px;

-khtml-border-radius: 10px;
		}
		
        </style>
    <fieldset>
      <legend>'.$this->l('Settings').'</legend>
      <form action="'.$_SERVER['REQUEST_URI'].'" method="post" id="form">
          <input type="hidden" name="items" id="itemsInput" value="" size="200" />
  			
        <div class="clear">&nbsp;</div>
       <div id="menu_items">
       <div class=" box_submit">
        
        <p class="center">
          <input type="submit" id="submitwpblocktopmenu" name="submitwpblocktopmenu" value="'.$this->l('  Save  ').'" class="button" />
        </p>
        </div><h1>'.$this->l('Menu').'</h1>    
       <div class="wp_items box">
                <select multiple="multiple" id="availableItems" style="">';
                
                //BEGIN CMS Categories
                $this->_html .= '<optgroup label="'.$this->l('CMS Categories').'">';
                $_cms_cat=CMSCategory::getCategories($cookie->id_lang);
                  
               $this->_html .=$this->menuCMSCategory($_cms_cat,$_cms_cat[0][1],1,1,1,'CCS');
                
               $this->_html .= '</optgroup>';
                //END CMS Categories
                // BEGIN CMS
                $this->_html .= '<optgroup label="'.$this->l('CMS').'">';
                $_cms = CMS::listCms($cookie->id_lang);
            
                foreach($_cms as $cms)
                  $this->_html .= '<option value="CMS'.$cms['id_cms'].'" ">'.$cms['meta_title'].'</option>';
                $this->_html .= '</optgroup>';
                // END CMS
                // BEGIN SUPPLIER
                $this->_html .= '<optgroup label="'.$this->l('Supplier').'">';
                $suppliers = Supplier::getSuppliers(false, $cookie->id_lang);
                foreach($suppliers as $supplier)
                  $this->_html .= '<option value="SUP'.$supplier['id_supplier'].'" ">'.$supplier['name'].'</option>';
                $this->_html .= '</optgroup>';
                // END SUPPLIER
                // BEGIN Manufacturer
                $this->_html .= '<optgroup label="'.$this->l('Manufacturer').'">';
                $manufacturers = Manufacturer::getManufacturers(false, $cookie->id_lang);
                foreach($manufacturers as $manufacturer)
                  $this->_html .= '<option value="MAN'.$manufacturer['id_manufacturer'].'" ">'.$manufacturer['name'].'</option>';
                $this->_html .= '</optgroup>';
                // END Manufacturer
                // BEGIN Categories
                $this->_html .= '<optgroup label="'.$this->l('Categories').'">';
                $this->getCategoryOption1(1, $cookie->id_lang);
                $this->_html .= '</optgroup>';
                // END Categories
                // BEGIN Products
                $this->_html .= '<optgroup label="'.$this->l('Products').'">';
                  $this->_html .= '<option value="PRODUCT" font-style:italic">'.$this->l('Choose ID product').'</option>';
                $this->_html .= '</optgroup>';
                // END Products
                // BEGIN Menu Top Links
                $this->_html .= '<optgroup label="'.$this->l('Menu Top Links').'">';
                $links = WPMenuTopLinks::gets($cookie->id_lang);
                foreach($links as $link)
                  $this->_html .= '<option value="LNK'.$link['id_link'].'" ">'.$link['label'].'</option>';
                $this->_html .= '</optgroup>';
                // END Menu Top Links
                $this->_html .= '</select><br />
                <br />
                <a href="#" id="addItem" >'.$this->l('Add').'</a>			
             
        
        </div>
        
       <div class="wp_menu box">';
            
			$this->makeMenuOption();
                $this->_html .= '</ol><br/>
                <br/>
                
               
        
		</div>
		
             
   
        </div>
      </form>
      <div class="clear">&nbsp;</div>
    </fieldset><br />';

		$defaultLanguage = intval(Configuration::get('PS_LANG_DEFAULT'));
		$languages = Language::getLanguages();
		$iso = Language::getIsoById($defaultLanguage);
		$divLangName = 'link_label';
    $this->_html .= '
    <fieldset>
      <legend><img src="../img/admin/add.gif" alt="" title="" />'.$this->l('Add Menu Top Link').'</legend>
      <form action="'.$_SERVER['REQUEST_URI'].'" method="post" id="form">
  			<label>'.$this->l('Label').'</label>
        <div class="margin-form">';
				foreach ($languages as $language)
				{
					$this->_html .= '
					<div id="link_label_'.$language['id_lang'].'" style="display: '.($language['id_lang'] == $defaultLanguage ? 'block' : 'none').';float: left;">
						<input type="text" name="label['.$language['id_lang'].']" id="label_'.$language['id_lang'].'" size="70" value="" />
					</div>';
				 }
				$this->_html .= $this->displayFlags($languages, $defaultLanguage, $divLangName, 'link_label', true);

        $this->_html .= '</div><p class="clear"> </p>
  			<label>'.$this->l('Link').'</label>
  			<div class="margin-form">
          <input type="text" name="link" value="" size="70" />
  			</div>
  			<label>'.$this->l('New Window').'</label>
  			<div class="margin-form">
          <input type="checkbox" name="new_window" value="1" />
  			</div>
        <p class="center">
          <input type="submit" name="submitwpblocktopmenuLinks" value="'.$this->l('  Add  ').'" class="button" />
        </p>
  		</form>
    </fieldset><br />';
    
    $this->_html .= '
    <fieldset>
      <legend><img src="../img/admin/details.gif" alt="" title="" />'.$this->l('List Menu Top Link').'</legend>
      <table style="width:100%;">
        <thead>
          <tr>
            <th>'.$this->l('Id Link').'</th>
            <th>'.$this->l('Label').'</th>
            <th>'.$this->l('Link').'</th>
            <th>'.$this->l('New Window').'</th>
            <th>'.$this->l('Action').'</th>
          </tr>
        </thead>
        <tbody>';
        $links = WPMenuTopLinks::gets($cookie->id_lang);
        foreach($links as $link)
        {
          $this->_html .= '
          <tr>
            <td>'.$link['id_link'].'</td>
            <td>'.$link['label'].'</td>
            <td>'.$link['link'].'</td>
            <td>'.(($link['new_window']) ? $this->l('Yes') : $this->l('No')).'</td>
            <td>
              <form action="'.$_SERVER['REQUEST_URI'].'" method="post">
                <input type="hidden" name="id_link" value="'.$link['id_link'].'" />
          			<input type="submit" name="submitwpblocktopmenuRemove" value="'.$this->l('Remove').'" class="button" />
          		</form>
            </td>
          </tr>';
        }
        $this->_html .= '</tbody>
      </table>
  	</fieldset>';
    echo $this->_html;
  }
  
  

  private function getMenuItems()
  {
  
 $items=Db::getInstance()->ExecuteS('SELECT * FROM `'._DB_PREFIX_.'wpblocktopmenu` order by `order`');
   $results=array();
 
  /* $this->reorderItems($items,$results);*/
   
    return $items;
  }
  
  private function getLastIndex()
  {
  $item=Db::getInstance()->getRow('SELECT id FROM `'._DB_PREFIX_.'wpblocktopmenu` order by `id` desc');
if ($item) return $item['id']+1;
 return 0;
  }

private function reorderItems($items,$result,$depth=1)
{
$found=0;
$i=0;
while ($i< count($items) && $items[$i]['depth']!=$depth ) {$i++;}
echo $i;
if ($i==count($items)) {
if ($depth>1)
{
 $this->reorderItems($items,$result,$depth-1);
}
else
return 1;
}
$result[]=$items[$i];

$depth=$items[$i]['depth'];
unset($items[$i]);
$this->reorderItems($items,$result,$depth);
return 0;
}
  private function makeMenuOption()
  {global $cookie, $page_name;

  $curr_level=1;
    
    $items=$this->getMenuItems();  
     $this->_html.="<script type=\"text/javascript\">var no_menu_items=".$this->getLastIndex().";</script>";
    $this->_html.='<ol id="wp_menu" class="level0 sortable">';
    foreach($items as $key=>$item)
    {
    extract($item);
    if ($depth>$curr_level) {$this->_html.='<ol class="level'.$depth.' ">';}
    if ($depth==$curr_level && $key!=0) {$this->_html.='</li>';}
    if ($depth<$curr_level) {$this->_html.=str_repeat('</li></ol>',$curr_level-$depth).'</li>';}
    $curr_level=$depth; 
     switch($type)
    
      {
      
        case'CAT':
        $this->_html.='<li id="list_'.$id.'" ><div><input type="hidden" class="type" value="CAT" /><input type="hidden" class="id_ref" value="'.$id_ref.'" />';
          $this->getCategoryOption($id_ref, $cookie->id_lang,  false);
            $this->_html.='<span class="remove">'.$this->l('remove').'</span></div>'.PHP_EOL;;
        break;
        case'PRD':
          $product = new Product($id_ref, true, $cookie->id_lang);
          if(!is_null($product->id))
            $this->_html .= '<li id="list_'.$id.'"><div><input type="hidden" class="type" value="PRD" /><input type="hidden" class="id_ref" value="'.$id_ref.'" />'.$product->name.'<span class="remove">'.$this->l('remove').'</span></div>'.PHP_EOL;
        break;
         case'CCS':
          
          $_this_cat=new CMSCategory($id_ref,$cookie->id_lang);
          
          $this->_html .='<li id="list_'.$id.'"><div><input type="hidden" class="type" value="CCS" /><input type="hidden" class="id_ref" value="'.$id_ref.'" />'.$_this_cat->name.' (CAT)
          <span class="remove">'.$this->l('remove').'</span></div>'.PHP_EOL;
        break;
        case'CMS':
          $cms = CMS::getLinks($cookie->id_lang, array($id_ref));
          if(count($cms))
            $this->_html .= '<li id="list_'.$id.'"><div><input type="hidden" class="type" value="CMS" /><input type="hidden" class="id_ref" value="'.$id_ref.'" />'.$cms[0]['meta_title'].'<span class="remove">'.$this->l('remove').'</span></div>'.PHP_EOL;
        break;
        case'MAN':
          $manufacturer = new Manufacturer($id_ref, $cookie->id_lang);
          if(!is_null($manufacturer->id_ref))
            $this->_html .= '<li id="list_'.$id.'"><div><input type="hidden" class="type" value="MAN" /><input type="hidden" class="id_ref" value="'.$id_ref.'" />'.$manufacturer->name.'<span class="remove">'.$this->l('remove').'</span></div>'.PHP_EOL;
        break;
        case'SUP':
          $supplier = new Supplier($id_ref, $cookie->id_lang);
          if(!is_null($supplier->id_ref))
            $this->_html .= '<li value="list_'.$id.'"><div><input type="hidden" class="type" value="SUP" /><input type="hidden" class="id_ref" value="'.$id_ref.'" />'.$supplier->name.'<span class="remove">'.$this->l('remove').'</span></div>'.PHP_EOL;
        break;
        case'LNK':
       
          $link = WPMenuTopLinks::get($id_ref, $cookie->id_lang); 
          if(count($link))
            $this->_html .= '<li id="list_'.$id.'"><div><input type="hidden" class="type" value="LNK" /><input type="hidden" class="id_ref" value="'.$id_ref.'" />'.$link[0]['label'].'<span class="remove">'.$this->l('remove').'</span></div>'.PHP_EOL;
        break;
      }
      
    

    }
     $this->_html.=str_repeat('</li></ol>',$curr_level-1).'</li>';
  }
  


  private function makeMenu()
  {
		global $cookie, $page_name;
		  $curr_level=1;
    foreach($this->getMenuItems() as $key=>$item)
    {
    extract($item);
  
    
    if ($depth>$curr_level) {$this->_menu.='<ul>';}
    if ($depth==$curr_level && $key!=0) {$this->_menu.='</li>';}
    if ($depth<$curr_level) {$this->_menu.=str_repeat('</li></ul>',$curr_level-$depth).'</li>';}
    $curr_level=$depth;
     switch($type)
      {
      
        case'CAT':
         $this->getCategory($id_ref, $cookie->id_lang);
        break;
        case'PRD':
        $selected = ($page_name == 'product' && (Tools::getValue('id_product') == $id_ref)) ? ' class="sfHover"' : '';
          $product = new Product($id_ref, true, $cookie->id_lang);
          if(!is_null($product->id))
            $this->_menu .= '<li'.$selected.'><a href="'.$product->getLink().'"><span>'.$product->name.'</span></a>'.PHP_EOL;
             break;
         case'CCS':
           $selected = ($page_name == 'cms' && (Tools::getValue('id_cms_category') == $id_ref)) ? ' class="sfHover"' : '';
          $_this_cat=new CMSCategory($id_ref,$cookie->id_lang);
          $link = new Link();
          
          $this->_menu.='<li'.$selected.'><a href="'.$link->getCMSCategoryLink($_this_cat->id,$_this_cat->link_rewrite).'"><span>'.htmlentities($_this_cat->name).'
          </span></a>'.PHP_EOL;
        break;
        case'CMS':
         $selected = ($page_name == 'cms' && (Tools::getValue('id_cms') == $id_ref)) ? ' class="sfHover"' : '';
          $cms = CMS::getLinks($cookie->id_lang, array($id_ref));
          if(count($cms))
            $this->_menu .= '<li'.$selected.'><a href="'.$cms[0]['link'].'"><span>'.htmlentities($cms[0]['meta_title']).'</span></a>'.PHP_EOL;
    
        break;
        case'MAN':
           $selected = ($page_name == 'manufacturer' && (Tools::getValue('id_manufacturer') == $id_ref)) ? ' class="sfHover"' : '';
          $manufacturer = new Manufacturer($id_ref, $cookie->id_lang);
          if(!is_null($manufacturer->id))
          {
      			if (intval(Configuration::get('PS_REWRITING_SETTINGS')))
      				$manufacturer->link_rewrite = Tools::link_rewrite($manufacturer->name, false);
      			else
      				$manufacturer->link_rewrite = 0;
      			$link = new Link;
            $this->_menu .= '<li'.$selected.'><a href="'.$link->getManufacturerLink($id_ref, $manufacturer->link_rewrite).'">'.$manufacturer->name.'</a>'.PHP_EOL;
          }
         break;
        case'SUP':
         $selected = ($page_name == 'supplier' && (Tools::getValue('id_supplier') == $id_ref)) ? ' class="sfHover"' : '';
          $supplier = new Supplier($id_ref, $cookie->id_lang);
          if(!is_null($supplier->id))
          {
            $link = new Link;
            $this->_menu .= '<li'.$selected.'><a href="'.$link->getSupplierLink($id_ref, $supplier->link_rewrite).'"><span>'.$supplier->name.'</span></a>'.PHP_EOL;
          }
         break;
        case'LNK':
             $link = WPMenuTopLinks::get($id_ref, $cookie->id_lang);
          if(count($link))
            $this->_menu .= '<li><a href="'.$link[0]['link'].'"'.(($link[0]['new_window']) ? ' target="_blank"': '').'><span>'.$link[0]['label'].'</span></a>'.PHP_EOL;
     break;
      }
      
    
     
     
    }
     $this->_menu.=str_repeat('</li></ul>',$curr_level-1).'</li>';
  }
  
 public function getCategoryOption1($id_category, $id_lang, $children = true)
  {
    $categorie = new Category($id_category, $id_lang);
    if(is_null($categorie->id))
      return;
    if(count(explode('.', $categorie->name)) > 1)
      $name = str_replace('.', '', strstr($categorie->name, '.'));
    else
      $name = $categorie->name;
    $this->_html .= '<option value="CAT'.$categorie->id.'" style="margin-left:'.(($children) ? round(15+(15*(int)$categorie->level_depth)) : 0).'px;">'.$name.'</option>';
    if($children)
    {
      $childrens = Category::getChildren($id_category, $id_lang);
      if(count($childrens))
        foreach($childrens as $children)
          $this->getCategoryOption1($children['id_category'], $id_lang);
    }
  }

  private function getCategoryOption($id_category, $id_lang, $children = true)
  {
    $categorie = new Category($id_category, $id_lang);
    if(is_null($categorie->id))
      return;
    if(count(explode('.', $categorie->name)) > 1)
      $name = str_replace('.', '', strstr($categorie->name, '.'));
    else
      $name = $categorie->name;
    $this->_html .= ''.$name.'';
   
  }

  private function getCategory($id_category, $id_lang)
  {
    global $page_name;

    $categorie = new Category($id_category, $id_lang);
    if(is_null($categorie->id))
      return;
    $selected = ($page_name == 'category' && ((int)Tools::getValue('id_category') == $id_category)) ? ' class="sfHoverForce"' : '';
    $this->_menu .= '<li'.$selected.'>';
    if(count(explode('.', $categorie->name)) > 1)
      $name = str_replace('.', '', strstr($categorie->name, '.'));
    else
      $name = $categorie->name;
    if ($id_category==1)
    {
    $this->_menu .= '<a href="'._PS_BASE_URL_.__PS_BASE_URI__.'"><span>'.htmlentities($name).'</span></a>';
    }
    else {
    $this->_menu .= '<a href="'.$categorie->getLink().'"><span>'.htmlentities($name).'</span></a>';
    }
  }
public function hookHeader()
	{
	
		Tools::addJS($this->path.'/js/superfish-modified.js');
		
		
	}
	
  public function hooktop($param)
  {
		global $smarty;
		$this->makeMenu();
		
		$smarty->assign('MENU_SEARCH', Configuration::get('MOD_wpblocktopmenu_SEARCH'));
		$smarty->assign('MENU', preg_replace('~>\s+<~', '><', $this->_menu));
		$smarty->assign('this_path', $this->_path);
    return $this->display(__FILE__, 'blank_blocktopmenu.tpl');
  }
  
}
?>