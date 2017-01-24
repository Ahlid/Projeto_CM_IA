import React, { Component } from 'react';
import {Text, View, Button } from 'react-native';


export default class WinScreen extends React.Component {

    render(){

        let rootContainerStyle = styles.blueRootContainer;
        let info = "Venceu a Partida";

        return  <View style={[{width: this.props.width, height: this.props.height}, styles.baseRootContainer, rootContainerStyle]}>
            <Text style={{fontSize: 30}}>{info}</Text>
            <Text style={{fontSize: 40, color: '#F4F0E6'}}>{this.props.score} Pontos</Text>
            <View style={{marginTop: 20,flexDirection: 'row',justifyContent: 'center', alignItems: 'center'}}>
                <View style={{width: 100}}>
                    <Button
                        onPress={function(){}}
                        style={{width: 100}}
                        title="Voltar"
                        color='#444849'
                    />
                </View>
            </View>
        </View>
    }
}

var styles = {
    baseRootContainer: {
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center'
    },
    blueRootContainer: {
        backgroundColor: '#3F9BBE'
    }
}