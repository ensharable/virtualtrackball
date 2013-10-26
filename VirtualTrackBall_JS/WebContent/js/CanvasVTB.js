Ensharable.CanvasVTB = function(canvas) {
	this.canvas = canvas;
	this.width = canvas.width;
	this.height = canvas.height;
	Ensharable.VirtualTrackBall.prototype.setWinSize.call(this, this.width,
			this.height);
	
	this.canvas.addEventListener("mousedown", this.mouseDownHandler(),
			false);
	this.canvas.addEventListener("mouseup", this.mouseUpHandler(), false);
	this.canvas.addEventListener("mousemove", this.mouseMoveHandler(),
			false);
};

Ensharable.CanvasVTB.prototype = new Ensharable.VirtualTrackBall();

Ensharable.CanvasVTB.prototype.constructor = Ensharable.CanvasVTB;

Ensharable.CanvasVTB.prototype.mouseDownHandler = function() {
	var currentObj = this;
	return function(event) {
		currentObj.mousedown = true;
		var rect = currentObj.canvas.getBoundingClientRect();
		currentObj.setRotationStart(event.clientX - rect.left, event.clientY - rect.top);
	};
};

Ensharable.CanvasVTB.prototype.mouseUpHandler = function() {
	var currentObj = this;
	return function(event) {
		currentObj.mousedown = false;
	};
};

Ensharable.CanvasVTB.prototype.mouseMoveHandler = function() {
	var currentObj = this;
	return function(event) {
		if (currentObj.mousedown == true) {
			var rect = currentObj.canvas.getBoundingClientRect();
			var x = event.clientX - rect.left;
			var y = event.clientY - rect.top;
			currentObj.rotateTo(x, y);
			drawScene();
		}
	};
};
