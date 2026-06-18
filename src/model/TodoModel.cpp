#include "TodoModel.h"
#include <QUuid>
#include <QDateTime>


TodoModel::TodoModel(QObject *parent) : QAbstractListModel(parent)
{
    {
        NEX::TodoItem item("1", "学习1", "123", "高", "xxxx",
                           false, QDateTime::currentDateTime(), QDate::currentDate());
        m_todoItems.append(item);
    }
    {
        NEX::TodoItem item("2", "学习2", "123", "高", "hhhhh",
                           false, QDateTime::currentDateTime(), QDate::currentDate().addDays(1));
        m_todoItems.append(item);
    }
}

int TodoModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_todoItems.size();
}

QVariant TodoModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_todoItems.size()) {
        return {};
    }

    const auto &item = m_todoItems.at(index.row());
    switch (role) {
    case IdRole:
        return item.id;
    case TitleRole:
        return item.title;
    case CategoryRole:
        return item.category;
    case PriorityRole:
        return item.priority;
    case NoteRole:
        return item.note;
    case CompletedRole:
        return item.completed;
    case CreatedAtRole:
        return item.createdAt.toString(Qt::ISODate);
    case DueDateRole:
        return item.dueDate.isValid() ? item.dueDate.toString(Qt::ISODate) : QString();
    case DueGroupRole:
        return dueGroupFor(item);
    default:
        return {};
    }
}

QHash<int, QByteArray> TodoModel::roleNames() const
{
    return {
        { IdRole, "id" },
        { TitleRole, "title" },
        { CategoryRole, "category" },
        { PriorityRole, "priority" },
        { NoteRole, "note" },
        { CompletedRole, "completed" },
        { CreatedAtRole, "createdAt" },
        { DueDateRole, "dueDate" },
        { DueGroupRole, "dueGroup" },
    };
}

void TodoModel::addTodo(const QString &title, const QString &category, const QString &priority, const QString &note, const QDate &dueDate)
{
    auto id = QUuid::createUuid().toString(QUuid::WithoutBraces);
    auto currentTime = QDateTime::currentDateTime();
    NEX::TodoItem item(id, title, category, priority, note,
                       false, currentTime, dueDate);

    const int row = m_todoItems.size();
    beginInsertRows(QModelIndex(), row, row);
    m_todoItems.append(item);
    endInsertRows();
}

void TodoModel::updateTodo(const QString &id, const QString &title, const QString &category, const QString &priority, const QString &note, const QDate &dueDate)
{
    const int row = indexOfTodo(id);
    if (row < 0) {
        return;
    }

    auto &item = m_todoItems[row];
    item.title = title;
    item.category = category;
    item.priority = priority;
    item.note = note;
    item.dueDate = dueDate;

    const auto modelIndex = index(row, 0);
    emit dataChanged(modelIndex, modelIndex, {
        TitleRole,
        CategoryRole,
        PriorityRole,
        NoteRole,
        DueDateRole,
        DueGroupRole
    });
}

void TodoModel::removeTodo(const QString &id)
{
    const int row = indexOfTodo(id);
    if (row < 0) {
        return;
    }

    beginRemoveRows(QModelIndex(), row, row);
    m_todoItems.removeAt(row);
    endRemoveRows();
}

void TodoModel::toggleTodo(const QString &id)
{
    const int row = indexOfTodo(id);
    if (row < 0) {
        return;
    }

    auto &item = m_todoItems[row];
    item.completed = !item.completed;

    const auto modelIndex = index(row, 0);
    //必须发才会通知qml里 数据改变了
    //“第 row 行的数据变了，变的是 completed 和 dueGroup 这两个 role。”
    emit dataChanged(modelIndex, modelIndex, { CompletedRole, DueGroupRole });
    emit countChanged();
}

int TodoModel::totalCount() const
{
    return m_todoItems.size();
}

int TodoModel::activeCount() const
{
    int activeNum = 0;
    for(auto &item : m_todoItems){
        if(!item.completed)
            activeNum++;
    }
    return activeNum;
}

int TodoModel::completedCount() const
{
    int completedCount = 0;
    for(auto &item : m_todoItems){
        if(item.completed)
            completedCount++;
    }
    return completedCount;
}

int TodoModel::indexOfTodo(const QString &id) const
{
    for (int i = 0; i < m_todoItems.size(); ++i) {
        if (m_todoItems.at(i).id == id) {
            return i;
        }
    }

    return -1;
}

QString TodoModel::dueGroupFor(const NEX::TodoItem &item) const
{
    if (item.completed) {
        return QStringLiteral("已完成");
    }

    if (!item.dueDate.isValid()) {
        return QStringLiteral("无日期");
    }

    const QDate today = QDate::currentDate();
    if (item.dueDate < today) {
        return QStringLiteral("已过期");
    }
    if (item.dueDate == today) {
        return QStringLiteral("今天");
    }
    if (item.dueDate == today.addDays(1)) {
        return QStringLiteral("明天");
    }

    return QStringLiteral("以后");
}
