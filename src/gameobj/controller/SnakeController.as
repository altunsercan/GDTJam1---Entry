package gameobj.controller
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	
	import managers.PhysicsManager;
	
	public class SnakeController implements IController
	{
		
		[Inject]
		public var scObj:SceneObject;
		
		[Inject]
		public var phyManager:PhysicsManager;
		
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
			
			var shape:b2CircleShape = new b2CircleShape( 1 );
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = shape;
			fixtureDef.restitution = 0.7;
			fixtureDef.isSensor = false;
			hitbox = phyManager.world.CreateBody( bodyDef );
			hitbox.CreateFixture( fixtureDef );
			
			
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