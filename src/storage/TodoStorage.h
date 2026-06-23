#pragma once

#include "../model/TodoItem.h"
#include <QObject>
#include <QList>
#include <QString>

class TodoStorage : public QObject
{
    Q_OBJECT

public:
    explicit TodoStorage(QObject *parent = nullptr);

    QList<NEX::TodoItem> loadTodos();
    void saveTodos(const QList<NEX::TodoItem> &todos);

private:
    QString storagePath() const;
};
