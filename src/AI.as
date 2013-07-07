package  {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import units.EnemyUnit;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class AI { 
		
		public static var percent:Number = 1.7;  
		
		private var masWater:Vector.<Point> = new Vector.<Point>;
		private var masSq:Vector.<Point> = new Vector.<Point>;
		private var attMas:Vector.<Array>;
		private var damageMas:Vector.<Number> = new Vector.<Number>; 
		private var placeMas:Vector.<Number> = new Vector.<Number>;  
		private var curhero:Point; 
		private var mas:Vector.<Object>; 
		private var container:Sprite;
		private var unit:EnemyUnit; 
		 
		private var resaltPoint:Point; 
		private var resaltTarget:Unit; 
		
		public function AI(tar:EnemyUnit, p:Point, mas:Vector.<Object>, cont:Sprite) {
			curhero = p; 
			this.mas = mas;
			unit = tar; 
			container = cont; 
			getPath(tar.speed);
			attMas = new Vector.<Array>(masSq.length, true);
			lookTargets();
			calkAttack(); 
		}
		 
		private function getSquare(y:int, x:int, color:uint=0xff0000):void {
			var fig:DisplayObject = new Drawler(color);
			container.addChildAt(fig, 0); 
			fig.x = x * Map.grid_size;  
			fig.y = y * Map.grid_size;   
		}
		
		private function getPath(spd:int):void { 
			mas[curhero.y][curhero.x].water = -1;  
			masWater.push(curhero);
			masSq.push(curhero);
			getSquare(masWater[0].y, masWater[0].x);
			var bol:Boolean = true;  
			while(bol) {   
				bol = scanPath(spd);
			}
		}
		
		private function scanPath(spd:int):Boolean {
			var timeMas:Vector.<Point> = new Vector.<Point>;
			var b:Boolean; 
			var index:int;
			var curIndex:int; 
			var dirX:int;
			var dirY:int;
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];  
			for each (var p:Point in masWater) {
				curIndex = mas[p.y][p.x].water;
				if (curIndex == -1) curIndex = 0;
				for (var i:int = 0; i < direction.length; i++) {  
					dirX = p.x + direction[i][0];
					dirY = p.y + direction[i][1];    
					if (Game.getIndex(dirX, dirY)) {  
						index = mas[dirY][dirX].coff;   
						var op:Object = mas[dirY][dirX];
						if (op.water == 0 || (op.water > index + curIndex)) { 
							op.water = index + curIndex; 
							if(op.unit==undefined) { 
								timeMas.push(new Point(dirX, dirY)); 
								if (op.water <= spd) {
									if (!op.sq) {
										getSquare(dirY, dirX);
										masSq.push(new Point(dirX, dirY)); 
										op.sq = true; 
									}
									b = true;   
								}
							}
						}
					}  
			    }       
			} 
			masWater = timeMas;
			return b; 
		}
		 
		private function lookTargets():void {
			var dirX:int; 
			var dirY:int;  
			var direction:Array = unit.enemyDirection();
			var goodUnit:Unit;
			
			for (var j:int; j < masSq.length; j++ ) {
				for (var i:int = 0; i < direction.length; i++) {  
					dirX = masSq[j].x + direction[i][0];    
					dirY = masSq[j].y + direction[i][1]; 
					if (Game.getIndex(dirX, dirY)) {  
						if (mas[dirY][dirX].unit != undefined) {
							goodUnit = mas[dirY][dirX].unit;
							if (!goodUnit.enemy) {
								if(attMas[j] == null)
									attMas[j] = [goodUnit]; 
								else attMas[j].push(goodUnit); 
							}
						}
					}
				}
			} 
		}
		
		private function calkAttack():void {
			var cof:Number = 0;
			var smas:Array;
			var damage:Number;
			var p:Point;
			var goodgay:Unit;
			
			for (var i:int = 0; i < attMas.length; i++ ) {
				if (attMas[i] != null) {
					smas = attMas[i];  
					for (var j:int = 0; j < smas.length; j++ ) {
						goodgay = smas[j]; 
						p = Game.gerCoord(goodgay.x, goodgay.y);   
						cof = 1 - mas[p.y][p.x].coff * .1;   
						damage = (unit.att - goodgay.def) * cof; 
						if (damage >= goodgay.hp) {               			  
							resaltTarget = goodgay;		
							resaltPoint = scanResPoint();  
							return; 						
						}
						damage *= (1 - goodgay.agi * .01);
						damage = parseFloat(damage.toFixed(2));
						damageMas.push(damage);
					} 
					if (smas.length > 1) {   
					for (var s:int; s < smas.length-1; s++ ) {
							masSq.splice(i, 0, masSq[i]);   
						} 
					}
				} 
				else damageMas.push(0);  
			}  
			for each (var pt:Point in masSq) {
				placeMas.push(mas[pt.y][pt.x].coff); 
			}
			
			var arrackTransform:Vector.<Unit> = new Vector.<Unit>();
			for each(var boof:Array in attMas) {
				if(boof!=null) { 
					for (var h:int=0; h < boof.length; h++) {
						arrackTransform.push(boof[h]);  
					}  
				} 
				else arrackTransform.push(null);
			}
			
			var sortMas:Array = QSort.quickSort(damageMas, 0, damageMas.length - 1, masSq, true);
			masSq = sortMas[1]; 
			damageMas = sortMas[0]; 
			sortMas = QSort.quickSort(damageMas, 0, damageMas.length - 1, arrackTransform, true);
			arrackTransform = sortMas[1];   
			damageMas = sortMas[0];
			sortMas = QSort.quickSort(damageMas, 0, damageMas.length - 1, placeMas);
			placeMas = sortMas[1];  
			damageMas = sortMas[0]; 

			resaltPoint = masSq[masSq.length-1];
			resaltTarget = arrackTransform[arrackTransform.length-1];
			for (var m:int=placeMas.length-1; m >= 0; m--) { 
				if (placeMas[m] >= placeMas[m - 1]) {
					if ( (damageMas[m] * percent) >= damageMas[m + 1] ) {
						resaltTarget = arrackTransform[m];
						resaltPoint = masSq[m]; 
						break; 
					}
					else {
						resaltTarget = arrackTransform[m+1];
						resaltPoint = masSq[m+1]; 
						break;
					}
				}   
			}
		} 
		
		private function scanResPoint():Point { 
			var target:Point;
			var curCof:int;
			var cof:int;  
			var smas:Array;
			for (var i:int = 0; i < attMas.length; i++ ) {
				if (attMas[i] != null) { 
					smas = attMas[i];   
					for (var j:int = 0; j < smas.length; j++ ) { 
						if (resaltTarget == smas[j]) {
							cof = mas[masSq[i].y][masSq[i].x].coff
							if ( curCof <  cof) {
								target = masSq[i];
								curCof = cof; 
							}
						}
					}
				}
			}
			return target;
		}
		
//----- 		
	}
}