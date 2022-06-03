//
//  CampusController.swift
//  
//
//  Created by Denys Danyliuk on 02.06.2022.
//

import Vapor
import KPIHubParser

struct CampusAPILogin: Equatable, Codable {

    let accessToken: String
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case sessionId
    }
}

final class CampusController {

    func getGroup(request: Request) async throws -> String {
//        let groups = try await getNewGroups(
//            client: request.client,
//            logger: request.logger
//        )
//        try await GroupModel.query(on: request.db).delete(force: true)
//        try await groups.create(on: request.db)
//        let groupModels = try await GroupModel.query(on: request.db).all()

        let url1 = URL(string: "https://api.campus.kpi.ua/oauth/token?Username=dda77177&Password=4a78dd74")!
//        try await request.client.post(url1)
//            .content.decode(<#T##decodable: Content.Protocol##Content.Protocol#>)


        let response: ClientResponse = try await request.client.post(
            "https://api.campus.kpi.ua/oauth/token?Username=dda77177&Password=4a78dd74",
            beforeSend: { clientRequest in
//                let content = AllGroupClientRequest(prefixText: letter, count: 100)
//                clientRequest.
//                try clientRequest.content.encode(content)
            }
        )
        let result = try response.content.decode(CampusAPILogin.self)

        let all = response.headers.setCookie!.all
        let wrapped = response.headers.setCookie.wrapped!
        print(all)
        print("---")
        print(wrapped)
        print(result)

        let response2: ClientResponse = try await request.client.get(
            "https://api.campus.kpi.ua/Account/Info",
            beforeSend: { clientRequest in
                let auth = BearerAuthorization(token: result.accessToken)
                clientRequest.headers.bearerAuthorization = auth
                //                let content = AllGroupClientRequest(prefixText: letter, count: 100)
                //                clientRequest.
                //                try clientRequest.content.encode(content)
            }
        )
        print("!!!")
        print(response2.description)


        return "Done"
        //        return GroupsResponse(
//            numberOfGroups: groupModels.count,
//            groups: groupModels
//        )
    }

