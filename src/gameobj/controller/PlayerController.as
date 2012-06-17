package gameobj.controller
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.Time;
	import com.yogurt3d.core.animation.controllers.SkinController;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	
	import flash.geom.Transform;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import managers.GameStatsManager;
	import managers.GlobalVariables;
	import managers.KeyboardManager;
	import managers.MouseManager;
	import managers.PhysicsManager;
	import managers.Y3DManager;
	
	public class PlayerController implements IController
	{
		
		
		public static const STATE_INACTIVE:int = 0;
		public static const STATE_NORMAL:int = 1;
		public static const STATE_DASH:int = 2;
		public static const STATE_RUN:int = 3;
		public static const STATE_HIT:int = 4;
			
		public var limitzmax:Number = 7;
		public var limitzmin:Number = -5;
		
		public var desiredx:Number = -5;
		
		public var zMovementSpeed:Number = 6;
		
		[Inject]
		public function set scObj( value:SceneObject ):void
		{
			m_scObj = value;
		}
		public function get scObj():SceneObject
		{
			return m_scObj
		}
		private var m_scObj:SceneObject;
		
		[Inject]
		public var mouseManager:MouseManager;
		
		[Inject]
		public var keyboardManager:KeyboardManager;
		
		[Inject]
		public var phyManager:PhysicsManager;
		
		[Inject]
		public var y3dManager:Y3DManager;
		
		[Inject]
		public var gameStats:GameStatsManager;
		
		
		private var m_controlState:int = STATE_INACTIVE; 
		
		public function get controlState():int
		{
			return m_controlState;
		}
		
		
		/// Dash variables
		private const dashSpeed:Number = 30;
		private var shiftbackComplete:Boolean = false;
		private var dashTarget:Vector3D;
		private var dashTargetReached:Boolean;
		
		/// Hit variables
		private var hitTime:Number = 0;
		private const hitSlowdownLength:Number = 2;
		
		//// Physics variables
		private var hitbox:b2Body;
		public function PlayerController()
		{
		}
		
		public function initialize():void
		{
			//GDTJam1.masterInjector.injectInto(this);
			Yogurt3D.onFrameStart.add( onPreUpdate );
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type =  b2Body.b2_dynamicBody;
			bodyDef.userData = this;
			
			var shape:b2CircleShape = new b2CircleShape( 0.5 );
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = shape;
			fixtureDef.restitution = 0.7;
			fixtureDef.isSensor = false;
			hitbox = phyManager.world.CreateBody( bodyDef );
			hitbox.CreateFixture( fixtureDef );
			
			m_controlState = STATE_NORMAL;
		}
		
		private function onPreUpdate():void
		{
			if( !y3dManager.gameScreen.gameRunning ) return;
			
			/// Switch states
			if( m_controlState==STATE_NORMAL && keyboardManager.isKeyJustDown( Keyboard.E ) && gameStats.energy > 15 )
			{
				gameStats.energy -= 15;
				setDashVariables();
			}
			if( m_controlState==STATE_NORMAL && keyboardManager.isKeyJustDown( Keyboard.W ) )
			{
				setRunVaribles();
			}
			if( m_controlState==STATE_RUN && keyboardManager.isKeyJustUp( Keyboard.W ) )
			{
				unsetRunVaribles();
			}
			if( m_controlState==STATE_HIT && hitTime+hitSlowdownLength < Time.timeSeconds )
			{
				unsetHitVaribles();
			}
			
			//// Do state actions
			switch(m_controlState)
			{
				case STATE_NORMAL:
				case STATE_RUN:
				{
					normalStatePreUpdate();
					break;
				}
				case STATE_DASH:
				{
					dashStatePreUpdate();
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			hitbox.SetPosition( new b2Vec2( scObj.transformation.globalPosition.x, scObj.transformation.globalPosition.z ) );
			
		}
		private function normalStatePreUpdate():void
		{
			var currentPos:Vector3D =  scObj.transformation.position;
			
			var nextPosition:Vector3D = mouseManager.position3D;
			
			if( nextPosition == null ) return;
			
			if( controlState == STATE_RUN  )
			{
				if( gameStats.energy <= 0 )
				{
					unsetRunVaribles();
				}else
				{
					gameStats.energy -= 1;
				}
				
			}
			
			/// UpdateArrow
			scObj.children[2].transformation.position = new Vector3D(); 
			scObj.children[2].transformation.lookAt( nextPosition );
		
			
			nextPosition.z = roundPosition(nextPosition.z);
			
			var zDesiredChange:Number = (nextPosition.z-currentPos.z) ;
			var zChangeDir:Number;
			if(zDesiredChange != 0 )
			{
				zChangeDir = zDesiredChange/ Math.abs( zDesiredChange );
				
				zDesiredChange = Math.abs( zDesiredChange );
				//			if( Math.abs(zDesiredChange)<1)
				//			{
				//				zDesiredChange = 0;
				//			}
				
				var zCalcChange:Number = Time.deltaTimeSeconds * zMovementSpeed * GlobalVariables.GAME_SPEED;
				zCalcChange
				if(  zDesiredChange < zCalcChange )
				{
					zCalcChange = zDesiredChange;
				}
				
				nextPosition.z = currentPos.z + zCalcChange * zChangeDir;
				
				if( nextPosition.z > limitzmax )
				{
					nextPosition.z = limitzmax;
				}else if( nextPosition.z <limitzmin )
				{
					nextPosition.z = limitzmin;
				}
				
			}else
			{
				zChangeDir = 0;
				nextPosition.z = currentPos.z;
			}
			
			if( currentPos.x != desiredx ) /// Slowly shiftback to desired x
			{
				
				scObj.transformation.x = Math.max( currentPos.x - Time.deltaTimeSeconds * GlobalVariables.RUN_SPEED * GlobalVariables.GAME_SPEED  ,desiredx );
				if( currentPos.x != desiredx )
				{
					shiftbackComplete = true;
				}
				
			}
			
			
			scObj.transformation.z = nextPosition.z;
		}
		
		private function dashStatePreUpdate():void
		{
			
			var currentPos:Vector3D =  scObj.transformation.position;
			var nextPosition:Vector3D = new Vector3D();
			// move to target
		 	if( !dashTargetReached )
			{
				// shift dash target
				dashTarget.x -= GlobalVariables.RUN_SPEED * GlobalVariables.GAME_SPEED * Time.deltaTimeSeconds ;
				
				var CalcChange:Number = Time.deltaTimeSeconds * dashSpeed * GlobalVariables.GAME_SPEED; // Speed in any direction
				
				// Z Movement
				var zDesiredChange:Number = (dashTarget.z-currentPos.z) ;
				var zChangeDir:Number;
				if(zDesiredChange != 0 )
				{
					zChangeDir = zDesiredChange/ Math.abs( zDesiredChange );
					
					zDesiredChange = Math.abs( zDesiredChange );
					
					var zCalcChange:Number = CalcChange;
					
					if(  zDesiredChange <CalcChange )
					{
						zCalcChange = zDesiredChange;
					}
					
					nextPosition.z = currentPos.z + zCalcChange * zChangeDir;
					
				}else
				{
					zChangeDir = 0;
					nextPosition.z = currentPos.z;
				}
				
				// X Movement
				var xDesiredChange:Number = (dashTarget.x-currentPos.x) ;
				var xChangeDir:Number;
				if(xDesiredChange != 0 )
				{
					xChangeDir = xDesiredChange/ Math.abs( xDesiredChange );
					
					xDesiredChange = Math.abs( xDesiredChange );
					
					var xCalcChange:Number = CalcChange;
					
					if( xDesiredChange < xCalcChange )
					{
						xCalcChange = xDesiredChange;
					}
					
					nextPosition.x = currentPos.x + xCalcChange * xChangeDir;
					
				}else
				{
					xChangeDir = 0;
					nextPosition.x = currentPos.x;
				}
				
				if( dashTarget.x == nextPosition.x && dashTarget.z == nextPosition.z )
				{
					dashTargetReached = true;
					unsetDashVariables();
				}
				
				scObj.transformation.x = nextPosition.x;
				scObj.transformation.z = nextPosition.z;
			}else
			{
				
			}
		}
		
		
		private function setDashVariables():void
		{
			dashTarget = mouseManager.position3D;
			
			var animCont:SkinController = SkinController( SceneObjectRenderable( scObj.children[0] ).geometry.getComponent("skinController"));
			animCont.playAnimation("dash");
			
			if( dashTarget.z > limitzmax )
			{
				dashTarget.z = limitzmax;
			}else if( dashTarget.z <limitzmin )
			{
				dashTarget.z = limitzmin;
			}
			
			dashTargetReached = false;
			
			shiftbackComplete = false;
			
			m_controlState = STATE_DASH;
		}
		private function unsetDashVariables():void
		{
			dashTarget = null;
			
			var animCont:SkinController = SkinController( SceneObjectRenderable( scObj.children[0] ).geometry.getComponent("skinController"));
			animCont.playAnimation("run");
			
			m_controlState = STATE_NORMAL;
		}
		private function setRunVaribles():void
		{
			var animCont:SkinController = SkinController(SceneObjectRenderable( scObj.children[0] ).geometry.getComponent("skinController"));
			animCont.playAnimation("runFast");
			
			GlobalVariables.RUN_SPEED = 12;
			m_controlState = STATE_RUN;
		}
		private function unsetRunVaribles():void
		{
			var animCont:SkinController = SkinController( SceneObjectRenderable( scObj.children[0] ).geometry.getComponent("skinController"));
			animCont.playAnimation("run");
			
			GlobalVariables.RUN_SPEED = 6;
			m_controlState = STATE_NORMAL;
		}
		public function setHitVaribles():void
		{
			GlobalVariables.RUN_SPEED = 2;
			m_controlState = STATE_HIT;
			
			hitTime = Time.timeSeconds;
			
		}
		public function unsetHitVaribles():void
		{
			GlobalVariables.RUN_SPEED = 6;
			m_controlState = STATE_NORMAL;
			
			
		}
		private function roundPosition( pos:Number ):Number
		{
			return int(pos * 100)/100;
		}
		
		public function dispose():void
		{
			
		}
	}
}