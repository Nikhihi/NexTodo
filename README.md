# NexTodo

一个基于 **Qt 6 + QML + C++** 的跨平台桌面端任务管理应用，同时也是 QML + C++ 全栈开发的实践项目。

## ✨ 功能特性

- **任务增删改查** — 完整的任务 CRUD 操作，支持标题、分类、优先级、备注、截止日期
- **完成状态切换** — 一键标记任务完成/未完成，已完成任务显示删除线样式
- **多维度筛选** — 按状态筛选：全部 / 进行中 / 已完成
- **文本搜索** — 按任务标题实时模糊搜索
- **任务详情面板** — 主从布局（Master-Detail），右侧面板展示选中任务的完整信息
- **自定义日历组件** — 完整的日历日期选择器，支持月份切换、今天高亮、动画过渡
- **优先级与分类** — 支持低/中/高优先级（带颜色标记）及自定义分类标签
- **JSON 本地持久化** — 数据自动保存到本地 `todos.json`，启动时自动加载
- **响应式布局** — 根据窗口宽度自适应切换 Desktop / Tablet / Phone 布局（Tablet 和 Phone 布局待完善）

## 🖼️ 预览

> 运行截图待补充，可先参考 `docs/design/` 目录下的原型设计 HTML。

## 🛠️ 技术栈

| 技术 | 说明 |
|------|------|
| **C++17** | 核心语言，负责数据模型、业务逻辑、存储层 |
| **Qt 6** | 应用框架（Core / Gui / Qml / Quick 模块） |
| **QML** | 声明式 UI 层，负责所有界面与交互 |
| **CMake 3.16+** | 构建系统 |
| **Qt Creator 13.0** | 推荐开发环境 |

## 📁 项目结构

```
NexTodo/
├── CMakeLists.txt              # 根 CMake 构建配置
├── main.cpp                    # 应用入口，注册 C++ 对象到 QML 上下文
├── nextodo.qrc                 # Qt 资源文件，注册所有 QML
├── data/
│   └── todos.json              # 运行时数据文件（JSON 持久化）
├── docs/
│   ├── NexTodo开发设计文档.md   # 详细架构设计文档
│   └── design/                 # 界面原型设计
├── src/
│   ├── CMakeLists.txt          # 源文件子目录 CMake
│   ├── model/
│   │   ├── TodoItem.h          # 任务数据结构体
│   │   ├── TodoModel.h         # QAbstractListModel 子类
│   │   └── TodoModel.cpp       # 数据模型：CRUD + 筛选逻辑
│   └── storage/
│       ├── TodoStorage.h       # JSON 文件读写类
│       └── TodoStorage.cpp     # 序列化/反序列化实现
└── qml/
    ├── Main.qml                # 根窗口，布局切换逻辑
    ├── components/             # 可复用组件
    │   ├── AddTodoDialog.qml   # 新建/编辑任务弹窗
    │   ├── AppHeader.qml       # 顶部栏：标题 + 搜索 + 添加按钮
    │   ├── CalendarPicker.qml  # 自定义日历日期选择器
    │   ├── FilterBar.qml       # 筛选按钮栏 + 排序
    │   ├── SearchBox.qml       # 搜索输入框
    │   └── TodoCard.qml        # 单条任务卡片
    ├── layouts/                # 响应式布局
    │   ├── DesktopLayout.qml   # 桌面端主从布局
    │   ├── TabletLayout.qml    # 平板布局（待完善）
    │   └── PhoneLayout.qml     # 手机布局（待完善）
    ├── pages/                  # 页面
    │   ├── TaskListPage.qml    # 任务列表页
    │   ├── TaskDetailPage.qml  # 任务详情页
    │   └── EditTaskPage.qml    # 编辑页（待完善）
    └── styles/
        └── Theme.qml           # 主题样式（待完善）
```

## 🏗️ 架构设计

采用 **三层架构**，清晰分离关注点：

```
QML UI 层 (Qt Quick)
    ↕  Q_INVOKABLE 调用 + contextProperty 绑定
C++ 数据层 (QAbstractListModel)
    ↕  TodoStorage 读写
JSON 持久化层 (QJsonDocument)
```

- **TodoModel** 是核心数据模型，继承自 `QAbstractListModel`，直接在模型内部实现筛选（而非使用 `QSortFilterProxyModel`）
- 通过 `dataVersion` 计数器属性强制 QML 绑定在数据变更时重新求值
- C++ 对象通过 `engine.rootContext()->setContextProperty()` 注册到 QML 全局上下文

## 🚀 构建与运行

### 环境要求

- **Qt 6.x**（需包含 Core、Gui、Qml、Quick 模块）
- **CMake 3.16+**
- 支持 C++17 的编译器（MSVC 2019+ / GCC 9+ / Clang 10+）
- Windows / macOS / Linux 均可

### 命令行构建

```bash
# 克隆项目
git clone https://github.com/Nikhihi/NexTodo.git
cd NexTodo

# 配置 & 构建
mkdir build && cd build
cmake .. -G "Ninja" -DCMAKE_PREFIX_PATH=/path/to/Qt/6.x.x/gcc_64
cmake --build .

# 运行
./NexTodo
```

> 将 `/path/to/Qt/6.x.x/gcc_64` 替换为你本机的 Qt 6 安装路径。

### Qt Creator 构建

1. 用 Qt Creator 打开项目根目录的 `CMakeLists.txt`
2. 选择合适的 Kit（Qt 6.x 桌面开发套件）
3. 点击 **构建** → **运行**

## 📝 开发笔记

- 这是一个 **QML + C++ 学习实践项目**，目标不是功能复杂度，而是完整走通一个小型应用的骨架：QML 负责界面与交互，C++ 负责数据模型、业务逻辑和本地持久化
- 目前仅 Desktop 布局功能完整，Tablet 和 Phone 布局及部分组件为预留桩代码
- `todos.json` 数据文件生成在可执行文件同级目录下
- 详细设计文档见 [docs/NexTodo开发设计文档.md](docs/NexTodo开发设计文档.md)

## 📋 待办事项

- [ ] 完善 Tablet / Phone 响应式布局
- [ ] 实现主题切换（Theme.qml）
- [ ] 添加任务分组/标签功能
- [ ] 引入 `QSortFilterProxyModel` 优化筛选逻辑
- [ ] 添加数据导出/导入功能
- [ ] 补充单元测试

## 📄 许可证

MIT License

---

*Built with Qt 6 & ❤️*
