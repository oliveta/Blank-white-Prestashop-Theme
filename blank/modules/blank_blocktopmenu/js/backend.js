$(document).ready(function(){

var options;
options=$("#availableItems option");
optgroup=$("#availableItems optgroup");
$("#availableItems").height((options.length+optgroup.length)*15+'px');

if ($("ol.sortable"))
{ $("ol.sortable").nestedSortable({
			disableNesting: "no-nest",
			forcePlaceholderSize: true,
			handle: "div",
			helper:	"clone",
			items: "li",
			maxLevels: 3,
			opacity: .6,
			placeholder: "placeholder",
			revert: 250,
			tabSize: 25,
			tolerance: "pointer",
			toleranceElement: "> div"
		});
		
		}

//removing menu items
if ($(".remove"))
{
$(".remove").click(function() {
$(this).closest("li").remove();
});
}

        
          $("#addItem").click(add);
          $("#availableItems").dblclick(add);
        
          
//saving menu          
          $("#form").submit(function() {
         serialized = $("ol.sortable").nestedSortable("toArray");

        s=new Array();
        $.each(serialized,function(key,item) {
    
        if (key>0)
        s.push(item["item_id"]+"="+$("#list_"+item["item_id"]+" .type").val()+"|"+$("#list_"+item["item_id"]+" .id_ref").val()+"|"+item["parent_id"]+"|"+item["depth"]);
        });
         serialized=s.join("&");
        
        
       
			$("#itemsInput").val(serialized);
			
			return true;
          
          });
          
     //adding menu items to the menu     
         
         
         
         
       
		
	
});