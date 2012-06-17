package gameobj.controller
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.animation.controllers.SkinController;
	import com.yogurt3d.core.animation.event.AnimationEvent;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	
	import managers.PhysicsManager;
	import managers.SoundManager;
	
	public class SnakeController implements IController
	{
		
		[Inject]
		public var scObj:SceneObject;
		
		[Inject]
		public var phyManager:PhysicsManager;
		
		[Inject]
		public var soundMan:SoundManager;
		
		public function SnakeController()
		{
		}
		//// Physics variables
		private var hitbox:b2Body;
		
		public function initialize():void
		{
			//GDTJam1.masterInjector.injectInto(this);
			Yogurt3D.onFrameStart.add( onPreUpdate );
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type =   b2Body.b2_dynamicBody;
			bodyDef.userData = this;
			
			var shape:b2CircleShape = new b2CircleShape( 0.5 );
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = shape;
			fixtureDef.restitution = 0.7;
			fixtureDef.isSensor = false;
			hitbox = phyManager.world.CreateBody( bodyDef );
			hitbox.CreateFixture( fixtureDef );
			
			
		}
		public function playHit():void
		{
			
			soundMan.hitEffectChannel.stop();
			soundMan.hitEffectChannel = soundMan.hitS.play();
			
			var animCont:SkinController = SkinController( SceneObjectRenderable( scObj.children[0] ).geometry.getComponent("skinController"));
			animCont.playAnimation("basket", 0);
			animCont.addEventListener("endOfLoop", function anim1Func( _e:AnimationEvent):void
			{
				animCont.stop();
				animCont.removeEventListener("endOfLoop", anim1Func );
			});
			
			var animCont2:SkinController = SkinController( SceneObjectRenderable( scObj.children[1] ).geometry.getComponent("skinController"));
			animCont2.playAnimation("snake", 0);
			animCont2.addEventListener("endOfLoop", function anim2Func( _e:AnimationEvent):void
			{
				animCont2.stop();
				animCont2.removeEventListener("endOfLoop", anim2Func );
			});
		}
		
		
		private function onPreUpdate():void
		{
			
			if( scObj.parent ) // Only on stage add physics
			{
				hitbox.SetPosition( new b2Vec2( scObj.transformation.globalPosition.x, scObj.transformation.globalPosition.z ) );
			}else
			{
			}
		}
		
		public function dispose():void
		{
		}
	}
}