Feature: Have local variables
    
  Scenario: Assignment should be possible
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
      
        - main <- Export
        ( + int :INT32;
          int := 1;
          printf("Hello World to %dntegers", int);
          int := 2;
          printf(" and %dntegers", int);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World to 1ntegers and 2ntegers
      """

