# Table of Contents

1. [Requirements](#requirements)
1. [Server](#server)
    1. [REST Interface](#rest-interface)
    1. [User Creation](#user-creation)
    1. [Authentication](#authentication)
        1. [Keycloak](#keycloak)
        1. [Custom solutions](#custom-solutions)
    1. [Authorization](#authorization)
        1. [User Groups](#user-groups)
        1. [CORS](#cors)
    1. [Asset Management](#asset-management)
    1. [Database](#database)
        1. [Gorm](#gorm)
        1. [MongoDB](#mongodb)
    1. [Third party integration](#third-party-integration)
        1. [Protocols](#protocols)
        1. [WebSockets](#websocket)
1. [Runtime](#runtime)
1. [AI Services](#ai-services)
    1. [Sprite sheet render example](#sprite-sheet-render-example)
    1. [Image Generation example](#image-generation-example)
1. [Client](#client)
    1. [Multi user design](#multi-user-design)
    1. [Save Revision Detection](#save-revision-detection)
    1. [Object change notification](#object-change-notification)
    1. [Object locking](#object-locking)
1. [Scaling Considerations](#scaling-considerations)
    1. [Server scaling](#server-scaling)
    1. [Database scaling](#database-scaling)
    1. [Client scaling](#client-scaling)
1. [Example Shell Session](#example-shell-session)

## Jabali API Proposal

## Requirements

You will be responsible for designing and implementing services which will power game editor apps for a 2D top-down RPG/Adventure game. This game editor app will allow creators to design and modify game levels using a combination of keyboard-mouse interaction, generative AI systems for a broad range of assets and code generation. There will also be chat-based modules that interface with generative AI systems. Once the game editor app is launched, we will also expose these services to third party developers to integrate into their own engines/workflows.

1. Start with the high-level architecture of the system, key components and their interactions including front-end, backend services and AI services.
1. Next, draft for services and API endpoints.
1. Lastly, consider the key trade-off in the choices for speed of implementation and future scaling.

## Server

### REST interface

For initial deployments, a REST interface will be used. REST can be iterated upon rapidly and is easy to use by the client. A quick workflow centered on openapi-generator is used to not only to define the REST interface, generate openapi documentation (both online and offline) but also the go server code, go client code, and javascript clients. For a full list install openapi-generator (`brew install openapi-generator`) and execute `openapi-generator list` or see [Generators](https://openapi-generator.tech/docs/generators)

### User Creation

Without the use of Keycloak, user creation will be done using custom code and managed internally. With Keycloak, the user creation part will be dependant on the choice of Keycloak authentication. For example, if GitHub is used for OpenIdConnect authentication, when user creation will be done via GitHub.

### Authentication

Successful user authentication will generate a jwt token with the subject claim (sub) set to the userId. The jwt token is required for each call, therefore each call will have the userId available via jwt decoding.

#### Keycloak

Authentication via [Keycloak](https://www.keycloak.org/) would provide jwt token generation as well as refresh token support. This api spec assumes a jwt token contains the userId when making API calls.
Keycloak can be used to support user management at different scales of lifecycle. If you only have 5 or so users, you can just use the built in user store. As the user base grows you can use other mechanisms like slapd-ldap, or Active Directory, or openIdConnect resources like GitHub, local GitLab, or Google Auth etc.

#### Custom solutions

[golang-jwt](https://golang-jwt.github.io/jwt/) can also be used however that leaves a lot of implementation to be done for example, token refresh. golan-jwt provides the tools but the implementation is up to the user.

[example custom auth example](https://www.golang.company/blog/jwt-authentication-in-golang-using-gin-web-framework)

### Authorization

#### User Groups

REST calls will be restricted to users that belong to the appropriate group. The group is defined during authentication.

#### CORS

It's standard practice to protect API's using CORS. CORS can be implemented in go as a middleware. See [go cors](https://github.com/rs/cors)

### Asset Management

Users of the editor will be able to provide their own assets for placement within the game levels. The site should support uploading of various image data formats. Similarly, it should support secure storage as there is the potential for copyrighted assets being uploaded.

### Database

[Go SQLDriver projects](https://go.dev/wiki/SQLDrivers)

I'm not going to recommend much in this space since the choice of database is usually driven by the collective experience of the developers in the team. Personally, for management simplicity, I would recommend a hosted RDB solution. Amazon Aurora is easy for management and scalability but expensive. Simple MySQL or PostgreSQL compatible dbs perform well and are easily manageable when hosted, i.e. Amazon RDS provides this.

Again, the chosen DB should represent the most familiar system amongst the current developers.

#### Gorm

Many people consider ORMs to be overhead and may prefer simpler database management. However, ORMs provide a great deal of functionality and compatibility. Perhaps the largest benefit is the automatic query generation. One such ORM is [GORM](https://gorm.io/docs/).

#### MongoDB

MongoDB is acceptable, however, the only real hosted solution is Mongo Atlas, which has become fairly cost prohibitive at scale. Features like snapshots, server upgrades, and restores are easy to do greatly simplifying management however. It also has the (ig)notable distinction of not being compatible with ORMs.

### Third party integration

#### Protocols

As the initial protocol is using REST for simplified client integration, integration into third party systems may require other mechanisms. gRPC is high performance, universally accepted, Remote Procedure Call (RPC) framework which provides this capability. However, it may be preferable to support more than just one protocol.

* [ConnectRPC](https://connectrpc.com/docs/introduction) is one such framework. It provides gRPC, gRPC-web, as well as HTTP protocols. It can also support REST style calls using gRPC transcoding. See [gRPC Transcoding](https://cloud.google.com/endpoints/docs/grpc/transcoding) and [http.proto](https://github.com/googleapis/googleapis/blob/738ff24cb9c00be062dc200c10426df7b13d1e65/google/api/http.proto#L44).

* [gRPC-Gateway](https://github.com/grpc-ecosystem/grpc-gateway#readme) can be used to generate the REST proxy since ConnectRPC wont know what to do with the url structure

#### Websocket

For third party integrations the server will provide a websocket interface for asynchronous communication.

* [built in](https://pkg.go.dev/golang.org/x/net/websocket)
* [gorilla](https://github.com/gorilla/websocket)
* [gws](https://pkg.go.dev/github.com/lxzan/gws)

## Runtime

[Kubernetes Diagram](https://drive.google.com/file/d/1h4gmQfpWhmQV5ryglbeSlf_SXafMrbvv/view?usp=sharing)

## AI Services

AI services are separately deployed and called to by the server. The integration between the server side code and AI services will be treated as an external integration with AI servers being deployed and managed separately.

### Sprite sheet render example

Given two assets, you can instruct the AI backend to render images in-between the two to create a smooth animation.
See [Simple DAIN tutorial](https://www.youtube.com/watch?v=VHVrvSe3myc) and [DAIN](https://grisk.itch.io/dain-app) as a examples of an existing possible workflow.

### Image Generation example

A natural language interface will be provided to facilitate AI driven image generation similar to MidJourney and others.

## Client

The while the server's REST interface provides the necessary calls to manage the data, the client will potentially need additional calls to support its functionality. For example, multiple users edit the same game level will need support systems like optimistic locking of objects, event notification systems (i.e. someone deleted an object), and possibly orchestration systems that makes batch processing or complex operations simple for the client.

### Multi user design

Depending on the size and scope of a game, the level design can be managed by a single user, allowing the web client developer to assume atomic access to objects. This greatly simplifies editor implementation. However, having a team of editors accessing and editing the same game level simultaneously would greatly enhance productivity.

#### Save Revision Detection

One way of handling multi user editing is to detect non incremental save ids. When a game level is saved its revision number is incremented by 1. If the editing revising id in the db is equal to or greater than the new save version, the a collision happens and conflict resolution must to done. (A perhaps simpler version could just use a UTC timestamp.)

To simplify conflict resolution, each object within the game level can contain its own revision id. To resolve the conflict, the level could be reloaded by the saver, discarding identical objects and only asking the user to resolve objects with different ids. (Can be as simple as 'keep yours' or 'keep theirs').

#### Object change notification

With multiple users editing the same level simultaneously, one nice (advanced) feature would be to send ObjectChanged notifications to each client editing the current level. Web editors could connect via WebSockets and subscribe to messages pertaining to the gameId/levelId and receive real time updates to other objects they are not editing.

#### Object locking

When editing a object, i.e. moving it, renaming it, changing textures, etc an object lock would be placed first to prevent other users from changing it.

For example:

1. On MouseDown/KeyDown
    * Single user behavior doesn't require server interaction during mouse or key down
    * If multi-user functionality in implemented, set OptimisticLock on objectId. If not available, notify user
2. On MouseUp/KeyUp
    * Client calls updateObject to set position/name/values/etc
    * If multi-user functionality in implemented, check OptimisticLock for locking/object version collision

## Scaling Considerations

### Server scaling

1. The server will run within kubernetes and should scale as requests increase due to Horizontal Pod Scalers.
1. Caching may be utilized to fetch resources that change infrequently, like AI feature details (i.e. the list of AI methods and their parameters, etc).

### Database scaling

1. If RDS (or some other hosted database) is used, scaling the database is typically vertical (i.e. size of instance). Horizontal database scaling involves ether custom server code for key routing, explicit separation of databases (i.e. Asset database, User data, Game data), and configuration. After simplistic horizontal scaling has no more options, then vertical scaling will be applied. Ultimately, without some form of key sharding there will be a practical maximum. Key sharding for tradition RDB's require third party solutions.
1. MongoDB scaling is similar to the previous option however sharding is a built in feature of Mongo and works well in my experience. It is much more complicated than simple database isolation and vertical scaling.

### Client scaling

1. Scaling the client for is similar to the server code, as it will be hosted via kubernetes.
1. CDN hosting of the client code is possible depending on the architecture, i.e. complex node.js deployments may make it difficult.

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
