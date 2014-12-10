# Introduction #

This source code is the one I have used as exercises for the Ironhack
training.  I am responsible for teaching the Core Data and Testing
(unit testing, TDD) week and I decided to create this examples that
can be used as exercises.  Feel free to use them. And if you are
interested in more code like this, I do contract work. Contact me:
- Email: jortiz -at- powwau.com
- Twitter: jdortiz

The core contents of the week are about the model part of an
application. In the examples I won't purposely focus on the visual
part: no autolayout constraints, no fancy animations, no problem with
poor ux.

Git is assumed. ALWAYS commit after each section of the exercises.  The
repo has been created with that philosophy, each section corresponds
to a commit. Thus, you can checkout the version before the exercise
and compare it with the next commit to check my answer to the
exercise.

I do know that not all the answers are optimal, some will have to be
improved for performance in production code. However:

1. I am against of premature optimization.
2. I rather favor legibility than performance.
3. These examples are meant for other people to understand what is
   going on and learn from them.

# Exercises #

## TDD Demo ##

Learn how to write code the TDD way.

### Create project (5min)
1. Create new project in Xcode. Use the "Empty application" (iOS) template.
2. Call it "BadHunterTDD" and use Core Data.
3. Close the project window.
4. Create a Podfile in the project directory.

        platform :ios, "7.0"

        target "BadHunterTDD" do

        end

        target "BadHunterTDDTests" do
          pod 'OCMock'
        end

5. Execute `pod install`
6. Copy the Core Data Test template

        $ cd
        $ tar xjvf <path>/UnitTestTemplates.tar.bz2

7. Open BadHunterTDD.xcworkspace

### First test (test return) (10 min) ###

Make an initial test, in order to understand the pieces and the mechanics.

1. Create the Agent entity in the model and declare the name,
   destructionPower and motivation as they were defined before.
2. Generate the subclass.
3. Generate the Model category.
4. Delete the existing test.
5. Change the code so it can run without crashing.
6. Create a new test file from the new template.
7. Replace the imported header.
8. Uncomment the createCoreDataStack invocation.
9. Change the createSut to use a convenience constructor.
10. Add the **minimum** amount of code to make it compile.
11. Run the test and see that it fails.
12. Add the source code in the category to create the Agent object.
13. Run the test and see that it fails, but notice that it is related
    to "Agent not being located in the bundle."
14. Add the xcdatamodel file to the Tests target.
15. Run the test and see that it succeeds.

## TDD exercise ##

Now you play to get code from the tests.

### Test the transient property (test state) (15 min) ###

Core Data properties need no testing, but the assessment that is
calculated, is somthing to be checked.

1. Add the transient property to the model as you did before.
2. Write the first test to check the assessment value given a
   combination of destruction power and motivation.
3. Run the test. Red.
4. Hardcode the result.
5. Run the test. Green.
6. Add the second test for the transient property with another
   combination of values.
7. Run the test. Red.
8. Generalize the resuls.
9. Run the test. Green.

### Test KVO compliance (test behavior) (20 min) ###

will/didAccessValueForKey is required for maintaining relationships
and unfaulting, so we must be sure that it works.

1. Test behavior using OCMock.
2. Understand the problems of mocking and Core Data.
3. Replace properties with primitive values and voila!
4. Refactor to include constants.

### Test assessment dependencies (20 min) ###

Test that objects observing changes of assessment are notified when
the other two properties change.

1. Create a test thatk checks if the
   `+keyPathsForValuesAffectingAppraisal` method returns anything (not
   nil).
2. Notice that in order to compile the test and get the red, you do
   need to declare the class method.
3. Write the code to pass the test. An empty array is enough.
4. Write another test to check that the destruction power is contained
   in the set.
5. Write the code to pass the tests.
6. Repeat the process for motivation.

### Complete agent functionality (30 min) ###

Test other logic of the model.

1. Add tests and code for the picture logic.
2. Add tests and code for the fetch requests.

### Create the other entities and their tests (30 min) ###

Extend the tests to the FreakType entity.

1. Create the FreakType entity and the subclass.
2. Run the test to confirm that everything is fine.
3. Test the convenience constructor, NOT the relationship.
4. Create a fixture for the fetches.

### Test validation (30 min) ###

Validation is a key part of Core Data. Test that the data is validated
only if follows our requirements and understand how to make this
custom validations.

1. Write the test to confirm that an empty agent name cannot be
   saved.
2. To add the validation include the validateName:error: to the Agent
   category. Pay attention to the input value: it is a pointer to an
   NSString *.
3. Change the model to disallow empty agent names. Remember to use
   the simplest (hardcoded) solution.
4. Make a second test to check that non empty agent names can be
   saved.
5. Modify the validation code to pass the test.
6. Make another test to see that a name consisting only on spaces
   will not be accepted when saving.
