# Basic install instructions

 - Download the Qt SDK installer from https://www.qt.io/download

 - For the most part, you need Qt 5.12.x or above. In the Qt installer, you specify:
   ![Selecting Qt 5.12.x](preview/installer.png)
   Only tick off the platforms you need, as each platform incurs a big download.

 - Once the installation is finished, clone the repository and open the directory in Qt Creator.
   Qt Creator should automatically open it as a CMake project.

# Deployment??

If you want to deploy the project as a self-contained program, you will need to use your platforms \*deployqt (eg. `windeployqt`, `macdeployqt`, `linuxdeployqt`)

You will then run

    \*deployqt --qmldir=$PROJECT_DIR/src ../BonziRevolutions{.exe}

This will:
 - Bundle all Qt shared libraries
 - Bundle all used QML modules

# WebAssembly

Follow similar instructions as the basic instructions, except installing the WebAssembly version of Qt 5.13.x or above.

For setting up a toolchain, follow [this blog article](https://blog.qt.io/blog/2018/11/19/getting-started-qt-webassembly/), and add the Emscripten compiler to Qt Creator.

Once this is done, open the QMake project (.pro file).
