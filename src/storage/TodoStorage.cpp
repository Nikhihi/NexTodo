#include "TodoStorage.h"
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QCoreApplication>
#include <QDebug>

TodoStorage::TodoStorage(QObject *parent)
    : QObject(parent)
{
}

QString TodoStorage::storagePath() const
{
    const QString dir = QCoreApplication::applicationDirPath();
    QDir().mkpath(dir);
    qDebug()<< dir;
    return dir + QStringLiteral("/todos.json");
}

QList<NEX::TodoItem> TodoStorage::loadTodos()
{
    QList<NEX::TodoItem> items;

    QFile file(storagePath());
    if (!file.open(QIODevice::ReadOnly)) {
        return items;
    }

    const QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    file.close();

    const QJsonArray array = doc.array();
    for (const QJsonValue &val : array) {
        const QJsonObject obj = val.toObject();

        NEX::TodoItem item;
        item.id        = obj.value("id").toString();
        item.title     = obj.value("title").toString();
        item.category  = obj.value("category").toString();
        item.priority  = obj.value("priority").toString();
        item.note      = obj.value("note").toString();
        item.completed = obj.value("completed").toBool();
        item.createdAt = QDateTime::fromString(obj.value("createdAt").toString(), Qt::ISODate);
        item.dueDate   = QDate::fromString(obj.value("dueDate").toString(), Qt::ISODate);

        items.append(item);
    }

    return items;
}

void TodoStorage::saveTodos(const QList<NEX::TodoItem> &todos)
{
    QJsonArray array;
    for (const NEX::TodoItem &item : todos) {
        QJsonObject obj;
        obj["id"]        = item.id;
        obj["title"]     = item.title;
        obj["category"]  = item.category;
        obj["priority"]  = item.priority;
        obj["note"]      = item.note;
        obj["completed"] = item.completed;
        obj["createdAt"] = item.createdAt.toString(Qt::ISODate);
        obj["dueDate"]   = item.dueDate.toString(Qt::ISODate);

        array.append(obj);
    }

    QFile file(storagePath());
    if (file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        file.write(QJsonDocument(array).toJson());
        file.close();
    }
}
