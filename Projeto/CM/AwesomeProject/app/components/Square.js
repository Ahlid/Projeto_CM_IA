import React, { Component } from 'react';
import { StyleSheet, View } from 'react-native';

import Svg,{
    Circle,
    Ellipse,
    G,
    LinearGradient,
    RadialGradient,
    Line,
    Path,
    Polygon,
    Polyline,
    Rect,
    Symbol,
    Text,
    Use,
    Defs,
    Stop
} from 'react-native-svg';


export default class Square extends Component {

    constructor(props){
        super(props);

        let square = this.props.square;
        this.state = {
            isClosed: square.isClosed,
            owner: square.owner
        }

        this.onChange = function(){
            let square = this.props.square;
            this.state.isClosed = square.isClosed;
            this.state.owner =  square.owner;
            this.setState(this.state);
        }.bind(this);
    }

    componentWillMount() {
        this.props.square.changeListeners.push(this.onChange);
    }

    componentWillUnmount() {
        //this.props.square.changeListeners.remove(this.onChange);
    }

    static get defaultProps() {
        return {
            top: 0,
            left: 0,
            width: 0,
            height: 0,
            square: {}
        };
    }

    render() {
        console.log("Render Square " + "[" + this.props.indexRow + "," + this.props.indexColumn + "]");
        let style =  {
            top: this.props.centerY - this.props.height / 2,
            left: this.props.centerX - this.props.width / 2,
            width: this.props.width,
            height: this.props.height,
        };

        let styleState = this.state.isClosed ? (this.state.owner == 'player1' ? styles.closedSquarePlayer1 : styles.closedSquarePlayer2): styles.openedSquare;
        let textStyleState = this.state.isClosed ? styles.textClosedSquare : styles.textOpenedSquare;
        return (
            <Svg
                height="100"
                width="100"
            >
                <Circle
                    cx="50"
                    cy="50"
                    r="45"
                    stroke="blue"
                    strokeWidth="2.5"
                    fill="green"
                />
                <Rect
                    x="15"
                    y="15"
                    width="70"
                    height="70"
                    stroke="red"
                    strokeWidth="2"
                    fill="yellow"
                />
            </Svg>
        );
        /*
        return (
                <View style={[styles.squareBase, style, styleState]}>
                    <Text style={textStyleState}>{"[" + this.props.indexRow + "," + this.props.indexColumn + "]"}</Text>
                </View>
        );*/
    }

}


const styles = StyleSheet.create({

    squareBase: {
        position: 'absolute',
        top: 0,
        left: 0,
        width: 0,
        height: 0,
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'transparent',
    },

    closedSquarePlayer1: {
        backgroundColor: '#EA4335'
    },

    closedSquarePlayer2: {
        backgroundColor: '#98C878'
    },

    openedSquare: {
        backgroundColor: 'transparent'
    },

    textClosedSquare: {
        color: '#ffffff'
    },

    textOpenedSquare: {
        color: '#000000'
    }
});