import React, { Component } from 'react';

import {
    AppRegistry,
    Text,
    View,
    Image
} from 'react-native';

export default class Banana extends Component {
    render() {
        let pic = {
            uri: 'https://upload.wikimedia.org/wikipedia/commons/d/de/Bananavarieties.jpg'
        };
        let size = {
            width: this.props.width,
            height: this.props.height
        };
        return (
            <View>
                <Text>Hello {this.props.name}!</Text>
                <Image source={pic} style={size}/>
            </View>
        );
    }
}
