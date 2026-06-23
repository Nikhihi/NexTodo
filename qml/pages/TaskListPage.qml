import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../components" as MyComponents

Rectangle {
    id: root
    color: "#ffffff"
    signal selectChanged(string id)
    signal editTodo(string id)

    ListView {
        id: listView
        anchors {
            fill: parent
            leftMargin: 8
            rightMargin: 8
            topMargin: 6
            bottomMargin: 6
        }
        clip: true
        model: todoModel
        spacing: 6

        // ── 分组 ──────────────────────────────
        section.property: "dueGroup"
        section.criteria: ViewSection.FullString
        section.delegate: Rectangle {
            width: listView.width
            height: 40
            color: "transparent"
            RowLayout {
                anchors.fill: parent
                Label {
                    text: section
                    font.pixelSize: 18
                    font.bold: true
                    color: "#000000"
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: {
                        var count = todoModel ? todoModel.groupCount(section) : 0
                        return "当前显示" + count + "个"
                    }
                    font.pixelSize: 13
                    color: "#888888"
                }
            }
        }

        // ── 卡片 ──────────────────────────────
        delegate: MyComponents.TodoCard {
            id: card
            width: listView.width
            todoId: model.id
            title: model.title
            category: model.category
            priority: model.priority
            dueDate: model.dueDate
            completed: model.completed
            selected: listView.currentIndex === index ? true : false
            hovered: ma.containsMouse
            MouseArea {
                id: ma
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index
                    root.selectChanged(todoId)
                }
                hoverEnabled: true
            }
            onChangeCompleted: function(todoId, isCompleted) {
                // console.log("id:%1, status changed:%2"
                //     .arg(todoId)
                //     .arg(isCompleted ? "completed" : "active"))
                todoModel.toggleTodo(todoId)
            }
            onEditTodo: function(id) {
                root.editTodo(id)
            }
        }
    }
}
