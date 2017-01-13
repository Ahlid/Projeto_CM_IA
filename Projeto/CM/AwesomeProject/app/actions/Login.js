/**
 * Created by pcts on 1/11/2017.
 */
import * as types from './Types'

export function makeLogin(username) {
    return {
        type: types.LOGIN,
        username,
    }
}

export function test(name,index) {
    return {
        type: types.TEST,
        name,
        index,
    }
}