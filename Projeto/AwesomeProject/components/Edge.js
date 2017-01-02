import React, { Component } from 'react';
import { StyleSheet, View, Text, TouchableHighlight, ToastAndroid } from 'react-native';

export default class Edge extends Component {

    constructor(props){
        super(props);

        this.state = {
            isClosed: this.props.edge.isClosed,
            orientation: this.props.edge.orientation
        };

    }

    onChange(){
        let edge = this.props.edge;
        this.state.isClosed = edge.isClosed;
        this.setState(this.state);
    }

    componentWillMount() {
        this.props.edge.changeListeners.push(this.onChange.bind(this));
    }

    componentWillUnmount() {
        this.props.edge.changeListeners.remove(this.onChange.bind(this));
    }

    static get defaultProps() {
        return {
            top: 0,
            left: 0,
            size: 0,
            orientation: 'vertical'
        };
    }

    render() {
        console.log("Render Edge");

        let stateStyle = {
            top: this.props.centerY - Edge.EDGE_WIDTH/2,
            left: this.props.centerX - Edge.EDGE_WIDTH/2,
            width: this.state.orientation == 'horizontal' ? this.props.size : Edge.EDGE_WIDTH,
            height: this.state.orientation == 'horizontal' ? Edge.EDGE_WIDTH : this.props.size,
            backgroundColor: this.state.isClosed ? '#a82f26' : '#00000022'
        }

        return (
            <TouchableHighlight style={[styles.edgeBase, stateStyle]} onPress={this.props.onClick}>
                <View/>
            </TouchableHighlight>
        );
    }

}
Edge.EDGE_WIDTH = 18;


const styles = StyleSheet.create({
    edgeBase: {
        position: 'absolute',
        top: 0,
        left: 0,
        width: 0,
        height: 0,
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#a82f26',
    }
});