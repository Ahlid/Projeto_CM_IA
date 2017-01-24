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
import WinnerScreenPlayer1 from './WinnerScreenPlayer1';
import WinnerScreenPlayer2 from './WinnerScreenPlayer2';

export default class SinglePlayer extends React.Component{

    constructor(props){
        super(props);

        this.state = {
            width: 0,
            height: 0,
            hasWinner: false,
            winner: null,
            board: null,
            hSquares: 5,
            vSquares: 5,
            player1: "player1",
            player2: "player2",
            turn: "player1"
        }
    }

    componentWillMount(){
        this.startGame()
    }

    componentWillUpdate(){
        return true;
    }

    startGame(){

        this.state.board = new BoardModel(this.state.hSquares, this.state.vSquares);
        this.state.board.setEdgesOnClick(function(edge){

            if(edge.isClosed)
                return;

            let closedSquares = edge.setClosed(this.state.turn);

            if (closedSquares == 0){
                this.state.turn = this.state.turn == this.state.player1 ? this.state.player2 : this.state.player1;
            }

            if (this.state.board.isFilled()){
                this.state.winner = this.state.board.getCurrentWinner();
                this.state.hasWinner = true;
                this.setState(this.state);
            }

        }.bind(this));

        this.setState(this.state);
    }

    render(){

        if(this.state.hasWinner){

            switch(this.state.winner){
                case "player1":
                    return <WinnerScreenPlayer1/>
                case "player2":
                    return <WinnerScreenPlayer2/>
            }

        }

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
                borderRight: 1,
            }

            styleScore1 = {
                width: this.state.width,
                height: (this.state.height - this.state.width - 40) / 2,
            }

            styleScore2 = {
                width: this.state.width,
                height: (this.state.height - this.state.width - 40) / 2,
            }


        }





        return (
            <View onLayout={onLayout} style={[styleBoardBaseContainer]}>
                <View style={[styleScoreContainer]}>
                    <Score style={styleScore1} player="Azuis" score="0" color="#3F9BBE"/>
                    <Score style={styleScore2} player="Laranjas" score="0" color="#DC7F4A"/>
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
