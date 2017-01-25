import React, { Component } from 'react';
import {Text, View, Button } from 'react-native';
import { Actions } from 'react-native-router-flux'

export default class DrawScreen extends React.Component {

    render(){

        let text = "Não houve vencedor";


        return  <View style={[{width: this.props.width, height: this.props.height}, styles.baseRootContainer, styles.colorRootContainer]}>
            <Text style={{fontSize: 30}}>{text}</Text>
            <Text style={{fontSize: 40}}>Empate</Text>
            <View style={{marginTop: 20,flexDirection: 'row',justifyContent: 'center', alignItems: 'center'}}>
                <View style={{marginRight: 4,width: 100}}>
                    <Button
                        onPress={function(){
                            this.props.restart();}.bind(this)}
                        style={{width: 100}}
                        title="Novo Jogo"
                        color='#444849'
                    />
                </View>
                <View style={{marginLeft: 4,width: 100}}>
                    <Button
                        onPress={function(){Actions.menu()}}
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
    colorRootContainer: {
        backgroundColor: '#F4F0E6'
    }
};