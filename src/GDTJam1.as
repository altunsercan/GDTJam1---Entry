package
{
	import cmd.DisplaySplashCmd;
	import cmd.LoadGameAssetsCmd;
	import cmd.SetupY3DCmd;
	
	import com.yogurt3d.core.materials.Material;
	import com.yogurt3d.presets.material.MaterialFill;
	import com.yogurt3d.presets.sceneobjects.BoxSceneObject;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Vector3D;
	
	import guard.GameSystemsReadyGuard;
	
	import managers.ResourcesManager;
	import managers.ScreenManager;
	import managers.Y3DManager;
	
	import ops.InitializeDoomsdayConsoleOp;
	
	import org.as3commons.async.command.CompositeCommandKind;
	import org.as3commons.async.command.ICompositeCommand;
	import org.as3commons.async.command.impl.CompositeCommand;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.swiftsuspenders.Injector;

	[SWF(width="1024", height="768", frameRate="60", wmode="direct", backgroundColor="#000000")]
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
			masterInjector = new Injector();
			masterInjector.map(GDTJam1).toValue( this );
			masterInjector.map( ScreenManager ).toSingleton( ScreenManager );
			masterInjector.map( Y3DManager ).toSingleton( Y3DManager );
			masterInjector.map( ResourcesManager ).toSingleton( ResourcesManager );
			
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
					.addCommand( new LoadGameAssetsCmd() )			// LoadAssets
					.addCommand( new SetupY3DCmd() )      // Wait until game systems are ready
					)
				);
			
			m_initializationCmd.addCompleteListener( onInitializationComplete );
			m_initializationCmd.addErrorListener( onInitializationError );
			
			m_initializationCmd.execute();
			
			
		}
		
		/////
		// Initialization
		/////
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

