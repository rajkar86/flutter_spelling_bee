# **Flutter Coding Standards**

This document outlines the coding standards for Flutter projects to ensure code quality, maintainability, and consistency across the development team.

## **1\. Project Structure**

* **Consistent Structure**: Adhere to the project structure defined in the architectural guidelines (modular, layered).  
* **Meaningful Names**: Use clear and descriptive names for directories, files, and classes.

## **2\. Dart Language**

* **Effective Dart**: Follow the [Effective Dart](https://dart.dev/effective-dart) style guide.  
* **Strong Mode**: Write code that is sound and passes all static analysis checks with flutter analyze.  
* **Explicit Types**: Use explicit types for variable declarations and function signatures. Use var or final/const with type inference only when the type is obvious.  
* **Immutability**: Prefer immutable data structures. Use final and const as much as possible. When creating a class, make all fields final by default, and only make them non-final if there is a specific need for them to be mutable.  
* **Code Formatting**: Use flutter format to automatically format your code.  
* **Linting**: Enable and fix all lints reported by flutter analyze. Consider using a stricter linting configuration (e.g., enabling more lints from package:lints).

## **3\. Comments and Documentation**

* **Document Public APIs**: Use dartdoc comments (///) to document all public classes, methods, and properties.  
* **Clear Explanations**: Write concise and clear comments to explain complex logic, non-obvious code, and the purpose of code sections.  
* **Avoid Redundant Comments**: Do not add comments that simply repeat what the code does.  
* **Update Comments**: Keep comments up-to-date with code changes.  
* **TODOs**: Use // TODO: for tasks that need to be done in the future, and include a clear description of the task.  
* **Doc Comments**: Add doc comments to all public methods and classes.

## **4\. Naming Conventions**

* **Variables and Parameters**: Use camelCase.  
* **Classes and Enums**: Use PascalCase.  
* **Functions and Methods**: Use camelCase.  
* **Constants**: Use camelCase with all letters capitalized (e.g., kDefaultPadding).  
* **Libraries and Imports**: Use snake\_case.  
* **File Names**: Use snake\_case.  
* **Acronyms**: When used in a class name, spell out acronyms longer than two letters (e.g., HttpService not HTTPService). For variables and method names, use the common acronym (e.g., httpService).

## **5\. Imports**

* **Organize Imports**: Follow the order in import statements:  
  1. Flutter packages  
  2. Third-party packages  
  3. Project-local imports  
* **Relative Imports**: Use relative imports for project-local files.  
* **Specific Imports**: Import only the required members from a library. Avoid wildcard imports (import 'package:x/x.dart' as x;). The only exception is for Flutter packages with a large number of symbols, where it is conventional to use a wildcard import.  
* **Aliasing**: Use aliasing for conflicting imports (import 'package:a/a.dart' as a;).

## **6\. State Management (BLOC)**

* **BLOC Pattern**: Implement the BLOC pattern for all state management.  
* **Clear Separation**: Maintain a clear separation between UI, BLOC, and data layers.  
* **Events and States**: Define explicit events and states for each BLOC.  
* **Single Responsibility**: Each BLOC should have a single responsibility.  
* **Asynchronous Operations**: Handle all asynchronous operations within the BLOC.  
* **Error Handling**: Implement proper error handling in BLOCs and emit error states to the UI.  
* **Testing**: Thoroughly test BLOCs in isolation.  
* **Naming**:  
  * BLOC class: \[Feature\]Bloc (e.g., HomeBloc)  
  * Event class: \[Feature\]Event (e.g., HomeEvent)  
  * State class: \[Feature\]State (e.g., HomeState)  
  * Events: Use names like LoadData, AddItem, DeleteItem  
  * States: Use names like Loading, Loaded, Error, ItemsLoaded, ItemAdded, ItemDeleted

## **7\. Widgets**

* **Small Widgets**: Build small, focused widgets that are reusable.  
* **Stateless vs. Stateful**: Use StatelessWidget whenever possible. Use StatefulWidget only when the widget needs to manage its own state.  
* **const** Constructor: Use const constructors for widgets that can be created with constant values. This allows Flutter to optimize widget tree rebuilding.  
* **Keyed Widgets**: Use Keys when comparing Widgets of the same type.  
* **Layout**: Use layout widgets effectively (Row, Column, Flex, Expanded, Padding, Align, etc.) to create flexible and responsive UIs.  
* **Theming**: Use Theme.of(context) to access the current theme and apply styles consistently.  
* **Responsive Design**: Build UIs that adapt to different screen sizes using MediaQuery and LayoutBuilder.  
* **Accessibility**: Consider accessibility when building widgets (e.g., using Semantics, providing labels for form fields).  
* **Performance**: Be mindful of performance when building widgets. Avoid unnecessary widget rebuilds.

## **8\. Asynchronous Programming**

* **async** and **await**: Use async and await for asynchronous operations.  
* **Error Handling**: Handle errors in asynchronous operations using try-catch blocks.  
* **Streams**: Use Streams for handling continuous data flow (e.g., WebSocket communication, listening to sensor data).  
* **Futures**: Use Futures for single asynchronous operations.  
* **Cancel Subscriptions**: Cancel Stream subscriptions when they are no longer needed.

## **9\. Error Handling**

* **try-catch**: Use try-catch blocks to handle exceptions.  
* **Specific Exceptions**: Catch specific exception types whenever possible.  
* **Logging**: Log errors using a logging package (e.g., package:logger).  
* **User Feedback**: Provide user-friendly error messages.  
* **BLOC Error States**: In BLOCs, emit error states to the UI to handle and display errors.

## **10\. Testing**

* **Test Pyramid**: Follow the testing pyramid (unit, widget, integration).  
* **Unit Tests**: Write unit tests for all business logic, including BLOCs.  
* **Widget Tests**: Write widget tests to verify UI components.  
* **Integration Tests**: Write integration tests to verify interactions between different parts of the app.  
* **Test Coverage**: Aim for high test coverage (80% unit, 70% widget, 50% integration).  
* **Test Naming**: Use clear and descriptive names for test cases.  
* **Mocking**: Use mocking libraries (e.g., mockito) to isolate units under test.  
* **Golden Tests**: Consider using golden tests for UI components to ensure visual consistency.

## **11\. Version Control**

* **Git**: Use Git for version control.  
* **Meaningful Commits**: Write clear and concise commit messages.  
* **Branching Strategy**: Use a branching strategy (e.g., Gitflow) for managing different stages of development.  
* **Pull Requests**: Use pull requests for code reviews.

## **12\. Code Reviews**

* **Regular Reviews**: Conduct regular code reviews.  
* **Focus on Quality**: Focus on code quality, maintainability, and adherence to coding standards.  
* **Constructive Feedback**: Provide constructive feedback in code reviews.  
* **Reviewer Guidelines**:  
  * Check for adherence to coding standards.  
  * Verify that the code is well-documented.  
  * Ensure that the code is testable and has sufficient tests.  
  * Look for potential bugs or performance issues.  
  * Check for code duplication.  
  * Ensure that the code follows the principles of SOLID.  
  * Verify that the code is easy to understand and maintain.

## **13\. Documentation**

* **In-Code Documentation**: Use dartdoc comments to document code.  
* **README**: Provide a comprehensive README file that explains how to set up, run, and contribute to the project.  
* **API Documentation**: If the app has an API, provide clear and up-to-date API documentation.  
* **Architectural Documentation**: Document the architecture of the application.

## **14\. Best Practices**

* **DRY (Don't Repeat Yourself)**: Avoid code duplication by creating reusable components and functions.  
* **KISS (Keep It Simple, Stupid)**: Write simple and easy-to-understand code.  
* **SOLID Principles**: Follow the SOLID principles of object-oriented design.  
* **YAGNI (You Aren't Gonna Need It)**: Avoid adding unnecessary features or complexity.  
* **Performance**: Write performant code. Be mindful of resource usage and optimize where necessary.  
* **Security**: Write secure code. Follow security best practices to prevent vulnerabilities.  
* **Accessibility**: Make the app accessible to everyone.

By adhering to these coding standards, you can ensure that your Flutter projects are of high quality, maintainable, and easy to collaborate on.