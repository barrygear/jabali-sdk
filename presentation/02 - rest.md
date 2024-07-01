# REST API

This document contains a set of example api calls and classes to define the early stage of the server code.

## Org

The Org object defines either a Company or a single user (solo users must create at least 1 Org). It is the top most organization value. Multiple users and multiple games can be organized beneath an Org object.

### REST Calls

| Name      | REST                |
| :-------- | :------------------ |
| listOrgs  | GET /orgs           |
| createOrg | POST /org           |
| getOrg    | GET /org/{orgId}    |
| updateOrg | PATCH /org/{orgId}  |
| deleteOrg | DELETE /org/{orgId} |
| saveOrg   | PUT /org/{orgId}    |

* listOrgs will return list of all Organizations associated with the userId.
* createOrg will create a new Organization and set the userId as the Owner.
* getOrg will the details of the Org.
* updaterOrg will update a field of the Org object.
* deleteOrg will delete the Org if no data is associated with it.
* saveOrg will update all fields of an Org.

### Org Schema

```yaml
  schemas:
    Org:
      example:
        name: my-org
        displayName: My Org
        owner: some user-id
      properties:
        name:
          example: my-org
          type: string
        displayName:
          example: My Org
          type: string
        owner:
          example: some user-id
          type: string
      type: object
    createOrg_request:
      properties:
        name:
          type: string
        displayName:
          type: string
        owner:
          type: string
      required:
      - name
      - displayName
      - owner
      type: object
    updateOrg_request:
      properties:
        name:
          type: string
        displayName:
          type: string
        owner:
          type: string
      required:
      - name
      - displayName
      - owner
      type: object
    saveOrg_request:
      properties:
        name:
          type: string
        displayName:
          type: string
        owner:
          type: string
      required:
      - name
      - displayName
      - owner
      type: object
```

## User

The User object contains user information.

### User REST Calls

| Name       | REST                  |
| :--------- | :-------------------- |
| listUsers  | GET /users            |
| createUser | POST /user            |
| getUser    | GET /user/{userId}    |
| updateUser | PATCH /user/{userId}  |
| deleteUser | DELETE /user/{userId} |
| saveUser   | PUT /user/{userId}    |

* listUsers will return list of all Users associated with the userId.

## Games

The Games object defines a game and its descriptive data. Most of the api calls will need a gameId as a parameter.

### Games REST Calls

| Name       | REST                  |
| :--------- | :-------------------- |
| listGames  | GET /games            |
| createGame | POST /game            |
| getGame    | GET /game/{gameId}    |
| updateGame | PATCH /game/{gameId}  |
| deleteGame | DELETE /game/{gameId} |
| saveGame   | PUT /game/{gameId}    |

* listGames will return list of all Games associated with the userId.

### Games Schema

```yaml
  schemas:
    Game:
      example:
        gameId: 4e1243bd22c66e76c2ba9eddc1f91394e57f9f83
        displayName: My Game
        name: my-game
        url: https://raw.githubusercontent.com/scraly/gophers/main/arrow-gopher.png
      properties:
        name:
          example: my-game
          type: string
        displayName:
          example: My Game
          type: string
        gameId:
          example: 4e1243bd22c66e76c2ba9eddc1f91394e57f9f83
          type: string
        url:
          example: https://raw.githubusercontent.com/scraly/gophers/main/arrow-gopher.png
          type: string
      type: object
    createGame_request:
      properties:
        name:
          type: string
        displayName:
          type: string
        url:
          type: string
      required:
      - displayName
      - name
      - url
      type: object
```

## GameLevel

| Name        | REST                                   |
| :---------- | :------------------------------------- |
| listLevels  | GET /{gameId}/gamelevel               |
| getLevel    | GET /{gameId}/gamelevel/{level-id}    |
| createLevel | POST /{gameId}/gamelevel              |
| updateLevel | PATCH /{gameId}/gamelevel/{level-id}  |
| deleteLevel | DELETE /{gameId}/gamelevel/{level-id} |
| saveLevel   | PUT /{gameId}/gamelevel/{level-id}    |

## GameObject

| Name                | REST                                                  |
| :------------------ | :---------------------------------------------------- |
| listObjects         | GET /{gameId}/gameobject                             |
| getObject           | GET /{gameId}/gameobject/{object-id}                 |
| createObject        | POST /{gameId}/gameobject                            |
| updateObject        | PATCH /{gameId}/gameobject/{object-id}               |
| deleteObject        | DELETE /{gameId}/gameobject/{object-id}              |
| deleteObjectVersion | DELETE /{gameId}/gameobject/{object-id}/{version-id} |
| saveObject          | PUT /{gameId}/gameobject/{object-id}                 |

## Lock

Locks are used for multi user editing purposes. When an object is being edited, client calls
createLock on object-id

| Name       | REST                              |
| :--------- | :-------------------------------- |
| listLocks  | GET /{gameId}/locks              |
| getLock    | GET /{gameId}/locks/{lock-id}    |
| createLock | POST /{gameId}/locks             |
| updateLock | PATCH /{gameId}/locks/{lock-id}  |
| deleteLock | DELETE /{gameId}/locks/{lock-id} |

## AI

The game editor will have the ability to invoke AI functionality from the backend.

1. listAICalls returns data that can be used to populate the AI calls in the UI as well as provide required and optional parameters needed to invoke the call, i.e. a schema.
2. invokeAICall will be used to make a backend call to use the AI functionality. For example, to generate a sprite tween sets.
3. invokeAIChat, a ChatGPT like interface. The allows the user to type in using natural language model to invoke AI functionality, for example invoking a MidJourney like image generation.

### REST

| Name         | REST                           |
| :----------- | :----------------------------- |
| listAICalls  | GET /{gameId}/ai              |
| invokeAICall | POST /{gameId}/ai             |
| invokeAIChat | GET /{gameId}/ai/{chatString} |

### AI Schema

```yaml
  schemas:
    AICalls:
      example:
        id: d5c07425675ba6682d89278ed8616a88d49af0a2
        requiredParams: |
          parameters:
            - name : param1Name
              description : param1Description
              value: param1ExampleValue
            - name : param2Name
              description : param2Description
              value: param2ExampleValue
            - name : param3Name
              description : param3Description
              value: param3ExampleValue
            - name : param4Name
              description : param4Description
              value: param4ExampleValue
        optionalParams: |
          parameters:
            - name : param1Name
              description : param1Description
              value: param1ExampleValue
            - name : param2Name
              description : param2Description
              value: param2ExampleValue
            - name : param3Name
              description : param3Description
              value: param3ExampleValue
            - name : param4Name
              description : param4Description
              value: param4ExampleValue
      properties:
        id:
          example: d5c07425675ba6682d89278ed8616a88d49af0a2
          type: string
        requiredParams:
          example: |
            parameters:
              - name : param1Name
                description : param1Description
                value: param1ExampleValue
          type: string
        optionalParams:
          example: |
            parameters:
              - name : param1Name
                description : param1Description
                value: param1ExampleValue
          type: string
      type: object
    AIInvocation:
      example:
        id: d5c07425675ba6682d89278ed8616a88d49af0a2
        parameters: |
          {
            param1: param1value
            param2: param2value
            param3: param3value
            param4: param4value
          }
      properties:
        id:
          example: d5c07425675ba6682d89278ed8616a88d49af0a2
          type: string
        parameters:
          example: |
            {
              param1: param1value
              param2: param2value
              param3: param3value
              param4: param4value
            }
          type: string
      type: object
```
