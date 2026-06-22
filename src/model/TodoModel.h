#pragma once

#include "TodoItem.h"
#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QVariantMap>

class TodoModel : public QAbstractListModel
{
    Q_OBJECT
signals:
    void countChanged();

    void filterModeChanged();
    void dataVersionChanged();
public:
    Q_PROPERTY(int totalNum READ totalCount  NOTIFY countChanged)
    Q_PROPERTY(int activeNum READ activeCount  NOTIFY countChanged)
    Q_PROPERTY(int completedNum READ completedCount  NOTIFY countChanged)

    //筛选模式
    Q_PROPERTY(QString filterMode READ filterMode WRITE setFilterMode NOTIFY filterModeChanged)

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

    Q_INVOKABLE void setFilterMode(const QString& filterMode);

    /**
     * @brief getTodoMap 获取指定ID的任务详情
     * @param id 任务ID
     * @return 详细信息
     */
    Q_INVOKABLE QVariantMap getTodoMap(const QString & id);

private:
    bool matchesFilter(const NEX::TodoItem& item) const;

    const NEX::TodoItem * itemForVisibleRow(int row) const;

private:
    int indexOfTodo(const QString& id) const;
    QString dueGroupFor(const NEX::TodoItem& item) const;

    QList<NEX::TodoItem> m_todoItems;

    QString m_filterMode{"total"};
    int m_dataVersion{0};
};
