import SquareModel from '../models/SquareModel'
import EdgeModel from '../models/EdgeModel'

export default class BoardModel {

    constructor(hSquares, vSquares) {

        //Linear Arrays of squares and edges
        let squares = [];
        let edges = [];
        let horizontalEdges = [];
        let verticalEdges = [];

        //Attributes
        this.hSquares = hSquares;
        this.vSquares = vSquares;
        this.squares = squares;
        this.edges = edges;
        this.horizontalEdges = horizontalEdges;
        this.verticalEdges = verticalEdges;

        //Simplified name variables for number of vertical and horizontal squares
        let h = hSquares;
        let v = vSquares;

        //Loop v * h times to create a matrix of squares and each respective edges
        for (let i = 0; i < v; i++) {

            //Create the square row
            squares[i] = [];

            if (i == 0) {
                horizontalEdges[i] = [];
            }
            horizontalEdges[i + 1] = [];

            verticalEdges[i] = [];

            //Loop h times to create an array of squares and each respective edges
            for (let j = 0; j < h; j++) {

                let topEdge;
                //If the top Edge is shared than the edge was already created
                if (i > 0) {
                    topEdge = squares[i - 1][j].bottomEdge;

                } else {
                    topEdge = new EdgeModel(false, 'horizontal', i, j);
                    horizontalEdges[i][j] = topEdge;
                    edges.push(topEdge);
                }

                let leftEdge;
                //If the left Edge is shared than the edge was already created
                if (j > 0) {
                    leftEdge = squares[i][j - 1].rightEdge;
                } else {
                    leftEdge = new EdgeModel(false, 'vertical', i, j);
                    verticalEdges[i][j] = leftEdge;
                    edges.push(leftEdge);
                }

                let bottomEdge = new EdgeModel(false, 'horizontal', i + 1, j);
                let rightEdge = new EdgeModel(false, 'vertical', i, j + 1);

                horizontalEdges[i + 1][j] = bottomEdge;
                verticalEdges[i][j + 1] = rightEdge;

                let square = new SquareModel(topEdge, leftEdge, bottomEdge, rightEdge);

                //Associates the edges to the square
                //Related squares are used for performance reasons
                square.topEdge.relatedSquares.push(square);
                square.leftEdge.relatedSquares.push(square);
                square.bottomEdge.relatedSquares.push(square);
                square.rightEdge.relatedSquares.push(square);

                //Adds the edges to the array of edges
                edges.push(bottomEdge);
                edges.push(rightEdge);

                //Adds the square to the matrix of squares
                squares[i].push(square);

            }
        }
    }

    setEdgesOnClick(handler){
        this.edges.forEach((edge) => {

            edge.setOnClickHandler(handler);
        });
    }

    disableEdges(){
        this.edges.forEach((edge) => {
            edge.disable();
        });
    }

    enableEdges(){
        this.edges.forEach((edge) => {
            edge.enable();
        });
    }

    isFilled(){
        for(var i = 0; i< this.squares.length ; i++){
            for(var j = 0; j< this.squares[i].length ; j++) {
                if (this.squares[i][j].owner == null) {
                    return false;
                }
            }
        }
        return true;
    }

    getCurrentWinner(player1, player2){
        var count1 = 0;
        var count2 = 0;
        for(var i = 0; i< this.squares.length ; i++){
            for(var j = 0; j< this.squares[i].length ; j++) {

                switch(this.squares[i][j].owner){
                    case player1:
                        count1++;
                        break;
                    case player2:
                        count2++;
                        break;
                }
            }
        }

        if(count1 == count2)
            return null;

        return count1 > count2 ? player1 : player2;

    }

    getScore(player){

        var count = 0;
        for(var i = 0; i< this.squares.length ; i++){
            for(var j = 0; j< this.squares[i].length ; j++) {
                if (this.squares[i][j].owner == player) {
                 count++;
                }
            }
        }

        return count;
    }


    getBoxNumberToWin(){
        return Math.floor(this.hSquares * this.vSquares / 2 + 1);
    }

}