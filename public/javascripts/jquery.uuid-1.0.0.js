/*
    UUID plugin for jQuery
    Copyright (c) 2013 Andre Ventura (http://github.com/andreventuravale)
    Licensed under the MIT license (http://github.com/andreventuravale/common/blob/master/mit-license.txt)
    Version: 1.0.0 
*/

(function ($) {

    function randHexStr(n) {
        var dig;
        var hex = [];
        var len = 0;
        while (len < n) {
            dig = (((Math.random() * 100) % 16) & 0xFF).toString(16);
            hex.push(dig);
            len++;
        }
        return hex.join("");
    }

    function newUUID() {
        return randHexStr(8) +
             "-" + randHexStr(4) +
             "-4" + randHexStr(3) +
             "-a" + randHexStr(3) +
             "-" + randHexStr(12);
    }

    $.fn.newUUID = function (closure) {
        this.each(function () {
            if (closure)
                closure.call(this, newUUID());
        });
        return this;
    };

    $.newUUID = newUUID;

})(jQuery);