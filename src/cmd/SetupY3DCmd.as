package cmd
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import managers.Y3DManager;
	
	import org.as3commons.async.command.IAsyncCommand;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.osflash.signals.Signal;
	
	public class SetupY3DCmd extends EventDispatcher implements IAsyncCommand
	{
		
		[Inject]
		public var y3dManager:Y3DManager;
		
		
		
		public function SetupY3DCmd()
		{
			super(this);
		}
		
		public function execute():*
		{
			GDTJam1.masterInjector.injectInto( this );
			try{
				y3dManager.initializeManager();
				
				var opComplete:OperationEvent = new OperationEvent( OperationEvent.COMPLETE, this );
				dispatchEvent( opComplete );
				
				
			}catch( _e:Error )
			{
				
				
			}
			
			return null;
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