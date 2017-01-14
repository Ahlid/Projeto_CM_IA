import React, { Component } from 'react';
import SquareModel from '../models/SquareModel'
import EdgeModel from '../models/EdgeModel'
import Square from './Square'
import Edge from './Edge'
import Vertex from './Vertex'
import {Text, View} from 'react-native';

//TODO Fix the squares positions

/**
 * Represents the game board for the dots and boxes game
 */
export default class Board extends Component {

    constructor(props) {
        super(props);

        //Linear Arrays of squares and edges
        let squares = [];
        let edges = [];
        let horizontalEdges = [];
        let verticalEdges = [];


        //Simplified name variables for number of vertical and horizontal squares
        let h = this.props.squaresHorizontal;
        let v = this.props.squaresVertical;

        //Loop v * h times to create a matrix of squares and each respective edges
        for(let i=0; i < v; i++){

            //Create the square row
            squares[i] = [];

            if(i == 0){
                horizontalEdges[i] = [];
            }
            horizontalEdges[i+1] = [];

            verticalEdges[i] = [];

            //Loop h times to create an array of squares and each respective edges
            for(let j=0; j < h; j++){

                let topEdge;
                //If the top Edge is shared than the edge was already created
                if(i > 0) {
                    topEdge = squares[i-1][j].bottomEdge;

                } else {
                    topEdge = new EdgeModel(false, 'horizontal');
                    horizontalEdges[i][j] = topEdge;
                }

                let leftEdge;
                //If the left Edge is shared than the edge was already created
                if(j > 0) {
                    leftEdge = squares[i][j-1].rightEdge;
                } else {
                    leftEdge = new EdgeModel(false, 'vertical');
                    verticalEdges[i][j] = leftEdge;
                }

                let bottomEdge = new EdgeModel(false, 'horizontal');
                let rightEdge = new EdgeModel(false, 'vertical');

                horizontalEdges[i+1][j] = topEdge;
                verticalEdges[i][j+1] = topEdge;

                let square = new SquareModel(topEdge, leftEdge, bottomEdge, rightEdge);

                //Associates the edges to the square
                //Related squares are used for performance reasons
                square.topEdge.relatedSquares.push(square);
                square.leftEdge.relatedSquares.push(square);
                square.bottomEdge.relatedSquares.push(square);
                square.rightEdge.relatedSquares.push(square);

                //Adds the edges to the array of edges
                edges.push(topEdge);
                edges.push(leftEdge);
                edges.push(bottomEdge);
                edges.push(rightEdge);

                //Adds the square to the matrix of squares
                squares[i].push(square);

            }
        }

        //Sets the state of the Board
        this.state = {
            squares: squares,
            edges: edges,
            horizontalEdges: horizontalEdges,
            verticalEdges: verticalEdges,
            width: 0,
            height: 0,
        };
    }





    /**
     * Renders the squares of the board
     * @returns {*} array of Square components
     */
    renderSquares() {

        if(this.state.width == 0 || this.state.height == 0)
            return null;

        let renderList = [];

        //Simplified name variables for number of vertical and horizontal squares
        let h = this.props.squaresHorizontal;
        let v = this.props.squaresVertical;

        let maxSize = Math.max(Vertex.VERTEX_WIDTH, Edge.EDGE_WIDTH);

        let width = (this.state.width  - maxSize) / h - Edge.EDGE_WIDTH;
        let height = (this.state.height - maxSize) / v - Edge.EDGE_WIDTH;

        let offset = Vertex.VERTEX_WIDTH/2 + (Edge.EDGE_WIDTH/2);

        let c = 0;
        for(let i=0; i < v; i++){
            for(let j=0; j < h; j++, c++){
                let square = this.state.squares[i][j];

                renderList.push(
                    <Square key={c}
                            centerX={j*width + offset  + Edge.EDGE_WIDTH*j + width/2}
                            centerY={i*height + offset + Edge.EDGE_WIDTH*i + height/2}
                            width={width}
                            height={height}
                            indexRow={i}
                            indexColumn={j}
                            square={square}
                    />
                );

            }
        }

        return renderList;
    }

