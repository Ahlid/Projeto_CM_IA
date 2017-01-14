/**
 * Created by pcts on 1/11/2017.
 */
import * as types from '../actions/Types'
import createReducer from '../lib/createReducer';
import { combineReducers } from 'redux'


export default function reducer(state, action) {
    switch (action.type) {

        case types.LOGIN:
            return Object.assign({}, state, {
                username: action.username
            })

        case types.VIEW_ROOMS:
            return Object.assign({}, state, {
                rooms: action.rooms
            })

        case types.TEST:

            var mm = state.manel;
            mm[action.index] = action.name;

            return Object.assign({}, state, { manel: mm });

        case types.START_GAME:
            var game = state.game;
            game.hSquares = action.game.hSquares;
            game.vSquares = action.game.vSquares;
            game.hSquares = action.game.hSquares;
            game.user1 = action.game.user1;
            game.user2 = action.game.user2;
            game.turn = action.game.turn;
            game.caixas = action.game.board.caixas;
            game.arestasVerticais = action.game.board.arestasVerticais;
            game.arestasHorizontais = action.game.board.arestasHorizontais;

            return Object.assign({}, state, {game : game});

        default:
            return state
    }
}


