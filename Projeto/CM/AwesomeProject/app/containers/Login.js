/**
 * Created by pcts on 1/11/2017.
 */
import React, {Component} from 'react';
import {View, Text, Button, TextInput, Alert} from 'react-native';
import {connect} from 'react-redux';
import { ActionCreators } from '../actions'
import { bindActionCreators } from 'redux'
import { Actions } from 'react-native-router-flux'


class Login extends React.Component{

    constructor(props){
        super(props)
        this.state = {
            username:"",
            socket: props.socket,
            err:false
        }
    }

    onclick(){
        this.state.socket.on('login',this._onLogin.bind(this));
        this.state.socket.emit('login',{username:this.state.username});
    }

    _onLogin(data){
        if (data.err){
            this.setState({err:true});
            this.state.socket.removeAllListeners("login");
        }else {
            this.props.makeLogin(this.state.username);
            this.state.socket.removeAllListeners("login");
            Actions.menu();
        }
    }

    onActionSelected(position) {
        if (position === 0) { // index of 'Settings'
            showSettings();
        }
    }

    render(){
       return <View>
            <Text>Redux</Text>
           <TextInput
               style={{height: 40}}
               placeholder="Type here to translate!"
               onChangeText={(text) => this.setState({username:text})}
               onEndEditing={this.clearFocus}
           />
            <Button onPress={this.onclick.bind(this)}
                    title="click me"
                    color="#841584" />

           {this.state.err ? <Text>Username em uso, escolha outro</Text> : null}

        </View>
    }
}

function mapDispatchToPros(dispatch) {
    return bindActionCreators(ActionCreators, dispatch);
}

export default connect((state)=> {return {
    username: state.username,
    socket: state.socket

}}, mapDispatchToPros)(Login);