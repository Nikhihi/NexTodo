#pragma once

#include "TodoItem.h"
#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QVariantMap>
#include "../storage/TodoStorage.h"

class TodoModel : public QAbstractListModel
{
    Q_OBJECT
signals:
    void countChanged();

    void filterModeChanged();
    void sortModeChanged();
    void dataVersionChanged();
public:
    Q_PROPERTY(int totalNum READ totalCount  NOTIFY countChanged)
    Q_PROPERTY(int activeNum READ activeCount  NOTIFY countChanged)
    Q_PROPERTY(int completedNum READ completedCount  NOTIFY countChanged)

    //筛选模式
    Q_PROPERTY(QString filterMode READ filterMode WRITE setFilterMode NOTIFY filterModeChanged)

    //排序模式
    Q_PROPERTY(QString sortMode READ sortMode WRITE setSortMode NOTIFY sortModeChanged)

    //数据版本号，任何增删改都+1，用于 QML 刷新绑定
    Q_PROPERTY(int dataVersion READ dataVersion NOTIFY dataVersionChanged)

    enum Roles{
        IdRole = Qt::UserRole + 1,
        TitleRole,
        CategoryRole,
        PriorityRole,
        NoteRole,
        CompletedRole,
        CreatedAtRole,
        DueDateRole,
        DueGroupRole
    };

    explicit TodoModel(QObject *parent =  nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addTodo(
        const QString& title,
        const QString& category,
        const QString& priority,
        const QString& note,
        const QDate& dueDate
    );

    Q_INVOKABLE void updateTodo(
        const QString& id,
        const QString& title,
        const QString& category,
        const QString& priority,
        const QString& note,
        const QDate& dueDate
    );

    Q_INVOKABLE void removeTodo(const QString& id);
    Q_INVOKABLE void toggleTodo(const QString& id);

    int dataVersion() const;
    Q_INVOKABLE int totalCount() const;
    Q_INVOKABLE int activeCount() const;
    Q_INVOKABLE int completedCount() const;

    Q_INVOKABLE QString filterMode() const;

    /**
     * @brief setFilterMode 设置筛选模式
     * @param filterMode total、completed、active
     */
    Q_INVOKABLE void setFilterMode(const QString& filterMode);

    Q_INVOKABLE QString sortMode() const;

    /**
     * @brief setSortMode 设置排序模式
     * @param sortMode createdAtDesc、createdAtAsc、priority、completedLast
     */
    Q_INVOKABLE void setSortMode(const QString& sortMode);

    /**
     * @brief setFilterString 设置筛选字段
     * @param filterString
     */
    Q_INVOKABLE void setFilterString(const QString& filterString);

    /**
     * @brief getTodoMap 获取指定ID的任务详情
     * @param id 任务ID
     * @return 详细信息
     */
    Q_INVOKABLE QVariantMap getTodoMap(const QString & id);

    /**
     * @brief groupCount 获取指定分组中（符合当前筛选条件）的任务数量
     * @param group 分组名（已过期/今天/明天/以后/无日期/已完成）
     */
    Q_INVOKABLE int groupCount(const QString& group) const;

private:
    bool matchesFilter(const NEX::TodoItem& item) const;

    const NEX::TodoItem * itemForVisibleRow(int row) const;

private:
    int indexOfTodo(const QString& id) const;
    QString dueGroupFor(const NEX::TodoItem& item) const;
    int groupSortOrder(const QString& group) const;
    void sortItems();

    QList<NEX::TodoItem> m_todoItems;

    QString m_filterMode{"total"};
    QString m_filterString{""};
    QString m_sortMode{"completedLast"};
    int m_dataVersion{0};

    TodoStorage m_todoStorage;
};
