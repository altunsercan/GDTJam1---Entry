package screens
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.materials.Material;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.viewports.Viewport;
	import com.yogurt3d.presets.material.MaterialFill;
	import com.yogurt3d.presets.sceneobjects.PlaneSceneObject;
	import com.yogurt3d.presets.sceneobjects.SphereSceneObject;
	
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import gameobj.ObstacleGenearator;
	import gameobj.PlayerFactory;
	import gameobj.RepeatingPathFactory;
	
	import managers.MouseManager;
	import managers.Y3DManager;
	
	import org.as3commons.logging.level.DEBUG;
	
	public class GameScreen extends Sprite implements IScreen
	{
		[Inject]
		public var y3dManager:Y3DManager;
		
		[Inject]
		public var obstacleGen:ObstacleGenearator;
		
		[Inject]
		public var mouseManager:MouseManager;
		
		private var m_viewport:Viewport;
		
		private var m_gameSetupComplete:Boolean = false;
		private var m_gameRunning:Boolean = false;
		
		private var m_debug_mouse3d:SphereSceneObject;
		
		
		private var m_repeatingPaths:Array; 
		
		public function GameScreen()
		{
			super();
			GDTJam1.masterInjector.injectInto( this );
		}
		
		public function addViewport( view:Viewport ):void
		{
			m_viewport = view;	
			
			m_viewport.update()
			
			addChildAt( view, 0 );
		
		}
		
		public function setupNewGame():void
		{
			/// Set Camera
			var fov:Number = GDTJam1.width/GDTJam1.height;
			y3dManager.camera.frustum.setProjectionPerspective( GDTJam1.height, fov  , 1, 300 );
			y3dManager.camera.frustum.CalcFrustumPointsPers( GDTJam1.height, fov  , 1, 300 );
			y3dManager.camera.transformation.position = new Vector3D( 0, 10, 15 );
			y3dManager.camera.transformation.lookAt( new Vector3D() );
			
			/// Set Mouse Interaction Plane
			var mouseInteractionPlane:PlaneSceneObject = new PlaneSceneObject( 50, 50, 10, 10 );
			mouseInteractionPlane.userID = "mouseInteractionPlane";
			mouseInteractionPlane.material = new MaterialFill( 0xDDDDDD );
			mouseInteractionPlane.visible = false;
			y3dManager.scene.addChild( mouseInteractionPlane );
			
			/// Repeating Camera
			m_repeatingPaths = [];
			
			var repeatingPath:SceneObject;
			
			repeatingPath = RepeatingPathFactory.instantiateRepeatingPath();
			repeatingPath.transformation.x = -24;
			y3dManager.scene.addChild( repeatingPath );
			
			m_repeatingPaths.push( repeatingPath );
			
			repeatingPath = RepeatingPathFactory.instantiateRepeatingPath();
			y3dManager.scene.addChild( repeatingPath );
			
			m_repeatingPaths.push( repeatingPath );
			
			repeatingPath = RepeatingPathFactory.instantiateRepeatingPath();
			repeatingPath.transformation.x = +24;
			y3dManager.scene.addChild( repeatingPath );
			
			m_repeatingPaths.push( repeatingPath );
			
//			repeatingPath = RepeatingPathFactory.instantiateRepeatingPath();
//			repeatingPath.transformation.x = +48;
//			y3dManager.scene.addChild( repeatingPath );
//			
//			m_repeatingPaths.push( repeatingPath );
			
			/// Player
			var player:SceneObject = PlayerFactory.instantiatePlayer();
			y3dManager.scene.addChild( player );
			
			
			/// Obstacles
			obstacleGen.start();
			
			/// Debug
			// Show 3d mouse intersection point
			m_debug_mouse3d = new SphereSceneObject( 0.5 );
			m_debug_mouse3d.material = new MaterialFill( 0x003300 );
			
			y3dManager.scene.addChild( m_debug_mouse3d );
			
			Yogurt3D.onFrameEnd.add( onPreUpdate );
			
			
			m_gameSetupComplete = true;
		}
		
		private function onPreUpdate():void
		{
			if( m_gameSetupComplete )
			{
				var pos:Vector3D = mouseManager.position3D;
				if( pos )
				{
					m_debug_mouse3d.transformation.position = pos ;
				}
			}
			
			
			
			
		}
		
		
		public function get gameRunning():Boolean
		{
			return m_gameRunning;
		}
		
		public function show():void
		{
			if( !m_gameSetupComplete )
			{
				setupNewGame();
			}
			m_gameRunning = true;
			
			
		}
		
		public function hide():void
		{
			m_gameRunning = false;
		}
		
		public function destroyScreen():void
		{
		}
	}
}