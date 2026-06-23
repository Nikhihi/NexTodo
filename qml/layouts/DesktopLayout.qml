import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../pages" as Pages
import "../components" as MyComponents

Item {
    id: root

    property string searchText: ""

    signal addTodoRequested()
    signal searchTextChangedByUser(string text)

    signal signalEditTodo(string id)

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        MyComponents.AppHeader {
            id: header
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            searchText: root.searchText

            onAddRequested: root.addTodoRequested()
            onSearchTextChangedByUser: function(text) {
                root.searchText = text
                root.searchTextChangedByUser(text)
                todoModel.setFilterString(text)
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#e5e7eb"
        }
        MyComponents.FilterBar{
            id: filter
            Layout.fillWidth: true
            Layout.preferredHeight: 58

            totalNum: todoModel ? todoModel.totalNum : 0
            activeNum: todoModel ? todoModel.activeNum : 0
            completedNum: todoModel ? todoModel.completedNum : 0

            onFilterChanged: function(filterMode){
                todoModel.setFilterMode(filterMode)
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            //color: "#e5e7eb"
            color: "red"
        }

        Item {
            id: todoItem
            Layout.fillWidth: true
            Layout.fillHeight: true

            property string currentSelectedID: ""

            RowLayout {
                anchors.fill: parent
                Pages.TaskListPage {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 3
                    visible: true

                    onSelectChanged: function(id){
                        todoItem.currentSelectedID = id
                    }

                    onEditTodo: function(id){
                        root.signalEditTodo(id)
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    width: 1
                    color: "#d5dde9"
                }

                Pages.TaskDetailPage{
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true

                    detailTodoID: todoItem.currentSelectedID

                    onEditTodo: function(id){
                        root.signalEditTodo(id)
                    }
                    onRemoveTodo: function(id){
                        todoItem.currentSelectedID = ""
                        todoModel.removeTodo((id))
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#e5e7eb"
        }
        Label {
            Layout.fillWidth: true
            Layout.minimumHeight: 42
            font.pixelSize: 13
            padding: 20
            color: "#667085"
            text: "共" + (todoModel ? todoModel.totalNum : 0) + "个任务，"
                  + "已完成" + (todoModel ? todoModel.completedNum : 0) + "，"
                  + "进行中" + (todoModel ? todoModel.activeNum : 0) + "个"

            verticalAlignment: "AlignVCenter"
            background: Rectangle {
                color: "#ffffff"
            }
        }
    }
}
