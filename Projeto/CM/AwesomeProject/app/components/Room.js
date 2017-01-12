/**
 * Created by pcts on 1/11/2017.
 */
//todo: componente que representa cada sala

import React, { Component } from 'react';
import { Modal, Text, TouchableHighlight, View,TextInput,Button  } from 'react-native';



class Room extends React.Component{

    constructor(props){
        super(props);

        this.state = {
            username: props.username,
            size : props.size,
            id : props.id
        }
    }

    _onPressButton(){
        this.props.join(this.state.id);
    }

    render(){


        return(
          <View>
              <TouchableHighlight onPress={this._onPressButton.bind(this)}>
                  <Text>Sala de {this.state.username} com tamanho {this.state.size}</Text>
              </TouchableHighlight>
          </View>
        );
    }

}

export default Room;