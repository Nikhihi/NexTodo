import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#ffffff"

    property string detailTodoID: ""

    // dataVersion 确保 TodoModel 内部变更时重新求值
    property var todoData: {
        var _ = todoModel.dataVersion
        return detailTodoID ? todoModel.getTodoMap(detailTodoID) : ({})
    }

    // ---- 空状态 ----
    Label {
        anchors.centerIn: parent
        text: "选择左侧任务查看详情"
        color: "#94a3b8"
        font.pixelSize: 15
        visible: !detailTodoID
    }

    // ---- 详情内容 ----
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16
        visible: !!detailTodoID

        // 标题
        Label {
            Layout.fillWidth: true
            text: todoData.title || ""
            font.pixelSize: 22
            font.weight: 700
            color: todoData.completed ? "#94a3b8" : "#172033"
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
        }

        // 日期 + 状态标签
        RowLayout {
            spacing: 12

            Label {
                text: {
                    if (!todoData.dueDate) return ""
                    var d = new Date(todoData.dueDate)
                    return d.toLocaleDateString(Qt.locale(), "yyyy-MM-dd")
                }
                font.pixelSize: 13
                color: "#667085"
                visible: text !== ""
            }

            Rectangle {
                radius: 10
                color: todoData.completed ? "#e8f0ff" : "#fef3c7"
                implicitWidth: statusLabel.implicitWidth + 16
                implicitHeight: 24

                Label {
                    id: statusLabel
                    anchors.centerIn: parent
                    text: todoData.completed ? "已完成" : "进行中"
                    font.pixelSize: 12
                    color: todoData.completed ? "#2563eb" : "#d97706"
                }
            }
        }

        // 分类 + 优先级
        RowLayout {
            spacing: 8
            visible: !!todoData.category || !!todoData.priority

            Rectangle {
                radius: 10
                color: "#f8fafc"
                border.width: 1
                border.color: "#e4eaf3"
                implicitWidth: catLabel.implicitWidth + 16
                implicitHeight: 24
                visible: !!todoData.category

                Label {
                    id: catLabel
                    anchors.centerIn: parent
                    text: "分类: " + (todoData.category || "")
                    font.pixelSize: 12
                    color: "#667085"
                }
            }

            Rectangle {
                radius: 10
                color: "#f8fafc"
                border.width: 1
                border.color: "#e4eaf3"
                implicitWidth: priLabel.implicitWidth + 16
                implicitHeight: 24
                visible: !!todoData.priority

                Label {
                    id: priLabel
                    anchors.centerIn: parent
                    text: "优先级: " + (todoData.priority || "")
                    font.pixelSize: 12
                    color: todoData.priority === "高" ? "#dc2626"
                         : todoData.priority === "中" ? "#d97706"
                         : "#16a34a"
                }
            }
        }

        // 分割线
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#e4eaf3"
        }

        // 备注
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Label {
                text: "备注"
                font.pixelSize: 13
                font.weight: 600
                color: "#475569"
            }

            Label {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                text: todoData.note || ""
                font.pixelSize: 14
                color: "#334155"
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignTop
                lineHeight: 1.5
            }
        }

        Item { Layout.fillHeight: true }

        // 底部创建时间
        Label {
            Layout.fillWidth: true
            text: todoData.createdAt
                  ? "创建于 " + new Date(todoData.createdAt).toLocaleDateString(Qt.locale(), "yyyy-MM-dd hh:mm")
                  : ""
            font.pixelSize: 11
            color: "#94a3b8"
            horizontalAlignment: Text.AlignRight
        }
    }
}
