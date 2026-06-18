#pragma once

#include "TodoItem.h"
#include <QObject>
#include <QAbstractListModel>
#include <QList>

class TodoModel : public QAbstractListModel
{
    Q_OBJECT
signals:
    void countChanged();
public:
    Q_PROPERTY(int totalNum READ totalCount  NOTIFY countChanged)
    Q_PROPERTY(int activeNum READ activeCount  NOTIFY countChanged)
    Q_PROPERTY(int completedNum READ completedCount  NOTIFY countChanged)

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

    Q_INVOKABLE int totalCount() const;
    Q_INVOKABLE int activeCount() const;
    Q_INVOKABLE int completedCount() const;

private:
    int indexOfTodo(const QString& id) const;
    QString dueGroupFor(const NEX::TodoItem& item) const;

    QList<NEX::TodoItem> m_todoItems;
};
