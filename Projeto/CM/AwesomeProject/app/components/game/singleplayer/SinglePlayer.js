import React, { Component } from 'react';
import {
    Modal,
    Text,
    TouchableHighlight,
    View,
    TextInput,
    Button
} from 'react-native';

import Board from '../../board/Board';
import BoardModel from '../../../models/BoardModel';
import Score from './Score';
import WinnerScreen from './WinnerScreen';
import ChoseDimensions from './ChoseDimensions';

export default class SinglePlayer extends React.Component{

    constructor(props){
        super(props);

        this.state = {
            width: 0,
            height: 0,
            hasWinner: false,
            winner: null,
            board: null,
            hSquares: 0,
            vSquares: 0,
            player1: "player1",
            scorePlayer1: 0,
            player2: "player2",
            scorePlayer2: 0,
            turn: "player1"
        }
    }






    restart(){

        this.setState({
            player1: "player1",
            scorePlayer1: 0,
            player2: "player2",
            scorePlayer2: 0,
            turn: "player1",
            hasWinner: false,
            winner: null,
            hSquares: 0,
            vSquares: 0,

        });
    }


    startGame(stateReceiver){


        console.log(stateReceiver);
        this.state.board = new BoardModel(stateReceiver.hSquares, stateReceiver.vSquares);
        this.state.board.setEdgesOnClick(function(edge){

            if(edge.isClosed)
                return;

            let closedSquares = edge.setClosed(this.state.turn);

            let newState = Object.assign({}, this.state);


            if (closedSquares == 0){
                newState.turn = newState.turn == newState.player1 ?
                                        newState.player2 : newState.player1;
            } else {

                switch(newState.turn){
                    case newState.scorePlayer1:
                        newState.scorePlayer1 += closedSquares;
                        break;
                    case newState.scorePlayer2:
                        newState.scorePlayer2 += closedSquares;
                        break;
                }

            }

            if (newState.board.isFilled()){
                newState.winner = newState.board.getCurrentWinner(newState.player1, newState.player2);
                newState.hasWinner = true;
            }

            this.setState(newState);

        }.bind(this));

        this.setState({vSquares:stateReceiver.vSquares, hSquares:stateReceiver.hSquares});
    }

    render(){




        let onLayout = (event) => {

            let width = event.nativeEvent.layout.width;
            let height = event.nativeEvent.layout.height;

            if(this.state.width == width &&
                this.state.height == height) {
                return;
            }

            this.state.width = width;
            this.state.height = height;
            this.setState(this.state);
        };

        let isPortrait = true;
        if(this.state.width > this.state.height)
            isPortrait = false;

        let styleBoardBaseContainer = {};
        let styleBoardContainer = {};
        let styleScoreContainer = {};
        let styleScore1 = {};
        let styleScore2 = {};

        if(isPortrait){

            styleBoardBaseContainer = styles.basePortrait;

            let min = Math.min(this.state.width, this.state.height) - 40;
            styleBoardContainer = {
                width: min + 40,
                height: min + 40,
                paddingTop: 20,
                paddingBottom: 20,
                paddingLeft : 20,
                paddingRight : 20,
            }

            let scoreContainerHeight = this.state.height - this.state.width;

            styleScoreContainer = {
                height: scoreContainerHeight,
                flex: 1,
                flexDirection: 'row',
                backgroundColor: 'black',
            }

            styleScore1 = {
                width: this.state.width / 2,
                height: scoreContainerHeight,
            }

            styleScore2 = {
                width: this.state.width / 2,
                height: scoreContainerHeight,
            }


        } else {

            styleBoardBaseContainer = styles.baseLandscape;

            let min = Math.min(this.state.width, this.state.height) - 40;
            styleBoardContainer = {
                width: min + 40,
                height: min + 40,
                paddingTop: 20,
                paddingBottom: 20,
                paddingLeft : 20,
                paddingRight : 20,
            }


            let scoreContainerWidth = this.state.width - this.state.height;

            styleScoreContainer = {
                width: scoreContainerWidth,
                flex: 1,
                flexDirection: 'column',
                backgroundColor: 'black',
            }

            styleScore1 = {
                width: scoreContainerWidth,
                height: this.state.height / 2,
            }

            styleScore2 = {
                width: scoreContainerWidth,
                height: this.state.height / 2,
            }
        }


        if(this.state.hasWinner){

            switch(this.state.winner){
                case "player1":
                    return  <View onLayout={onLayout} style={[styleBoardBaseContainer]}>
                                <WinnerScreen playerIndex={1}
                                                     score={this.state.board.getScore(this.state.winner)}
                                                     width={this.state.width}
                                                     height={this.state.height}
                                                     restart = {this.restart.bind(this)}
                                />
                            </View>
                case "player2":
                    return  <View onLayout={onLayout} style={[styleBoardBaseContainer]}>
                        <WinnerScreen playerIndex={2}
                                             score={this.state.board.getScore(this.state.winner)}
                                             width={this.state.width}
                                             height={this.state.height}
                                             restart = {this.restart.bind(this)}
                        />
                    </View>
                default:
                    return <DrawScreen/>

            }

        }



        if (this.state.vSquares == 0 || this.state.hSquares == 0){
            return <ChoseDimensions onGo= { this.startGame.bind(this)} />
        }
        console.log(this.state)

        return (
            <View onLayout={onLayout} style={[styleBoardBaseContainer]}>
                <View style={[styleScoreContainer]}>
                    <Score style={styleScore1} player="Azuis" score={this.state.board.getScore(this.state.player1)} color="#3F9BBE"/>
                    <Score style={styleScore2} player="Laranjas" score={this.state.board.getScore(this.state.player2)}  color="#DC7F4A"/>
                </View>
                <View style={[styleBoardContainer]}>
                    <Board board={this.state.board} squaresHorizontal={this.state.hSquares} squaresVertical={this.state.vSquares} />
                </View>
            </View>
        );
    }

}

const styles = {
    basePortrait: {
        flex: 1,
        flexDirection: 'column',
        backgroundColor: '#F4F0E6',
    },
    baseLandscape: {
        flex: 1,
        flexDirection: 'row',
        backgroundColor: '#F4F0E6',
    }
};
