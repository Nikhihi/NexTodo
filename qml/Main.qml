import QtQuick
import QtQuick.Controls
import "layouts" as Layouts
import "components" as MyComponents

ApplicationWindow{
    id: mainWindow
    visible: true

    minimumWidth: 1180
    minimumHeight: 720

    readonly property bool isPhone: width < 600
    readonly property bool isTablet: width >= 600 && width < 1000
    readonly property bool isDesktop: width >= 1000

    Loader {
        anchors.fill: parent
        sourceComponent: mainWindow.isPhone ? phoneLayout
                                            : mainWindow.isDesktop
                                              ? desktopLayout
                                              : tabletLayout
    }

    MyComponents.AddTodoDialog {
        id: addTodoDialog
        anchors.centerIn: parent
        onAccepted: {
            todoModel.addTodo(title, category, priority, note, dueDate)
        }
    }

    Component {
        id: phoneLayout
        Layouts.PhoneLayout {
            anchors.fill: parent
        }
    }

    Component {
        id: tabletLayout
        Layouts.TabletLayout {
            anchors.fill: parent
        }
    }

    Component {
        id: desktopLayout
        Layouts.DesktopLayout {
            anchors.fill: parent

            //新建任务弹窗
            onAddTodoRequested: {
                addTodoDialog.editMode = false
                addTodoDialog.open()
            }

            onSignalEditTodo: function(id){
                addTodoDialog.editMode=true
                addTodoDialog.todoID = id
                addTodoDialog.open()
            }
        }
    }
}
