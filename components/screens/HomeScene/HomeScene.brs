' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    ' listen on port 8089
    ? "[HomeScene] Init"
    
    m.background    =    m.top.findNode("Background")
    m.itemmask      =    m.top.findNode("itemMask")
    ' GridScreen node with RowList

    m.gridScreen    =    m.top.findNode("GridScreen")
    m.episodes      =    m.top.findNode("Episodes")
    m.errorScene    =    m.top.findNode("ErrorScene")
    m.rowList       =    m.top.findNode("rowList")
    m.bg            =    m.top.findNode("GridScreen").getChild(0)
    ' DetailsScreen Node with description, Video Player

    m.detailsScreen =    m.top.findNode("DetailsScreen")
    m.videoPlayer   =    m.detailsScreen.findNode("VideoPlayer")
    
    m.option        =    m.top.findNode("option_btn")
    m.optionCont = m.top.findNode("optionCont")
    ' Observers
    m.top.observeField("rowItemSelected", "OnRowItemSelected")
    m.top.observeField("optionSelected", "OnOptionSelected")
    m.top.observeField("episodesRowItemSelected", "OnRowItemSelected") 
    m.top.observeField("playSelected", "OnRowItemSelected")
    m.videoPlayer.observeField("state", "checkEndOfEpisode")    
    m.top.observeField("visible", "OnVisibleChange")
    'animation for option bar
    m.animation = m.top.FindNode("myAnim1")
    m.gridAnim = m.top.findNode("slideUpItemMask")
    m.rowAnim = m.top.findNode("slideUpRowlist")
    m.videoFromEpisode = true

    m.exitConfirm = m.top.findNode("ExitConfirm")
    m.exitButtongrp = m.top.findNode("yesOrNo")
    m.yes = m.top.findNode("Yes")
    m.no = m.top.findNode("No")
    m.yes.observeField("buttonSelected", "exitMMV")
    m.no.observeField("buttonSelected", "exit_cancel")
    'print type(m.detailsScreen.videoPlayer)
End Function 
function exitMMV()
    m.top.exitApp = true
end function
function exit_cancel()
    m.exitConfirm.visible = false
    m.top.visible = true
    m.gridScreen.setFocus(true)
end function



'When a video is completed go back to episode screen with focus on last item selected
function checkEndOfEpisode()
    if m.videoPlayer.visible = true and m.videoPlayer.state = "finished"    
        videoEnded()
    end if
end function
function OnVisibleChange()
    if m.top.visible = true
        m.videoFromEpisode = true
    end if
End Function

' if content set, focus on GridScreen
Function OnChangeContent()
    m.gridAnim.control = "start"
    m.rowAnim.control = "start"
    m.gridScreen.setFocus(true)
    'm.episodes.setFocus(true)
    'm.loadingIndicator.control = "stop"
End Function

function updateRow()
    m.CWTask = CreateObject("roSGNode", "ContinueWatching")
    m.CWTask.control = "RUN"

end function

'Option button selected handler
Function OnOptionSelected()
    m.optionCont.visible = "true"
    m.animation.control = "start"
    m.optionCont.setFocus(true)
End Function 

' Row item selected handler
Function OnRowItemSelected()
    ?"On row item selected"
    if m.gridScreen.visible = true and m.episodes.visible = false 
        if m.gridScreen.itemFocused[0] = 0 and m.top.rowCount > 1
            selectedItem = m.gridScreen.focusedContent
            m.videoFromEpisode = false
            m.detailsScreen.id = m.gridScreen.focusedContent.id
            m.detailsScreen.epUrl = m.gridScreen.focusedContent.url            
            m.detailsScreen.content = m.gridScreen.focusedContent
            m.detailsScreen.passedTitle = m.gridScreen.focusedContent.Title
            m.detailsScreen.thumbnail = m.gridScreen.focusedContent.HDPOSTERURL
            m.detailsScreen.visible = true
            m.detailsScreen.setFocus(true)
        else
            m.itemmask.height = "720"
            m.slideFull = m.top.findNode("slideUpFull")
            m.slideFull.control = "start"
            m.gridScreen.visible = "false"
            m.episodes.showName = m.gridScreen.focusedContent.title
            m.episodes.seasonUrl = m.gridScreen.focusedContent.seasonUrl
            m.episodes.seasonCount = m.gridScreen.focusedContent.seasonNumber
            m.episodes.canCallApi = true
            m.episodes.content = m.gridScreen.focusedContent
            m.episodes.setFocus(true)
            m.episodes.visible = true 
                        
            result = true 
        end if

    else if m.gridScreen.visible = false and m.episodes.visible = true
        m.videoFromEpisode = true
        m.detailsScreen.id = m.episodes.focusedContent.id
        m.detailsScreen.epUrl = m.episodes.focusedContent.url
        m.detailsScreen.content = m.episodes.focusedContent
        m.detailsScreen.passedTitle = m.episodes.focusedContent.SHORTDESCRIPTIONLINE1
        m.detailsScreen.thumbnail = m.episodes.focusedContent.SDGRIDPOSTERURL
        m.detailsScreen.visible = true
        m.detailsScreen.setFocus(true)
        result = true
    end if
    
