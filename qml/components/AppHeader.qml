import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property string searchText: ""

    signal searchTextChangedByUser(string text)
    signal addRequested()

    implicitHeight: 72

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        anchors.topMargin: 12
        anchors.bottomMargin: 12
        spacing: 12

        ColumnLayout {
            Layout.preferredWidth: 180
            Layout.fillHeight: true
            spacing: 2

            Text {
                text: "NexTodo"
                font.pixelSize: 24
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: "任务管理器"
                font.pixelSize: 16
                color: "#666666"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        SearchBox {
            id: searchBox
            text: root.searchText
            Layout.fillWidth: true
            Layout.preferredWidth: 360
            Layout.maximumWidth: 520
            Layout.preferredHeight: 40

            onTextEdited: function(text) {
                root.searchText = text
                root.searchTextChangedByUser(text)
            }

            onAccepted: function(text) {
                root.searchText = text
                root.searchTextChangedByUser(text)
            }
        }

        Button {
            text: "+"
            Layout.preferredWidth: 44
            Layout.preferredHeight: 40

            onClicked: root.addRequested()
        }
    }
}
