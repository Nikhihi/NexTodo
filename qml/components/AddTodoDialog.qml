import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root
    width: 430
    height: 630
    modal:true
    background: Rectangle {
        radius: 12
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            id: label
            text: "新建任务"
            Layout.fillWidth: true;
            font.pixelSize: 20
            font.weight: 780
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#e5e7eb"
        }
        Item {
            id: item
            Layout.fillHeight: true
        }
    }
}
