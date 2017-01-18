/**
 * Created by pcts on 1/11/2017.
 */
import React, {Component} from 'react';
import {Modal, Text, TouchableHighlight, View, TextInput, Button} from 'react-native';
import {connect} from 'react-redux';
import Board from '../components/Board';
import BoardModel from '../models/BoardModel';
import {ActionCreators} from '../actions'
import {bindActionCreators} from 'redux'


class Jogo extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            serverConfirmationToStart: false,
            winner: false,
            loser: false,
            board: null
        }
    }

    componentDidMount() {
        this.props.socket.emit('gameReady');
        this.props.socket.on('userLeave', this._winner.bind(this));
        this.props.socket.on('start', this._startGame.bind(this));
        this.props.socket.on('receiveMove', this._receiveMove.bind(this));
    }

    componentWillUnmount() {
        this.props.socket.removeAllListeners('userLeave');
        this.props.socket.removeAllListeners('start');
        this.props.socket.removeAllListeners('receiveMove');
    }

    componentWillUpdate() {
        return true;
    }

    _winner() {
        this.setState({
            winner: true
        });
    }

    _loser() {
        this.setState({
            loser: true
        });
    }

    _startGame(data) {
        let info = data.gameInfo;
        this.props.startGame(info);

        this.state.board = new BoardModel(info.hSquares, info.vSquares);
        this.state.board.setEdgesOnClick(function (edge) {

            if (edge.isClosed)
                return;

            this.state.board.disableEdges();

            //Prepares for move ack
            this.props.socket.on('ackMove', function (data) {

                var score = this.state.board.getScore('player1');

                edge.setClosed('player1');


                if (score < this.state.board.getScore('player1')) {

                    this.state.board.enableEdges();
                }
            }.bind(this));

            //Makes the move in the server
            this.props.socket.emit('makeMove', {
                gameID: data.gameInfo.id,
                edge: edge.orientation == 'horizontal' ? 0 : 1,
                row: edge.row,
                column: edge.column,
            });

        }.bind(this));
        this.state.serverConfirmationToStart = true;

        if (info.turn != this.props.username) {
            this.state.board.disableEdges();
        }

        this.setState(this.state);
    }

    //On receive a move made from an opponent
    _receiveMove(move) {

        var edges = move.edge == 0 ? this.state.board.horizontalEdges : this.state.board.verticalEdges;
        var score = this.state.board.getScore('Player2');
        edges[move.row][move.column].setClosed('Player2');
        console.log('MOVE', move);


        if (score == this.state.board.getScore('Player2')) {

            this.state.board.enableEdges();
        }

        //Send ack after receiving the move
        this.props.socket.emit('ackReceiveMove', {
            ack: {
                gameID: move.gameID
            }
        });

    }

    render() {

        if (this.state.winner) {
            return <Winner/>
        }

        if (this.state.loser) {
            return <Loser/>
        }

        if (!this.state.serverConfirmationToStart || !this.props.hSquares) {
            return <Waiting/>
        }

        return <Board board={this.state.board} squaresHorizontal={this.props.hSquares}
                      squaresVertical={this.props.vSquares}/>;
    }

}


class Winner extends React.Component {

    render() {
        return <View>
            <Text>Winner!</Text>
        </View>
    }
}

class Loser extends React.Component {

    render() {
        return <View>
            <Text>Loser!</Text>
        </View>
    }

}

class Waiting extends React.Component {

    render() {
        return <View>
            <Text>Starting game...</Text>
        </View>
    }

}

function mapDispatchToPros(dispatch) {
    return bindActionCreators(ActionCreators, dispatch);
}

export default connect((store) => {
    return {
        hSquares: store.game.hSquares,
        vSquares: store.game.vSquares,
        socket: store.socket,
        username: store.username,
        player1: store.game.player1,
        player2: store.game.player2,
        turn: store.game.turn
    }
}, mapDispatchToPros)(Jogo);