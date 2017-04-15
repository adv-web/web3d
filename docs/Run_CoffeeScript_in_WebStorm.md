# Running CoffeeScript

On this page:

- Introduction
- Compiling CoffeeScript manually and running the generated JavaScript code
- Compile CoffeeScript on the fly during run

## Introduction

CoffeeScript code is not processed by browsers that work with JavaScript code. Therefore to be executed, CoffeeScript code has to be translated into JavaScript. This operation is referred to as compilation and the tools that perform it are called compiler.

For more details about compilation in WebStorm, see the section [Using File Watchers](https://www.jetbrains.com/help/webstorm/2017.1/using-file-watchers.html).

In either case, running CoffeeScript is supported only in the local mode. This means that WebStorm itself starts the Node.js engine and the target application according to a [run configuration](https://www.jetbrains.com/help/webstorm/2017.1/run-debug-configuration.html) and gets full control over the session.

For more details about running Node.js applications, see [Running and Debugging Node.js](https://www.jetbrains.com/help/webstorm/2017.1/running-and-debugging-node-js.html).

There are two approaches to running CoffeeScript in WebStorm:

- Compile the CoffeeScript code manually and then run the output JavaScript code as if it were a Node.js application.
- Run the original CoffeeScript code through the NodeJS run configuration and have WebStorm compile it on the fly.

## Compiling CoffeeScript manually and running the generated JavaScript code

1. [Compile the CoffeeScript code into Javascript](https://www.jetbrains.com/help/webstorm/2017.1/compiling-coffeescript-to-javascript.html).
2. [Start creating a Node.js run configuration](https://www.jetbrains.com/help/webstorm/2017.1/running-and-debugging-node-js.html#Node.js_run) with the following mandatory settings:The Node.js engine to use. By default, the field shows the path to the interpreter specified on the [Node.js](https://www.jetbrains.com/help/webstorm/2017.1/node-js-and-npm.html) page during Node.js configuration.In the Working directory field, specify the location of the files referenced from the starting CoffeeScript file to run, for example, includes. If this file does not reference any other files, just leave the field empty.In the Path to Node App JS File text box, specify the full path to the JavaScript file that was generated from the original CoffeeScript file during the compilation.
3. Save the configuration and click ![run.png](https://www.jetbrains.com/help/img/idea/2017.1/run.png) on the toolbar.
4. Proceed as while [running a Node.js application](https://www.jetbrains.com/help/webstorm/2017.1/running-and-debugging-node-js.html#running).

## Compile CoffeeScript on the fly during run

1. This mode requires that the `register.js` file, which is a part of the `coffee-script`package, should be located inside the project. Therefore you need to install the `coffee-script` package on the [Node.js](https://www.jetbrains.com/help/webstorm/2017.1/node-js.html) page locally, as described in [Node Package Manager (npm)](https://www.jetbrains.com/help/webstorm/2017.1/node-package-manager-npm.html).
2. Open the starting CoffeeScript file in the editor or select in the Project tool window and choose Create <CoffecScript_file_name> on the context menu. Alternatively, start creating a Node.js run configuration as described in [Running and Debugging Node.js](https://www.jetbrains.com/help/webstorm/2017.1/running-and-debugging-node-js.html#Node.js_run). In the [Run/Debug Configuration: Node JS](https://www.jetbrains.com/help/webstorm/2017.1/run-debug-configuration-node-js.html) dialog that opens, specify the following mandatory settings:The Node interpreter to use. Select the relevant interpreter configuration or create a new one, see By default, the field shows the path to the interpreter specified on the [Node.js](https://www.jetbrains.com/help/webstorm/2017.1/node-js-and-npm.html) page during Node.js configuration.For Linux and macOS, this setting is overridden by the Node.js from the path to the CoffeeScript compiler executable file.In the Node parameters text box, type the following:`--require coffee-script/register`CopyIn the Working directory field, specify the [working directory](http://en.wikipedia.org/wiki/Working_directory) of the application. All references in the starting CoffeeScript file, for example, imports, will be resolved relative to this folder, unless such references use full paths.By default, the field shows the project root folder. To change this predefined setting, choose the desired folder from the drop-down list, or type the path manually, or click the Browse button ![browseButton.png](https://www.jetbrains.com/help/img/idea/2017.1/browseButton.png) and select the location in the dialog box, that opens.In the JavaScript file text box, specify the full path to the CoffeeScript file to run.Note that all the mandatory fields will be filled in automatically if you create a run configuration directly from the required CoffeeScript file.
3. Save the configuration and click ![run.png](https://www.jetbrains.com/help/img/idea/2017.1/run.png) on the toolbar.
4. Proceed as while [running a Node.js application](https://www.jetbrains.com/help/webstorm/2017.1/running-and-debugging-node-js.html#running).