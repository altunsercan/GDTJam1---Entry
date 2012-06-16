package gameobj.controller
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.Time;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	
	import flash.geom.Transform;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import managers.GlobalVariables;
	import managers.KeyboardManager;
	import managers.MouseManager;
	import managers.Y3DManager;
	
	public class PlayerController implements IController
	{
		private const STATE_INACTIVE:int = 0;
		private const STATE_NORMAL:int = 1;
		private const STATE_DASH:int = 2;
		private const STATE_RUN:int = 3;
			
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
		public var y3dManager:Y3DManager;
		
		
		private var controlState:int = STATE_INACTIVE; 
		
		
		/// Dash variables
		private const dashSpeed:Number = 30;
		
		private var dashTarget:Vector3D;
		private var dashTargetReached:Boolean;
		
		public function PlayerController()
		{
		}
		
		public function initialize():void
		{
			//GDTJam1.masterInjector.injectInto(this);
			Yogurt3D.onFrameStart.add( onPreUpdate );
			
			controlState = STATE_NORMAL;
		}
		
		private function onPreUpdate():void
		{
			if( !y3dManager.gameScreen.gameRunning ) return;
			
			/// Switch states
			if( controlState==STATE_NORMAL && keyboardManager.isKeyJustDown( Keyboard.E ) )
			{
				setDashVariables();
			}
			if( controlState==STATE_NORMAL && keyboardManager.isKeyJustDown( Keyboard.W ) )
			{
				setRunVaribles();
			}
			if( controlState==STATE_RUN && keyboardManager.isKeyJustUp( Keyboard.W ) )
			{
				unsetRunVaribles();
			}
			
			//// Do state actions
			switch(controlState)
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
			
		}
		private function normalStatePreUpdate():void
		{
			var currentPos:Vector3D =  scObj.transformation.position;
			
			var nextPosition:Vector3D = mouseManager.position3D;
			
			if( nextPosition == null ) return;
			
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
			
			if( dashTarget.z > limitzmax )
			{
				dashTarget.z = limitzmax;
			}else if( dashTarget.z <limitzmin )
			{
				dashTarget.z = limitzmin;
			}
			
			dashTargetReached = false;
			
			controlState = STATE_DASH;
		}
		private function unsetDashVariables():void
		{
			dashTarget = null;
			controlState = STATE_NORMAL;
		}
		private function setRunVaribles():void
		{
			GlobalVariables.RUN_SPEED = 12;
			controlState = STATE_RUN;
		}
		private function unsetRunVaribles():void
		{
			GlobalVariables.RUN_SPEED = 6;
			controlState = STATE_NORMAL;
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