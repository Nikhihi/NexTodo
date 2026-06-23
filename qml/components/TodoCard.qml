import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml

Rectangle {
    id: root

    property string todoId: ""
    property string title: ""
    property string category: ""
    property string priority: ""
    property date dueDate: new Date()
    property bool completed: false
    property bool selected: false
    property bool hovered: false

    width: ListView.view ? ListView.view.width : 320
    height: 76
    radius: 8
    border.width: 2
    border.color: selected ?  "#93b4ff" : "#d8e0ec"
    color: hovered ? "#f9fbff" : "white"

    //修改完成情况信号
    signal changeCompleted(string todoId, bool isCompleted)

    //编辑信号
    signal editTodo(string todoId)

    RowLayout {
        z: 1  // 高于外部 MouseArea，确保内部按钮可点击
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        //完成按钮
        AbstractButton {
            id: completedButton
            Layout.preferredHeight: 28
            Layout.preferredWidth: 28
            Layout.alignment: Qt.AlignVCenter
            checkable: true
            checked: root.completed

            background: Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: completedButton.checked ? "#22c55e" : "#ffffff"
                border.width: 2
                border.color: completedButton.checked ? "#22c55e" : "#cbd5e1"
            }

            contentItem: Text {
                text: completedButton.checked ? "\u2713" : ""
                color: "#ffffff"
                font.pixelSize: 14
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                root.changeCompleted(root.todoId, completedButton.checked)
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 8

            Label {
                Layout.fillWidth: true
                text: root.title
                color: root.completed ? "#7b8798" : "#172033"
                font.pixelSize: 15
                font.weight: 730
                elide: Text.ElideRight
                font.strikeout: root.completed
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 22
                spacing: 6

                Label {
                    id: categoryLabel
                    Layout.preferredHeight: 22
                    Layout.alignment: Qt.AlignVCenter
                    leftPadding: 8
                    rightPadding: 8
                    topPadding: 0
                    bottomPadding: 0
                    text: "分类:" + root.category
                    color: "#667085"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    background: Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: "#f8fafc"
                        border.width: 1
                        border.color: "#e4eaf3"
                    }
                }

                Label {
                    id: priorityLabel
                    Layout.preferredHeight: 22
                    Layout.alignment: Qt.AlignVCenter
                    leftPadding: 8
                    rightPadding: 8
                    topPadding: 0
                    bottomPadding: 0
                    text: "优先级:" + root.priority
                    color: "#db2525"

                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    background: Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: root.priority==="高" ? "#feeceb" : root.priority==="中" ? "#fff4d6" : "#e8f7ee"
                        border.width: 1
                        border.color: "#e4eaf3"
                    }
                }

                Label {
                    id: dueDateLabel
                    Layout.preferredHeight: 22
                    Layout.alignment: Qt.AlignVCenter
                    leftPadding: 8
                    rightPadding: 8
                    topPadding: 0
                    bottomPadding: 0
                    text: "计划完成:" + Qt.formatDate(dueDate, "yyyy-MM-dd")
                    color: "#667085"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    background: Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: "#f8fafc"
                        border.width: 1
                        border.color: "#e4eaf3"
                    }
                }


                Item {
                    Layout.fillWidth: true
                }
            }
        }

        //更多操作按钮
        AbstractButton {
            id: editTodoBtn
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            text: "···"

            background: Rectangle {
                anchors.fill: parent
                radius: 8
                color: "#f6f8fb"
                border.width: 1
                border.color: "#d8e0ec"
            }
            contentItem: Text {
                text: editTodoBtn.text
                color: "#656f84"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
            }
            onClicked: root.editTodo(root.todoId)
        }

    }
}
