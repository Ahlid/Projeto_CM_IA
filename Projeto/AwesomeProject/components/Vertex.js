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
            top: this.props.centerY - Vertex.VERTEX_WIDTH/2,
            left: this.props.centerX - Vertex.VERTEX_WIDTH/2,
        };

        return (
            <View style={[styles.vertexBase, style]} />
        );
    }

}
Vertex.VERTEX_WIDTH = 24;

const styles = StyleSheet.create({

    vertexBase: {
        position: 'absolute',
        top: 0,
        left: 0,
        width: Vertex.VERTEX_WIDTH,
        height: Vertex.VERTEX_WIDTH,
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#4285F4',
    },

});