//https://facebook.github.io/react-native/docs/getting-started.html
import React, {Component} from 'react';
import Board from './components/Board.js';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View
} from 'react-native';

export default class AwesomeProject extends Component {
    render() {
        return (
                <Board squaresHorizontal={4} squaresVertical={4}/>
        );
    }

}


AppRegistry.registerComponent('AwesomeProject', () => AwesomeProject);
