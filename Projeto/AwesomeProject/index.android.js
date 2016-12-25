//https://facebook.github.io/react-native/docs/getting-started.html

/*

 Correr emulador
 - C:\Android\sdk\tools\emulator.exe -netdelay none -netspeed full -avd S3

 Iniciar o react native packager:
 - cd "C:\Users\Ricardo Morais\Documents\Projeto_CM_IA\Projeto\AwesomeProject"
 - react-native start

 Iniciar o react native no android:
 - cd "C:\Users\Ricardo Morais\Documents\Projeto_CM_IA\Projeto\AwesomeProject"
 - react-native run-android

 Atalhos:
 -Refresh -> carregar duas vezes no R


 */
import React, {Component} from 'react';
import Blink from './components/Blink.js';
import Banana from './components/Banana.js';
import FlexDirectionBasics from './components/FlexDirectionBasics.js';
import PizzaTranslator from './components/PizzaTranslator.js';
import JustifyContentBasics from './components/JustifyContentBasics.js'
import {
    AppRegistry,
    StyleSheet,
    Text,
    View
} from 'react-native';

export default class AwesomeProject extends Component {
    render() {
        return (
                <PizzaTranslator/>
        );
    }
}
/*
 <FlexDirectionBasics/>
 <View style={styles.container}>
 <Blink text='I love to blink'/>
 <Banana name="Banana" width={100} height={110}/>
 <Text style={styles.welcome}>
 Welcome to React Native!
 </Text>
 <Text style={styles.instructions}>
 To get started, edit index.android.js
 </Text>
 <Text style={styles.instructions}>
 Double tap R on your keyboard to reload,{'\n'}
 Shake or press menu button for dev menu
 </Text>
 </View>
 */



const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
});

AppRegistry.registerComponent('AwesomeProject', () => AwesomeProject);
