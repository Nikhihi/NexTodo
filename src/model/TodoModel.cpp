#include "TodoModel.h"
#include <QUuid>
#include <QDateTime>
#include <algorithm>


TodoModel::TodoModel(QObject *parent) : QAbstractListModel(parent)
{
    m_todoItems = m_todoStorage.loadTodos();
    sortItems();
}

int TodoModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    int count = 0;
    for(const NEX::TodoItem &item : m_todoItems){
        if(matchesFilter(item))
            ++count;
    }

    return count;
}

QVariant TodoModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_todoItems.size()) {
        return {};
    }

    const NEX::TodoItem * item = itemForVisibleRow(index.row());
    switch (role) {
    case IdRole:
        return item->id;
    case TitleRole:
        return item->title;
    case CategoryRole:
        return item->category;
    case PriorityRole:
        return item->priority;
    case NoteRole:
        return item->note;
    case CompletedRole:
        return item->completed;
    case CreatedAtRole:
        return item->createdAt.toString(Qt::ISODate);
    case DueDateRole:
        return item->dueDate.isValid() ? item->dueDate.toString(Qt::ISODate) : QString();
    case DueGroupRole:
        return dueGroupFor(*item);
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

    beginResetModel();
    m_todoItems.append(item);
    sortItems();
    endResetModel();
    m_dataVersion++;
    emit dataVersionChanged();
    m_todoStorage.saveTodos(m_todoItems);
}

void TodoModel::updateTodo(const QString &id, const QString &title, const QString &category, const QString &priority, const QString &note, const QDate &dueDate)
{
    const int row = indexOfTodo(id);
    if (row < 0) {
        return;
    }

    auto &item = m_todoItems[row];
    const QString oldGroup = dueGroupFor(item);

    item.title = title;
    item.category = category;
    item.priority = priority;
    item.note = note;
    item.dueDate = dueDate;

    if (dueGroupFor(item) != oldGroup) {
        beginResetModel();
        sortItems();
        endResetModel();
    } else {
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
    m_dataVersion++;
    emit dataVersionChanged();

    m_todoStorage.saveTodos(m_todoItems);
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
    m_dataVersion++;
    emit dataVersionChanged();

    m_todoStorage.saveTodos(m_todoItems);
}

void TodoModel::toggleTodo(const QString &id)
{
    const int row = indexOfTodo(id);
    if (row < 0) {
        return;
    }

    auto &item = m_todoItems[row];
    const QString oldGroup = dueGroupFor(item);
    item.completed = !item.completed;

    if (dueGroupFor(item) != oldGroup) {
        beginResetModel();
        sortItems();
        endResetModel();
    } else {
        const auto modelIndex = index(row, 0);
        emit dataChanged(modelIndex, modelIndex, { CompletedRole, DueGroupRole });
    }
    emit countChanged();
    m_dataVersion++;
    emit dataVersionChanged();

    m_todoStorage.saveTodos(m_todoItems);
}

int TodoModel::totalCount() const
{
    return m_todoItems.size();
}

int TodoModel::dataVersion() const
{
    return m_dataVersion;
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

QString TodoModel::filterMode() const
{
    return m_filterMode;
}

void TodoModel::setFilterMode(const QString &filterMode)
{
    if (m_filterMode == filterMode)
            return;

    beginResetModel();
    m_filterMode = filterMode;
    endResetModel();

    emit filterModeChanged();
}

QString TodoModel::sortMode() const
{
    return m_sortMode;
}

void TodoModel::setSortMode(const QString &sortMode)
{
    if (m_sortMode == sortMode)
        return;

    beginResetModel();
    m_sortMode = sortMode;
    sortItems();
    endResetModel();

    emit sortModeChanged();
}

void TodoModel::setFilterString(const QString &filterString)
{
    if(m_filterString == filterString)
        return;
    beginResetModel();
    m_filterString = filterString;
    endResetModel();

    emit filterModeChanged();
}

QVariantMap TodoModel::getTodoMap(const QString &id)
{
    QVariantMap _map;
    for(auto &i : m_todoItems){
        if(i.id == id){
            _map.insert("title", i.title);
            _map.insert("note", i.note);
            _map.insert("category", i.category);
            _map.insert("priority", i.priority);
            _map.insert("completed", i.completed);
            _map.insert("dueDate", i.dueDate);
            _map.insert("createdAt", i.createdAt);
            break;
        }
    }
    return _map;
}

bool TodoModel::matchesFilter(const NEX::TodoItem &item) const
{
    if(m_filterMode == "completed")
        return item.completed && item.title.contains(m_filterString);

    if(m_filterMode == "active")
        return !item.completed && item.title.contains(m_filterString);
    return item.title.contains(m_filterString);
}

const NEX::TodoItem * TodoModel::itemForVisibleRow(int row) const
{
    int visibleRow = 0;

    for (const auto &item : m_todoItems) {
        if (!matchesFilter(item))
            continue;

        if (visibleRow == row)
            return &item;

        ++visibleRow;
    }

    return nullptr;
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

int TodoModel::groupSortOrder(const QString &group) const
{
    if (group == QStringLiteral("已过期")) return 0;
    if (group == QStringLiteral("今天"))   return 1;
    if (group == QStringLiteral("明天"))   return 2;
    if (group == QStringLiteral("以后"))   return 3;
    if (group == QStringLiteral("无日期")) return 4;
    if (group == QStringLiteral("已完成")) return 5;
    return 6;
}

static int priorityOrder(const QString &priority)
{
    if (priority == QStringLiteral("高")) return 0;
    if (priority == QStringLiteral("中")) return 1;
    if (priority == QStringLiteral("低")) return 2;
    return 3;
}

void TodoModel::sortItems()
{
    std::stable_sort(m_todoItems.begin(), m_todoItems.end(),
        [this](const NEX::TodoItem &a, const NEX::TodoItem &b) {
            // 第1级：分组优先级（永远不动）
            int orderA = groupSortOrder(dueGroupFor(a));
            int orderB = groupSortOrder(dueGroupFor(b));
            if (orderA != orderB)
                return orderA < orderB;

            // 第2级：组内按用户选择的排序方式
            if (m_sortMode == QStringLiteral("createdAtDesc")) {
                return a.createdAt > b.createdAt;   // 最近创建在前
            }
            if (m_sortMode == QStringLiteral("createdAtAsc")) {
                return a.createdAt < b.createdAt;   // 最早创建在前
            }
            if (m_sortMode == QStringLiteral("priority")) {
                int pA = priorityOrder(a.priority);
                int pB = priorityOrder(b.priority);
                if (pA != pB) return pA < pB;       // 高→中→低
                // 同级优先级按截止日期
                if (a.dueDate.isValid() && b.dueDate.isValid())
                    return a.dueDate < b.dueDate;
                if (a.dueDate.isValid() != b.dueDate.isValid())
                    return a.dueDate.isValid();
                return a.createdAt < b.createdAt;
            }
            // 默认 completedLast：按截止日期升序，无日期排最后
            if (a.dueDate.isValid() && b.dueDate.isValid())
                return a.dueDate < b.dueDate;
            if (a.dueDate.isValid() != b.dueDate.isValid())
                return a.dueDate.isValid();
            return a.createdAt < b.createdAt;
        });
}

int TodoModel::groupCount(const QString &group) const
{
    int count = 0;
    for (const auto &item : m_todoItems) {
        if (dueGroupFor(item) == group && matchesFilter(item))
            ++count;
    }
    return count;
}
