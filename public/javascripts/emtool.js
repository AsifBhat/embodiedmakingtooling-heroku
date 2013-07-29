/*------------------------------------ Drag and drop --------------------------------------------------*/


function allowDrop(ev){
    ev.preventDefault();
}

function drag(ev){
    ev.dataTransfer.setData("Text",ev.target.id);
}

function drop(ev,hexag_array,stage,layer,gridHeight){
    ev.preventDefault();
    var data=ev.dataTransfer.getData("Text");

    var radius = hexag_array[0].getRadius();
    var height = (radius * Math.sqrt(3));
    var side = radius * 3 / 2;

    // Get content element description
    var r = $("#container");   
    var p = $((r.children().first()).children().first());
    var off = p.offset(); 
    var e = $("#" + data);
    var desc = $(e.parent().prev()).html();
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

    // Color coding based on type of content element
    var hexcolor = 'white';
    if(data.indexOf('F') == 0) {
    	hexcolor = 'blue';
    } else if(data.indexOf('S')===0) {
    	hexcolor ='red';
    } else {
    	hexcolor='yellow';
    }

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

    /*  Adding Tool tip */
    var tooltip = new Kinetic.Label({
        x: 170,
        y: 75,
        opacity: 0.75
    });

      tooltip.add(new Kinetic.Tag({
        fill: 'black',
        pointerDirection: 'down',
        pointerWidth: 10,
        pointerHeight: 10,
        lineJoin: 'round',
        shadowColor: 'black',
        shadowBlur: 10,
        shadowOffset: 10,
        shadowOpacity: 0.5
      }));
          
       tooltip.add(new Kinetic.Text({
        text: desc,
        fontFamily: 'Calibri',
        fontSize: 14,
        padding: 1,
        fill: 'white'
      }));

    hexag_array[arr_index].on("mousemove", function(){
        tooltip.setPosition(textX + 5, textY + 5);               
        tooltip.show();
        layer.draw();
        stage.add(layer);
    });
     
    hexag_array[arr_index].on("mouseout", function(){
        tooltip.hide();
        layer.draw();
        stage.add(layer);
    });

    hexag_array[arr_index].setFill(hexcolor);
    layer.add(hexag_array[arr_index]);
    layer.add(simpleText);
    layer.add(tooltip);
    stage.add(layer);

}