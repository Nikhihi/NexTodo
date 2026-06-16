# NexTodo 开发设计文档

NexTodo 是一个用于练习 QML + C++ 的任务管理项目。项目目标不是做复杂功能，而是完整走通一个真实小应用的结构：QML 负责界面和交互，C++ 负责数据模型、业务逻辑和本地保存。

## 1. 项目目标

第一版目标：

- 显示任务列表
- 添加任务
- 编辑任务
- 删除任务
- 切换完成状态
- 搜索任务
- 按状态筛选：全部、进行中、已完成
- 支持任务日期：今天、明天、以后、无日期、已过期
- 启动时读取本地 JSON
- 数据变化后保存到本地 JSON

后续扩展目标：

- 支持桌面、平板、手机布局
- 支持日期选择器
- 支持任务提醒
- 支持重复任务
- 支持 SQLite 存储
- 支持 Android 打包

## 2. 技术结构

推荐使用 Qt Quick + C++：

```text
-----------------------------+
| QML 界面层                  |
| Main.qml                    |
| TodoCard.qml                |
| AddTodoDialog.qml           |
| DetailPanel.qml             |
+-------------+---------------+
              |
              | 调用 Q_INVOKABLE 方法
              v
+-------------+---------------+
| C++ 数据层                   |
| TodoModel                    |
| TodoStorage                  |
| TodoItem                     |
+-------------+---------------+
              |
              | 读写 JSON
              v
+-------------+---------------+
| 本地存储                     |
| todos.json                   |
+-----------------------------+
```

QML 不直接操作文件，所有数据增删改查都通过 C++ 完成。

## 3. 推荐目录结构

```text
NexTodo/
├─ CMakeLists.txt
├─ main.cpp
├─ src/
│  ├─ model/
│  │  ├─ TodoItem.h
│  │  ├─ TodoModel.h
│  │  └─ TodoModel.cpp
│  └─ storage/
│     ├─ TodoStorage.h
│     └─ TodoStorage.cpp
├─ qml/
│  ├─ Main.qml
│  ├─ layouts/
│  │  ├─ DesktopLayout.qml
│  │  ├─ TabletLayout.qml
│  │  └─ PhoneLayout.qml
│  ├─ pages/
│  │  ├─ TaskListPage.qml
│  │  ├─ TaskDetailPage.qml
│  │  └─ EditTaskPage.qml
│  ├─ components/
│  │  ├─ TodoCard.qml
│  │  ├─ FilterBar.qml
│  │  ├─ SearchBox.qml
│  │  ├─ PrioritySelector.qml
│  │  ├─ DateSelector.qml
│  │  ├─ AddTodoDialog.qml
│  │  ├─ ConfirmDialog.qml
│  │  └─ EmptyState.qml
│  └─ styles/
│     └─ Theme.qml
├─ docs/
│  ├─ NexTodo开发设计文档.md
│  └─ design/
│     └─ nex-todo-responsive-prototype.html
└─ data/
   └─ todos.json
```

开发阶段可以先把 JSON 放在 `data/todos.json`。正式一些时，建议使用：

```cpp
QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
```

这样桌面和 Android 都能正确保存数据。

## 4. 数据模型设计

### 4.1 TodoItem

每个任务建议包含这些字段：

```cpp
struct TodoItem {
    QString id;
    QString title;
    QString category;
    QString priority;
    QString note;
    bool completed;
    QDateTime createdAt;
    QDate dueDate;
};
```

字段说明：

| 字段 | 类型 | 说明 |
|---|---|---|
| `id` | `QString` | 任务唯一 ID |
| `title` | `QString` | 任务标题 |
| `category` | `QString` | 分类，例如学习、编程、UI、生活 |
| `priority` | `QString` | 优先级：低、中、高 |
| `note` | `QString` | 备注 |
| `completed` | `bool` | 是否完成 |
| `createdAt` | `QDateTime` | 创建时间 |
| `dueDate` | `QDate` | 计划日期或截止日期，可为空 |

### 4.2 日期字段设计

`createdAt` 和 `dueDate` 不要混用。

```text
createdAt：任务创建时间，系统自动生成
dueDate：任务计划在哪天做，由用户选择
```

示例：

```text
今天创建了一个任务，但计划明天做：
createdAt = 2026-06-17 10:30
dueDate   = 2026-06-18
```

