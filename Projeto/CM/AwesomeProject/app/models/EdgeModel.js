
export default class EdgeModel {

    constructor(isClosed, orientation, row, column) {
        this.isClosed = isClosed;
        this.orientation = orientation;
        this.row = row;
        this.column = column;
        this.relatedSquares = [];
        this.changeListeners = [];
        this.clickHandler = null;
        this.isDisabled = false;
    }

    onClickHandler(){
        if(!this.isDisabled){
            this.clickHandler(this);
        }
    }

    disable(){
        this.isDisabled = true;
    }

    enable(){
        this.isDisabled = false;
    }

    setOnClickHandler(handler){
        this.clickHandler = handler;
        console.log('handler', handler);
    }

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
