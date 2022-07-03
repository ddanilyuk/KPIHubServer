# KPI Hub Server

Vapor server for [KPIHub iOS app](https://github.com/ddanilyuk/KPIHubIOS/) which can parse [rozklad.kpi.ua](http://rozklad.kpi.ua) and [campus.kpi.ua](campus.kpi.ua).


## Hosing: 
Server is hosted by digital ocean cloud.

Domain: **kpihub.xyz**

## Used technologies

- [Vapor](https://github.com/vapor/vapor)
- [vapor-routing](https://github.com/pointfreeco/vapor-routing) (by poinfree)
- fluent-postgres (for storing groups)
- docker, docker-compose
- Github actions, Secrets

## Requests

### Rozklad

#### Receiving all groups:

**GET** `/api/groups/all`

#### Search group by name:

**GET** `/api/groups/search?name=$(groupName)`

#### Get group lessons:

**GET** `/api/group/$(ID)/lessons`

### Campus

#### Student user info:

**GET** `/api/campus/userInfo?username=$(username)&password=$(password)`

#### Student study sheet:

**GET** `/api/campus/studySheet?username=$(username)&password=$(password)`

## How it works?

The main thing that the server does is parisng.

### RozkladV2

Looks like [rozklad.kpi.ua](http://rozklad.kpi.ua/) is migrating to new site [schedule.kpi.ua](https://github.com/kpi-ua/schedule.kpi.ua).
And as [rozklad.kpi.ua](http://rozklad.kpi.ua/) is not reacheable now, I created a wrapper RozkladV2 above new API. 

### RozkladV1

Every 28th on every mounth crone script updates group list. This is a rather labor-intensive task, and if you do it more often, the [rozklad.kpi.ua](http://rozklad.kpi.ua/) protection will work and the IP will be banned.

When user request lessons for particular group, server goes to [rozklad.kpi.ua](http://rozklad.kpi.ua/) and parse lessons live.

### Campus

Every request for campus-related staff need to be provieded with campus credentials.

Server do not store any credential information. So that’s why u need to pass credentials for every request.

Server use this data for receiving Bearea token and cookies. 

### Routing

At the heart of the approach for routing was taken `vapor-routing` by pointfree. This library gives an opportunity to move routing-related code to separate library and then use it by iOS application.

### Parsing

This server use `swift-parsing` library for parsing HTML pages. There are a couple of parsers.

- `GroupParser`
    
    Used for receiving group id’s from html pages
    
- `LessonsParser`
    
    Extracting lessons from two schedule tables
    
- `StudySheetActivitiesParser`
    
    Parse studysheet table for all years of study
    
- `StudySheetLessonsParser`
    
    Parse grades of a Specific Subject