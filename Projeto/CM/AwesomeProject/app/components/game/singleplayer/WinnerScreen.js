import React, { Component } from 'react';
import {Text, View, Button } from 'react-native';


export default class WinnerScreen extends React.Component {




    render(){

        let rootContainerStyle = this.props.playerIndex == 1 ? styles.blueRootContainer : styles.orangeRootContainer;
        let winnerText = this.props.playerIndex == 1 ? "Azuis venceram" : "Laranjas venceram";


        return  <View style={[{width: this.props.width, height: this.props.height}, styles.baseRootContainer, rootContainerStyle]}>
            <Text style={{fontSize: 30}}>{winnerText}</Text>
            <Text style={{fontSize: 40, color: '#F4F0E6'}}>{this.props.score} Pontos</Text>
            <View style={{marginTop: 20,flexDirection: 'row',justifyContent: 'center', alignItems: 'center'}}>
                <View style={{marginRight: 4,width: 100}}>
                    <Button
                        onPress={function(){}}
                        style={{width: 100}}
                        title="Novo Jogo"
                        color='#444849'
                        />
                </View>
                <View style={{marginLeft: 4,width: 100}}>
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
    },
    orangeRootContainer: {
        backgroundColor: '#DC7F4A'
    }
}