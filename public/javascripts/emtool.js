/*------------------------------------ Drag and drop --------------------------------------------------*/


function allowDrop(ev)
{
ev.preventDefault();
}

function drag(ev)
{

ev.dataTransfer.setData("Text",ev.target.id);
}

function drop(ev,hexag_array,stage,layer,gridHeight)
{
ev.preventDefault();
var data=ev.dataTransfer.getData("Text");

var radius = hexag_array[0].getRadius();
var height = (radius * Math.sqrt(3));
var side = radius * 3 / 2;

// Get content element description
var r = $("#container");   
var p = $((r.children().first()).children().first());
var off = p.offset(); 
var e = $("#"+data);
console.log($(e.parent().prev()).html());

// Get pixel co-ordinates relative to canvas/stage to position id text
var xpos= ev.pageX-off.left;
var ypos = ev.pageY-off.top;

// Find matrix co-ordinates
var col = Math.round((xpos-radius)/(side+3));
var i1 = col%2;
var i2 = (i1*height)/2;
var i3 = ypos - radius - i2;
var row = Math.round(i3 / (height+4));

// Get pixel co-ordinates of hexagon on the canvas
var arr_index = (col*gridHeight)+row;
var textX = ((hexag_array[arr_index]).getX()) - Math.round(radius/2);
var textY = ((hexag_array[arr_index]).getY());
var simpleText = new Kinetic.Text({
    x: textX,
    y: textY,
    text: data,
    fontSize: 10,
    fontFamily: 'Calibri',
    fill: 'white'
  });

/*
// Creating group
var group = new Kinetic.Group({ 
});
group.add(hexag_array[(col*80)+row]);
group.add(simpleText);
layer.add(group);*/
hexag_array[arr_index].setFill("blue");
layer.add(hexag_array[arr_index]);
layer.add(simpleText);
stage.add(layer);

}