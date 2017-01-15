/**
 * Created by pcts on 1/11/2017.
 */
import React, {Component} from 'react';
import {View, Text, Button, Modal, TouchableHighlight} from 'react-native';
import {connect} from 'react-redux';
import AddSala from './AddSala';
import { Actions } from 'react-native-router-flux';
import Room from '../components/Room'

class Sala extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            rooms: props.rooms,
            socket: props.socket,
            modal: false

        }
    }


    componentDidMount() {
        this.state.socket.on('viewRooms', this._socketOnViewRooms.bind(this))
        this.state.socket.emit('viewRooms', '');
    }

    componentWillUnmount() {
        this.state.socket.removeAllListeners("viewRooms");
    }

    _socketOnViewRooms(data) {

        this.setState(
            {rooms: data.rooms}
        );


    }

    _modalTest() {
        this.setState({modal: true});
    }

    _addSalaOnCriar(size){
        this.setState({
            modal: false
        });

        this.state.socket.emit('createRoom',{size:size});
        Actions.salaespera();


    }

    _addSalaOnCancelar(){
        this.setState({
            modal: false
        });
    }

    _joinSala(id){
        this.state.socket.emit('joinRoom',{id:id});
        this.state.socket.on('joinConfirm',function(data){
            this._joinSalaConfirm(data,id);
        }.bind(this));


    }

    _joinSalaConfirm(data,id){
        if(data.id == id){
            //confirma-se que é a sala dele entao vamos dar inicio ao jogo
            this.state.socket.removeAllListeners('joinConfirm');
            Actions.jogo();

        }
    }

    render() {

        var rooms = [];
        for(var i = 0 ; i< this.state.rooms.lenght ; i++){

           rooms.push(<Room key={i} username={this.state.rooms[i].user} size={this.state.rooms[i].size} id={this.state.rooms[i].id} join = {this._joinSala.bind(this)} />);

        }

        return (
            <View>
                <Modal
                    animationType={"slide"}
                    transparent={false}
                    visible={this.state.modal}
                    onRequestClose={() => {
                        alert("Modal has been closed.")
                    }}>

                    <AddSala onCriar={this._addSalaOnCriar.bind(this)} onCancelar={this._addSalaOnCancelar.bind(this)}  />
                </Modal>


                <Text>Salas</Text>
                <Text>{JSON.stringify(this.state.rooms)}</Text>
                {this.state.rooms.map(function(item,index){

                    return(<Room key={index} username={item.user} size={item.size} id={item.id} join = {this._joinSala.bind(this)} />)

                        }.bind(this))}
                <Button title="Ver modal" onPress={this._modalTest.bind(this)}></Button>
            </View>

        );

    }

}


export default  connect((store) => {
    return {

        rooms: store.rooms,
        socket: store.socket
    }
})(Sala);