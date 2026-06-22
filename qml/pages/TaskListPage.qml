import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../components" as MyComponents

Rectangle {
    id: root
    color: "#ffffff"
    signal selectChanged(string id)

    ColumnLayout{
        id: layout
        anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 8
                    topMargin: 6
                    bottomMargin: 6
                }
        ListView {
            id: listView
            anchors.fill: parent
            clip: true
            model: todoModel
            spacing: 6
            property int hoverItem: -1

            delegate: MyComponents.TodoCard {
                id: card
                width: listView.width
                todoId: model.id
                title: model.title
                category: model.category
                priority: model.priority
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
                    console.log("id:%1, status changed:%2"
                        .arg(todoId)
                        .arg(isCompleted ? "completed" : "active"))
                    todoModel.toggleTodo(todoId)
                }


            }

        }
    }

}
