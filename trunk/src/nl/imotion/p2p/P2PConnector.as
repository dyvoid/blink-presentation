/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2009-2013 Pieter van de Sluis
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://code.google.com/p/imotionproductions/
 */

package nl.imotion.p2p
{
    import flash.events.AsyncErrorEvent;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.GroupSpecifier;
    import flash.net.NetConnection;
    import flash.net.NetGroup;


    /**
     * @author Pieter van de Sluis
     */
    public class P2PConnector extends EventDispatcher
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _connection     :NetConnection;
		private var _group          :NetGroup;

		private var _isConnected    :Boolean = false;

		private var _groupID            :String;
        private var _multicastAddress   :String;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function P2PConnector()
        {
            
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function connect( groupID:String = "group", multicastAddress:String = "239.225.0.1:12345" ):void
		{
            if ( _connection ) throw new Error( "Already connected." );

            _groupID = groupID;
            _multicastAddress = multicastAddress;

            _connection = new NetConnection();
            _connection.addEventListener( NetStatusEvent.NET_STATUS, handleNetStatus );
            _connection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, handleNetError );
            _connection.addEventListener( IOErrorEvent.IO_ERROR, handleNetError );
            _connection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handleNetError );
            _connection.connect( "rtmfp:" );
		}


		public function sendMessage( type:String, data:Object = null ):void
		{
			if( !_isConnected ) return;

			var message:Message = new Message( type, data );
            message.sender = _group.convertPeerIDToGroupAddress( _connection.nearID );
			message.timeStamp = new Date().time; // add time stamp to make each call unique

			_group.post( message );
		}

        // ____________________________________________________________________________________________________
        // PRIVATE

		private function setupGroup():void
		{
			var groupspec:GroupSpecifier = new GroupSpecifier( _groupID );
			groupspec.postingEnabled = true;
			groupspec.ipMulticastMemberUpdatesEnabled = true;
			groupspec.addIPMulticastAddress( _multicastAddress );

			_group = new NetGroup( _connection, groupspec.groupspecWithAuthorizations() );
			_group.addEventListener( NetStatusEvent.NET_STATUS, handleNetStatus );
		}


		private function parseMessage( messageObject:Object ):void
		{
			var message:Message = new Message( messageObject.type, messageObject.data );
            message.sender = messageObject.sender;
            message.timeStamp = parseInt( messageObject.timeStamp );
            
            dispatchEvent( new P2PConnectorEvent( P2PConnectorEvent.MESSAGE_RECEIVED, message ) );
		}

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleNetStatus( e:NetStatusEvent ):void
		{
			trace( "P2P Status: " + e.info.code );

			switch ( e.info.code )
			{
				case "NetConnection.Connect.Success":
					setupGroup();
				break;

				case "NetGroup.Connect.Success":
					_isConnected = true;
				break;

                case "NetGroup.Neighbor.Connect" :
                    dispatchEvent( new Event( Event.CONNECT ) );
                break;

				case "NetGroup.Posting.Notify" :
					parseMessage( e.info.message );
				break;
			}
		}


        private function handleNetError( e:ErrorEvent ):void
        {
            trace( "P2P Error: " + e.toString() );
        }

    }
}