7. Modify the validation code to pass the test.
8. Add another test to veryfy that no error is returned when the
   agent can be saved.
9. Add another test to verify that the validation returns an error
   with a code when it doesn't pass.
10. Define the error codes in the category header.
11. Create the error with the proper information to pass the test.
12. Finally check that invoking the validation directly with a NULL
    pointer for the name doesn't fail (the test will not finish).
13. Test also that using a NULL pointer for the name generates an
    explanatory error. Refactor the previous test using a pointer for
    the error.

### Refactor tests (10 min) ###

1. Notice that the Core Stack creation is repeated in all three test files.
2. Create a CoreDataTestCase file that inherits from
   XCTestCase. (Don't use the refactoring menu selecting the name of
   one of the test classes.)
3. Start with the AgentTests class. Move the Core Data Stack objects
   declaration to the header of the new class.
4. Copy the "Set up and tear down" block to the implementation of the
   new class.
5. Remove the create an release sut methods and invocations from the
   CoreDataTestCase class.
6. Declare the creation and release of the stack and the fixture in
   the header.
7. In the AgentTests class, change the import from XCTest to
   CoreDataTestCase.h
8. Make the AgentTests class inherit from CoreDataTestCase.
9. Remove the creation and release of the Core Data stack and the
   fixture.
10. Run the tests to verify that everything is fine.
11. Make the same changes to the other tests files.

### Add a self served stack: UIManagedDocument (5 min) ###

Undertand a different way to work with the Core Data Stack.

1. Create the BadHunterDocument class as subclass of UIManagedDocument.
2. Create its corresponding test class.
3. In the createSut method, create a fake URL and a new document with
   the initWithFileURL: initializer.
4. Verify that the test passes.
5. Write a test to ensure that the managed object context that the
   document provides is the one that you create for the tests.
6. Replace the context in the createSut method.
7. Run the test. It will fail. Change the context creation to be
   created with concurrency type NSMainQueueConcurrencyType.

### Exercises for the reader (15 min) ###

- Test that pictures are deleted when objects are.

## Import data ##

Make our object able to work with data in a different format.

### Create a convenience constructor for importing (20 min) ###

Use convenience constructors, that consume the data in the expected format.

1. Declare a convenience constuctor for Agent that takes the MOC and a
   dictionary as parameters.
2. Write the following tests and make the code to pass them:
   1. Verify that it returns a non nil value.
   2. Verify that the name passed in the dictionary is preserved.
   3. Verify that the destruction power passed in the dictionary is
      preserved.
   4. Verify that the motivation passed in the dictionary is preserved.

### Create convenience constructors for the other entities (20 min) ###

Apply the same concepts to the other entities.

1. Create a convenience constuctor for the FreakType that takes the
   MOC and a dictionary as parameters.
2. Verify (tests) that it returns a non nil value and the name is
   preserved.
3. Create a convenience constuctor for the Domain that takes the
   MOC and a dictionary as parameters.
4. Verify (tests) that it returns a non nil value and the name is
   preserved.
5. Refactor the code so the constructors share code.

### Import relationships (20 min) ###

Understand how the relationships can be recovered from the data and
applied to our model.

1. Add a ficture to the Agent tests with one freak type.
2. Add a test to modify the agent convenience constructor (with tests)
   so it is related with the (pre-existing) category that has the name
   provided in the dictionary with the "freakTypeName" key, as name.
3. Pass the test.
4. Add a test to modify the agent convenience constructor (with tests)
   so it is related with the (pre-existing) domains that have the
   names (array) provided in the dictionary with the "domainNames"
   key, as name.

### General importer (30 min) ###

Make the importer method that performs all the required steps.

1. Create the importData as a document method that takes a dictionary.
2. Create (and test) as many FreakTypes as indicated in the array
   contained under the "FreakTypes" of the main dictionary key.
3. Create (and test) as many Domains as indicated in the array
   contained under the "Domains" of the main dictionary key.
4. Create (and test) as many Agents as indicated in the array
   contained under the "Agents" of the main dictionary key.

### Preload existing data (20 min) ###

Understand how to provide seed data in our app.

1. Create another lazy loaded property that returns the URL to the
   initial data. If it doesnt exist, it returns a path to a resource
   in the main bundle.
2. Create a lazy loaded property for the document class for the file
   manager. If it doesn't exist returns the defaultManager.
3. Create a test to verify that if the storeURL passed to
   `configurePersistentStoreCoordinatorForURL:ofType:modelConfiguration:storeOptions:error:`
   doesn't exist, it is copied from the URL to the initial data.
4. Remember to call super.

### Exercises for the reader ###

- Create an OSX target that loads a JSON file and uses this to store
  the data.
- Import images.
- Export methods.
