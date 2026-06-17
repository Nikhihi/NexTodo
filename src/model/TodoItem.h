#pragma once

#include <QString>
#include <QDateTime>
#include <QDate>


namespace NEX {
    struct TodoItem
    {
        QString id;
        QString title;
        QString category;
        QString priority;
        QString note;
        bool completed;
        QDateTime createdAt;
        QDate dueDate;
        TodoItem(){}
        TodoItem(const QString& id,
                 const QString& title,
                 const QString& category,
                 const QString& priority,
                 const QString& note,
                 const bool& completed,
                 const QDateTime& createdAt,
                 const QDate& dueDate) {
            this->id = id;
            this->title = title;
            this->category = category;
            this->priority = priority;
            this->note = note;
            this->completed = completed;
            this->createdAt = createdAt;
            this->dueDate = dueDate;
        }
    };
}
