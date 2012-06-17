package guard
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import managers.ResourcesManager;
	import managers.Y3DManager;
	
	import org.as3commons.async.command.IAsyncCommand;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.osflash.signals.Signal;
	
	public class GameSystemsReadyGuard extends EventDispatcher implements IAsyncCommand
	{
		[Inject]
		public var y3dManager:Y3DManager;
		
		[Inject]
		public var resourcesManager:ResourcesManager;
		
		private var m_systemwaitcounter:int = 0;
		
		
		public function GameSystemsReadyGuard()
		{
		}
		
		public function execute():*
		{
			GDTJam1.masterInjector.injectInto( this );
			
			var systemsReady:Boolean = true;
			
			if( !y3dManager.initialized )
			{
				systemsReady = false;
				m_systemwaitcounter++;
				y3dManager.INITIALIZED.addOnce( decreaseCounter );	
			}
			
			if( !resourcesManager.complete )
			{
				systemsReady = false;
				m_systemwaitcounter++;
				resourcesManager.COMPLETE.addOnce( decreaseCounter );	
			}
			
			
			if( systemsReady )
			{
				notifyReady();
			}
			
			return null;
		}
		private function decreaseCounter():void
		{
			m_systemwaitcounter--;
			if( m_systemwaitcounter == 0 )
			{
				notifyReady();
			}
		}
		
		private function notifyReady():void
		{
			var opComplete:OperationEvent = new OperationEvent( OperationEvent.COMPLETE, this );
			
			dispatchEvent( opComplete );
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