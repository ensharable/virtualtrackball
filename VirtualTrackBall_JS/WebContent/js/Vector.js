Ensharable.Vector = function(x, y, z) {

	this.x = x || 0;
	this.y = y || 0;
	this.z = z || 0;
};

Ensharable.Vector.prototype = {

	len : function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	},

	nor : function() {
		var length = this.len();
		if (length == 0) {
			this.x = 0;
			this.y = 0;
			this.z = 0;
		} else {
			this.x = this.x / length;
			this.y = this.y / length;
			this.z = this.z / length;
		}
		return this;
	},

	clone : function() {
		return new Ensharable.Vector(this.x, this.y, this.z);
	},

	cross : function(a) {
		var x = this.x, y = this.y, z = this.z;
		this.x = y * a.z - z * a.y;
		this.y = z * a.x - x * a.z;
		this.z = x * a.y - y * a.x;
		return this;
	},

	sub : function(a) {
		this.x = this.x-a.x;
		this.y = this.y-a.y;
		this.z = this.z-a.z;
		return this;
	},
};