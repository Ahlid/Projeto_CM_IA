import React, { Component } from 'react';
import {Text, View, Button,TouchableHighlight } from 'react-native';
import { Actions } from 'react-native-router-flux'

export default class WinnerScreen extends React.Component {


    render(){

        let rootContainerStyle = this.props.playerIndex == 1 ? styles.blueRootContainer : styles.orangeRootContainer;
        let winnerText = this.props.playerIndex == 1 ? "Azuis venceram" : "Laranjas venceram";


        return  <View style={[{width: this.props.width, height: this.props.height}, styles.baseRootContainer, rootContainerStyle]}>
            <Text style={{fontSize: this.props.width / 10}}>{winnerText}</Text>
            <Text style={{fontSize: this.props.width / 9, color: '#F4F0E6'}}>{this.props.score} Pontos</Text>
            <View style={{marginTop: 20,flexDirection: 'row',justifyContent: 'center', alignItems: 'center'}}>
                <TouchableHighlight onPress={function(){this.props.restart();}.bind(this)}
                                    style={{marginRight: 4,width: this.props.width / 2.5}}>

                    <View style={{backgroundColor: '#444849',justifyContent: 'center',
                alignItems: 'center' }}>
                        <Text style={{fontSize: this.props.width / 15,color: '#F4F0E6',  padding: 10, fontWeight: "bold"}}>Novo Jogo</Text>
                    </View>


                </TouchableHighlight>
                <TouchableHighlight onPress={function(){Actions.menu()}}
                                    style={{marginLeft: 4,width: this.props.width / 2.5}}>

                    <View style={{backgroundColor: '#444849',justifyContent: 'center',
                alignItems: 'center' }}>
                        <Text style={{fontSize: this.props.width / 15,color: '#F4F0E6', padding: 10 , fontWeight: "bold"}}>Voltar</Text>
                    </View>


                </TouchableHighlight>


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
    },
    orangeRootContainer: {
        backgroundColor: '#DC7F4A'
    }
}