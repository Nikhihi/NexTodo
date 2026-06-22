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
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            //color: "#e5e7eb"
            color: "red"
        }
        MyComponents.FilterBar{
            id: filter
            Layout.fillWidth: true
            Layout.preferredHeight: 58

            totalNum: todoModel.totalNum
            activeNum: todoModel.activeNum
            completedNum: todoModel.completedNum

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
                        console.log("currentSelectedID:", id)
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
                }
            }


        }
    }
}
