package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.ParticleType;
	import net.flashpunk.utils.Ease;
	
	public class Particles extends Entity
	{
		/** Particle emitter. */
		[Embed(source = '../../assets/particle.png')] private const PARTICLE:Class;
		public var emitter:Emitter = new Emitter(PARTICLE, 11, 11);
		
		/** Constructor, define particles and stuff. */
		public function Particles() 
		{
			graphic = emitter;
			emitter.x = emitter.y = -5;
			layer = 1;
			
			// Create a dust particle
			var p:ParticleType = emitter.newType("dust", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
			p.setMotion(20, 5, .2, 140, 50, .3, Ease.cubeOut);
			p.setColor(0xFFFFFF, 0xFF3366, Ease.quadIn);
			
			// Create the trail particle.
			p = emitter.newType("trail", [0, 1, 2, 3, 4, 5]);
			p.setMotion(0, 10, .5, 360, 30, .5, Ease.cubeInOut);
			p.setColor(0xFF3366, 0xFFFFFF);
			p.setAlpha(1, 0);
		}
	}
}
