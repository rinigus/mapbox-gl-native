# Note: Using Sqlite instead of QSqlDatabase for better compatibility.

option(MBGL_WITH_QT_DEMO "Build Mapbox GL Qt demo" ON)
option(MBGL_WITH_QT_TEST "Build Mapbox GL Qt tests" ON)
option(MBGL_WITH_QT_HEADLESS "Build Mapbox GL Qt with headless support" ON)

find_package(Qt5Gui REQUIRED)
find_package(Qt5Network REQUIRED)

if (MBGL_WITH_QT_DEMO OR MBGL_WITH_QT_TEST OR MBGL_WITH_QT_HEADLESS)
   find_package(Qt5OpenGL REQUIRED)
endif()

if (MBGL_WITH_QT_DEMO)
   find_package(Qt5Widgets REQUIRED)
endif()

include(GNUInstallDirs)

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    add_definitions("-DQT_COMPILING_QIMAGE_COMPAT_CPP")
    add_definitions("-D_USE_MATH_DEFINES")
    add_definitions("-Wno-deprecated-declarations")
    add_definitions("-Wno-inconsistent-missing-override")
    add_definitions("-Wno-macro-redefined")
    add_definitions("-Wno-microsoft-exception-spec")
    add_definitions("-Wno-unknown-argument")
    add_definitions("-Wno-unknown-warning-option")
    add_definitions("-Wno-unused-command-line-argument")
    add_definitions("-Wno-unused-local-typedef")
    add_definitions("-Wno-unused-private-field")
endif()

target_sources(
    mbgl-core
    PRIVATE
        ${PROJECT_SOURCE_DIR}/platform/$<IF:$<PLATFORM_ID:Windows>,qt/src/bidi.cpp,default/src/mbgl/text/bidi.cpp>
        ${PROJECT_SOURCE_DIR}/platform/default/include/mbgl/gfx/headless_backend.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/include/mbgl/gfx/headless_frontend.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/include/mbgl/gl/headless_backend.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/gfx/headless_backend.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/gfx/headless_frontend.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/gl/headless_backend.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/i18n/collator.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/layermanager/layer_manager.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/asset_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/database_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/file_source_manager.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/file_source_request.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/local_file_request.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/local_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/main_resource_loader.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/offline.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/offline_database.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/offline_download.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/online_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/sqlite3.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/util/compression.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/util/monotonic_timer.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/async_task.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/async_task_impl.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/number_format.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/gl_functions.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/http_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/http_file_source.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/http_request.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/http_request.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/local_glyph_rasterizer.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_image.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_logging.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/run_loop.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/run_loop_impl.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/string_stdlib.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/thread.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/thread_local.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/timer.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/timer_impl.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/utf.cpp
)

if (MBGL_WITH_QT_HEADLESS)
   target_sources(
        mbgl-core
        PRIVATE
           ${PROJECT_SOURCE_DIR}/platform/qt/src/headless_backend_qt.cpp
   )
endif()


target_compile_definitions(
    mbgl-core
    PRIVATE QT_IMAGE_DECODERS
    PUBLIC __QT__ MBGL_USE_GLES2
)

target_include_directories(
    mbgl-core
    PRIVATE ${PROJECT_SOURCE_DIR}/platform/default/include
)

include(${PROJECT_SOURCE_DIR}/vendor/icu.cmake)
include(${PROJECT_SOURCE_DIR}/vendor/nunicode.cmake)
include(${PROJECT_SOURCE_DIR}/vendor/sqlite.cmake)

target_link_libraries(
    mbgl-core
    PRIVATE
        $<$<NOT:$<PLATFORM_ID:Windows>>:z>
        $<$<NOT:$<PLATFORM_ID:Windows>>:mbgl-vendor-icu>
        Qt5::Core
        Qt5::Gui
        Qt5::Network
        mbgl-vendor-nunicode
        mbgl-vendor-sqlite
)

if (MBGL_WITH_QT_HEADLESS)
   target_link_libraries(
        mbgl-core
        PRIVATE
          Qt5::OpenGL
   )
endif()

add_library(
    qmapboxgl
    ${PROJECT_SOURCE_DIR}/platform/qt/include/qmapbox.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/include/qmapboxgl.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapbox.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_map_observer.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_map_observer.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_map_renderer.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_map_renderer.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_p.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_renderer_backend.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_renderer_backend.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_scheduler.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_scheduler.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_conversion.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_geojson.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_geojson.hpp
)

set_property(TARGET qmapboxgl PROPERTY POSITION_INDEPENDENT_CODE ON)

# FIXME: Because of rapidjson conversion
target_include_directories(
    qmapboxgl
    PRIVATE ${PROJECT_SOURCE_DIR}/src
)

target_include_directories(
    qmapboxgl
    PUBLIC ${PROJECT_SOURCE_DIR}/platform/qt/include
)

target_compile_definitions(
    qmapboxgl
    PRIVATE QT_BUILD_MAPBOXGL_LIB
)

target_link_libraries(
    qmapboxgl
    PRIVATE
        Qt5::Core
        Qt5::Gui
        mbgl-compiler-options
        mbgl-core
)

# install library
install(TARGETS qmapboxgl
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}" COMPONENT shared NAMELINK_SKIP
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}" COMPONENT development)

install(FILES
        platform/qt/include/QMapbox
        platform/qt/include/QMapboxGL
        platform/qt/include/qmapbox.hpp
        platform/qt/include/qmapboxgl.hpp
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/qt5"
        COMPONENT development)

if (MBGL_WITH_QT_DEMO)
  add_executable(
    mbgl-qt
    ${PROJECT_SOURCE_DIR}/platform/qt/app/main.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/app/mapwindow.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/app/mapwindow.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/resources/common.qrc
    )

  # Qt public API should keep compatibility with old compilers for legacy systems
  set_property(TARGET mbgl-qt PROPERTY CXX_STANDARD 98)

  target_link_libraries(
    mbgl-qt
    PRIVATE
      Qt5::Widgets
      Qt5::Gui
      mbgl-compiler-options
      qmapboxgl
  )

  if (UNIX)
    target_link_libraries(
      mbgl-qt
      PRIVATE
        pthread
        )
  endif()
endif()

if (MBGL_WITH_QT_TEST)
  add_executable(
    mbgl-test-runner
    ${PROJECT_SOURCE_DIR}/platform/qt/test/main.cpp
    )

  target_include_directories(
    mbgl-test-runner
    PUBLIC ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/test/include
    )

  target_compile_definitions(
    mbgl-test-runner
    PRIVATE WORK_DIRECTORY=${PROJECT_SOURCE_DIR}
    )

  target_link_libraries(
    mbgl-test-runner
    PRIVATE
    Qt5::Gui
    Qt5::OpenGL
    mbgl-compiler-options
    pthread
    )

  if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    target_link_libraries(
      mbgl-test-runner
      PRIVATE -Wl,-force_load mbgl-test
      )
  else()
    target_link_libraries(
      mbgl-test-runner
      PRIVATE -Wl,--whole-archive mbgl-test -Wl,--no-whole-archive
      )
  endif()
endif()

find_program(MBGL_QDOC NAMES qdoc)

if(MBGL_QDOC)
    add_custom_target(mbgl-qt-docs)

    add_custom_command(
        TARGET mbgl-qt-docs PRE_BUILD
        COMMAND
            ${MBGL_QDOC}
            ${PROJECT_SOURCE_DIR}/platform/qt/config.qdocconf
            -outputdir
            ${CMAKE_BINARY_DIR}/docs
    )
endif()

add_test(NAME mbgl-test-runner COMMAND mbgl-test-runner WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
