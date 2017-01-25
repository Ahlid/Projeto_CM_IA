import React, { Component } from 'react';
import Edge from './Edge'
import { StyleSheet, View, Text } from 'react-native';

export default class Vertex extends Component {

    static get defaultProps() {
        return {
            top: 0,
            left: 0,
        };
    }

    render() {
        let style =  {
            top: this.props.centerY - this.props.size/2,
            left: this.props.centerX - this.props.size/2,
            width: this.props.size,
            height: this.props.size,
            borderRadius: this.props.size,
        };

        return (
            <View style={[styles.vertexBase, style]} />
        );
    }

}


const styles = StyleSheet.create({

    vertexBase: {
        position: 'absolute',
        top: 0,
        left: 0,
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 20,
        backgroundColor: '#444849',
    },

});