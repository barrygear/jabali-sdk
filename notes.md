# API Proposal

API Endpoint : https://api.jabali.com

Version: v1

All endpoints start with `{API Endpoint}/{Version}`

## API Services

### API Service : games.jabali.com

| Name       | REST                    |
| :--------- | :---------------------- |
| listGames  | GET /games              |
| createGame | POST /game              |
| getGame    | GET /game/{game-id}     |
| updateGame | PATCH /game/{game-id}   |
| deleteGame | DELETE /game/{game-id}  |
| saveGame   | PUT /game/{game-id}     |

### API Service : gamelevel.jabali.com

| Name        | REST                                   |
| :---------- | :------------------------------------- |
| listLevels  | GET /{game-id}/gamelevel               |
| getLevel    | GET /{game-id}/gamelevel/{level-id}    |
| createLevel | POST /{game-id}/gamelevel              |
| updateLevel | PATCH /{game-id}/gamelevel/{level-id}  |
| deleteLevel | DELETE /{game-id}/gamelevel/{level-id} |
| saveLevel   | PUT /{game-id}/gamelevel/{level-id}    |

### API Service : gameobject.jabali.com

| Name                | REST                                                  |
| :------------------ | :---------------------------------------------------- |
| listObjects         | GET /{game-id}/gameobject                             |
| getObject           | GET /{game-id}/gameobject/{object-id}                 |
| createObject        | POST /{game-id}/gameobject                            |
| updateObject        | PATCH /{game-id}/gameobject/{object-id}               |
| deleteObject        | DELETE /{game-id}/gameobject/{object-id}              |
| deleteObjectVersion | DELETE /{game-id}/gameobject/{object-id}/{version-id} |
| saveObject          | PUT /{game-id}/gameobject/{object-id}                 |

### API Service : locks.jabali.com

Locks are used for multi user editing purposes. When an object is being edited, client calls
createLock on object-id

| Name       | REST                              |
| :--------- | :-------------------------------- |
| listLocks  | GET /{game-id}/locks              |
| getLock    | GET /{game-id}/locks/{lock-id}    |
| createLock | POST /{game-id}/locks             |
| updateLock | PATCH /{game-id}/locks/{lock-id}  |
| deleteLock | DELETE /{game-id}/locks/{lock-id} |

### API Service : ai.jabali.com

Invoke an AI assistant to generate resources

generateSpriteSheet

| Name       | REST                              |
| :--------- | :-------------------------------- |
| listAI     | GET /{game-id}/ai                 |
| getLock    | GET /{game-id}/locks/{lock-id}    |
| triggerAI  | POST /{game-id}/ai                |
| updateLock | PATCH /{game-id}/locks/{lock-id}  |
| deleteLock | DELETE /{game-id}/locks/{lock-id} |

## Client specific

```pre
MouseUp/KeyUp
	Calls updateObject to set position/name/values/etc
	idea : if multiuser, check Optimisticlock for collision

MouseDown/KeyDown
	idea : if multiuser, set Optimisticlock on object-id

VersionedObjects? undo etc
```

## Example Shell Session

```bash
#!/usr/bin/env bash
APIVERSION="v1"
AUTH_KEY="4e1243bd22c66e76c2ba9eddc1f91394e57f9f83"
ENDPOINT="https://api.jabali.com/${APIVERSION}"
GAMES_ENDPOINT="${ENDPOINT}/games}"
LEVELS_ENDPOINT="${ENDPOINT}/%s/gamelevel}"
CURL="curl -H \"Authorization: Bearer : ${AUTH_KEY}\""

# create game
_NEW_GAME='{"name": "Final Fantasy XXX"}'
_NEW_GAME_DATA=$(${CURL} "${GAMES_ENDPOINT}" --json "${_NEW_GAME}")
_GAMEID=$(jq -cr '.game-id' <<< ${_NEW_GAME_DATA})

# fix name
_TMP_NEW_GAME_DATA=$(jq -cr '.name="Final Fantasy XX"' <<< "${_NEW_GAME_DATA}")
# saveGameData
_NEW_GAME_DATA=$(${CURL} -X PUT "${GAMES_ENDPOINT}/${_GAMEID}" --json "${_TMP_NEW_GAME_DATA}")

# create level
_NEW_LEVEL_DATA=$(${CURL} "$(printf "${LEVELS_ENDPOINT}" ${_GAMEID})" --json '{"name": "Level 1"}')
_LEVELID=$(jq -cr '.level-id' <<< ${_NEW_LEVEL_DATA})
```

