package gameobj.controller
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.Time;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	
	import gameobj.RepeatingPathFactory;
	
	import managers.GlobalVariables;
	import managers.Y3DManager;
	
	public class RepeatingPathController implements IController
	{
		private static const DESTROYX:Number = -30;
		
		
		[Inject]
		public var scObj:SceneObject;
		
		[Inject]
		public var y3dManager:Y3DManager;
		
		public function RepeatingPathController()
		{
		}
		
		public function initialize():void
		{
			Yogurt3D.onFrameStart.add( onPreUpdate );
		}
		
		private function onPreUpdate():void
		{
			if( !y3dManager.gameScreen.gameRunning || scObj.scene == null ) return;
			
			scObj.transformation.x -= roundPosition( GlobalVariables.RUN_SPEED * GlobalVariables.GAME_SPEED * Time.deltaTimeSeconds );
		
			if( scObj.transformation.x < DESTROYX )
			{
				scObj.transformation.x += 72;
			}
			
		
		
		}
		private function roundPosition( pos:Number ):Number
		{
			return int(pos * 100)/100;
		}
		
		public function dispose():void
		{
			Yogurt3D.onFrameStart.remove( onPreUpdate );
		}
	}
}