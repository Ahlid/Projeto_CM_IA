/**
 * Created by pcts on 1/11/2017.
 */
import React, { Component } from 'react';
import { Modal, Text, Image, View,TextInput,Button, BackAndroid, Dimensions, TouchableHighlight  } from 'react-native';
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
        Actions.salas({type: 'reset'});
    }

    _onUserJoined(){
        this.state.socket.removeAllListeners('userJoined');
        Actions.jogo();
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

      return (
          <View style={{ alignItems: 'center',
              justifyContent: 'center', flex: 1,
              flexDirection: 'column',
              backgroundColor : '#F4F0E6'}} >
              <Text style={{textAlign: 'center',fontSize: (height>width) ? height/35 : width/25, fontWeight: "bold"}}>Waitting...</Text>

              <Image style={{marginTop:20}} source={require('../images/ajax-loader.gif')} />
              <TouchableHighlight
                  underlayColor="transparent"
                  onPress={this._onCancel.bind(this)}
              >
                  <View style={styles.buttonInside1}>

                      <Text style={{fontSize: height/25, fontWeight: "bold"}}>Cancel</Text>
                  </View>


              </TouchableHighlight>

        </View>
      );
    }

}


export default connect((store)=>{

    return {
        socket : store.socket
    }

})(SalaDeEspera);


var styles = {}