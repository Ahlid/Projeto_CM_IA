import React, { Component } from 'react';
import {
    Text,
    TouchableHighlight,
    View,
    Button
} from 'react-native';

export default class Score extends React.Component{

    render(){
        return (
            <View style={[this.props.style, {backgroundColor: '#444849'}]} >
                <Text style={{fontSize: this.props.style.width / 6,fontWeight: 'bold',
                            color: '#F4F0E6',
                            textAlign:'center',
                            position: 'absolute', left: 0, right: 0, bottom: 30
                }}>{this.props.player + ": " + this.props.score}</Text>
                <View style={{height: 14, backgroundColor: this.props.color, position: 'absolute', left: 0, right: 0, bottom: 0}}></View>
            </View>
        );
    }

}