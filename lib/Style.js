/**
 * Style
 */
"use strict";

class Style
{
	constructor(owner)
	{
		this.color = "green";
		this.bg = "blue";
		if(owner){owner.color = "orange";
		//	ts.debug(17,owner.name);
		}
	}
}

module.exports = Style;
