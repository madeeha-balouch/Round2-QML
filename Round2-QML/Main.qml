import QtQuick
import QtQml
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import QtMultimedia

Window {
    width: 540
    height: 380
    visible: true
    color: "steelblue"
    title: qsTr("Hello World")

Column{
    anchors.centerIn: parent
        Video {
            id: video
            width: 500
            height: 300
            source: ""

            // when End of duration reached, set video's playback position back to the initial state
            onStopped: {
            video.position = slider.minval
            }
        }
     //Progress Slider
        Item {

            width: video.width
            height: 10

            Rectangle {
                id: slider
                width: parent.width
                height: parent.height
                color: "lightgray"

                property int minval: 0
                property int maxval: video.duration

                Rectangle {
                    id: handle
                    width: 15
                    height: 14
                    radius: width/2
                    color: "darkblue"

                    MouseArea {
                        anchors.fill: parent
                        drag.target: handle
                        drag.axis: "XAxis"
                        drag.minimumX: slider.x
                        drag.maximumX: slider.x + slider.width - handle.width

                        onPositionChanged: {
                            let positionRatio = (handle.x - slider.x) / (slider.width - handle.width);
                            let newPosition = slider.minval + positionRatio * (slider.maxval - slider.minval);
                            video.position = newPosition;
                           }
             //makes the handle move as the video is being played
            Connections {
                   target: video
                   onPositionChanged: {
                       // change the position of the handle as the video position changes
                       let positionRatio = (video.position - slider.minval) / (slider.maxval - slider.minval);
                       handle.x = slider.x + positionRatio * (slider.width - handle.width);
                   }
               }
            }
        }}}
        //PlayButton
        Row {
                spacing: 10
                leftPadding: 160
                topPadding: 10

                Rectangle {
                    id: playButton
                    width: 60
                    height: 30
                    radius: 20
                    color: "gray"
                    border.color: "black"

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Play")
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (video.playbackState === MediaPlayer.PausedState || video.playbackState === MediaPlayer.StoppedState)
                                video.play();
                               }
                    }
                }

              //PauseButton
                Rectangle {
                    id: stopButton
                    width: 60
                    height: 30
                    radius: 20
                    color: "gray"
                    border.color: "black"

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Pause")
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (video.playbackState === MediaPlayer.PlayingState)
                                video.pause();
                        }
                    }
                }

             }
       }

    FileDialog {
        id: chooseVideo
        title: "Select a Video to Display"
        nameFilters: ["Video Files (*.mp4 *.avi *.mov)"]
        visible: true

        onAccepted: {
            video.source = chooseVideo.selectedFile
            video.play()
        }

    }
}
