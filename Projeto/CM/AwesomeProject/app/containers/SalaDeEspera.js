/**
 * Created by pcts on 1/11/2017.
 */
import React, { Component } from 'react';
import { Modal, Text, TouchableHighlight, View,TextInput,Button, BackAndroid  } from 'react-native';
import {connect} from 'react-redux';
import { Actions } from 'react-native-router-flux'

class SalaDeEspera extends React.Component{

    constructor(props){
        super(props);

        this.state = {
            socket : this.props.socket
        }
    }

    componentDidMount(){
        BackAndroid.addEventListener('hardwareBackPress', this._onBackButton.bind(this));
        this.state.socket.on('userJoined',this._onUserJoined.bind(this))
    }

    _onBackButton(){
        this.props.socket.emit('leaveRoom','');
        this.state.socket.removeAllListeners('userJoined')
        BackAndroid.removeEventListener('hardwareBackPress', this._onBackButton);
        return true;
    }

    _onCancel(){
        this.props.socket.emit('leaveRoom','');
        this.state.socket.removeAllListeners('userJoined')
        Actions.salas();
    }

    _onUserJoined(){
        this.state.socket.removeAllListeners('userJoined');
        Actions.jogo();
    }

    render(){
      return (
          <View>
            <Text>Waiting for opponent....</Text>
              <Button onPress={this._onCancel.bind(this)} title="Cancel" ></Button>
        </View>
      );
    }

}


export default connect((store)=>{

    return {
        socket : store.socket
    }

})(SalaDeEspera);