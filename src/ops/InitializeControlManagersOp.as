package ops
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import managers.KeyboardManager;
	import managers.MouseManager;
	
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	
	public class InitializeControlManagersOp extends EventDispatcher implements IOperation
	{
		[Inject]
		public var mouseManager:MouseManager;
		
		[Inject]
		public var keyboardManager:KeyboardManager;
		
		private var initialized:Boolean = false;
		
		public function InitializeControlManagersOp()
		{
			super(this);
			GDTJam1.masterInjector.injectInto( this );
			
			
			mouseManager.initialize();
			keyboardManager.initialize();
			
			initialized = true;
			
			var event:OperationEvent = new OperationEvent( OperationEvent.COMPLETE, this );
			dispatchEvent( event );
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
			addEventListener(OperationEvent.COMPLETE, listener, useCapture, priority, useWeakReference);
			if( initialized )
			{
				var event:OperationEvent = new OperationEvent( OperationEvent.COMPLETE, this );
				dispatchEvent( event );
			}
			
		}
		
		public function addErrorListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(OperationEvent.ERROR, listener, useCapture, priority, useWeakReference);
		}
		
		public function addTimeoutListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(OperationEvent.TIMEOUT, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeCompleteListener(listener:Function, useCapture:Boolean=false):void
		{
			removeEventListener(OperationEvent.COMPLETE, listener, useCapture);
		}
		
		public function removeErrorListener(listener:Function, useCapture:Boolean=false):void
		{
			removeEventListener(OperationEvent.ERROR, listener, useCapture);
		}
		
		public function removeTimeoutListener(listener:Function, useCapture:Boolean=false):void
		{
			removeEventListener(OperationEvent.TIMEOUT, listener, useCapture);
		}
	}
}