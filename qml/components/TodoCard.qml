import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    property string id: ""
    property string title: ""
    property string category: ""
    property string priority: ""
    property bool completed: false

    width: ListView.view ? ListView.view.width : 320
    height: 76
    radius: 8
    border.color: "#d8e0ec"
    color: "white"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        AbstractButton{
            Layout.preferredHeight: 40
            Layout.preferredWidth: 40
            Layout.alignment: Qt.AlignVCenter

            background: Rectangle {
                anchors.fill: parent
                visible: true
                radius: height / 2
                border.width: 1
                border.color: "red"
            }

        }



        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Label {
                text: root.title
                color: "black"
                font.pixelSize: 18
                font.bold: true
            }
        }
        Item {
            id: item
            Layout.fillWidth: true
        }

    }


}
