import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    Rectangle {
        width: parent.width
        height: 58
        color: "#fbfdff"
        RowLayout {
            spacing: 10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 12

            ButtonGroup { id: btnGroup}
            AbstractButton {
                id: totalBtn
                Layout.preferredWidth: 80
                Layout.preferredHeight: 36
                leftPadding: 13
                rightPadding: 13
                topPadding: 0
                bottomPadding: 0
                checkable: true
                hoverEnabled: true
                ButtonGroup.group: btnGroup
                text: "全部"
                background: Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: totalBtn.checked ? "#e8f0ff" : totalBtn.hovered ? "#f6f8fb" : "transparent"
                    border.width: 1
                    border.color: totalBtn.checked ? "#bdd0ff" : totalBtn.hovered ? "#d8e0ec" : "transparent"
                }
                contentItem: Text {
                    text: totalBtn.text
                    color: totalBtn.checked ? "#2563eb":"#667085";
                    font.pixelSize: 14
                    font.weight: 650
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            AbstractButton {
                id: activeBtn
                Layout.preferredWidth: 80
                Layout.preferredHeight: 36
                leftPadding: 13
                rightPadding: 13
                topPadding: 0
                bottomPadding: 0
                checkable: true
                hoverEnabled: true
                ButtonGroup.group: btnGroup
                text: "进行中"
                background: Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: activeBtn.checked ? "#e8f0ff" : activeBtn.hovered ? "#f6f8fb" : "transparent"
                    border.width: 1
                    border.color: activeBtn.checked ? "#bdd0ff" : activeBtn.hovered ? "#d8e0ec" : "transparent"
                }
                contentItem: Text {
                    text: activeBtn.text
                    color: activeBtn.checked ? "#2563eb":"#667085";
                    font.pixelSize: 14
                    font.weight: 650
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            AbstractButton {
                id: completedBtn
                Layout.preferredWidth: 80
                Layout.preferredHeight: 36
                leftPadding: 13
                rightPadding: 13
                topPadding: 0
                bottomPadding: 0
                checkable: true
                hoverEnabled: true
                ButtonGroup.group: btnGroup
                text: "已完成"
                background: Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: completedBtn.checked ? "#e8f0ff" : completedBtn.hovered ? "#f6f8fb" : "transparent"
                    border.width: 1
                    border.color: completedBtn.checked ? "#bdd0ff" : completedBtn.hovered ? "#d8e0ec" : "transparent"
                }
                contentItem: Text {
                    text: completedBtn.text
                    color: completedBtn.checked ? "#2563eb":"#667085";
                    font.pixelSize: 14
                    font.weight: 650
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }


            Item {
                id: emptyItem
                Layout.fillWidth: true
            }
            Label {
                id: label
                Layout.preferredHeight: 36
                Layout.preferredWidth: 60
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "排序"
                font.pixelSize: 12
                color: "#889098";
            }
            ComboBox{
                id: comboBox
                Layout.preferredWidth: 100
                Layout.preferredHeight: 36
                leftPadding: 12
                rightPadding: 30
                contentItem: Text {
                    text: comboBox.displayText
                    color: "#667085"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                indicator: Text {
                    x: comboBox.width - width - 12
                    y: (comboBox.height - height) / 2
                    text: "v"
                    color: "#667085"
                    font.pixelSize: 10
                }
                model: ["最近更新", "昨天"]
                background: Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    //color: completedBtn.checked ? "#e8f0ff" : completedBtn.hovered ? "#f6f8fb" : "transparent"
                    border.width: 1
                    border.color: "#e8f0ff"
                }
            }


        }
    }
}
