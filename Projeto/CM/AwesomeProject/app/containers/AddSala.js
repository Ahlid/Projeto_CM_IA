/**
 * Created by pcts on 1/11/2017.
 */
import React, {Component} from 'react';
import {Modal, Text, TouchableHighlight, View, TextInput, Button, StyleSheet, Image, Slider} from 'react-native';

class AddSala extends Component {
    constructor(props) {
        super(props);

        this.state = {
            hSquares: 5,
            vSquares: 5,
            error: null
        }
    }

    onCriar() {
        if (!isNaN(this.state.hSquares*1) && this.state.hSquares > 0 && this.state.hSquares < 8
            &&
            !isNaN(this.state.vSquares*1) && this.state.vSquares > 0 && this.state.vSquares < 8) {
            this.props.onCriar(this.state);
        } else {

            this.setState({error: "As dimensões deverão ser um número de 1 a 7"});
        }

    }

    onCancelar() {
        this.props.onCancelar();
    }

    render() {


        return (
            <View style={{
                alignItems: 'center',
                justifyContent: 'center', flex: 1,
                flexDirection: 'column',
                backgroundColor : 'rgba(0, 0, 0, 0.2);'

            }}>


                <View style={{height: 300, backgroundColor: "white", padding:50, shadowColor: "#000000", borderRadius:10,
                    shadowOpacity: 0.8,
                    shadowRadius: 2,
                    shadowOffset: {
                        height: 4,
                        width: -4,
                    }}}>
                    <Text style={{fontSize:30, fontWeight: "bold",textAlign:'center'}}>Criar Nova Sala</Text>
                    <Text style={{fontSize:20, fontWeight: "bold"}}>Escolha as dimensões do tabuleiro</Text>
                    <View style={styles.content}>
                        <Image
                            style={{height: 10, width: 30, marginRight: 10}}
                            source={require('../images/move_horizontal.png')}
                        />
                        <Text>{this.state.hSquares}</Text>


                        <Slider style={{width: 200}} value={this.state.hSquares}
                                onValueChange={(value) => this.setState({hSquares: value})} step={1} minimumValue={1}
                                maximumValue={7}/>

                    </View>

                    <View style={styles.content}>
                        <Image
                            style={{height: 30, width: 10, marginRight: 20, marginLeft: 10}}
                            source={require('../images/move_vertical.png')}
                        />
                        <Text>{this.state.vSquares}</Text>


                        <Slider style={{width: 200,}} value={this.state.vSquares}
                                onValueChange={(value) => this.setState({vSquares: value})} step={1} minimumValue={1}
                                maximumValue={7}/>

                    </View>

                    <View style={styles.content2}>
                        <Button style={{marginTop:20}} title="Criar" onPress={this.onCriar.bind(this)}></Button>
                        <Button style={{marginTop:20}}  title="Cancelar" onPress={this.onCancelar.bind(this)}></Button>
                        {(this.state.error) ? <Text>{this.state.error}</Text> : null}
                    </View>

                </View>

            </View>
        );
    }
}

export default AddSala;


var styles = StyleSheet.create({
    content: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center'
    },
    content2: {
        flex: 2,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center'
    },
});