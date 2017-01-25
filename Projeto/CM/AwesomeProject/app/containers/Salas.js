/**
 * Created by pcts on 1/11/2017.
 */
import React, {Component} from 'react';
import {View, Text, Button, Modal, TouchableHighlight, ScrollView, StyleSheet, Dimensions} from 'react-native';
import {connect} from 'react-redux';
import AddSala from './AddSala';
import {Actions} from 'react-native-router-flux';
import Room from '../components/board/Room';
import ActionButton from 'react-native-circular-action-menu';
import Icon from 'react-native-vector-icons/Ionicons';

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

    _addSalaOnCriar(size) {
        this.setState({
            modal: false
        });

        this.state.socket.emit('createRoom', {
            hSquares: size.hSquares,
            vSquares: size.vSquares
        });
        Actions.salaespera();
    }

    _addSalaOnCancelar() {
        this.setState({
            modal: false
        });
    }

    _joinSala(id) {
        this.state.socket.emit('joinRoom', {id: id});
        this.state.socket.on('joinConfirm', function (data) {
            this._joinSalaConfirm(data, id);
        }.bind(this));
    }

    _joinSalaConfirm(data, id) {
        if (data.id == id) {
            //confirma-se que é a sala dele entao vamos dar inicio ao jogo
            this.state.socket.removeAllListeners('joinConfirm');
            Actions.jogo();

        }
    }

    render() {

        var {height,width} = Dimensions.get('window');

        if (width > height) {
            var x = height;
            width = height;
            height = width;
        }

        return (

                <View style={{ flex: 1,
                    backgroundColor : '#F4F0E6'
                }}>
                    <View style={{height:height/8,
                        alignItems: 'center',
                        justifyContent: 'center',
                        backgroundColor: '#444849'


                    }}>
                        <Text style={{ color: 'white', fontSize: (height>width) ? height/35 : width/25}}>Salas Disponiveis</Text>
                    </View>
                    <ScrollView style={styles.Room}>
                        <Modal
                            animationType={"slide"}
                            transparent={true}
                            visible={this.state.modal}
                            onRequestClose={() => {
                                alert("Modal has been closed.")
                            }}>

                            <AddSala onCriar={this._addSalaOnCriar.bind(this)}
                                     onCancelar={this._addSalaOnCancelar.bind(this)}/>
                        </Modal>

                        {this.state.rooms.map(function (item, index) {
                            console.log(item);
                            return (<Room key={index} index={index} username={item.user} hSquares={item.hSquares}
                                          vSquares={item.vSquares} id={item.id}
                                          join={this._joinSala.bind(this)}/>)

                        }.bind(this))}


                    </ScrollView>
                    <ActionButton onPress={this._modalTest.bind(this)} buttonColor="#3d96b8" position="right">

                    </ActionButton>
                </View>


        );

    }

}


export default connect((store) => {
    return {
        rooms: store.rooms,
        socket: store.socket
    }
})(Sala);


const styles = StyleSheet.create({
    actionButtonIcon: {
        fontSize: 20,
        height: 22,
        width: 20,
        color: 'white',
        position: 'absolute',
        bottom: 10,
        right: 10
    }
});

