/**
 * Created by pcts on 1/18/2017.
 */
import React, { Component } from 'react';
import { Modal, Text, TouchableHighlight, View, TextInput, Button } from 'react-native';
import {connect} from 'react-redux';
import Board from '../components/Board';
import BoardModel from '../models/BoardModel';
import { ActionCreators } from '../actions'
import { bindActionCreators } from 'redux'

class SinglePlayer extends React.Component{

    constructor(props){
        super(props);

        this.state = {
            winner: false,
            loser: false,
            board: null,
            hSquares: 5,
            vSquares: 5,
            player1: "player1",
            player2: "player2",
            turn: "Player1"
        }
    }


    componentWillMount(){
        this._startGame()
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

    _startGame(){


        this.state.board = new BoardModel(this.state.hSquares, this.state.vSquares);
        this.state.board.setEdgesOnClick(function(edge){

            if(edge.isClosed)
                return;

            var score = this.state.board.getScore(this.state.turn);

                edge.setClosed(this.state.turn);

            if (score == this.state.board.getScore(this.state.turn)){
                this.state.turn = this.state.turn == this.state.player1 ? this.state.player2 : this.state.player1;
                console.log(this.state.turn);
            }


            if (this.state.board.isFilled()){
                this.setState({winner:true});
            }

        }.bind(this));



        this.setState(this.state);
    }

    //On receive a move made from an opponent


    render(){

        if (this.state.winner){
            return <Winner/>
        }

        if (this.state.loser){
            return <Loser/>
        }


        return <Board board={this.state.board} squaresHorizontal={this.state.hSquares} squaresVertical={this.state.vSquares} />;
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



export default SinglePlayer;