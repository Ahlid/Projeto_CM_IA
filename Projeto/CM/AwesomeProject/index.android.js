import React, {Component} from 'react';
import {AppRegistry, View, Text} from 'react-native';
import './UserAgent';
import io from 'socket.io-client/dist/socket.io' ;
import {Provider} from 'react-redux';
import {createStore, applyMiddleware, combineReducers, compose} from 'redux';
import thunkMiddleware from 'redux-thunk';
import createLogger from 'redux-logger';
import reducer from './app/reducers/Reducers'
import AppContainer from './app/containers/AppContainer';

const loggerMiddleware = createLogger({predicate: (getState, action) => __DEV__});

function configureStore(initialState) {
    const enchancer = compose(
        applyMiddleware(
            thunkMiddleware,
            loggerMiddleware
        )
    );

    return createStore(reducer, initialState, enchancer);
}

const socket = io('http://cm-server-ahlid1.c9users.io:8081', {jsonp: false});

const store = configureStore({
    username: "",
    rooms: [],
    game: {},
<<<<<<< HEAD

    socket: socket
=======
    socket: socket,
    manel : ["teste1","teste2"]
>>>>>>> 13377cba15a55cef0d7070efd4cb8b0b2f530143
});


const App = () => (
    <Provider store={store}>
        <AppContainer/>
    </Provider>

)

AppRegistry.registerComponent('AwesomeProject', () => App);
