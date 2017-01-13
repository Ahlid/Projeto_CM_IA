
export default class EdgeModel {

    constructor(isClosed, orientation) {
        this.isClosed = isClosed;
        this.orientation = orientation;
        this.relatedSquares = [];
        this.changeListeners = [];
    }

    clickHandler(){
        this.setClosed();
    };

    signalChange(){
        this.changeListeners.forEach((listener)=>{
            listener();
        });
    }

    setClosed(){
        if(!this.isClosed){
            this.isClosed = true;

            this.relatedSquares.forEach((square) => {
                if(square.topEdge.isClosed &&
                        square.leftEdge.isClosed &&
                            square.bottomEdge.isClosed &&
                                square.rightEdge.isClosed) {

                    square.setClosed();

                }
            })

            this.signalChange();
        }
    }

}
