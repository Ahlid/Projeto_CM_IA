/**
 * Created by pcts on 1/11/2017.
 */
import React, {Component} from 'react';
import {View, Text, Button, TextInput, Alert} from 'react-native';
import {connect} from 'react-redux';
import { Actions } from 'react-native-router-flux'

class Menu extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            username : props.username,
            socket : props.socket
        }
    }

    render() {
        return (
            <View>
                <Text>
                   Menu, username {this.state.username}
                </Text>

                <Button onPress={() => {Actions.singlePlayer()}}
                        title="SinglePlayer"
                        color="#841584" />

                <Button onPress={() => {Actions.salas()}}
                        title="Salas"
                        color="#841584" />
            </View>
        )
    }
}

export default  connect((store) => {

    return {
        username: store.username,
        socket: store.socket

    }
})(Menu);




