


	  <span
	    ondblclick="var text_val=$(this).text(); $(this).text(''); 
			$('<input class=\'item-name\' type=\'text\'>').appendTo($(this).parent()).val(text_val).focus();
			console.log($(this).parent());
			"
	    >
      <!--Body content-->

      <ul class="items sortable" id="items-list">
        <li ng-repeat="item in items | filter:query | orderBy:orderProp"
            class="item-listing">
	  <span
	    ondblclick="var text_val=$(this).text(); $(this).text(''); 
			$('<input class=\'item-name\' type=\'text\'>').appendTo($(this).parent()).val(text_val).focus();
			console.log($(this).parent());
			"
	    >
	  {{item.name}}
        </li>
      </ul>



      <ul class="items">
        <li ng-repeat="item in items | filter:query | orderBy:orderProp"
	    data-drop="true" jqyoui-droppable
	    data-jqyoui-options="{scope:'items'}"
            class="item-listing">
	  <div
	    data-drag="true" jqyoui-draggable="{animate:true}"
	    data-jqyoui-options="{scope:'items', revert: 'invalid', grid: [50, 30],
				 snapMode: 'outer', axis:'y', opacity: 0.8, cancel:'.item-name', cursor:'-webkit-grabbing'}"
	     class="item">
	    <!-- snap:'.item-listing',   -->
	    <!-- ng-drag="true" ng-drag-data="{item:id}" ng-drag-success="onDragComplete($data,$event)" ng-center-anchor="true" -->
	    <span class="item-handle">{{item.id}}</span>
            <span class="item-name">{{item.name}}</a>
	  </div>
        </li>
      </ul>


$('.sortable').sortable({
  items: 'li', axis: 'y',
  revert: true
});

$(".item-name")
  .on( "mouseover", function() {
    $( this ).css( "color", "red" );
  })
  .on('dblclick', 'li', function(){
    console.log($(this).text(""));
  });     
//   css({ 'color': 'red'});


$("#items-list").
  on('dblclick', 'li', function(){
    console.log($(this).text(""));
  });


//   .on('dblclick', 'li', function () {
//     oriVal = $(this).text();
//     $(this).text("");
//     $("<input type='text'>").appendTo(this).focus();
// });

	  // <input class="item-name" type="text"
	  //        value="{{item.name}}"
	  //        readonly="true"
	  //        ondblclick="this.style.color='green';  this.readOnly='';      "
	  //        onfocus="   this.style.color='purple'; this.readOnly='';      "
	  //        onselect="  this.style.color='red';    // this.readOnly='';      "
	  //        onblur="    this.style.color='blue';   this.readOnly='true';  "
	  //        >
    // "ng-sortable":         "1.2.0",  
