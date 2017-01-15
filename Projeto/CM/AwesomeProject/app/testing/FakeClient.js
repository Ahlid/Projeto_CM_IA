var client = require("socket.io-client")('http://cm-server-ahlid1.c9users.io:8081'); // This is a client connecting to the SERVER 2

client.on("connect",function(){
    console.log('connected');
    client.emit('login',{username:"RicardoMorais2"});

    client.on('login',function(data){
        console.log('Login: '+data.err);
        client.emit('createRoom',{size:20});
        client.emit('viewRooms','');
    });

    client.on('viewRooms',function(data){
        console.log(JSON.stringify(data));
    });

    client.on('userJoined',function(data){
        client.emit('gameReady','');
    });

    client.on('start',function(data){
        console.log(data);
        client.emit('makeMove',{
            gameID: data.gameInfo.id,
            edge: 0,
            row: 1,
            column: 1,
        })
    });
});