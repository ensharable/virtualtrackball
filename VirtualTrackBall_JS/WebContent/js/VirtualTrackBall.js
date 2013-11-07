/**
 * 
 */

var Ensharable = {} ;

Ensharable.VirtualTrackBall = function(){};

Ensharable.VirtualTrackBall.prototype = {

	setWinSize:function(width, height){
		this.width = width;
		this.height = height;
		this.r = this.min(width, height)/2;
		this.q = new Ensharable.Quaternion();
		this.start;
	},
	
	getTrackBallVector:function(win_x, win_y){
		var x,y,z;
		x = (2.0*win_x-this.width)/this.width;
		y = (this.height-2.0*win_y)/this.height;
		z = 0;
		
		var v = new Ensharable.Vector(x, y, z);
		var len = v.len();
		len = (len<1.0) ? len : 1.0;
		z = Math.sqrt(1-len*len);
		v.z = z;
		
		return v.nor();
	},
	
	//get start position and create track ball vector for start position
	setRotationStart:function(win_x, win_y){
		this.start = this.getTrackBallVector(win_x, win_y);
	},
	
	
	//get new position, create track ball vector, and base on the old vector and new vector,
	//calculate the rotation axial, and angle
	rotateTo:function(win_x, win_y){
		var end = this.getTrackBallVector(win_x, win_y);
		var axis = end.clone().cross(this.start).nor();
		var dis = 0-end.clone().sub(this.start).len()*2;
		
		var curRP = new Ensharable.Quaternion();
		curRP.setFromAxisAngle(axis, dis);
		
		//this.q.multiply(curRP);
		this.q = curRP.multiply(this.q);
		this.start=end;
	},
	
	//convert it to Quaternion, and merger to the old one, convert to matrix and return
	getRotationMatrix:function(){
		var temp = Matrix.I(4);
		if(this.q===null || this.q===undefined){
			return temp.identity();
		}
		return this.q.makeRotationFromQuaternion();
	},
	
	min:function(x, y){
		if(x>y){
			return y;
		}else{
			return x;
		}
	},

};