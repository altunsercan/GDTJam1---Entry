package gameobj.controller
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.Time;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	
	import gameobj.ObstacleGenearator;
	import gameobj.RepeatingPathFactory;
	import gameobj.SnakeFactory;
	
	import managers.GlobalVariables;
	import managers.Y3DManager;
	
	public class ObstacleController implements IController
	{
		private static const DESTROYX:Number = -48;
		
		
		[Inject]
		public var scObj:SceneObject;
		
		[Inject]
		public var y3dManager:Y3DManager;
		
		[Inject]
		public var obstacleGen:ObstacleGenearator;
		
		public var len:Number;
		public function ObstacleController( _len:Number)
		{
			len = _len;
		}
		
		public function initialize():void
		{
			Yogurt3D.onFrameStart.add( onPreUpdate );
		}
		
		private function onPreUpdate():void
		{
			if( !y3dManager.gameScreen.gameRunning || scObj.scene == null ) return;
			
			scObj.transformation.x -= GlobalVariables.RUN_SPEED * Time.deltaTimeSeconds;
		
			if( scObj.transformation.x < DESTROYX )
			{
				
				scObj.parent.removeChild( scObj );
				
				while ( scObj.children.length > 0 )
				{
					var element:SceneObject = scObj.children[ scObj.children.length -1];
					scObj.removeChild(element);
					
					var elUsrId:String = element.userID;
					if( elUsrId.search("snake_") != -1 )
					{
						SnakeFactory.recycle( element );
					}
				}
				
				obstacleGen.notifyRemove( this );
				
				//RepeatingPathFactory.recycle( scObj );
			}
			
		
		}
		
		public function dispose():void
		{
			Yogurt3D.onFrameStart.remove( onPreUpdate );
		}
	}
}