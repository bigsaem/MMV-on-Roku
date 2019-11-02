' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    ' listen on port 8089
    ? "[HomeScene] Init"

    ' GridScreen node with RowList
    m.gridScreen = m.top.findNode("GridScreen")

    ' DetailsScreen Node with description, Video Player
     m.detailsScreen = m.top.findNode("DetailsScreen")
    
    
   ' Empty
    m.episodes = m.top.findNode("Episodes")

    ' Observer to handle Item selection on RowList inside GridScreen (alias="GridScreen.rowItemSelected")
    m.top.observeField("rowItemSelected", "OnRowItemSelected")
    
    m.top.observeField("episodesRowItemSelected", "OnRowItemSelected")
    
    m.top.observeField("playSelected", "OnRowItemSelected")
    
    
    
    ' loading indicator starts at initializatio of channel
    m.loadingIndicator = m.top.findNode("loadingIndicator")
End Function 

' if content set, focus on GridScreen
Function OnChangeContent()
    m.gridScreen.setFocus(true)
    'm.episodes.setFocus(true)
    m.loadingIndicator.control = "stop"
End Function

' Row item selected handler
Function OnRowItemSelected()
    ?"On row item selected"
    ' On select any item on home scene, show Details node and hide Grid
'    m.gridScreen.visible = "false"
'    m.detailsScreen.content = m.gridScreen.focusedContent
'    m.detailsScreen.setFocus(true)
'    m.detailsScreen.visible = "true"

    if m.gridScreen.visible = true and m.episodes.visible = false
        m.gridScreen.visible = "false"
        'm.episodes.showName = m.gridScreen.focusedContent.title
        m.episodes.seasonUrl = m.gridScreen.focusedContent.seasonUrl
        m.episodes.seasonCount = m.gridScreen.focusedContent.seasonNumber
        m.episodes.content = m.gridScreen.focusedContent
        m.episodes.setFocus(true)
        m.episodes.visible = "true"        
    else if m.gridScreen.visible = false and m.episodes.visible = true
        m.episodes.visible = "false"
        m.DetailsScreen.epUrl = m.episodes.focusedContent.url
        m.detailsScreen.visible = "true"
    else if m.detailsScreen.visible = true
        print "in vid player"
        m.detailsScreen.content = m.episodes.focusedContent
        m.detailsScreen.setFocus(true)
        'm.detailsScreen.videoPlayerVisible = true
        
    end if
    
    
End Function

' Main Remote keypress event loop
Function OnKeyEvent(key, press) as Boolean
    ? ">>> HomeScene >> OnkeyEvent"
    result = false
    if press then
        if key = "options"
            ' option key handler

        
        else if key = "back"

            ' if Episodes opened
            if m.gridScreen.visible = false and m.episodes.visible = true
                m.gridScreen.setFocus(true)
                m.gridScreen.visible = "true"
                'm.detailsScreen.visible = "false"
                m.episodes.visible = "false"
                result = true               
                
            ' if video player opened
            else if m.gridScreen.visible = false and m.episodes.videoPlayerVisible = true
                'm.detailsScreen.videoPlayerVisible = false
                 m.episodes.videoPlayerVisible = false
                
                result = true
                                
            end if

        end if
    end if
    return result
End Function
