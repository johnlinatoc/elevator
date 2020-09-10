HOW TO RUN PROGRAM:

ruby bin/run.rb

-----------------------------------

Here are my steps in approaching this challenge:

1. Wrote down and analyzed needed features 
2. Domain Modeling with appropriate methods
3. Wrote tests for intended features
4. Coded features
5. Refactored


1. (Analyzed Features) I analyzed the given prompt and I wanted to know what was the appropriate way to allow the user to use the program. I can see that the elevator needs to communicate information to the user constantly and also keep track of multiple scenarios, such as when to stop on a floor and which direction it should go. After studying the prompt a little more, I decided to focus on making a CLI and focus time more on testing and creating a more stable application. By taking the information from the prompt, I wrote down some user stories to help me tackle all the necessary features first, then I wrote down some other stories regarding some other feature that I thought would be needed also after going through scenarios.

2. (Domain Modeling) Thinking on how people usually use an elevator, I wanted to create the program to be used by the user as the elevator communicating with the them directly. I also saw that you can have at least 2 models and have the passenger be responsible for its desired floor and also be aware of the elevator's current status. Then the elevator would be responsible for all the passengers in relation to their desired floor along with its own info. It would need a method to display all the floors everytime it would move up or down a floor and it would need to display a success message when reached

3. (Tests Created) I used test driven development for this program and I coded the tests before I coded the features. I like this approach because of the feedback loop the tests provide and helps me to ensure that I am thinking critically about the code. I tried my best to keep the tests as readable and understandable as possible by using 'context's in my descriptions of the tests. Taking the necessary features from the prompt and the user stories I created, I used those as the basis for the tests for the program. By following the tests, this helped me streamline my workflow and naturally gave me a guide to work off of. Some blockers were just syntax and trying to mock out certain scenarios. 

4. (Developed Features) By using the tests as a guide, I coded out the features and it was a relatively smooth process. The program had less bugs as I started to add more functionality to it. Some blockers were trying to find how to exactly find a way for the elevator was supposed to communicate to the user, but after analyzing it more I could see how the data must be stored in the destinations instance variable to help pass that data along to the other methods. 

5. (Refactored Code) Naturally, the tests couldn't cover every scenario, so I had to refactor the tests so that it would cover as much as I could. One situation was just trying to properly test the correct output to the terminal, so I refactored the output for that. I also refactored some code that was repeated in both the tests and in the implementations themselves.

------------------------------------------

Improvements:

If I could improve on this application, I would do a couple things. The major struggles I had in this was my ability to think through every detail while writing tests and how to keep classes as clean as possible. I was unable to test every single part of the code, particularly the parser class and the '#handle_watch' method in the Elevator class. I could not prevent the test from going into an infinite loop and stopping all other tests from running, but that would definitely be the first improvement I would make. I would also try to find more ways to separate out lines of code into their own methods in anticipation of the application growing. I would also try to find areas where I could separate out methods into their own classes to try to keep even more areas of the code cleaner and more flexible for change.