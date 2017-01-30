/**
 * Created by pcts on 1/11/2017.
 */
import React, {Component} from 'react';
import {View, Text, Button, TextInput, Alert, Dimensions, BackAndroid, TouchableHighlight, Image} from 'react-native';
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
            err:false,
            waiting: false
        }

        let handler = function() {
            // this.onMainScreen and this.goBack are just examples, you need to use your own implementation here
            // Typically you would use the navigator here to go to the last state.

            BackAndroid.removeEventListener('hardwareBackPress', handler);
            Actions.menu({type: 'reset'});
            return true;

        }.bind(this);

        BackAndroid.addEventListener('hardwareBackPress', handler);
    }

    onclick(){
        this.setState({waiting:true});
        this.state.socket.on('login',this._onLogin.bind(this));
        this.state.socket.emit('login',{username:this.state.username});
    }

    _onLogin(data){

        if (data.err){
            this.setState({err:true, waiting: false });
            this.state.socket.removeAllListeners("login");
        }else {
            this.props.makeLogin(this.state.username);
            this.state.socket.removeAllListeners("login");
            Actions.salas();
        }
    }

    onActionSelected(position) {
        if (position === 0) { // index of 'Settings'
            showSettings();
        }
    }

    render(){


        var {height,width} = Dimensions.get('window');

        if (width > height) {
            var x = height;
            width = height;
            height = width;
        }

        styles.buttonInside1 = {
            paddingTop: height/ 40,
            paddingBottom: (height / 40),
            justifyContent: 'center',
            alignItems: 'center',
            backgroundColor : '#F2AA77',
            marginTop:40,
            paddingLeft: (width / 5),
            paddingRight: (width / 5)

        };

        var {width, height} = Dimensions.get('window');

        if (this.state.waiting){
            return (
                <View style={{ alignItems: 'center',
                    justifyContent: 'center', flex: 1,
                    flexDirection: 'column',
                    backgroundColor : '#F4F0E6'}} >
                <Image style={{marginTop:20}} source={require('../images/ajax-loader.gif')} />

                </View>
            )
        }

       return <View style={{ alignItems: 'center',
           justifyContent: 'center', flex: 1,
           flexDirection: 'column',
           backgroundColor : '#F4F0E6'}} >
           <Text style={{textAlign: 'center',fontSize: (height>width) ? height/35 : width/25, fontWeight: "bold"}}>Choose a nickname</Text>

           <TextInput
               style={{color:'#3D96B8' ,textAlign: 'center',fontSize: (height>width) ? height/45 : width/35 ,height: 60, width: (width>height)? width/2 : height/2, marginTop:20 }}

               onChangeText={(text) => this.setState({username:text})}
               onEndEditing={this.clearFocus}
           />


           <TouchableHighlight
               underlayColor="transparent"
               onPress={this.onclick.bind(this)}
           >
               <View style={styles.buttonInside1}>

                   <Text style={{fontSize: height/25, fontWeight: "bold"}}>Continue</Text>
               </View>


           </TouchableHighlight>

           {this.state.err ? <Text style={{textAlign: 'center'}}>Nickname in use, choose another one.</Text> : null}

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


var styles = {}