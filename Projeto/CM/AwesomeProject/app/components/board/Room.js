/**
 * Created by pcts on 1/11/2017.
 */
//todo: componente que representa cada sala

import React, {Component} from 'react';
import {Modal, Text, TouchableHighlight, View, TextInput, Button, Dimensions, StyleSheet} from 'react-native';


class Room extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            username: props.username,
            hSquares: props.hSquares,
            vSquares: props.vSquares,
            id: props.id
        }
    }

    _onPressButton() {
        this.props.join(this.state.id);
    }

    render() {

        var {height, width} = Dimensions.get('window');

        if (width > height) {
            var x = height;
            width = height;
            height = width;
        }

        styles.buttonInside1 = {

            justifyContent: 'center',
            alignItems: 'center',
            marginLeft: width / 35,
            marginRight: width / 35,

            paddingLeft: width / 70,
            borderLeftWidth: 10,
            borderColor: (this.props.index % 2 == 0 ) ? ('#F69B59') : ('#46AFDF'),
            backgroundColor: 'lightgray',
            marginTop: 15

        };

        return (
            <View >
                <TouchableHighlight underlayColor="transparent" style={styles.buttonInside1}
                                    onPress={this._onPressButton.bind(this)}>
                    <View style={styles.Room}>
                        <Text style={{
                            paddingTop: height / 30,
                            paddingBottom: (height / 30),
                            flex: 7,
                            textAlign: 'left',
                            fontSize: height / 25,
                            fontWeight: "bold"
                        }}>Room of {this.state.username}</Text>
                        <Text style={{
                            paddingTop: height / 30,
                            paddingRight: width / 35, paddingBottom: (height / 30), backgroundColor: '#7F7F7F'
                            , color: '#F4F0E6', flex: 1, textAlign: 'right', fontSize: height / 25, fontWeight: "bold"
                        }}>{this.state.hSquares}*{this.state.vSquares}</Text>
                    </View>
                </TouchableHighlight>
            </View>
        );
    }

}

export default Room;


const styles = StyleSheet.create({

    Room: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'row',
        justifyContent: 'space-between',
    },

});