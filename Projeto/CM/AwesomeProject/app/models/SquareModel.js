
export default class SquareModel {

    constructor(topEdge,leftEdge, bottomEdge, rightEdge, isClosed){
        this.topEdge = topEdge;
        this.leftEdge = leftEdge;
        this.bottomEdge = bottomEdge;
        this.rightEdge = rightEdge;
        this.isClosed = isClosed;
        this.owner = null;
        this.changeListeners = [];
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
            this.signalChange();
        }
    }

    setOpened() {
        if(this.isClosed){
            this.isClosed = false;
            this.signalChange();
        }
    }

}