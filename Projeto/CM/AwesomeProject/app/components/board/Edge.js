import React, { Component } from 'react';
import { StyleSheet, View,  TouchableHighlight, ToastAndroid } from 'react-native';


import Svg,{
    Circle,
    Ellipse,
    G,
    LinearGradient,
    RadialGradient,
    Line,
    Path,
    Polygon,
    Polyline,
    Rect,
    Symbol,
    Text,
    Use,
    Defs,
    Stop
} from 'react-native-svg';


export default class Edge extends Component {

    constructor(props){
        super(props);

        this.state = {
            isClosed: this.props.edge.isClosed,
            orientation: this.props.edge.orientation,
            owner: this.props.edge.owner
        };

    }

    onChange(){
        let edge = this.props.edge;
        this.state.isClosed = edge.isClosed;
        this.state.owner = edge.owner;
        this.setState(this.state);
    }

    componentWillMount() {
        this.props.edge.changeListeners.push(this.onChange.bind(this));
    }

    componentWillUnmount() {
        //this.props.edge.changeListeners.remove(this.onChange.bind(this));
    }

    static get defaultProps() {
        return {
            top: 0,
            left: 0,
            size: 0,
            orientation: 'vertical'
        };
    }

    render() {
        console.log("Render Edge");

        let player1Color = '#46AFDF';
        let player2Color = '#F69B59';

        let stateStyle = {
            top: this.state.orientation == 'horizontal' ? this.props.centerY - this.props.girth /2 : this.props.centerY ,
            left: this.state.orientation == 'horizontal' ? this.props.centerX  : this.props.centerX - this.props.girth /2 ,
            width: this.state.orientation == 'horizontal' ? this.props.size : this.props.girth,
            height: this.state.orientation == 'horizontal' ? this.props.girth: this.props.size,
            backgroundColor: 'transparent',
        }

        let CONTROL_OFFSET = this.props.girth /3.2;
        let path = "";
        if(this.state.orientation == 'horizontal')
            path = `M  0 0
             C ${CONTROL_OFFSET} ${CONTROL_OFFSET} , ${stateStyle.width - CONTROL_OFFSET} ${CONTROL_OFFSET}, ${stateStyle.width} 0
             L ${stateStyle.width}  ${stateStyle.height}
             C ${stateStyle.width - CONTROL_OFFSET} ${stateStyle.height - CONTROL_OFFSET}, ${CONTROL_OFFSET} ${stateStyle.height - CONTROL_OFFSET}, 0 ${stateStyle.height} 
             Z`;
        else {
            path = `M 0 0
            L ${stateStyle.width}  0
            C ${stateStyle.width - CONTROL_OFFSET} ${CONTROL_OFFSET} , ${stateStyle.width - CONTROL_OFFSET} ${stateStyle.height - CONTROL_OFFSET} , ${stateStyle.width} ${stateStyle.height}
            L 0 ${stateStyle.height}
            C ${CONTROL_OFFSET} ${stateStyle.height - CONTROL_OFFSET}, ${CONTROL_OFFSET} ${CONTROL_OFFSET}, 0 0
            Z`;
        }

            //  { this.state.orientation == 'horizontal' ? <Dash/> : <Dash style={[dashStyle]}/> }

        return (

                <TouchableHighlight style={[styles.edgeBase, stateStyle]} underlayColor="transparent" onPress={this.props.edge.onClickHandler.bind(this.props.edge)}>
                    {!this.state.isClosed ? <View/> :
                        <Svg
                            width={stateStyle.width}
                            height={stateStyle.height}
                        >
                            <Path d={path} fill={ this.state.owner == 'player1' ? player1Color: player2Color }/>
                        </Svg>
                    }
                </TouchableHighlight>
        );
    }


}


const styles = StyleSheet.create({
    edgeBase: {
        position: 'absolute',
        top: 0,
        left: 0,
        width: 0,
        height: 0,
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'transparent',
    }

});















