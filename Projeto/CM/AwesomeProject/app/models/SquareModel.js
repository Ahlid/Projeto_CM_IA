
export default class SquareModel {

    constructor(topEdge,leftEdge, bottomEdge, rightEdge, isClosed){
        this.topEdge = topEdge;
        this.leftEdge = leftEdge;
        this.bottomEdge = bottomEdge;
        this.rightEdge = rightEdge;
        this.isClosed = isClosed;
        this.changeListeners = [];
    }

    signalChange(){
        this.changeListeners.forEach((listener)=>{
           listener();
        });
    }

    setClosed(){
        if(!this.isClosed){
            this.isClosed = true;
            this.signalChange();
        }
    }

}