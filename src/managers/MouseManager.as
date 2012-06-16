package managers
{
	import com.yogurt3d.core.cameras.Ray;
	import com.yogurt3d.core.managers.IDManager;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import org.osflash.signals.Signal;

	public class MouseManager
	{
		[Inject]
		public var y3dManager:Y3DManager;
		
		[Inject]
		public var screenManager:ScreenManager;
		
		
		public var POSITONUPDATE_3D:Signal = new Signal( Vector3D );
		
		private var m_position2D:Point = new Point();
		private var m_position3D:Vector3D;
		
		public function get position3D():Vector3D
		{
			if( m_position3D )
			{
				return m_position3D.clone();
			}
			return null
		}
		
		public function get position2D():Point
		{
			if( m_position2D )
			{
				return m_position2D.clone();
			}
			return null;
		}
		
		public function MouseManager()
		{
				
		}
		public function initialize():void
		{
			screenManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove)
		}
		private function onMouseMove( _e:MouseEvent ):void
		{
			m_position2D.x = _e.localX;
			m_position2D.y = _e.localY;
			
			if( y3dManager.gameScreen.gameRunning )
			{
				var interactionPlane:SceneObjectRenderable = SceneObjectRenderable( IDManager.getObjectByUserID("mouseInteractionPlane") );
				if( interactionPlane!= null )
				{
					var ray:Ray = y3dManager.camera.getRayFromMousePosition( GDTJam1.height, GDTJam1.width, m_position2D.x, m_position2D.y );
					m_position3D = ray.intersectSceneObject( interactionPlane );
				}
			}
		}
	}
}