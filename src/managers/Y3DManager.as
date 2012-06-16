package managers
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.cameras.Camera3D;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	import com.yogurt3d.core.viewports.Viewport;
	import com.yogurt3d.presets.cameras.FreeFlightCamera;
	
	import org.osflash.signals.Signal;
	
	import screens.GameScreen;

	public class Y3DManager
	{
		public var INITIALIZED:Signal = new Signal();
		
		private var m_viewport:Viewport;
		
		private var m_gamescreen:GameScreen;
		
		private var m_initialized:Boolean = false;
		
		public function Y3DManager()
		{
			
		}

		public function initializeManager():void
		{
			m_gamescreen = new GameScreen();
			
			m_viewport = new Viewport( GDTJam1.width, GDTJam1.height );
			m_viewport.camera = new Camera3D();
			//m_viewport.camera  = new FreeFlightCamera( m_viewport );
			m_viewport.scene = new Scene3D();
			m_viewport.scene .addChild( m_viewport.camera );
			m_viewport.autoUpdate = true;
			
			
			m_gamescreen.addViewport( m_viewport );
			
			var screenMan:ScreenManager = GDTJam1.masterInjector.getInstance( ScreenManager );
			
			screenMan.addScreen( "gameScreen", m_gamescreen );
			
			m_initialized = true;
			
			INITIALIZED.dispatch();
		}
		
		public function get initialized():Boolean
		{
			return m_initialized;
		}
		
		public function get scene():Scene3D
		{
			return m_viewport.scene;	
		}
		
		public function get camera():Camera3D
		{
			return m_viewport.camera;	
		}
		
		public function get viewport():Viewport
		{
			return m_viewport;
		}
		
		public function get gameScreen():GameScreen
		{
			return m_gamescreen;
		}
			
	}
}