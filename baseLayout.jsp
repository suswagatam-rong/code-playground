<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/libs/standard/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><tiles:insertAttribute name="title" ignore="true" /></title>
    
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        html, body {
            height: 100%;
            background-color: #f0f2f5; /* Matched to worklist background */
            overflow: hidden; /* Prevents outer body double-scrolling issues */
        }

        /* Flex Container Setup to protect UI integrity */
        .app-master-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
            width: 100vw;
        }

        .app-header-region {
            flex-shrink: 0; /* Ensures the navigation bar never squishes */
            width: 100%;
        }

        .app-body-content-region {
            flex: 1;
            overflow-y: auto; /* Contains scroll tracking explicitly inside the body frame */
            width: 100%;
            -webkit-overflow-scrolling: touch;
        }
    </style>
</head>
<body>

    <div class="app-master-container">
        
        <div class="app-header-region">
            <tiles:insertAttribute name="header" />
        </div>

        <main class="app-body-content-region">
            <tiles:insertAttribute name="body" />
        </main>
        
    </div>

</body>
</html>
