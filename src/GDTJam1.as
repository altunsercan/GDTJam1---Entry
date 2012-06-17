package
{
	import cmd.DisplaySplashCmd;
	import cmd.LoadGameAssetsCmd;
	import cmd.SetupY3DCmd;
	
	import com.yogurt3d.core.managers.DependencyManager;
	import com.yogurt3d.core.materials.Material;
	import com.yogurt3d.presets.material.MaterialFill;
	import com.yogurt3d.presets.sceneobjects.BoxSceneObject;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import gameobj.ObstacleGenearator;
	
	import guard.GameSystemsReadyGuard;
	
	import managers.GameStatsManager;
	import managers.KeyboardManager;
	import managers.MouseManager;
	import managers.PhysicsManager;
	import managers.ResourcesManager;
	import managers.ScreenManager;
	import managers.SoundManager;
	import managers.Y3DManager;
	
	import ops.InitializeControlManagersOp;
	import ops.InitializeDoomsdayConsoleOp;
	
	import org.as3commons.async.command.CompositeCommandKind;
	import org.as3commons.async.command.ICompositeCommand;
	import org.as3commons.async.command.impl.CompositeCommand;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.swiftsuspenders.Injector;

	[SWF(width="1024", height="768", frameRate="40", wmode="direct", backgroundColor="#000000")]
	public class GDTJam1 extends Sprite
	{
		public static var masterInjector:Injector;
		
		public static const width:uint = 1024;
		public static const height:uint = 768;
		
		private var m_initializationCmd:ICompositeCommand;
		
		/////
		// Constructor
		/////
		public function GDTJam1()
		{
			stage.focus = stage;
			
			//stage.addEventListener( KeyboardEvent.KEY_DOWN, test );
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill( 0x000000, 0.005 );
			sprite.graphics.drawRect( 0, 0, width, height );
			this.addChild( sprite );
			
			masterInjector = DependencyManager.injector;
			masterInjector.map(GDTJam1).toValue( this );
			masterInjector.map( ScreenManager ).toSingleton( ScreenManager );
			masterInjector.map( Y3DManager ).toSingleton( Y3DManager );
			masterInjector.map( ResourcesManager ).toSingleton( ResourcesManager );
			masterInjector.map( MouseManager ).toSingleton( MouseManager );
			masterInjector.map( KeyboardManager ).toSingleton( KeyboardManager );
			masterInjector.map( ObstacleGenearator ).toSingleton( ObstacleGenearator );
			masterInjector.map( PhysicsManager ).toSingleton( PhysicsManager );
			masterInjector.map( GameStatsManager ).toSingleton( GameStatsManager );
			masterInjector.map( SoundManager ).toSingleton( SoundManager );
			
			m_initializationCmd = new CompositeCommand( CompositeCommandKind.SEQUENCE )
			.addOperation( InitializeDoomsdayConsoleOp ) /// Start initializing essentials
			.addCommand( 
				new CompositeCommand( CompositeCommandKind.PARALLEL) /// Splash Scene / Loader  and StartUp Processes runs in paralel
				.addCommand( 
					new CompositeCommand(CompositeCommandKind.SEQUENCE)  
					.addCommand( new DisplaySplashCmd() )			// Display Splash Screen
					//.addCommand( new DisplayMainLoaderCmd() )			// Display Splash Screen
					.addCommand( new GameSystemsReadyGuard() )      // Wait until game systems are ready
					)
				.addCommand( 
					new CompositeCommand(CompositeCommandKind.SEQUENCE)  
					.addCommand( new SetupY3DCmd() )      // Setup 3D
					.addCommand( new LoadGameAssetsCmd() )			// LoadAssets
					.addOperation( InitializeControlManagersOp ) /// Initialize Mouse Manager
					)
				);
			
			m_initializationCmd.addCompleteListener( onInitializationComplete );
			m_initializationCmd.addErrorListener( onInitializationError );
			
			m_initializationCmd.execute();
			
			
		}
		
		/////
		// Initialization
		/////
		private function test(_e:KeyboardEvent):void
		{
			
		}
		
		private function onInitializationComplete(_evt:OperationEvent):void
		{
			/// Test
			var screenManager:ScreenManager = masterInjector.getInstance( ScreenManager );
			screenManager.changeScreen( "gameScreen" );
			
			
				
		}
		private function onInitializationError(_evt:OperationEvent):void
		{
			
		}
		

	}
}

