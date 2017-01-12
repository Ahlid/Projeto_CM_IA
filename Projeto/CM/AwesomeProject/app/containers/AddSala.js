/**
 * Created by pcts on 1/11/2017.
 */
import React, { Component } from 'react';
import { Modal, Text, TouchableHighlight, View,TextInput,Button  } from 'react-native';

 class AddSala extends Component {
    constructor(props){
        super(props);

        this.state = {
            size: 5
        }
    }

    onCriar(){
        this.props.onCriar(this.state.size);
    }

    onCancelar(){
        this.props.onCancelar();
    }

    render() {


        return (
            <View style={{marginTop: 22}}>
                <Text>Criar Nova Sala</Text>
                <TextInput
                    placeholder="Insira o tamanho do tabuleiro"
                    onChangeText={(text) => this.setState({size:text})}/>
                <Button title="Criar" onPress={this.onCriar.bind(this)}></Button>
                <Button title="Cancelar" onPress={this.onCancelar.bind(this)}></Button>
            </View>
        );
    }
}

export default AddSala;