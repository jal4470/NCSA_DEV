/* jQuery ColorPicker
   Written by Virgil Reboton(vreboton@gmail.com)
   
   ColorPicker function structures and attahcment is base on
   jQuery UI Date Picker v3.3beta
   by Marc Grabanski (m@marcgrabanski.com) and Keith Wood (kbwood@virginbroadband.com.au).
   
   ColorPicker render data is base on
   http://www.mattkruse.com/javascript/colorpicker/
   by Matt Kruse

*/
   
(function($) { // hide the namespace

function colorPicker()
{
	this._nextId = 0; // Next ID for a time picker instance
	this._inst = []; // List of instances indexed by ID
	this._curInst = null; // The current instance in use
	this._colorpickerShowing = false;
	this._colorPickerDiv = $('<div id="colorPickerDiv"></div>');
}
$.extend(colorPicker.prototype, {
	/* Class name added to elements to indicate already configured with a time picker. */
	markerClassName: 'hasColorPicker',

	/* Register a new time picker instance - with custom settings. */
	_register: function(inst) {
		var id = this._nextId++;
		this._inst[id] = inst;
		return id;
	},

	/* Retrieve a particular time picker instance based on its ID. */
	_getInst: function(id) {
		return this._inst[id] || id;
	},
	
	/* Handle keystrokes. */
	_doKeyDown: function(e) {
        var inst = $.colorPicker._getInst(this._colId);
		if ($.colorPicker._colorpickerShowing) {
			switch (e.keyCode) {
				case 9: 
				    // hide on tab out
				    $.colorPicker.hideColorPicker();
                    break; 

				case 27: 
				    // hide on escape
				    $.colorPicker.hideColorPicker();
					break;
            }
		}
		else if (e.keyCode == 40) { // display the time picker on down arrow key
			$.colorPicker.showFor(this);
		}
	},

/* Handle keystrokes. */
	_resetSample: function(e) {
        var inst = $.colorPicker._getInst(this._colId);
		inst._sampleSpan.css('background-color', inst._input.value);
		alert(inst._input.value);
	},
	
    /* Does this element have a particular class? */
	_hasClass: function(element, className) {
		var classes = element.attr('class');
		return (classes && classes.indexOf(className) > -1);
	},

    /* Pop-up the time picker for a given input field.
	   @param  control  element - the input field attached to the time picker or
	                    string - the ID or other jQuery selector of the input field or
	                    object - jQuery object for input field
	   @return the manager object */
	showFor: function(control) {
		control = (control.jquery ? control[0] :
			(typeof control == 'string' ? $(control)[0] : control));
		var input = (control.nodeName && control.nodeName.toLowerCase() == 'input' ? control : this);
		
		if ($.colorPicker._lastInput == input) { return; }
		if ($.colorPicker._colorpickerShowing) { return; }
		
		var inst = $.colorPicker._getInst(input._colId);
		
		$.colorPicker.hideColorPicker();
		$.colorPicker._lastInput = input;
		
		if (!$.colorPicker._pos) { // position below input
			$.colorPicker._pos = $.colorPicker._findPos(input);
			$.colorPicker._pos[1] += input.offsetHeight; // add the height			
		}
		
		var isFixed = false;
		$(input).parents().each(function() {
			isFixed |= $(this).css('position') == 'fixed';
		});
		
		if (isFixed && $.browser.opera) { // correction for Opera when fixed and scrolled
			$.colorPicker._pos[0] -= document.documentElement.scrollLeft;
			$.colorPicker._pos[1] -= document.documentElement.scrollTop;
		}
	
	    inst._colorPickerDiv.css('position', ($.blockUI ? 'static' : (isFixed ? 'fixed' : 'absolute'))).css('left', $.colorPicker._pos[0] + 'px').css('top', $.colorPicker._pos[1]+1 + 'px');
	
		$.colorPicker._pos = null;
		$.colorPicker._showColorPicker(inst);

		return this;
	},

    /* Find an object's position on the screen. */
	_findPos: function(obj) {
		while (obj && (obj.type == 'hidden' || obj.nodeType != 1)) {
			obj = obj.nextSibling;
		}
		var curleft = curtop = 0;
		if (obj && obj.offsetParent) {
			curleft = obj.offsetLeft;
			curtop = obj.offsetTop;
			while (obj = obj.offsetParent) {
				var origcurleft = curleft;
				curleft += obj.offsetLeft;
				if (curleft < 0) {
					curleft = origcurleft;
				}
				curtop += obj.offsetTop;
			}
		}
		return [curleft,curtop];
	},
	
	/* Close time picker if clicked elsewhere. */
	_checkExternalClick: function(event) {
		if (!$.colorPicker._curInst)
		{
			return;
		}
		var target = $(event.target);		
				
		if ((target.parents("#colorPickerDiv").length == 0) && $.colorPicker._colorpickerShowing && !($.blockUI))
		{
		    if (target.text() != $.colorPicker._curInst._colorPickerDiv.text())
		        $.colorPicker.hideColorPicker();
		}
	},

    /* Hide the time picker from view.
	   @param  speed  string - the speed at which to close the time picker
	   @return void */
	hideColorPicker: function(s) {
		var inst = this._curInst;
		if (!inst) {
			return;
		}		
 
		if (this._colorpickerShowing)
		{
			this._colorpickerShowing = false;
			this._lastInput = null;
			
			this._colorPickerDiv.css('position', 'absolute').css('left', '0px').css('top', '-1000px');
			
			if ($.blockUI)
			{
				$.unblockUI();
				$('body').append(this._colorPickerDiv);
			}
        
            this._curInst = null;        			
		}
		
		if (inst._input[0].value != $.css(inst._sampleSpan,'background-color'))
		{
		    inst._sampleSpan.css('background-color',inst._input[0].value);
		}
	},

	/* Attach the time picker to an input field. */
	_connectColorPicker: function(target, inst) {
		var input = $(target);
		if (this._hasClass(input, this.markerClassName)) { return; }
		
		$(input).attr('autocomplete', 'OFF'); // Disable browser autocomplete		
		inst._input = $(input);	
		
		// Create sample span
		inst._sampleSpan = $('<span class="ColorPickerDivSample" style="background-color:' + inst._input[0].value + ';height:' + inst._input[0].offsetHeight + ';">&nbsp;</span>');
		input.after(inst._sampleSpan);
		
		inst._sampleSpan.click(function() {
		    input.focus();
		});
								
		input.focus(this.showFor);
		
		input.addClass(this.markerClassName).keydown(this._doKeyDown);
		input[0]._colId = inst._id;		
	},
	
	
	/* Construct and display the time picker. */
	_showColorPicker: function(id) {
		var inst = this._getInst(id);
		this._updateColorPicker(inst);
		
        inst._colorPickerDiv.css('width', inst._startTime != null ? '10em' : '6em');
		
		inst._colorPickerDiv.show('fast');
		if (inst._input[0].type != 'hidden')
        {
		    inst._input[0].focus();
        }
		
		this._curInst = inst;
		this._colorpickerShowing = true;
	},

	/* Generate the time picker content. */
	_updateColorPicker: function(inst) {
		inst._colorPickerDiv.empty().append(inst._generateColorPicker());
		if (inst._input && inst._input[0].type != 'hidden')
		{
			inst._input[0].focus();
			
            $("td.color", inst._timePickerDiv).unbind().mouseover(function() {
                inst._sampleSpan.css('background-color', $.css(this,'background-color'));
            }).click(function() {
                inst._setValue(this);
            });
        }
    } 
	
});

/* Individualised settings for time picker functionality applied to one or more related inputs.
   Instances are managed and manipulated through the TimePicker manager. */
function ColorPickerInstance()
{
	this._id = $.colorPicker._register(this);
	this._input = null;
	this._colorPickerDiv = $.colorPicker._colorPickerDiv;
	this._sampleSpan = null;
}

$.extend(ColorPickerInstance.prototype, {
	/* Get a setting value, defaulting if necessary. */
	_get: function(name) {
		return (this._settings[name] != null ? this._settings[name] : $.colorPicker._defaults[name]);
	},
	
    _getValue: function () {
        if (this._input && this._input[0].type != 'hidden' && this._input[0].value != "")
		{
			return this._input[0].value;
        }
        return null;
    },
	
	_setValue: function (sel) {
        // Update input field
        if (this._input && this._input[0].type != 'hidden')
		{
		    this._input[0].value = $.attr(sel,'title').replace('#','');
			$(this._input[0]).change();
        }
        
        // Hide picker
        $.colorPicker.hideColorPicker();
    },
   	
	/* Generate the HTML for the current state of the time picker. */
	_generateColorPicker: function() {
        // Code to populate color picker window
        var colors  = new Array("#ff7f7f",
"#ff857f",
"#ff8c7f",
"#ff927f",
"#ff997f",
"#ff9f7f",
"#ffa57f",
"#ffac7f",
"#ffb27f",
"#ffb87f",
"#ffbf7f",
"#ffc57f",
"#ffcc7f",
"#ffd27f",
"#ffd87f",
"#ffdf7f",
"#ffe57f",
"#ffeb7f",
"#fff27f",
"#fff87f",
"#ffff7f",
"#f8ff7f",
"#f2ff7f",
"#ebff7f",
"#e5ff7f",
"#dfff7f",
"#d8ff7f",
"#d2ff7f",
"#ccff7f",
"#c5ff7f",
"#bfff7f",
"#b8ff7f",
"#b2ff7f",
"#acff7f",
"#a5ff7f",
"#9fff7f",
"#99ff7f",
"#92ff7f",
"#8cff7f",
"#85ff7f",
"#7fff7f",
"#7fff85",
"#7fff8c",
"#7fff92",
"#7fff99",
"#7fff9f",
"#7fffa5",
"#7fffac",
"#7fffb2",
"#7fffb8",
"#7fffbf",
"#7fffc5",
"#7fffcc",
"#7fffd2",
"#7fffd8",
"#7fffdf",
"#7fffe5",
"#7fffeb",
"#7ffff2",
"#7ffff8",
"#7fffff",
"#7ff8ff",
"#7ff2ff",
"#7febff",
"#7fe5ff",
"#7fdfff",
"#7fd8ff",
"#7fd2ff",
"#7fccff",
"#7fc5ff",
"#7fbfff",
"#7fb8ff",
"#7fb2ff",
"#7facff",
"#7fa5ff",
"#7f9fff",
"#7f99ff",
"#7f92ff",
"#7f8cff",
"#7f85ff",
"#7f7fff",
"#857fff",
"#8c7fff",
"#927fff",
"#997fff",
"#9f7fff",
"#a57fff",
"#ac7fff",
"#b27fff",
"#b87fff",
"#bf7fff",
"#c57fff",
"#cb7fff",
"#d27fff",
"#d87fff",
"#df7fff",
"#e57fff",
"#eb7fff",
"#f27fff",
"#f87fff",
"#ff7fff",
"#ff7ff8",
"#ff7ff2",
"#ff7feb",
"#ff7fe5",
"#ff7fdf",
"#ff7fd8",
"#ff7fd2",
"#ff7fcb",
"#ff7fc5",
"#ff7fbf",
"#ff7fb8",
"#ff7fb2",
"#ff7fac",
"#ff7fa5",
"#ff7f9f",
"#ff7f99",
"#ff7f92",
"#ff7f8c",
"#ff7f85");
							    
        var total = colors.length;
        var width = 20;
	    var html = "<table border='1px' cellspacing='0' cellpadding='0'>";
	    
	    for (var i=0; i<total; i++)
	    {
		    if ((i % width) == 0) { html += "<tr>"; }
		    
		    html += '<td class="color" title="' + colors[i] + '" style="background-color:' + colors[i] + '"><label>&nbsp;&nbsp;&nbsp;</label></td>';
		    
		    if ( ((i+1)>=total) || (((i+1) % width) == 0))
		    {
		        html += "</tr>";
            }
		}
		
		html += '<tr><td title="" style="background-color:#999" class="color" colspan="' + width + '" align="center"><label>No Color</label></td></tr>'
		
		html += "</table>";
    
        return html
	}
	
});


/* Attach the time picker to a jQuery selection.
   @param  settings  object - the new settings to use for this time picker instance (anonymous)
   @return jQuery object - for chaining further calls */
$.fn.attachColorPicker = function() {
	return this.each(function() {
		var nodeName = this.nodeName.toLowerCase();
		if (nodeName == 'input')
		{
			var inst = new ColorPickerInstance();
			$.colorPicker._connectColorPicker(this, inst);
		} 		
	});
};

$.fn.getValue = function() {
	var inst = (this.length > 0 ? $.colorPicker._getInst(this[0]._colId) : null);
	return (inst ? inst._getValue() : null);
};

$.fn.setValue = function(value) {
	var inst = (this.length > 0 ? $.colorPicker._getInst(this[0]._colId) : null);
	if (inst) inst._setValue(value);
};

/* Initialise the time picker. */
$(document).ready(function() {
	$.colorPicker = new colorPicker(); // singleton instance
	$(document.body).append($.colorPicker._colorPickerDiv).mousedown($.colorPicker._checkExternalClick);
});

})(jQuery);