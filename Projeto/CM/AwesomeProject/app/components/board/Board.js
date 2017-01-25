import React, { Component } from 'react';
import SquareModel from '../../models/SquareModel'
import EdgeModel from '../../models/EdgeModel'
import Square from './Square'
import Edge from './Edge'
import Vertex from './Vertex'
import {Text, View} from 'react-native';



/**
 * Represents the game board for the dots and boxes game
 */
export default class Board extends Component {

    constructor(props) {
        super(props);

        //Sets the state of the Board
        this.state = {
            width: 0,
            height: 0,
        };
    }

    shouldComponentUpdate(nextProps, nextState) {

        console.log("CURRENT", this.state);
        console.log("NEXT",nextState);
        if(this.state.width == 0 || this.state.height == 0)
            return true;

        if(this.state.width == nextState.width &&
            this.state.height == nextState.height &&
            this.props.board == nextProps.board)
            return false;

        return true;
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

        let maxSquares = Math.max(h, v);
        let size = this.state.width / maxSquares - (this.state.width / maxSquares) * 0.6;

        let width = (this.state.width  - size) / h ;
        let height = (this.state.height - size) / v;

        let offset = size/2;

        let c = 0;
        for(let i=0; i < v; i++){
            for(let j=0; j < h; j++, c++){
                let square = this.props.board.squares[i][j];

                renderList.push(
                    <Square key={c}
                            centerX={j*width  + offset + width/2}
                            centerY={i*height + offset  + height/2}
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

        let maxSquares = Math.max(h, v);
        let size = this.state.width / maxSquares - (this.state.width / maxSquares) * 0.6;

        let width = (this.state.width  - size) / h;
        let height = (this.state.height - size) / v;


        let c = 0;
        for(let i=0; i < v; i++){
            for(let j=0; j < h; j++, c+=4) {
                let square = this.props.board.squares[i][j];

                //Render top Edge only if it is the first top Edge
                if(i == 0){
                    renderList.push(
                        <Edge key={c + h*v * 2}
                              centerX={j*width + size/2}
                              centerY={i*height + size/2}
                              size={width}
                              girth={size}
                              edge={square.topEdge}
                              />
                    );
                }

                //Render left Edge only if it is the left top Edge
                if(j == 0){
                    renderList.push(
                        <Edge key={c + 1 + h*v * 2}
                              centerX={j*width + size/2}
                              centerY={i*height + size/2}
                              size={height}
                              girth={size}
                              edge={square.leftEdge}
                              />
                    );
                }

                //Render the right Edge
                renderList.push(
                    <Edge key={c + 2 + h*v * 2}
                          centerX={j*width + size/2}
                          centerY={i*height + height + size/2}
                          size={width}
                          girth={size}
                          edge={square.bottomEdge}
                          />
                );

                //Render the bottom Edge
                renderList.push(
                    <Edge key={c + 3 + h*v * 2}
                          centerX={j*width + width + size/2}
                          centerY={i*height + size/2}
                          size={height}
                          girth={size}
                          edge={square.rightEdge}/>
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

        let maxSquares = Math.max(h, v);
        let size = this.state.width / maxSquares - (this.state.width / maxSquares) * 0.6;

        //let maxSize = Math.max(Vertex.VERTEX_WIDTH, Edge.EDGE_WIDTH);



        let width = (this.state.width  - size) / h;
        let height = (this.state.height - size) / v;

        let c = 0;
        for(let i=0; i < v; i++) {
            for (let j = 0; j < h; j++, c += 4) {

                if(i==0 && j == 0){
                    renderList.push(<Vertex key={c + h*v * 3}
                                            centerX={j*width + size/2}
                                            centerY={i*height + size/2}
                                            size={size}
                                            />
                    );
                }

                renderList.push(<Vertex key={c + 1 + h*v * 3}
                                        centerX={j*width + width + size/2}
                                        centerY={i*height + size/2}
                                        size={size}
                                        />
                );

                renderList.push(<Vertex key={c + 2 + h*v * 3}
                                        centerX={j*width + size/2}
                                        centerY={i*height + height + size/2}
                                        size={size}
                                        />
                );

                renderList.push(<Vertex key={c + 3 + h*v * 3}
                                        centerX={j*width + width + size/2}
                                        centerY={i*height + height + size/2}
                                        size={size}
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


            this.setState({
                width: width,
                height: height
            });
        };


        //Renders the board with the 3 arrays
        return (
            <View style={{flex:1, backgroundColor: '#F4F0E6'}} onLayout={onLayout}>
                {[this.renderSquares(),this.renderEdges(),this.renderVertices()]}
            </View>
        );
    }
};
