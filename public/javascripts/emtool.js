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
hexag_array[0].setFill("blue");
layer.add(hexag_array[0]);
stage.add(layer);
}