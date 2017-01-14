/**
 * Created by Ricardo Morais on 14/01/2017.
 */
import * as types from './Types'

export function gameStarted(game) {
    return {
        type: types.START_GAME,
        game,
    }
}