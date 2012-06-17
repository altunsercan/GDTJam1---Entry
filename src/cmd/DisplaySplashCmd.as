package cmd
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import managers.ScreenManager;
	
	import org.as3commons.async.command.IAsyncCommand;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.osflash.signals.Signal;
	
	import screens.GameOverScreen;
	import screens.SplashScreenY3D;
	
	public class DisplaySplashCmd extends EventDispatcher implements IAsyncCommand
	{
		[Inject]
		public var screenManager:ScreenManager;
		
		private var m_logger:ILogger;
		
		public function DisplaySplashCmd()
		{
			m_logger = getLogger( DisplaySplashCmd );
		}
		
		public function execute():*
		{
			try
			{
				GDTJam1.masterInjector.injectInto( this );
			}catch( _e:Error )
			{
				m_logger.fatal( "Cannot inject ScreenManager: \n" + _e.message );	
			}
			
			if( screenManager )
			{
				var splash:SplashScreenY3D = new SplashScreenY3D();	
				splash.SPLASH_COMPLETE.addOnce( onSplashComplete );
				
				var gameover:GameOverScreen = new GameOverScreen();
				
				screenManager.addScreen( "gameover", gameover );
				screenManager.addScreen( "splash", splash, true );
				
			}
			return null;
		}
		
		public function onSplashComplete(  ):void
		{
			screenManager.destroyScreen( "splash" );
			
			var eventComplete:OperationEvent = new OperationEvent( OperationEvent.COMPLETE, this );	
			
			dispatchEvent( eventComplete );
		}
		
		public function get result():*
		{
			
			return {};
		}
		
		public function get error():*
		{
			return null;
		}
		
		public function get timeout():int
		{
			return 0;
		}
		
		public function set timeout(value:int):void
		{
		}
		
		public function addCompleteListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			this.addEventListener( OperationEvent.COMPLETE, listener, useCapture, priority, useWeakReference );
		}
		
		public function addErrorListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function addTimeoutListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeCompleteListener(listener:Function, useCapture:Boolean=false):void
		{
			this.removeEventListener( OperationEvent.COMPLETE, listener, useCapture );
		}
		
		public function removeErrorListener(listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function removeTimeoutListener(listener:Function, useCapture:Boolean=false):void
		{
		}
	}
}