    /**
     * Renders the Edges of the board
     * @returns {*} array of Edges components
     */
    renderEdges() {

        if(this.state.width == 0 || this.state.height == 0)
            return null;

        let renderList = [];

        //Simplified name variables for number of vertical and horizontal squares
        let h = this.props.squaresHorizontal;
        let v = this.props.squaresVertical;

        let maxSize = Math.max(Vertex.VERTEX_WIDTH, Edge.EDGE_WIDTH);

        let width = (this.state.width  - maxSize) / h;
        let height = (this.state.height - maxSize) / v;


        let c = 0;
        for(let i=0; i < v; i++){
            for(let j=0; j < h; j++, c+=4) {
                let square = this.state.squares[i][j];

                //Render top Edge only if it is the first top Edge
                if(i == 0){
                    renderList.push(
                        <Edge key={c + h*v * 2}
                              centerX={j*width + maxSize/2}
                              centerY={i*height + maxSize/2}
                              size={width + Edge.EDGE_WIDTH}
                              edge={square.topEdge}
                              onClick={square.topEdge.clickHandler.bind(square.topEdge)}/>
                    );
                }

                //Render left Edge only if it is the left top Edge
                if(j == 0){
                    renderList.push(
                        <Edge key={c + 1 + h*v * 2}
                              centerX={j*width + maxSize/2}
                              centerY={i*height + maxSize/2}
                              size={height}
                              edge={square.leftEdge}
                              onClick={square.leftEdge.clickHandler.bind(square.leftEdge)}/>
                    );
                }

                //Render the right Edge
                renderList.push(
                    <Edge key={c + 2 + h*v * 2}
                          centerX={j*width + maxSize/2}
                          centerY={i*height + height + maxSize/2}
                          size={width + Edge.EDGE_WIDTH}
                          edge={square.bottomEdge}
                          onClick={square.bottomEdge.clickHandler.bind(square.bottomEdge)}/>
                );

                //Render the bottom Edge
                renderList.push(
                    <Edge key={c + 3 + h*v * 2}
                          centerX={j*width + width + maxSize/2}
                          centerY={i*height + maxSize/2}
                          size={height}
                          edge={square.rightEdge}
                          onClick={square.rightEdge.clickHandler.bind(square.rightEdge)}/>
                );



            }
        }

        //Return the array of edges to render as components
        return renderList;
    }

    /**
     * Renders the Vertices of the board
     * @returns {*} array of Vertices components
     */
    renderVertices(){

        if(this.state.width == 0 || this.state.height == 0)
            return null;

        let renderList = [];

        let h = this.props.squaresHorizontal;
        let v = this.props.squaresVertical;

        let maxSize = Math.max(Vertex.VERTEX_WIDTH, Edge.EDGE_WIDTH);

        let width = (this.state.width  - maxSize) / h;
        let height = (this.state.height - maxSize) / v;

        let c = 0;
        for(let i=0; i < v; i++) {
            for (let j = 0; j < h; j++, c += 4) {

                if(i==0 && j == 0){
                    renderList.push(<Vertex key={c + h*v * 3}
                                            centerX={j*width + maxSize/2}
                                            centerY={i*height + maxSize/2}
                                            />
                    );
                }

                renderList.push(<Vertex key={c + 1 + h*v * 3}
                                        centerX={j*width + width + maxSize/2}
                                        centerY={i*height + maxSize/2}
                                        />
                );

                renderList.push(<Vertex key={c + 2 + h*v * 3}
                                        centerX={j*width + maxSize/2}
                                        centerY={i*height + height + maxSize/2}
                                        />
                );

                renderList.push(<Vertex key={c + 3 + h*v * 3}
                                        centerX={j*width + width + maxSize/2}
                                        centerY={i*height + height + maxSize/2}
                                        />
                );

            }
        }

        return renderList;

    }

    /**
     * Renders the Board
     * @returns {XML}
     */
    render() {

        //When the layout size changes
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
        }


        //Renders the board with the 3 arrays
        return (
            <View style={{flex:1,  margin : 20}} onLayout={onLayout}>
                {[this.renderSquares(),this.renderEdges(),this.renderVertices()]}
            </View>
        );
    }
};
