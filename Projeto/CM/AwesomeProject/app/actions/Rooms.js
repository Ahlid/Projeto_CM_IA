/**
 * Created by pcts on 1/11/2017.
 */
import * as types from './Types'

export function updateRooms(rooms) {
    return {
        type: types.VIEW_ROOMS,
        rooms,
    }
}