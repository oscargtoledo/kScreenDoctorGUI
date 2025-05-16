pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ScreenConfigurator

ApplicationWindow {
    id: window
    width: 640  * 2
    height: 480  * 2
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
            Rectangle {
                    id: intersection
                    z: 99
                    color: "transparent"
                    border.width: 3
                    border.color: "red"
                    // visible: false

                }
            DropArea {
                anchors.fill: parent
                Rectangle {
                    anchors.fill: parent
                    color: "green"
                    opacity: 0.1

                    visible: parent.containsDrag
                }
                
                function displaysOverlapping(display1, display2) {
                        var d1Rect = Qt.rect(display1.x, display1.y, display1.width, display1.height)
                        var d2Rect = Qt.rect(display2.x, display2.y, display2.width, display2.height)
                        if (ScreenConfigurator.displaysIntersecting(d1Rect, d2Rect)) {
                            var res = ScreenConfigurator.displayIntersection(d1Rect, d2Rect)
                            print(res)
                            intersection.x = res.x
                            intersection.y = res.y
                            intersection.width = res.width
                            intersection.height = res.height
                            display1.dragArea.resetMaxMins()
                            if (res.width < res.height) {
                                if (display1.x < res.x) {
                                    print("to the left")
                                    display1.dragArea.drag.minimumX = 0
                                    display1.dragArea.drag.maximumX = res.x - display1.width
                                    // display1.x -= res.width
                                }
                                else {
                                    print("to the right")
                                    display1.dragArea.drag.minimumX = res.x
                                    display1.dragArea.drag.maximumX = contents.width - display1.width
                                    // display1.x += res.width
                                }
                            }
                            else{
                                if (display1.y < res.y) {
                                    print("from the top")
                                    display1.dragArea.drag.minimumY = 0
                                    display1.dragArea.drag.maximumY = res.y - display1.height
                                    // display1.y -= res.height
                                }
                                else {
                                    print("from the bottom")
                                    display1.dragArea.drag.minimumY = res.y
                                    display1.dragArea.drag.maximumY = contents.height - display1.height
                                    // display1.y += res.height
                                }
                            }
                            return true;
                        } else  {
                            
                            // if (d1Rect.y + d1Rect.height < d2Rect.y || d1Rect.y > d2Rect.y + d2Rect.height) {
                            //     display1.dragArea.drag.minimumX = 0
                            //     display1.dragArea.drag.maximumX = contents.width - display1.width
                            // }
                            // return false;
                        }
                }

                //TODO: All displays get sampled to check if the dragged one can move again in a certain axis.
                //      Consider only computing limits on the nearest display
                function handleNoOverlaps(drag, displays) {

                    var checkFreeX = function(d1, d2) {
                        if (d1.y + d1.height < d2.y || d1.y > d2.y + d2.height) {
                            return true;
                        }
                        return false;
                    }

                    var checkFreeY = function(d1, d2) {
                        if (d1.x + d1.width < d2.x || d1.x > d2.x + d2.width) {
                            return true;
                        }
                        return false;
                    }

                    var freeX = displays.map((display) => {
                        return checkFreeX(drag, display)
                    })

                    if(freeX.every((value) => value === true)) {
                        drag.dragArea.drag.minimumX = 0
                        drag.dragArea.drag.maximumX = contents.width - drag.width
                    }

                    var freeY = displays.map((display) => {
                        return checkFreeY(drag, display)
                    })

                    if(freeY.every((value) => value === true)) {
                        drag.dragArea.drag.minimumY = 0
                        drag.dragArea.drag.maximumY = contents.height - drag.height
                    }



                }

                function handleDisplayOverlap() {
                    var displays = [];

                    for (var i = 0; i < displayRepeater.count; i++) {
                        var display = displayRepeater.itemAt(i);
                        if (display == drag.source)
                            continue;
                        displays.push(displayRepeater.itemAt(i));
                    }

                    var overlaps = displays.reduce(function(acc, display) {
                        return acc || ScreenConfigurator.displaysIntersecting(drag.source, display)
                    }, false) 

                    if (!overlaps) {
                        handleNoOverlaps(drag.source, displays)
                        print("no overlaps")
                        return
                    }
                    


                    for (display of displays) {
                        if (displaysOverlapping(drag.source, display)) print("overlap")
                    }
                }

                onDropped: drop => {
                    handleDisplayOverlap()
                    drop.source.dragArea.resetMaxMins()
                }
                onPositionChanged: function(drag) {
                    handleDisplayOverlap()
                }
            }

            Repeater {
                id: displayRepeater
                model: ScreenConfigurator.getDisplays()

                Rectangle {
                    id: display
                    required property int index
                    required property QtObject modelData
                    property int downscaleRatio: 10
                    readonly property Item dragArea: dragArea
                    width: modelData.size.width / downscaleRatio
                    height: modelData.size.height / downscaleRatio
                    color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                    x: modelData.pos.x / downscaleRatio
                    y: modelData.pos.y / downscaleRatio
                    Component.onCompleted: {
                        var outt = ((contents.width) / modelData.pos.x) * modelData.pos.x;
                        print(outt);
                    }
                    property point beginDrag
                    property bool caught: false
                    border {
                        width: 2
                        color: "white"
                    }
                    radius: 5
                    Text {
                        anchors.centerIn: parent
                        text: modelData.name
                        color: "white"
                    }
                    Drag.active: dragArea.drag.active
                    MouseArea {
                        id: dragArea
                        anchors.fill: parent

                        onReleased: (mouse) => {
                            parent.Drag.drop();
                        }

                        drag.minimumX: 0
                        drag.minimumY: 0
                        drag.maximumX: contents.width - display.width
                        drag.maximumY: contents.height - display.height
                        drag.target: parent

                        function resetMaxMins() {
                            drag.minimumX = 0
                            drag.minimumY = 0
                            drag.maximumX = contents.width - display.width
                            drag.maximumY = contents.height - display.height
                        }
                    }
                }
            }

            // Repeater {
            //     model: ScreenConfigurator.getDisplays()

            //     Rectangle {
            //         id: display
            //         required property int index
            //         required property QtObject modelData
            //         property int downscaleRatio: 10
            //         // required property string modelData
            //         width: modelData.size.width / downscaleRatio
            //         height: modelData.size.height / downscaleRatio
            //         // z: mouseArea.drag.active || mouseArea.pressed ? 2 : 1
            //         color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            //         // x: Math.random() * (contents.width / 2 - 100)
            //         x: modelData.pos.x / downscaleRatio
            //         y: modelData.pos.y / downscaleRatio
            //         Component.onCompleted: {
            //             // print(modelData.size);
            //             var outt = ((contents.width) / modelData.pos.x) * modelData.pos.x;
            //             print(outt);
            //         }
            //         // x: modelData.size[0]
            //         property point beginDrag
            //         property bool caught: false
            //         border {
            //             width: 2
            //             color: "white"
            //         }
            //         radius: 5
            //         // Drag.active: mouseArea.drag.active

            //         Text {
            //             anchors.centerIn: parent
            //             text: modelData.name
            //             color: "white"
            //         }
            //         DragHandler {
            //             xAxis {
            //                 minimum: 0
            //                 maximum: contents.width - display.width
            //             }
            //             yAxis {
            //                 minimum: 0
            //                 maximum: contents.height - display.height
            //             }
            //             // onGrabChanged: (transition, point) => {
            //             //     print(transition);
            //             // }
            //             // onGrabChanged: (transition, point) => {
            //             //     ScreenConfigurator.handlePositionChange(point);
            //             // }

            //         }
            //         // Drag.active: dragArea.drag.active
            //         // Drag.hotSpot.x: 10
            //         // Drag.hotSpot.y: 10

            //         // MouseArea {
            //         //     id: dragArea
            //         //     anchors.fill: parent

            //         //     drag.minimumX: 0
            //         //     drag.minimumY: 0
            //         //     drag.maximumX: contents.width - display.width
            //         //     drag.maximumY: contents.height - display.height
            //         //     drag.target: parent
            //         // }
            //     }
            // }

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