End Function

<<<<<<< HEAD
' set proper focus on buttons and stops video if return from Playback to details
'Sub onVideoVisibleChange()
'    print "in HS onVideoVisibleChange"
'    if m.videoPlayer2.visible = false and (m.top.visible = true or m.top.visible = false)
'        TimeStamp = Str(m.videoPlayer2.position)
'        Key = m.videoPlayer2.content.id
'        print m.videoPlayer2.content
'        ' Construct json here
'        valueJson = {"time":  m.videoPlayer2.position, "url": m.videoPlayer2.content.url, "streamFormat": "mp4", "id": Key, "duration": m.videoPlayer.content.duration}
'        ' Then turn json into string
'        valueJsonString = FormatJson(valueJson, 0)
'        sec = createObject("roRegistrySection", "MySection")
'        sec.Write(Key, valueJsonString)
'        sec.Flush()
'    end if
'End Sub

Sub OnVideoPlayerStateChange()
    ? "HomeScene > OnVideoPlayerStateChange : state == ";m.videoPlayer2.state
    if m.videoPlayer2.visible = false and (m.top.visible = true or m.top.visible = false)
        TimeStamp = Str(m.videoPlayer2.position)
        Key = m.videoPlayer2.content.id
        sec = createObject("roRegistrySection", "MySection")
        readJsonString =  sec.Read(Key)
        print readJsonString
        readJsonObject = parseJson(readJsonString)
        print readJsonObject
        if m.videoPlayer2.position > 10 and m.videoPlayer2.position < (Val(readJsonObject.duration) - 10)
            ' Construct json here
            valueJson = {"time":  m.videoPlayer2.position, "series": readJsonObject.series, "thumbnail": m.gridScreen.focusedContent.HDPosterUrl, "url": m.videoPlayer2.content.url, "streamFormat": "mp4", "id": Key, "duration": readJsonObject.duration, "name": readJsonObject.name}
            ' Then turn json into string
            valueJsonString = FormatJson(valueJson, 0)
            print valueJsonString
            sec.Write(Key, valueJsonString)
            sec.Flush()
        else
            sec.Delete(Key)
        end if
    end if
    
    if m.videoPlayer2.state = "error"
        'hide vide player in case of error
        m.videoPlayer2.visible = false
        m.GridScreen.visible = true
        m.GridScreen.setFocus(true)
    else if m.videoPlayer2.state = "playing"
    else if m.videoPlayer2.state = "finished"
        'hide vide player if video is finished
        m.videoPlayer2.visible = false
        
        Key = m.videoPlayer2.content.id
        sec = createObject("roRegistrySection", "MySection")
        sec.Delete(Key)
        'onItemSelected()
        m.GridScreen.visible = true
        m.GridScreen.setFocus(true)
    end if
end Sub

=======
>>>>>>> 5ac0d89a60dcf39b06ba7c5b3d257a3285358f32
' Main Remote keypress event loop
Function OnKeyEvent(key, press) as Boolean
    ? ">>> HomeScene >> OnkeyEvent"
    
    result = false
    if press then
        if key = "options"
            ' option key handler
            if m.detailsScreen.visible = false and m.exitConfirm.visible = false
                m.option.setFocus(true)
                result  = true
            end if

        else if key = "back"
        print "back pressed"
            if (m.optionCont.visible = true or m.option.hasFocus() = true) and m.gridScreen.visible = true
                m.optionCont.visible = "false"
                m.gridScreen.setFocus(true)
                updateRow()
                result = true
            else if (m.optionCont.visible = true or m.option.hasFocus() = true) and m.episodes.visible = true
                m.optionCont.visible = "false"
                m.episodes.setFocus(true)
                result = true
            else if m.detailsScreen.videoPlayerVisible = true            
                videoEnded()       
                result = true 
            else if m.gridScreen.visible = true and m.detailsScreen.visible = true
                m.detailsScreen.visible = false
                m.GridScreen.visible = true
                m.GridScreen.setFocus(true)
                result = true
            else if m.episodes.visible = true and m.detailsScreen.visible = true
                m.detailsScreen.visible=false
                m.episodes.visible = true
                m.episodes.setFocus(true)
                result = true
            else if m.gridScreen.visible = false and m.episodes.visible = true
                updateRow()
                m.gridScreen.setFocus(true)
                m.gridScreen.visible = true
                m.episodes.visible = false
                result = true            
            else if m.gridScreen.visible = true and m.episodes.visible = false and m.detailsScreen.visible = false
               m.exitConfirm.visible = true
               m.exitButtongrp.setFocus(true)
                result = true     
            end if
        end if
    end if
    return result
End Function

function videoEnded()

    if m.videoFromEpisode = true 
        m.episodes.content = m.episodes.refreshNode
        'm.episodes.refreshNode = {}
        m.detailsScreen.videoPlayerVisible = false
        m.detailsScreen.visible=false
        m.episodes.visible = true        
        m.episodes.setFocus(true)
    else 
        m.detailsScreen.videoPlayerVisible = false
        m.detailsScreen.visible=false
        m.gridScreen.visible = true
        m.gridScreen.setFocus(true)
    end if 
end function