    func getCurrent(request: Request) async throws -> String {


        let some = """
        <!DOCTYPE HTML>
        <html xmlns:v="urn:schemas-microsoft-com:vml">
        <head>
        <title></title>
        <meta http-equiv="Content-Type" CONTENT="text/html; charset=cp1251">
        <meta name="keywords" http-equiv="keywords" content="">
        <meta name="description" content="">
        <meta name="classification" content="Education, High school, Campus, Kyiv">
        <meta http-equiv="Cache-Control" content="no-cache"><meta http-equiv="Pragma" content="no-cache">
        <meta NAME="revisit" CONTENT="7 days"><meta NAME="revisit-after" CONTENT="7 days"><meta NAME="robots" CONTENT="index, follow">
        <meta name="distribution" content="Global"><meta name="allow-search" content="yes">
        <meta http-equiv="reply-to" content="info@campus.kpi.ua">
        <meta name="document-state" content="dynamic">
        <meta name="author" content="Design, web-architecture and programming by 3SunS. Data and DB support provided by KBIS and KPI subdivisions">
        <base href="https://campus.kpi.ua/">
        <link type="image/ico" href="images/icon.ico" rel="SHORTCUT ICON">
        <link href="css/styles.css" rel="stylesheet" type="text/css">

        <script type="text/javascript" language="JavaScript" src="js/jquery/jquery.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/jquery/jquery.tablesorter.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/jquery/jquery.pngfix.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/register0.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/common_g.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/jquery/floating_panel.jquery.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/common.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/panels.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/wz_jsgraphics.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/jquery/jquery.form.js"></script>

        <script language="JavaScript" src="js/jquery/ui/jquery-ui.min.js"></script>
        <script language="javascript" src="js/jquery/grid/grid.locale-en.js"></script>
        <script language="JavaScript" src="js/jquery/grid/grid.locale-ua.js"></script>
        <script language="JavaScript" src="js/jquery/grid/jquery.jqgrid.min.js"></script>
        <script>
        var ra = "student/";
        if (!empty(base_url)) ra = base_url + ra;
        </script>

        <link rel="stylesheet" type="text/css" media="screen"  href="js/jquery/ui/smoothness/jquery-ui.custom.css">
        <link rel="stylesheet" type="text/css" media="screen"  href="js/jquery/grid/ui.jqgrid.css">

        </head>
        <body><div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
        <script type="text/javascript" language="JavaScript" src="classes/overlib.js"></script>
        <a name="top"></a>

        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="main_tbl">
        <tr nowrap="nowrap">
        <!--левая боковая-->
        <th class="left_clmn" valign="top" rowspan="3"></th>
        <!--центральная (контентная) -->
        <td valign="top" class="header" nowrap="nowrap">


            <!--шапка с лого и контролами-->
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                    <td class="content_left logo"><a href="student/"><img src="images/logo.png" alt="е-Кампус КПІ"></a>
                    </td>
                    <td class="content_area">
                        <table cellpadding="0" cellspacing="0" border="0" class="profile">
                            <tr>
                                <td class="title"><span>Вітаємо, </span>  Данилюк Денис Андрійович!</td>
                                <td class="switch">
                                    <select id="role_switch"  disabled="disabled">
                                        <option value="">.: змінити роль :.</option>

                                    </select>
                                </td>
                                <td class="ctrl"><a href="student/index.php?mode=logout" title="Вихід"><img src="images/ctrl/exit.png" alt="[X]"  border="0" title="Вихід"></A>
                                </td>
                            </tr>
                        </table>
                        <form action="student/index.php?mode=search" method="post" name="search_form">
                        <table cellpadding="0" cellspacing="0" border="0" class="searchBox">
                            <tr>
                                <!--<td class="title"></td>-->
                                <td>
                                    <input name="search_str" type="text" id="search_str_" value="Пошук...">
                                    <input type="image" id="search_btn" src="images/ctrl/search.png" style="width:auto; height:auto" disabled="disabled">
                                    <!--<button disabled="disabled"><img src="images/ctrl/search.png" alt="[пошук]"  border="0" title="пошук"></button>-->

                                </td>
                                <td class="advance"><a href="#student/index.php?mode=search" title="Розширений пошук" class="dis">Розширений пошук</a>
                                </td>
                            </tr>
                        </table>
                        </form>

                        <table cellpadding="0" cellspacing="0" border="0" class="navigation">
                            <tr>
                                <td><a href="student/" title="">Головна</a>


                                                                                                    <img src="images/nav_line/arrow.png" alt="&raquo;"  title="&raquo;"><a href="https://campus.kpi.ua/student/index.php?mode=studysheet">Поточний контроль</a>                                    <img src="images/nav_line/arrow.png" alt="&raquo;"  title="&raquo;">Перегляд відомостей
                                                              </td>
                            </tr>
                        </table>
                                                <div class="pageHead" style="background-image:url(images/page/studysheet.png);">Поточний контроль</div>
                                            </td>
                </tr>
            </table>

                    </td>


        <!--правая боковая-->
        <th class="right_clmn" valign="top" rowspan="3"></th>
        </tr>


        <tr>
        <td class="centre_clmn2">

            <!--контентная часть страницы-->
            <table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
                <tr valign="top">
                     <!--навигационное меню-->
                     <td class="menu" nowrap>
                        <table cellpadding="0" cellspacing="3" border="0" width="100%">


                                <TR class="lm_item mi_common">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=profile">Мій профіль</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>

                                <TR class="lm_item mi_common">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=contacts">Контакти</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>

                                <TR class="lm_item mi_common">
                                        <TD>
                                                <A  href="http://kbis.kpi.ua/kbis/images/stories/lira/InstructionTeacherCampusV1.pdf" target="_blank">Довідка</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>

                                <TR class="lm_item mi_common">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=kodeks">Кодекс честі</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
        <tr><td class="spacer spacer_between"></td></tr>


                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=bb">Дошка Оголошень</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=msg">Повідомлення</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=kurator">Куратор</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=rnp">РНП</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=mob">Метод.забезпечення</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item_active">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=studysheet">Поточний контроль</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=vote">Опитування</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=votecovid">Опитування COVID</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=rectorialcontrol">Ректорський контроль</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=vedomoststud">Сесія</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=pk2021">Вступ 2021 (магістратура)</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/student/index.php?mode=sdchoice2021stud">Вибір дисциплін</A>
                                        </TD>
                                </TR>

        <TR class="lmi_delim"><TD></TD></TR>
                                <TR class="lm_item">
                                        <TD>
                                                <A  href="https://campus.kpi.ua/tutor/index.php?mode=attestationresults">Результати атестації</A>
                                        </TD>
                                </TR>

                                <tr><td class="spacer"></td></tr>
                        </table>
                     </td>
                    <td valign="top">
                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                            <tr>
                               <td class="cntnt" valign="top" colspan="2">

          <!-- -=- -=- -=- -=- -=- -=- -=- -=- -=- content  -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -->

        <style>
        .ui-widget{
          font-size: 12px !important;
        }
        #sheet td{
          padding: 5px;
        }
        .ui-widget{
          font-size:14px;
        }
        .moBox .buttonSet{
          text-align: center;
          margin-top: 40px;
        }
        .moBox .buttonSet button{
          margin: 0px 40px;
        }
        .head, .head *{
          border: 0;
        }
        .head{
          margin-bottom: 20px;
        }
        .studySheetBox{
          min-height: 200px;
        }
        .studySheetBox table{
          border: 1px solid;
        }
        td[title] input, td[title] select, td[title] textarea {
          cursor: pointer
        }
        td._del{
          color: red;
          text-align: center;
          font-size: 20px;
          cursor: pointer;
        }
        textarea{
          resize: vertical;
          max-height: 200px;
        }
        .studySheetBox td{
          border-right: 1px solid #D0D0D0;
          border-bottom: 1px solid #d0d0d0;
        }
        .ListBox td{
          padding: 5px;
          vertical-align: middle;
        }
        .studySheetBox table input, .studySheetBox table select, .studySheetBox textarea{
          width: 96%;
          padding: 2%;
          margin: 0;
          border: 0;
          background: transparent;
          display: block;
        }
        .error{
          box-shadow: 0px 0px 2px 1px red;
        }
        .studySheetBox th{
          text-align: center;
          background-color: #eee;
          padding: 5px;
          border-right: 1px solid #D0D0D0;
          border-bottom: 1px solid #d0d0d0;
        }
        .studySheetBox tr:nth-child(even){
          background-color: #E4F3FF;
        }
        .studySheetBox td span.placeholder{
          color: #999;
        }
        .studySheetBox .loader{
          margin: 20% auto;
          display: block;
        }
        .studySheetBox #tabs{
          display: none;
        }
        .studySheetBox span.addSheet{
          cursor: pointer;
          color: #00F;
        }
        .studySheetBox span.addSheet:hover{
          text-decoration: underline;
        }

        #cMonitoringRow td input{
          text-align: center;
        }
        #cMonitoringRow .select td{
          background-color: #91FFA9 !important;
        }
        .vertical{
          transform: rotate(90deg);
          width: 100px;
          height: 100px;
        }
        .ui-autocomplete {
          max-height: 150px;
          overflow-y: auto;
          overflow-x: hidden;
        }
        * html .ui-autocomplete {
          height: 100px;
        }
        #contextmenu{
          position: absolute;
          border: 1px solid #DDD;
          background-color: #FFF;
          padding: 7px 15px;
          font-size: 12px;
          box-shadow: 0px 0px 2px 0px #2B6885;
          color: #EF991D;
          cursor: pointer;
        }
        #contextmenu:hover{
          border: 1px solid #FFF;
          background-color: #6EB2FF;
          color: #FFF;
        }
        span.descript {
          position: relative;
          float: left;
          margin-top: -25px;
          color: red;
          font-size: 22px;
        }
        .summaAll{
          color: red;
          text-align: center;
        }
        #cMonitoringRow tr td:last-child{
          text-align: center;
        }
        #cMonitoringRow th span{
          width: 4em;
          display: inline-block;
        }
        #cMonitoringRow th:first-child span{
          width: 10px;
          display: inline-block;
        }

        #cMonitoringRow th:nth-child(4) span{
          width: 30px;
          display: inline-block;
        }
        #cMonitoringRow th:nth-child(5) span{
          width: 50px;
          display: inline-block;
        }

        #cMonitoringEmployeeName{
          padding: 5px;
          border: 1px solid #999;
        }
        th.cssHeader {
          background-image: url(/js/jquery/tablesorter/bg.gif);
          cursor: pointer;
          font-weight: bold;
          background-repeat: no-repeat;
          background-position: center left;
          padding-left: 20px;
          border-right: 1px solid #dad9c7;
          margin-left: -1px;
        }
        th.headerSortUp {
          background-image: url(/js/jquery/tablesorter/asc.gif);
          background-color: #D4E0EC;
        }
        th.headerSortDown {
          background-image: url(/js/jquery/tablesorter/desc.gif);
          background-color: #D4E0EC;
        }
        thead small{
          font-weight: normal;
        }
        .studySheetBox  .IsNotSum {
          background-color: #fff;
        }

        #zoom, #export{
          position: absolute;
          top: 6px;
          right: 6px;
          cursor: pointer;
        }
        #export{right:50px}
        #zoom:after, #export:after{
          content: '';
          background-size: cover;
          background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAB+UlEQVRo3u1aS26EMAxl1RPNKSrEn213HKQn6JF6LhZoGreNZDwh2JCYRCKSRYRmnPfihxMcirZtn03TSG3u+74sArVhGErwKcUB2Avo1HX9rKrq1/b65jp3XRcMvG3gE3zb8TgG2EUEYoF3kUATtolnRYBhUcFTEhxM7AiY66IBHpGoYMxTErIsUbg+tQjAWDEkpELCgg8qIRyRmCTwzJ/OQlhC9H4MEnjmz2ahhRM+s4gEIwG+sG88gT5sLxGwqZLOxpacQpCw4H1SsVGnix2NwCrPUz1C3yz5H8Ye1sZxfEzT9HYUPPwXfGCfMIZPsnidwAScixTNCDBAKNlsNRhjL2lYEpaAd4XFJLQJ+JLFv9TngrOrtDrVIsB9vkQ7YnAIeiUOvsz97zMGPrBPGCNkhls1+sACAMnC4zLw4RsjaqMEtnK5r08JqDZLwGVZEQgpoUsJZB0B7hbYsadKg8AtoasJ3BJKgcAtoasjcEvoSgJZSCjr7XSyLzTGwTsHfLKvlNm/1HPKKqgulGRZxVvYInUhlcKWryq+VdjKv7SIfrxwKsMaxV1HtXwhpP4ISPJ27PK6BIv4hEbrgEOARXZCo33EtLefYktICzwlEVJC2sesZc04KZJKSP2gO5iEtEhIv5c4lIVikZB8YrCSUAqf28CO+OjnNj+LTIIBLXq5iAAAAABJRU5ErkJggg==');
          width: 25px;
          height: 25px;
          float: left;
        }
        #export:after{
          background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyNpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChNYWNpbnRvc2gpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOkZGQThFMjAzRTRDRjExRTY4QUY4RUMyMDk4RTc0MDI3IiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOkZGQThFMjA0RTRDRjExRTY4QUY4RUMyMDk4RTc0MDI3Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6RkZBOEUyMDFFNENGMTFFNjhBRjhFQzIwOThFNzQwMjciIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6RkZBOEUyMDJFNENGMTFFNjhBRjhFQzIwOThFNzQwMjciLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz7oBOaSAAAKV0lEQVR42uxae3BU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');
        }
        #export:hover:after{
          content: '';
          background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyNpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChNYWNpbnRvc2gpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOkZGQThFMjA3RTRDRjExRTY4QUY4RUMyMDk4RTc0MDI3IiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOkZGQThFMjA4RTRDRjExRTY4QUY4RUMyMDk4RTc0MDI3Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6RkZBOEUyMDVFNENGMTFFNjhBRjhFQzIwOThFNzQwMjciIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6RkZBOEUyMDZFNENGMTFFNjhBRjhFQzIwOThFNzQwMjciLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4HMACXAAAKeUlEQVR42tRaeWwU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');
        }
        #zoomWindow{
          background: #fff;
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
        }
        #zoomWindow .studySheetBox{
          overflow: auto;
          overflow-y: hidden;
          font-size: 12px;
          max-height: 100%;
        }
        #close:after{
          position: absolute;
          right: 0;
          top: 0;
          background: rgba(255, 0, 0, 0.71);
          font-size: 30px;
          line-height: 25px;
          padding: 5px;
          color: rgb(255, 255, 255);
          border: 1px solid #5A5A5A;
          opacity: 0.4;
          cursor: pointer;
        }
        #close:hover:after{
          opacity: 1;
        }
        </style>
        <script type="text/javascript" charset="utf-8" src="js/jquery/jquery.printElement.min.js"></script>
        <script>
        $('document').ready(function (){

            updateYearSem();
            $('#selectYear, #selectSem').change(updateYearSem);

            var year = 0;
            var sem = 0;
            $('button, .button').button();
            $('.sorter').tablesorter({cssHeader: 'cssHeader'});
            $('#tabs').tabs().fadeIn();
            $("#printSheet").click(function (){
                $(".print").printElement();
            });


        });

        function updateYearSem(){
            if (!$('#selectYear').length || !$('#selectSem').length)
                return;
            var year = $('#selectYear').val();
            var sem = $('#selectSem').val() * 1;
            console.log(year, sem);

            $('.ListBox tbody tr').hide();
            $('.ListBox tbody tr' + (year != 0 ? '[data-year=' + year + ']' : '') + (sem > 0 ? '[data-sem=' + sem + ']' : '')).show();
        }


        function alert(s){
            window.status = s;
            $('body').append('<div id="aldialog"><p>' + s + '</p></div>');
            $('#aldialog').dialog({
                resizable: false,
                width: 400,
                modal: true,
                title: 'Повідомлення',
                buttons: {
                    Ok: function (){
                        $(this).dialog("close");
                    }
                },
                close: function (){
                    $('#aldialog').remove();
                }
            });
        }
        function confirm(s, callback){
            window.status = s;
            $('body').append('<div id="aldialog"><p>' + s + '</p></div>');
            $('#aldialog').dialog({
                resizable: false,
                width: 400,
                modal: true,
                title: 'Повідомлення',
                buttons: {
                    Продовжити: function (){
                        $(this).dialog("close");
                        callback();
                    },
                    Відміна: function (){
                        $(this).dialog("close");
                        return;
                    }
                },
                close: function (){
                    $('#aldialog').remove();
                }
            });
        }

        </script>

        <div class="moBox" style="width: 100%;">
                  <div class="studySheetBox">
        <p><b><big>Ваші відомості:</big></b></p>
        <p>Навчальний рік
        <select id="selectYear">
          <option value="0">Всі</option>
                        <option value="2018-2019" >2018-2019</option>
                        <option value="2019-2020" >2019-2020</option>
                        <option value="2020-2021" >2020-2021</option>
                        <option value="2021-2022" >2021-2022</option>
                  </select>
        півріччя
        <select id="selectSem">
          <option value="0">Всі</option>
          <option value="1">1</option>
          <option value="2">2</option>
        </select></p>
        <table width="100%" border="0" class="ListBox" cellspacing='0'>
        <thead>
          <tr>
            <th>Рядок РНП</th>
            <th>Викладачі</th>
          </tr>
        </thead>
        <tbody>
                        <tr data-year="2018-2019" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=41710">Іноземна мова-1. Вступ до загальнотехнічної іноземної мови, Бакалавр, Денна, 2018-2019 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: КАМГС3 ФЛ</a></td>
                <td>Грабар Ольга Володимирівна, Сергеєва Оксана Олексіївна</td>
              </tr>
                        <tr data-year="2018-2019" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=42107">Додаткові розділи вищої математики-1. Аналітична геометрія, Бакалавр, Денна, 2018-2019 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: МАтаТЙ ФМФ</a></td>
                <td>Блажієвська Ірина Петрівна</td>
              </tr>
            <tr data-year="2018-2019" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=41723">Іноземна мова-1. Вступ до загальнотехнічної іноземної мови, Бакалавр, Денна, 2018-2019 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: КАМГС3 ФЛ</a></td>
                <td>Грабар Ольга Володимирівна, Сергеєва Оксана Олексіївна, Заворотна Ольга Ігорівна</td>
              </tr>
                        <tr data-year="2018-2019" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=43345">Вища математика-2. Диференціальне та інтегральне обчислення функцій багатьох змінних, Бакалавр, Денна, 2018-2019 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: МАтаТЙ ФМФ</a></td>
                <td>Блажієвська Ірина Петрівна</td>
              </tr>
                        <tr data-year="2019-2020" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=45826">Іноземна мова-2. Іноземна мова загальнотехнічного спрямування, Бакалавр, Денна, 2019-2020 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: КАМГС3 ФЛ</a></td>
                <td>Сергеєва Оксана Олексіївна, Шевченко Ольга Миколаївна</td>
              </tr>
                        <tr data-year="2019-2020" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=47828">Іноземна мова-2. Іноземна мова загальнотехнічного спрямування, Бакалавр, Денна, 2019-2020 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: КАМГС3 ФЛ</a></td>
                <td>Сергеєва Оксана Олексіївна</td>
              </tr>
                        <tr data-year="2019-2020" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=48503">Алгоритми та методи обчислень, Бакалавр, Денна, 2019-2020 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Новотарський Михайло Анатолійович, Порєв Віктор Миколайович</td>
              </tr>
                        <tr data-year="2019-2020" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=48589">Методи оптимізації та планування експерименту, Бакалавр, Денна, 2019-2020 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Селіванов Віктор Левович, Регіда Павло Геннадійович</td>
              </tr>
                        <tr data-year="2019-2020" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=49038">Архітектура комп'ютерів-1. Арифметичні та управляючі пристрої, Бакалавр, Денна, 2019-2020 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Верба Олександр Андрійович, Жабін Валерій Іванович</td>
              </tr>
                        <tr data-year="2019-2020" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=50339">Вступ до філософії, Бакалавр, Денна, 2019-2020 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: КФ ФСП</a></td>
                <td>Баюжева Анна Олександрівна</td>
              </tr>
                        <tr data-year="2019-2020" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=51291">Стратегія охорони навколишнього середовища, Бакалавр, Денна, 2019-2020 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: ЕтаРП ІХФ</a></td>
                <td>Радовенчик Ярослав Вячеславович</td>
              </tr>
                        <tr data-year="2019-2020" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=52436">Додаткові розділи теорії електричних та магнітних кіл, Бакалавр, Денна, 2019-2020 (ОТ ФІОТ), 123 Комп'ютерна інженерія, Читає: ТЕ ФЕА</a></td>
                <td>Лободзинський Вадим Юрійович</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=59823">Системне програмування-2. Розробка системних програм, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Павлов Валерій Георгійович</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=59496">Іноземна мова професійного спрямування. Практичний курс іноземної мови для професійного спрямування-І, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: КАМГС3 ФЛ</a></td>
                <td>Сергеєва Оксана Олексіївна</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=63047">Архітектура комп'ютерів-2. Процесори, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Нікольський Сергій Сергійович, Клименко Ірина Анатоліївна</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=70594">Програмування мобільних систем, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Шульга Максим Володимирович</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=71410">Комп'ютерні мережі-1. Локальні комп'ютерні мережі, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Алєнін Олег Ігорович, Кулаков Юрій Олексійович</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=71628">Правові основи інформаційної безпеки, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: КІППІВ ФСП</a></td>
                <td>Дорогих Сергій Олександрович, Фурашев Володимир Миколайович</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=69092">Архітектура комп'ютерів-3. Мікропроцесорні засоби, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Ткаченко Валентина Василівна, Каплунов Артем Володимирович</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=69839">Іноземна мова професійного спрямування. Практичний курс іноземної мови для професійного спрямування-І, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: КАМГС3 ФЛ</a></td>
                <td>Сергеєва Оксана Олексіївна</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=75293">Курсова робота з Паралельних та розподілених обчислень, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Корочкін Олександр Володимирович</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=75315">Основи паралельного програмування, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Корочкін Олександр Володимирович</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=75326">Паралельні та розподілені обчислення, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Корочкін Олександр Володимирович</td>
              </tr>
                        <tr data-year="2020-2021" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=75157">Організація обчислювальних процесів, Бакалавр, Денна, 2020-2021 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Сімоненко Валерій Павлович, Сімоненко Андрій Валерійович</td>
              </tr>
                        <tr data-year="2021-2022" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=79941">Системне програмне забезпечення, Бакалавр, Денна, 2021-2022 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Сімоненко Андрій Валерійович, Сімоненко Валерій Павлович</td>
              </tr>
                        <tr data-year="2021-2022" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=79596">Іноземна мова професійного спрямування. Практичний курс іноземної мови для професійного спрямування-ІІ, Бакалавр, Денна, 2021-2022 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: КАМГС3 ФЛ</a></td>
                <td>Сергеєва Оксана Олексіївна</td>
              </tr>
                        <tr data-year="2021-2022" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=85228">Комп'ютерні мережі-2. Глобальні комп'ютерні мережі, Бакалавр, Денна, 2021-2022 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Алєнін Олег Ігорович, Кулаков Юрій Олексійович</td>
              </tr>
                        <tr data-year="2021-2022" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=85267">Сучасні технології програмування-1. Тестування та контроль якості (QА) вбудованих систем, Бакалавр, Денна, 2021-2022 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Калюжний Олександр Олегович, Клименко Ірина Анатоліївна</td>
              </tr>
                        <tr data-year="2021-2022" data-sem="1">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=84885">БЖД та цивільний захист, Бакалавр, Денна, 2021-2022 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОППЦБ ІЕЕ</a></td>
                <td>Праховнік Наталія Артурівна</td>
              </tr>
                        <tr data-year="2021-2022" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=91801">Програмування складних систем, Бакалавр, Денна, 2021-2022 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Долголенко Олександр Миколайович</td>
              </tr>
                        <tr data-year="2021-2022" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=91804">Багатопотокове програмування на Jаvа, Бакалавр, Денна, 2021-2022 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Долголенко Олександр Миколайович</td>
              </tr>
                        <tr data-year="2021-2022" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=95536">Сучасні технології програмування-2. Технології програмування на С/Емbеddеd, Бакалавр, Денна, 2021-2022 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Каплунов Артем Володимирович</td>
              </tr>
                        <tr data-year="2021-2022" data-sem="2">
                <td><a href="/student/index.php?mode=studysheet&action=view&id=99489">Програмування системи реального часу, Бакалавр, Денна, 2021-2022 (ОТ ФІОТ), 123 Комп’ютерна інженерія, Читає: ОТ ФІОТ</a></td>
                <td>Каплунов Артем Володимирович</td>
              </tr>
                  </tbody>
        </table>
        </div>
        </div>
        <div id="debug" style="display:none"></div>                                                <br><br>
                                                <span style="color:#CCCCCC; font-size:95%"></span>

                                        <!-- -=- -=- -=- -=- -=- -=- -=- -=- -=- eof content  -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -->

                              </td>
                            </tr>
                        </table>

                    </td>

                </tr>
            </table>

        </td>
        </tr>

        <tr>
        <td style="vertical-align:bottom" class="footer">
            <!--нижняя часть страницы-->
            <table cellpadding="0" cellspacing="0" border="0" width="100%" class="footer">
                <tr>
                    <td>                        Національний технічний університет України "КПІ ім. Ігоря Сікорського" - <a href="https://campus.kpi.ua/../">Електронний кампус</a> &copy; 2011-2022<br>
                        Усі права застережено. <a href="rules.htm" target="_blank">Правила використання</a><br>
                        Інформаційна підтримка: тел. +38 (044) 204 80 06, e-mail:· ecampus@kpi.ua<br>
                                <!--<span>Розробка сайту:</span> <a href="http://www.3suns.com.ua" style="text-decoration:none; color:#000">студія 3SunS</a>-->                    </td>
                    <td class="socials">

                    </td>
                </tr>
            </table>
        </td>
        </tr>


        </table>

        </body>
        <script type="text/javascript" language="JavaScript" src="js/init_panels.js"></script>
        <!--<script type="text/javascript" language="JavaScript" src="js/timer.js"></script>
        <script type="text/javascript" language="JavaScript" src="js/ajax/test_check.js"></script>-->
        </html>
        """
        let parser = StudySheetParser()
        let parsedResult = try parser.parse(some)
        print(parsedResult)
        print(parsedResult.map { $0.name }.joined(separator: "\n"))

        struct Test {
            let row: StudySheetRow
            let detailItems: [StudySheetDetailRow]
        }

        let fullResult = try await parsedResult
            .asyncMap { row -> Test in
                let response: ClientResponse = try await request.client.post(
                    "https://campus.kpi.ua\(row.link)",
                    beforeSend: { clientRequest in

                    }
                )
                guard
                    var body = response.body,
                    let html = body.readString(length: body.readableBytes)
                else {
                    throw Abort(.internalServerError)
                }
                let detailItems = try StudySheetDetailParser()
                    .parse(html)
                return Test(row: row, detailItems: detailItems)
            }

        print(fullResult)

        let response1: ClientResponse = try await request.client.post(
            "https://api.campus.kpi.ua/oauth/token?Username=dda77177&Password=4a78dd74"
        )
        let result = try response1.content.decode(CampusAPILogin.self)

        let all = response1.headers.setCookie!.all
        let wrapped = response1.headers.setCookie.wrapped!
        print(all)
        print("---")
        print(wrapped)
        print(result)

//        request.client.
//        App().cl÷
//        request.application.client.configura
//        request.client.configuration.redirectConfiguration = .disallow



//        request.client


        let response2: ClientResponse = try await request.client.get(
            "https://campus.kpi.ua/auth.php",
            beforeSend: { clientRequest in
//                clientRequest
//                let auth = BearerAuthorization(token: result.accessToken)
//                clientRequest.headers.bearerAuthorization = auth
                clientRequest.headers.cookie = response1.headers.setCookie

                print("clientRequest.headers.cookie \(clientRequest.headers)")
                //                let content = AllGroupClientRequest(prefixText: letter, count: 100)
                //                clientRequest.
                //                try clientRequest.content.encode(content)
            }
        )


//        response2.red
        print("!!!")
        print(response2.status)
        print(response2.description)
        print(response2.headers)
//        request.application.httpNonRedirect.client.

        print("cookie2 \(response2.headers.setCookie)")
//        let clien = Client.init

        let response3: ClientResponse = try await request.client.get(
            "https://campus.kpi.ua/student/index.php?mode=studysheet",
            beforeSend: { clientRequest in
                let auth = BearerAuthorization(token: result.accessToken)
                clientRequest.headers.bearerAuthorization = auth
//                let cookies = response2.headers.setCookie
                let all1 = response1.headers.setCookie!.all
                let all2 = response2.headers.setCookie!.all

                let res = all1.merging(all2) { (current, _) in current }

                let some = res.map { key, value in
                    return (key, value)
                }
//                res.map
                print("RES \(res)")
                // ("SID", res["SID"]!)
                // ("token", res["token"]!),
                clientRequest.headers.cookie = HTTPCookies(dictionaryLiteral: ("PHPSESSID", res["PHPSESSID"]!))
                //                let content = AllGroupClientRequest(prefixText: letter, count: 100)
                //                clientRequest.
                //                try clientRequest.content.encode(content)
                print("pppppp \(clientRequest.headers)" )
            }
        )
        guard
            var body = response3.body,
            let html = body.readString(length: body.readableBytes)
        else {
            throw Abort(.internalServerError)
        }


        print(parsedResult)


//        print("-------")
//        print(response3.description)
//        print(response3.headers)
//
//
////        response3.content.
////        response3.body
//
//        print("\n\n\n\n\n\n\n\n\n\n")
//
//        print(html)
//
//        let html2 = String(decoding: body.readableBytesView, as: UTF8.self)
//        print(html2)
//
//        let html3 = String(buffer: body)
//        print(html3)
//
////        let cString = response3.description.cString(using: String.Encoding.utf8)
//        let str = String(describing: response3.description.cString(using: String.Encoding.windowsCP1251))
//        print(str)
//        let str = String(describing: response3.description.cString(using: String.Encoding.utf8))

//        let string = String(
//        let result2 = response3.description.utf8DecodedString()
//        print(str)
        return "Done"
        //        return GroupsResponse(
        //            numberOfGroups: groupModels.count,
        //            groups: groupModels
        //        )
    }

}
//

//extension HTTPCookies {
//    public init(dictionaryLiteral elements: [(String, Value)]) {
////        super.ini
//        var cookies: [String: Value] = [:]
//        for (name, value) in elements {
//            cookies[name] = value
//        }
//        self.cookies = cookies
//    }
//}

extension String {
    func utf8DecodedString() -> String {
        let data = self.data(using: .windowsCP1251)
        let message = String(data: data!, encoding: .utf8) ?? ""
        return message
    }

    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
}
