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
		private static const DESTROYX:Number = -48;
		
		
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
			
			scObj.transformation.x -= GlobalVariables.RUN_SPEED * Time.deltaTimeSeconds;
		
			if( scObj.transformation.x < DESTROYX )
			{
				scObj.transformation.x += 24 * 4;
				//RepeatingPathFactory.recycle( scObj );
			}
			
		
		}
		
		public function dispose():void
		{
			Yogurt3D.onFrameStart.remove( onPreUpdate );
		}
	}
}