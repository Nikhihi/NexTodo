import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent
    RowLayout {
        spacing: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 12

        Button {
            id: totalBtn
            Layout.preferredWidth: 80
            Layout.preferredHeight: 36
            //radius: 8
        }
        Button {
            id: activeBtn
            Layout.preferredWidth: 80
            Layout.preferredHeight: 36
            //radius: 8
        }
        Button {
            id: completedBtn
            Layout.preferredWidth: 80
            Layout.preferredHeight: 36
            //radius:8
        }
    }
}
