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

        default:
            return state
    }
}


