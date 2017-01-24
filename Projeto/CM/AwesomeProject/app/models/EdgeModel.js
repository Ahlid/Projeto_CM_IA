
export default class EdgeModel {

    constructor(isClosed, orientation, row, column) {
        this.isClosed = isClosed;
        this.owner = null;
        this.orientation = orientation;
        this.row = row;
        this.column = column;
        this.relatedSquares = [];
        this.changeListeners = [];
        this.clickHandler = null;
        this.isDisabled = false;
    }

    onClickHandler(){
        console.log(this.row);
        console.log(this.column);
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


    setClosed(owner){
        if(!this.isClosed){
            this.isClosed = true;
            this.owner = owner;

            let count = 0;
            this.relatedSquares.forEach((square) => {
                if(square.topEdge.isClosed &&
                        square.leftEdge.isClosed &&
                            square.bottomEdge.isClosed &&
                                square.rightEdge.isClosed) {

                    square.setClosed(owner);
                    count++;
                }
            });

            this.signalChange();
            return count;
        }
    }

}