如果用户没有选择日期，`dueDate` 可以为空。

## 5. TodoModel 设计

`TodoModel` 继承 `QAbstractListModel`，暴露给 QML 使用。

### 5.1 Roles

```cpp
enum TodoRoles {
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
```

角色说明：

| Role | QML 名称 | 说明 |
|---|---|---|
| `IdRole` | `id` | 任务 ID |
| `TitleRole` | `title` | 标题 |
| `CategoryRole` | `category` | 分类 |
| `PriorityRole` | `priority` | 优先级 |
| `NoteRole` | `note` | 备注 |
| `CompletedRole` | `completed` | 是否完成 |
| `CreatedAtRole` | `createdAt` | 创建时间字符串 |
| `DueDateRole` | `dueDate` | 日期字符串 |
| `DueGroupRole` | `dueGroup` | 日期分组，例如今天、明天、无日期 |

### 5.2 暴露给 QML 的方法

```cpp
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
```

第一版可以先用 `QString dueDate`，例如 `"2026-06-18"`，等熟悉后再改成 `QDate`。

## 6. JSON 数据格式

推荐保存为数组：

```json
[
  {
    "id": "todo-001",
    "title": "学习 QML ListView",
    "category": "学习",
    "priority": "中",
    "note": "练习 delegate 和 model",
    "completed": false,
    "createdAt": "2026-06-17T09:30:00",
    "dueDate": "2026-06-17"
  },
  {
    "id": "todo-002",
    "title": "完成 C++ Model 练习",
    "category": "编程",
    "priority": "高",
    "note": "实现 QAbstractListModel",
    "completed": true,
    "createdAt": "2026-06-17T11:20:00",
    "dueDate": ""
  }
]
```

`dueDate` 为空字符串表示无日期。

## 7. 日期分组规则

列表显示时建议按 `dueDate` 分组。

```text
已过期：dueDate < 今天，并且 completed == false
今天：dueDate == 今天
明天：dueDate == 今天 + 1
以后：dueDate > 明天
无日期：dueDate 为空
已完成：completed == true
```

推荐第一版显示这些组：

```text
已过期
今天
明天
以后
无日期
已完成
```

注意：已完成任务可以统一放到“已完成”，也可以继续保留原日期分组。第一版建议统一放到“已完成”，逻辑更简单。

## 8. QML 页面设计

### 8.1 Main.qml

职责：

- 创建主窗口
- 注册当前设备类型
- 根据窗口宽度选择布局
- 持有全局状态，例如当前筛选、搜索关键词、选中的任务 ID

布局判断示例：

```qml
readonly property bool isPhone: width < 600
readonly property bool isTablet: width >= 600 && width < 1000
readonly property bool isDesktop: width >= 1000
```

### 8.2 DesktopLayout.qml

桌面布局：

```text
+------------------------------------------------------+
| NexTodo                          搜索框       +       |
+------------------------------------------------------+
| 全部 / 进行中 / 已完成             排序               |
+------------------------------+-----------------------+
| 任务列表                      | 任务详情              |
| 今天                          | 标题、分类、备注      |
| 明天                          | 编辑、完成、删除      |
+------------------------------+-----------------------+
| 共 N 个任务，已完成 M 个                              |
+------------------------------------------------------+
```

适合 Windows 桌面或大屏。

### 8.3 TabletLayout.qml

平板布局：

```text
+------------------------------------------------+
| NexTodo                   搜索框          +     |
+------------------------------------------------+
| 全部 / 进行中 / 已完成                         |
+------------------------+-----------------------+
| 任务列表               | 任务详情              |
+------------------------+-----------------------+
```

平板横屏可以继续使用双栏。竖屏时可以切换成手机逻辑。

### 8.4 PhoneLayout.qml

手机布局：

```text
+--------------------------+
| NexTodo              +   |
+--------------------------+
| 全部 / 进行中 / 完成     |
+--------------------------+
| 搜索任务...              |
|                          |
| 任务卡片                 |
| 任务卡片                 |
+--------------------------+
| 任务 / 统计 / 设置       |
+--------------------------+
```

点击任务后进入详情页：

```text
+--------------------------+
| <  NexTodo                |
+--------------------------+
| 标题                     |
| 分类                     |
| 优先级                   |
| 日期                     |
| 备注                     |
|                          |
| 完成  编辑  删除         |
+--------------------------+
```

