/**
 * Created by pcts on 1/11/2017.
 */
import React, { Component } from 'react';
import { Modal, Text, TouchableHighlight, View, TextInput, Button } from 'react-native';
import {connect} from 'react-redux';
import Board from '../components/Board';
import BoardModel from '../models/BoardModel';
import { ActionCreators } from '../actions'
import { bindActionCreators } from 'redux'


class Jogo extends React.Component{

    constructor(props){
        super(props);

        this.state = {
            serverConfirmationToStart: false,
            winner: false,
            loser: false,
            board: null
        }
    }

    componentDidMount(){
        this.props.socket.emit('gameReady');
        this.props.socket.on('userLeave',this._winner.bind(this));
        this.props.socket.on('start',this._startGame.bind(this));
        this.props.socket.on('receiveMove', this._receiveMove.bind(this));
    }

    componentWillUnmount(){
        this.props.socket.removeAllListeners('userLeave');
        this.props.socket.removeAllListeners('start');
        this.props.socket.removeAllListeners('receiveMove');
    }

    componentWillUpdate(){
        return true;
    }

    _winner(){
        this.setState({
            winner: true
        });
    }

    _loser(){
        this.setState({
            loser: true
        });
    }

    _startGame(data){
        let info = data.gameInfo;
        this.props.startGame(info);
        this.state.board = new BoardModel(info.hSquares, info.vSquares);
        this.state.board.setEdgesOnClick(function(edge){

            if(edge.isClosed)
                return;

            this.state.board.disableEdges();

            this.props.socket.on('ackMove', function (data){
                edge.setClosed();

            });

            this.props.socket.emit('makeMove',{
                gameID: data.gameInfo.id,
                edge: edge.orientation == 'horizontal' ? 0 : 1,
                row: edge.row,
                column: edge.column,
            })


        }.bind(this));
        this.state.serverConfirmationToStart = true;
        this.setState(this.state);
    }

    _receiveMove(move){
        this.state.board.horizontalEdges[move.row][move.column].setClosed();
        this.props.socket.emit('ackReceiveMove', {
            ack: {
                gameID: move.gameID
            }
        });

        this.state.board.enableEdges();
    }

    render(){

        if (this.state.winner){
            return <Winner/>
        }

        if (this.state.loser){
            return <Loser/>
        }

        if (!this.state.serverConfirmationToStart || !this.props.hSquares ){
            return <Waiting/>
        }

        return <Board board={this.state.board} squaresHorizontal={this.props.hSquares} squaresVertical={this.props.vSquares} />;
    }

}


class Winner extends React.Component {

    render(){
      return  <View>
            <Text>Winner!</Text>
        </View>
    }
}

class Loser extends React.Component {

    render(){
       return <View>
            <Text>Loser!</Text>
        </View>
    }

}

class Waiting extends React.Component {

    render(){
      return  <View>
            <Text>Starting game...</Text>
        </View>
    }

}

function mapDispatchToPros(dispatch) {
    return bindActionCreators(ActionCreators, dispatch);
}

export default connect((store)=> {return {
        hSquares: store.game.hSquares,
        vSquares: store.game.vSquares,
        socket: store.socket,
        username: store.username,
        player1: store.game.player1,
        player2: store.game.player2,
        turn: store.game.turn
}}, mapDispatchToPros)(Jogo);