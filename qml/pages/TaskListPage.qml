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

        delegate: MyComponents.TodoCard {
            width: listView.width

            todoId: model.id
            title: model.title
            category: model.category
            priority: model.priority
            completed: model.completed

            onChangeCompleted: function(todoId, isCompleted) {
                console.log("id:%1, status changed:%2"
                    .arg(todoId)
                    .arg(isCompleted ? "completed" : "active"))
                todoModel.toggleTodo(todoId)
            }
        }
    }
}