## 9. 核心组件设计

### 9.1 TodoCard.qml

显示单个任务。

需要的属性：

```qml
property string todoId
property string title
property string category
property string priority
property string dueDate
property bool completed
property bool selected
```

需要的信号：

```qml
signal clicked(string todoId)
signal toggleRequested(string todoId)
signal editRequested(string todoId)
signal deleteRequested(string todoId)
```

### 9.2 AddTodoDialog.qml

用于新增和编辑任务。

字段：

```text
标题
分类
优先级
日期
备注
```

交互规则：

- 标题为空时不能提交
- 新建时按钮显示“创建任务”
- 编辑时按钮显示“保存修改”
- 手机端可以改成底部弹出表单

### 9.3 DateSelector.qml

第一版不用做复杂日历，先做简单选项：

```text
今天
明天
以后
无日期
```

第二版再增加：

```text
自定义日期
```

## 10. 交互流程

### 10.1 新建任务

```text
点击 +
打开新建任务弹窗
输入标题、分类、优先级、日期、备注
点击创建任务
QML 调用 todoModel.addTodo(...)
C++ 插入数据
ListView 自动刷新
TodoStorage 保存 JSON
```

### 10.2 编辑任务

```text
点击任务的编辑按钮
打开编辑弹窗
填充原任务数据
修改内容
点击保存修改
QML 调用 todoModel.updateTodo(...)
C++ 更新数据
发出 dataChanged
保存 JSON
```

### 10.3 删除任务

```text
点击删除
打开确认弹窗
点击确认删除
QML 调用 todoModel.removeTodo(id)
C++ 删除数据
ListView 自动刷新
保存 JSON
```

### 10.4 切换完成状态

```text
点击任务左侧圆圈
QML 调用 todoModel.toggleTodo(id)
C++ 修改 completed
任务移动到已完成分组
保存 JSON
```

## 11. 筛选和搜索

筛选状态：

```text
全部
进行中
已完成
```

搜索规则：

```text
搜索标题、分类、备注
忽略大小写
搜索为空时显示当前筛选下的全部任务
没有结果时显示 EmptyState
```

第一版可以在 QML 里做筛选。更正式的做法是 C++ 再加一个 `QSortFilterProxyModel`。

## 12. Android 适配注意点

从一开始就避免写死尺寸。

建议：

- 用 `Layout`、`anchors`，少用固定 `x/y`
- 按钮高度保持 40 到 44 px 以上
- 手机端不要依赖 hover
- 手机端详情使用页面跳转
- 手机端新增/编辑使用底部弹出表单或全屏页面
- 保存路径使用 `QStandardPaths::AppDataLocation`

设备布局建议：

```qml
if (width < 600) {
    PhoneLayout {}
} else if (width < 1000) {
    TabletLayout {}
} else {
    DesktopLayout {}
}
```

## 13. 推荐实现顺序

```text
第 1 步：创建 Qt Quick C++ 项目
第 2 步：写 TodoItem 数据结构
第 3 步：写 TodoModel，先用内存假数据
第 4 步：把 TodoModel 注册给 QML
第 5 步：写 Main.qml 和 DesktopLayout.qml
第 6 步：写 TodoCard.qml，并绑定 ListView
第 7 步：实现 addTodo、removeTodo、toggleTodo
第 8 步：实现 AddTodoDialog.qml
第 9 步：实现 updateTodo
第 10 步：实现 TodoStorage JSON 读写
第 11 步：加入 dueDate 和日期分组
第 12 步：加入搜索和筛选
第 13 步：加入 TabletLayout.qml
第 14 步：加入 PhoneLayout.qml
第 15 步：测试 Android 构建
```

## 14. 第一版最小闭环

如果你想尽快跑起来，第一版只做这些：

```text
1. C++ 内存里保存任务数组
2. QML ListView 显示任务
3. 可以添加任务
4. 可以删除任务
5. 可以切换完成状态
6. 可以保存到 JSON
7. 可以启动时读取 JSON
```

完成这个闭环后，再加日期、搜索、筛选和移动端适配。

## 15. 参考原型

当前设计原型文件：

```text
docs/design/nex-todo-responsive-prototype.html
```

里面包含桌面、平板、手机三端交互设计，可以作为 QML 开发时的视觉和交互参考。

