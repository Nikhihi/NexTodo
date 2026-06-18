import QtQuick
import QtQuick.Controls
import "../components" as MyComponents

Item {
    id: root

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        model: todoModel


        delegate: MyComponents.TodoCard{
            width: listView.width

            title: model.title
        }
    }
}
