
cmake_minimum_required(VERSION 3.16)

project(NexTodo LANGUAGES CXX)

#C++标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick)
add_subdirectory(src)

set(PROJECT_SOURCES 
    main.cpp
    nextodo.qrc
    ${CPP_SOURCES}
)
#qt_standard_project_setup()

qt_add_executable(NexTodo
    ${PROJECT_SOURCES}
)

target_link_libraries(NexTodo PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick)

