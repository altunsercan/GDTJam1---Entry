package gameobj.controller
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.Time;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	
	import flash.geom.Vector3D;
	
	import managers.GlobalVariables;
	import managers.MouseManager;
	import managers.Y3DManager;
	
	public class PlayerController implements IController
	{
		public var limitzmax:Number = 6;
		public var limitzmin:Number = -4;
		
		public var desiredx:Number = -3;
		
		public var zMovementSpeed:Number = 6;
		
		public var zMouseShift:Number = 2.5;
		
		[Inject]
		public var scObj:SceneObject;
		
		[Inject]
		public var mouseManager:MouseManager;
		
		[Inject]
		public var y3dManager:Y3DManager;
		
		public function PlayerController()
		{
		}
		
		public function initialize():void
		{
			//GDTJam1.masterInjector.injectInto(this);
			Yogurt3D.onFrameStart.add( onPreUpdate );
			
			
		}
		
		private function onPreUpdate():void
		{
			if( !y3dManager.gameScreen.gameRunning ) return;
			
			var currentPos:Vector3D =  scObj.transformation.position;
			
			
			
			var nextPosition:Vector3D = mouseManager.position3D;
			
			if( nextPosition == null ) return;
			
			nextPosition.z = roundPosition(nextPosition.z);
			nextPosition.z += zMouseShift;
			
			var zDesiredChange:Number = (nextPosition.z-currentPos.z) ;
			var zChangeDir:Number = zDesiredChange/ Math.abs( zDesiredChange );
			zDesiredChange = Math.abs( zDesiredChange );
//			if( Math.abs(zDesiredChange)<1)
//			{
//				zDesiredChange = 0;
//			}
			
			var zCalcChange:Number = Time.deltaTimeSeconds * zMovementSpeed * GlobalVariables.GAME_SPEED;
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
			
			
			scObj.transformation.x = desiredx;
			scObj.transformation.z = nextPosition.z;
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