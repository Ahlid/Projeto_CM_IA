/**
 * Created by pcts on 1/11/2017.
 */
import React, {Component} from 'react';
import {View, Text, Button, TextInput, Alert, StyleSheet, Image, Dimensions, TouchableHighlight} from 'react-native';
import {connect} from 'react-redux';
import {Actions} from 'react-native-router-flux';
import {BoxShadow} from 'react-native-shadow';

class Menu extends React.Component {

    constructor(props) {
        super(props);


    }

    newStyles(){
        styles.bottomMenu ={
            marginTop: (Dimensions.get('window').height / 15),
                flex: 1,
                width: Dimensions.get('window').width
        };

        styles.buttonMenu = {
            marginTop: (Dimensions.get('window').height / 40),
                marginLeft: (Dimensions.get('window').width / 7),
                marginRight: (Dimensions.get('window').width / 7),
                borderColor : 'black',
                borderWidth : 0,
                elevation: 1,

        };

        styles.buttonInside1 = {
            paddingTop: (Dimensions.get('window').height / 40),
                paddingBottom: (Dimensions.get('window').height / 40),
                justifyContent: 'center',
                alignItems: 'center',
                backgroundColor : '#F2AA77'

        };
        styles.buttonInside2 = {
            paddingTop: (Dimensions.get('window').height / 40),
                paddingBottom: (Dimensions.get('window').height / 40),
                justifyContent: 'center',
                alignItems: 'center',
                backgroundColor : '#3D96B8'

        };
    }




    render() {
        console.log('render');
        const {height, width} = Dimensions.get('window');
        const orientation = (width > height) ? 'LANDSCAPE' : 'PORTRAIT';
        this.newStyles()
        const styleImagem = (orientation == 'PORTRAIT') ?{ width: width/2, height : width/2} : { width: height/2.5, height : height/2.5} ;

//eu nao fiz assim atença isto é um teste, como está está feito tipo merda experimenta sff


        return (
            <View onLayout={function () {
                this.setState({});
            }.bind(this)} style={styles.menuContainer}>

                <View style={styles.topMenu}>

                    <Image style={styleImagem}
                        source={require('../lib/logo.png')}
                    />

                </View>


                <View style={styles.bottomMenu}>

                        <View style={styles.buttonMenu}>
                            <TouchableHighlight
                                underlayColor="transparent"
                                onPress={() => {
                                    Actions.singlePlayer()
                                }}
                            >
                                <View style={styles.buttonInside1}>

                                    <Text style={{fontSize: 25, fontWeight: "bold"}}>Play Offline</Text>
                                </View>


                            </TouchableHighlight>
                        </View>

                        <View style={styles.buttonMenu}>
                            <TouchableHighlight
                                underlayColor="transparent"
                                onPress={() => {
                                    Actions.login()
                                }}
                            >
                                <View style={styles.buttonInside2}>

                                    <Text style={{fontSize: 25, fontWeight: "bold"}}>Play Online</Text>
                                </View>


                            </TouchableHighlight>
                        </View>



                </View>


            </View>
        )
    }
}

export default Menu;


const styles = StyleSheet.create({

    menuContainer: {
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F4F0E6'
    },

    topMenu: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },




});


/*
 *
 *
 *
 * */
