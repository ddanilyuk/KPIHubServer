# KPI Hub Server

Vapor server for [KPIHub iOS app](https://github.com/ddanilyuk/KPIHubIOS/) which is used for:

1. Parsing [rozklad.kpi.ua](http://rozklad.kpi.ua) or API requests to [schedule.kpi.ua](https://schedule.kpi.ua/api/)
2. Parsing [campus.kpi.ua](campus.kpi.ua).


## Hosing: 
Server is hosted by digital ocean cloud.

Domain: **kpihub.xyz**

## Used technologies

- [Vapor](https://github.com/vapor/vapor)
- [vapor-routing](https://github.com/pointfreeco/vapor-routing) (by poinfree)
- fluent-postgres (for storing groups)
- Docker, docker-compose
- Github Actions, Secrets

## Requests

### Rozklad

#### Receiving all groups:

**GET** `/api/groups/all`

#### Search group by name:

**GET** `/api/groups/search?name=$(groupName)`

#### Get group lessons:

**GET** `/api/group/$(ID)/lessons`

### Campus

#### Student info:

**GET** `/api/campus/userInfo?username=$(username)&password=$(password)`

#### Student study sheet:

**GET** `/api/campus/studySheet?username=$(username)&password=$(password)`

## How it works?

The main thing that the server does is parisng.

### RozkladV2

Looks like [rozklad.kpi.ua](http://rozklad.kpi.ua/) is migrating to new site [schedule.kpi.ua](https://schedule.kpi.ua/api/).
As [rozklad.kpi.ua](http://rozklad.kpi.ua/) is not reacheable now, I created a wrapper RozkladV2 above new API. 

### RozkladV1

Every 28th on every mounth crone script updates group list. This is a rather labor-intensive task, and if you do it too often, the [rozklad.kpi.ua](http://rozklad.kpi.ua/) will ban your IP.

When user request lessons for particular group, server goes to [rozklad.kpi.ua](http://rozklad.kpi.ua/) and parse lessons live.

### Campus

Every request for campus-related staff need to be provieded with campus credentials.

Server do not store any credential information. So that’s why u need to pass credentials for every request.

Server use this data for receiving Bearer token and cookies. 

### Routing

At the heart of the approach for routing was taken `vapor-routing` by pointfree. This library gives an opportunity to move routing-related code to separate library and use it in iOS application and server.

### Parsing

This server use `swift-parsing` library for parsing HTML pages. 

Parsers:

- `GroupParser`
    
    Receive groups IDs from HTML pages
    
- `LessonsParser`
    
    Extract lessons from two schedule tables (first and second weeks)
    
- `StudySheetActivitiesParser`
    
    Parse studysheet table for all years of study
    
- `StudySheetLessonsParser`
    
    Parse marks from a specific subject table
