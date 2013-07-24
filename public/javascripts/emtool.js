/*------------------------------------ Drag and drop --------------------------------------------------*/


function allowDrop(ev)
{
ev.preventDefault();
}

function drag(ev)
{
// add the div back to the parent of the div
ev.dataTransfer.setData("Text",ev.target.id);
}

function drop(ev,hexag_array,stage,layer)
{
ev.preventDefault();
var data=ev.dataTransfer.getData("Text");

// Get content element description
var r = $("#container");   
var p = $((r.children().first()).children().first());
var off = p.offset(); 
var e = $("#"+data);
console.log($(e.parent().prev()).html()); // Content element description

// Get co-ordinates to position id text
var xpos = ev.clientX-off.left;
var ypos = ev.clientY-off.top;
var radius = hexag_array[0].getRadius();
var col = Math.round((xpos-20)/((2*radius)+3));
var row = Math.round((ypos)/((2*radius)+3));
alert(col);
alert(row);
var textX = ((col*((2*radius)+3))+radius);
var textY = ((row*((2*radius)+3)));
alert(textX);
alert(textY);

// Create text element
var simpleText = new Kinetic.Text({
    x: textX,
    y: textY,
    text: data,
    fontSize: 10,
    fontFamily: 'Calibri',
  });


/*
// Create group
var group = new Kinetic.Group({
    
});
group.add(simpleText);
group.add(hexag_array[(col*80)+row]);
layer.add(group);*/

stage.add(layer);
console.log(stage.getAbsolutePosition());
console.log(off.left);
console.log(ev.clientX +" : "+ ev.clientY);
/*var mousexy = stage.getMousePosition();
var mx = mousexy.x;*/
//console.log("11111111"+mx);
 // console.log(stage.getX()); //0
//console.log(stage.get('#he')[0]); not working
//console.log(stage.getMousePosition()); not working
//console.log($(ev.target).position().left); = 0
//console.log($(ev.target).position().x); 
//console.log(ev.layerX); = 0

}