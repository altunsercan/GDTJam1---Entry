package managers
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.yogurt3d.Yogurt3D;
	
	import flash.display.Sprite;

	public class PhysicsManager
	{
		[Inject]
		public var screenManager:ScreenManager;
		
		
		
		public var world:b2World;
		
		public var debugSprite:Sprite;
		private var debugDraw:b2DebugDraw; //the actual debugDraw object
		public static const PTM:Number = 10; //our pixels to metre ration that will be used throughout the demo

		public function PhysicsManager()
		{
			
		}
		public function initializePhysics():void
		{
			world = new b2World( new b2Vec2(), false );
			world.SetContactListener( new GameContactListener() );
			
			//setupDebugDraw();
			//world.SetDebugDraw( debugDraw );
			
			Yogurt3D.onFrameStart.add( update );
		}
		private function update():void 
		{
			world.Step(1 / 30, 10, 10);
			world.ClearForces();
			world.DrawDebugData();
			
		}
		private function setupDebugDraw():void
		{
			debugSprite = new Sprite();
			debugSprite.x = 500;
			debugSprite.y = 300;
			screenManager.stage.stage.addChild(debugSprite);
			debugDraw = new b2DebugDraw();
			debugDraw.SetDrawScale(PTM);
			debugDraw.SetFillAlpha(0.4);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetSprite(debugSprite);
		}
		
	}
}

import Box2D.Dynamics.Contacts.b2Contact;
import Box2D.Dynamics.b2ContactListener;

import gameobj.controller.CowController;
import gameobj.controller.ObstacleController;
import gameobj.controller.PlayerController;
import gameobj.controller.SnakeController;

internal class GameContactListener extends b2ContactListener
{
	public function GameContactListener()
	{
	}
	
	override public function BeginContact(contact:b2Contact):void
	{
		/// Player Collisions
		if( contact.GetFixtureA().GetBody().GetUserData() is PlayerController || contact.GetFixtureB().GetBody().GetUserData() is PlayerController )
		{
			var playerController:PlayerController;
			var other:*;
			if(contact.GetFixtureA().GetBody().GetUserData() is PlayerController)
			{
				playerController 	= contact.GetFixtureA().GetBody().GetUserData();
				other 				= contact.GetFixtureB().GetBody().GetUserData();
			}else
			{
				playerController 	= contact.GetFixtureB().GetBody().GetUserData();
				other 				= contact.GetFixtureA().GetBody().GetUserData();
			}
			
			if( other is SnakeController )
			{
				// Die or slow down
				playerController.setHitVaribles();
				SnakeController( other ).playHit();
			}
			
			if( other is CowController)
			{
				if( playerController.controlState == PlayerController.STATE_DASH)
				{
					/// Dash Kill the cow
					CowController(other).dashKilled();
				}else 
				{
					/// Got hit
					playerController.setHitVaribles();
				}
				
				
				
			}
			
			
			
			
		}
		
		
	}
}