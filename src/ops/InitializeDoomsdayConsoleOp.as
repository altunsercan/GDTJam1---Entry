package ops
{
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.core.input.KeyBindings;
	import com.furusystems.dconsole2.core.input.KeyboardManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.DConsoleTarget;
	import org.osflash.signals.Signal;
	
	public class InitializeDoomsdayConsoleOp implements IOperation
	{
		[Inject]
		public var stage:GDTJam1;
		
		private var COMPLETE:Signal = new Signal( OperationEvent );
		//private var ERROR:Signal = new Signal( OperationEvent );
		
		private var m_logger:ILogger;
		private var m_completeEvent:OperationEvent;
		public function InitializeDoomsdayConsoleOp()
		{
			GDTJam1.masterInjector.injectInto( this );
			
			/// Initialize DConsole
			stage.addChild(DConsole.view);
			
			//DConsole.console.changeKeyboardShortcut( KeyBindings.c, KeyBindings.CTRL );
			DConsole.console.clear();
			DConsole.console.setHeaderText( "SkyCom AI Systems" );
			//DConsole.show();
			
			// Initialize Logger
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new DConsoleTarget() );
			
			m_logger = getLogger( InitializeDoomsdayConsoleOp );
			
			m_logger.info( "Doomsday Console Initialized" );
			
			m_completeEvent = new OperationEvent( OperationEvent.COMPLETE, this );
			
			COMPLETE.dispatch( m_completeEvent );
		}
		
		public function get result():*
		{
			return null;
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
			if( !m_completeEvent)
			{
				COMPLETE.addOnce( listener );
			}else
			{
				
				listener( m_completeEvent );
			}
			
		}
		
		public function addErrorListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			//ERROR.addOnce(listener);
		}
		
		public function addTimeoutListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeCompleteListener(listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function removeErrorListener(listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function removeTimeoutListener(listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
	}
}