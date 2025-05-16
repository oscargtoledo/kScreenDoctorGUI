pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ScreenConfigurator

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    menuBar: MenuBar {
        Menu {
            title: qsTr("&Layout")
            Action {
                text: qsTr("&New...")
            }
            Action {
                text: qsTr("&Open...")
            }
            Action {
                text: qsTr("&Save")
            }
            Action {
                text: qsTr("Save &As...")
            }
            MenuSeparator {}
            Action {
                text: qsTr("&Quit")
            }
        }
        Menu {
            title: qsTr("&Edit")
            Action {
                text: qsTr("Cu&t")
            }
            Action {
                text: qsTr("&Copy")
            }
            Action {
                text: qsTr("&Paste")
            }
        }
        Menu {
            title: qsTr("&Help")
            Action {
                text: qsTr("&About")
            }
        }
    }

    Page {
        anchors.fill: parent
        header: ToolBar {
            RowLayout {
                anchors.fill: parent
                ToolButton {
                    text: "Apply"
                }
            }
        }

        contentItem: Item {
            id: contents
            DropArea {
                anchors.fill: parent
                Rectangle {
                    anchors.fill: parent
                    color: "green"
                    opacity: 0.1

                    visible: parent.containsDrag
                }
                onPositionChanged: {
                    print(drag.x);
                    print(drag.y);
                }
            }

            Repeater {
                model: ScreenConfigurator.getDisplays()

                Rectangle {
                    id: display
                    required property int index
                    required property QtObject modelData
                    property int downscaleRatio: 10
                    // required property string modelData
                    width: modelData.size.width / downscaleRatio
                    height: modelData.size.height / downscaleRatio
                    // z: mouseArea.drag.active || mouseArea.pressed ? 2 : 1
                    color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                    // x: Math.random() * (contents.width / 2 - 100)
                    x: modelData.pos.x / downscaleRatio
                    y: modelData.pos.y / downscaleRatio
                    Component.onCompleted: {
                        // print(modelData.size);
                        var outt = ((contents.width) / modelData.pos.x) * modelData.pos.x;
                        print(outt);
                    }
                    // x: modelData.size[0]
                    property point beginDrag
                    property bool caught: false
                    border {
                        width: 2
                        color: "white"
                    }
                    radius: 5
                    // Drag.active: mouseArea.drag.active

                    Text {
                        anchors.centerIn: parent
                        text: modelData.name
                        color: "white"
                    }
                    DragHandler {
                        xAxis {
                            minimum: 0
                            maximum: contents.width - display.width
                        }
                        yAxis {
                            minimum: 0
                            maximum: contents.height - display.height
                        }
                        // onGrabChanged: (transition, point) => {
                        //     print(transition);
                        // }
                        // onGrabChanged: (transition, point) => {
                        //     ScreenConfigurator.handlePositionChange(point);
                        // }

                    }
                    // Drag.active: dragArea.drag.active
                    // Drag.hotSpot.x: 10
                    // Drag.hotSpot.y: 10

                    // MouseArea {
                    //     id: dragArea
                    //     anchors.fill: parent

                    //     drag.minimumX: 0
                    //     drag.minimumY: 0
                    //     drag.maximumX: contents.width - display.width
                    //     drag.maximumY: contents.height - display.height
                    //     drag.target: parent
                    // }
                }
            }

            // Repeater {
            //     // model: ScreenConfigurator.displays
            //     model: 10
            //     delegate: Text {
            //         text: modelData.index
            //     }
            //     // Rectangle {
            //     //     id: display
            //     //     // required property string modelData
            //     //     width: 50
            //     //     height: 50
            //     //     // z: mouseArea.drag.active || mouseArea.pressed ? 2 : 1
            //     //     color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            //     //     x: Math.random() * (contents.width / 2 - 100)
            //     //     y: Math.random() * (contents.height - 100)
            //     //     property point beginDrag
            //     //     property bool caught: false
            //     //     Component.onCompleted: {
            //     //         // print(Object.keys(display));
            //     //         // print(modelData.name());
            //     //         // print(modelData);
            //     //         print(index);
            //     //     }
            //     //     border {
            //     //         width: 2
            //     //         color: "white"
            //     //     }
            //     //     radius: 5
            //     //     // Drag.active: mouseArea.drag.active

            //     //     Text {
            //     //         anchors.centerIn: parent
            //     //         color: "white"
            //     //     }
            //     //     Drag.active: dragArea.drag.active
            //     //     Drag.hotSpot.x: 10
            //     //     Drag.hotSpot.y: 10

            //     //     MouseArea {
            //     //         id: dragArea
            //     //         anchors.fill: parent

            //     //         drag.minimumX: 0
            //     //         drag.minimumY: 0
            //     //         drag.maximumX: contents.width - display.width
            //     //         drag.maximumY: contents.height - display.height
            //     //         drag.target: parent
            //     //     }
            //     // }
            // }
        }

        footer: TabBar {}
    }
    Component.onCompleted: ScreenConfigurator
}
