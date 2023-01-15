cmake_minimum_required(VERSION 3.13)

project (quickpic VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

find_package(Qt5 REQUIRED COMPONENTS Core Widgets Quick Qml)

qt5_add_resources(APP_RESOURCES ${CMAKE_SOURCE_DIR}/quickpic.qrc)

# add_subdirectory(src)

add_executable(
	${PROJECT_NAME}
	main.cpp
	${APP_RESOURCES}
)

target_link_libraries(quickpic Qt5::Core Qt5::Widgets Qt5::Quick Qt5::Qml)