package game 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.ParticleType;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.*;
	
	public class Player extends Moveable
	{
		/**
		 * Player graphic.
		 */
		[Embed(source = "../../assets/player.png")] private const PLAYER:Class;
		public var image:Image = new Image(PLAYER);
		
		/**
		 * Tweeners.
		 */
		public const SCALE:LinearMotion = new LinearMotion;
		public const ROTATE:NumTween = new NumTween;
		
		/**
		 * Movement constants.
		 */
		public const MAXX:Number = 300;
		public const MAXY:Number = 800;
		public const GRAV:Number = 1500;
		public const FLOAT:Number = 3000;
		public const ACCEL:Number = 1200;
		public const DRAG:Number = 800;
		public const JUMP:Number = -500;
		public const LEAP:Number = 1.5;
		
		/**
		 * Movement properties.
		 */
		public var onSolid:Boolean;
		public var spdX:Number = 0;
		public var spdY:Number = 0;
		
		/**
		 * Particle emitter.
		 */
		public var emitter:Emitter;
		
		public function Player(x:int = 0, y:int = 0) 
		{
			this.x = x;
			this.y = y;
			
			graphic = image;

			// Set the image origin to the center of the image instead of the top-left.
			image.centerOrigin();
			image.smooth = true;
			
			setHitbox(image.width, image.height, 16, 16);
			
			addTween(SCALE);
			addTween(ROTATE);
			SCALE.x = SCALE.y = 1;
			
			Input.define("R", Key.RIGHT);
			Input.define("L", Key.LEFT);
			Input.define("JUMP", Key.SPACE, Key.SHIFT, Key.CONTROL, Key.UP, Key.Z, Key.X, Key.A, Key.S);
		}
		
		override public function added():void 
		{
			emitter = (FP.world.classFirst(Particles) as Particles).emitter;
		}
		
		/**
		 * Update the player.
		 */
		override public function update():void 
		{
			checkFloor();
			gravity();
			acceleration();
			jumping();
			move(spdX * FP.elapsed, spdY * FP.elapsed);
			animation();
			
			if (spdY != 0) emitter.emit("trail", x - 10 + FP.rand(20), y - 10 + FP.rand(20));
		}
		
		private function checkFloor():void
		{
			if (collide(solid, x, y + 1)) onSolid = true;
			else onSolid = false;
		}
		
		/**
		 * Applies gravity to the player.
		 */
		private function gravity():void
		{
			if (onSolid) return;
			var g:Number = GRAV;
			if (spdY < 0 && !Input.check("JUMP")) g += FLOAT;
			spdY += g * FP.elapsed;
			if (spdY > MAXY) spdY = MAXY;
		}
		
		/**
		 * Accelerates the player based on input.
		 */
		private function acceleration():void
		{
			// evaluate input
			var accel:Number = 0;
			if (Input.check("R")) accel += ACCEL;
			if (Input.check("L")) accel -= ACCEL;
			
			// handle acceleration
			if (accel != 0)
			{
				if (accel > 0)
				{
					// accelerate right
					if (spdX < MAXX)
					{
						spdX += accel * FP.elapsed;
						if (spdX > MAXX) spdX = MAXX;
					}
					else accel = 0;
				}
				else
				{
					// accelerate left
					if (spdX > -MAXX)
					{
						spdX += accel * FP.elapsed;
						if (spdX < -MAXX) spdX = -MAXX;
					}
					else accel = 0;
				}
			}
			
			// handle decelleration
			if (accel == 0)
			{
				if (spdX > 0)
				{
					spdX -= DRAG * FP.elapsed;
					if (spdX < 0) spdX = 0;
				}
				else
				{
					spdX += DRAG * FP.elapsed;
					if (spdX > 0) spdX = 0;
				}
			}
		}
		
		/**
		 * Makes the player jump on input.
		 */
		private function jumping():void
		{
			if (onSolid && Input.pressed("JUMP"))
			{
				spdY = JUMP;
				onSolid = false;
				if (spdX < 0 && image.flipped) spdX *= LEAP;
				else if (spdX > 0 && !image.flipped) spdX *= LEAP;
				
				SCALE.setMotion(1, 1.2, 1, 1, .2, Ease.quadIn);
				ROTATE.tween(0, 360 * -FP.sign(spdX), FP.scale(Math.abs(spdX), 0, MAXX, .7, .5), Ease.quadInOut);
				
				var i:int = 10;
				while (i --) emitter.emit("dust", x - 10 + FP.rand(20) , y + 16);
			}
		}
		
		/**
		 * Handles animation.
		 */
		private function animation():void
		{
			// control facing direction
			if (spdX != 0) image.flipped = spdX < 0;
			
			// image scale tweening
			image.scaleX = SCALE.x;
			image.scaleY = SCALE.y;
			
			// image rotation
			if (onSolid)
			{
				image.angle = 0;
				ROTATE.active = false;
				ROTATE.value = 0;
			}
			else image.angle = (spdX / MAXX) * 10 + ROTATE.value;
		}
		
		/**
		 * Horizontal collision handler.
		 */
		override protected function collideX(e:Entity):void 
		{
			if (spdX > 100 || spdX < -100) SCALE.setMotion(1, 1.2, 1, 1, .2, Ease.quadIn);
			spdX = 0;
		}
		
		/**
		 * Vertical collision handler.
		 */
		override protected function collideY(e:Entity):void 
		{
			if (spdY > 0)
			{
				SCALE.setMotion(1.2, 1, 1, 1, .2, Ease.quadIn);
				spdY = 0;
				spdX /= 2;
			}
			else
			{
				SCALE.setMotion(1.2, 1, 1, 1, .1, Ease.quadOut);
				spdY /= 2;
			}
		}
	}
}