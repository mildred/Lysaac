Feature: External procedure call with integer and two arguments

  Scenario: puts Hello World
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - printf (format:CSTRING, arg:INT32) <- External `printf`;
      
        - main <-
        (
          printf("Hello World to %dntegers", 1);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World to 1ntegers
      """
