/**
 * Created by pcts on 1/24/2017.
 */

import React, {Component} from 'react';
import {Modal, Text, TouchableHighlight, View, TextInput, Button, StyleSheet, Image, Slider, Dimensions} from 'react-native';


export default class ChoseDimensions extends React.Component {

    constructor(props){
        super(props);
        this.state = {
            hSquares :5,
            vSquares : 5
        }

    }


    onGo() {
        if (!isNaN(this.state.hSquares*1) && this.state.hSquares > 0 && this.state.hSquares < 6
            &&
            !isNaN(this.state.vSquares*1) && this.state.vSquares > 0 && this.state.vSquares < 6) {
            this.props.onGo(this.state);
        } else {

            this.setState({error: "As dimensões deverão ser um número de 1 a 7"});
        }

    }


    render() {

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



        console.log(height);
        console.log(width);
        return (
            <View style={{
                alignItems: 'center',
                justifyContent: 'center', flex: 1,
                flexDirection: 'column',
                backgroundColor : '#F4F0E6'

            }}
                  onLayout={function () {
                      this.setState({});
                  }.bind(this)}
            >


                <View style={{height: (height>width) ? height/2 : width/1.9}}>

                    <Text style={{textAlign: 'center',fontSize: (height>width) ? height/35 : width/25, fontWeight: "bold"}}>Escolha as dimensões do tabuleiro</Text>
                    <View style={styles.content}>
                        <Image
                            style={{height: width/39, width: width/13, marginRight: width/76.8}}
                            source={require('../../../images/move_horizontal.png')}
                        />
                        <Text style={{fontSize: height/25, fontWeight: "bold"}} >{this.state.hSquares}</Text>


                        <Slider style={{width: width/3.84}} value={this.state.hSquares}
                                onValueChange={(value) => this.setState({hSquares: value})} step={1} minimumValue={1}
                                maximumValue={5}/>

                    </View>

                    <View style={styles.content}>
                        <Image
                            style={{height: height/16.26, width: width/48.78 , marginRight: width/30, marginLeft:width/38.4}}
                            source={require('../../../images/move_vertical.png')}
                        />
                        <Text style={{fontSize: height/25, fontWeight: "bold"} }>{this.state.vSquares}</Text>


                        <Slider style={{width: width/3.84}} value={this.state.vSquares}
                                onValueChange={(value) => this.setState({vSquares: value})} step={1} minimumValue={1}
                                maximumValue={5}/>

                    </View>

                    <View style={styles.content2}>



                        <TouchableHighlight
                            underlayColor="transparent"
                            onPress={this.onGo.bind(this)}
                        >
                            <View style={styles.buttonInside1}>

                                <Text style={{fontSize: height/25, fontWeight: "bold"}}>Start</Text>
                            </View>


                        </TouchableHighlight>

                    </View>

                </View>

            </View>
        );
    }

}



var styles = StyleSheet.create({
    content: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        marginTop:20
    },
    content2: {
        flex: 2,
        alignItems: 'center',
        justifyContent: 'center'
    },
});