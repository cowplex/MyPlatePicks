/**
 * @author mikelownds
 */
package Reporting
{
	
	import flash.events.*;
    import flash.net.*;
    
	public class Report
	{
		
		private var _loader : URLLoader = new URLLoader();
		private var _request : URLRequest;
		
		private var _question : String = null;
		private var _level : String = null;
		
		private var _baseURI : String = "http://localhost:8889/report.php";//"http://cowplex.com/Circle1/report/report.php";
		
		private var _gameID : String = null;
		
		private var hash : MD5 = new MD5();
		
		public function Report(s: String)
		{
			setURI(s);
			
			_loader.addEventListener(Event.COMPLETE, IDcompleteHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, IDerrorHandler);
			
			_request = new URLRequest(_baseURI);
			try {
				_loader.load(_request);
			} catch (error:Error) {
				trace("Unable to load requested document.");
			}
		}

		private function setURI(s : String) : void
		{
			if(s == "KidsCom")
				_baseURI = "http://kidscom.com/games/myplatepicks/report/report.php";
			else if(s == "Local")
				_baseURI = "http://localhost:8889/report.php";
			else
				_baseURI = s;
		}

		private function IDcompleteHandler(event:Event):void {
			trace("IDcompleteHandler: " + _loader.data);
			//if(_gameID == null)
				_gameID = _loader.data;
		}
		
		private function completeHandler(event:Event):void {
			//trace("completeHandler: " + _loader.data);
			//if(_gameID == null)
			//	_gameID = _loader.data;
		}
		
		private function errorHandler(e:Event) : void
		{
			trace("Could not connect to datalogger. Data will NOT be logged for this session.");
			trace("URL: " + _baseURI);
		}
		
		private function IDerrorHandler(e:Event) : void
		{
			trace("Could not connect to datalogger. Data will NOT be logged for this session.");
			trace("URL: " + _baseURI);
			_gameID = null;
		}
		
		public function set question(q : String) : void
		{
			_question = hash.encrypt(q);
		}
		
		public function set level(l : String) : void
		{
			_level = l;
		}
        
		public function sendReport( datapoint : String, data : String ) : void
		{
			if(_gameID == null)
				return;
			
			var loader : URLLoader = new URLLoader();
			var request : URLRequest;
			
			if(datapoint == "answer" && data != "true" && data != null)
			{
				data = hash.encrypt(data);
			}
			
			loader.addEventListener(Event.COMPLETE, completeHandler);
			request = new URLRequest(_baseURI + "?gameid=" + _gameID + "&level=" + _level + "&question=" + _question + "&" + datapoint + "=" + data);
			try {
				loader.load(request);
			} catch (error:Error) {
				trace("Unable to load requested document.");
			}
		}
	}
}