/**
 * Created by pcts on 1/11/2017.
 */
import React, {Component} from 'react';
import {View, Text, Button, TextInput, Alert} from 'react-native';
import {connect} from 'react-redux';
import {ActionCreators} from '../actions'
import {bindActionCreators} from 'redux'
import {Router, Scene} from 'react-native-router-flux';
import Login from "./Login";
import Menu from "./Menu";
import Salas from "./Salas";
import SalaDeEspera from "./SalaDeEspera";
import Jogo from "../components/game/multiplayer/MultiplayerGame";
import SinglePlayer from "../components/game/singleplayer/SinglePlayer";


class AppContainer extends React.Component {

    render() {
        return (
            <Router hideNavBar={true}>
                <Scene key="root">
                    <Scene
                        key="login"
                        component={Login}
                    />

                    <Scene
                        key="menu"
                        title="menu"
                        component={Menu}
                        type="BackAction"
                        initial={true}
                    />

                    <Scene
                        key="salas"
                        title="salas"
                        component={Salas}
                        type="replace"
                    />

                    <Scene
                        key="salaespera"
                        title="salaespera"
                        component={SalaDeEspera}
                    />

                    <Scene
                        key="jogo"
                        title="jogo"
                        component={Jogo}
                    />

                    <Scene
                        key="singlePlayer"
                        title="singlePlayer"
                        component={SinglePlayer}
                    />

                </Scene>
            </Router>
        )
    }
}

function mapDispatchToPros(dispatch) {
    return bindActionCreators(ActionCreators, dispatch);
}

export default  connect(() => {
    return {}
}, mapDispatchToPros)(AppContainer);