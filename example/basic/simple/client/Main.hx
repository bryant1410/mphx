package;
import mphx.client.Client;

#if flash
import flash.events.Event;
import flash.Lib;
#end

class Main
{
	var clientSocket:Client;

	public function new ()
	{
		var ip = "127.0.0.1";

		#if sys
		if (Sys.args()[0] != null) ip = Sys.args()[0];
		#end

		clientSocket = new Client(ip, 8000);

		var quit = false;

		clientSocket.events.on("DM",function (data){
			trace("Server sent a direct message with data '" +data+"'");
		});

		clientSocket.events.on("Server wide broadcast",function (data){
			trace("server broadcasted a server wide message. Data was '"+data+"'");
		});

		clientSocket.events.on("SomeoneDisconnected", function (data){
			trace("Someone (else) disconnected from the server. You're still connected though!");
		});

		clientSocket.onConnectionClose = function (reason:mphx.utils.Error.ClientError){
			//Custom error handling...
			quit = true;
		}
		clientSocket.onConnectionError = function (reason:mphx.utils.Error.ClientError){
			//Custom error handling...
			quit = true;
		}

		clientSocket.connect();
		clientSocket.send("Hello",123);

		#if js
		//nothingSpecial
		#elseif flash
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, function(e: Event)
		{
			clientSocket.update();
		});

		#else
		
		while (quit == false){
			clientSocket.update();
			Sys.sleep(0.01); // wait for 1 ms

		}
		#end

	}
	public static function main () {
		new Main();
	}
}
