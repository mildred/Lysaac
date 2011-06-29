Feature: Show an error when a type is not found
    
  @wip
  Scenario: Unknown types should be ignored
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
        (
          TOTO.redo;
          printf("Hello World to %dntegers", 1);
        );
      
      """
     When I execute the cluster "c"
     Then I should have the errors
      | c/main.li | 11 | 5 | Unknown type TOTO |
      And I should see
      """
      Hello World to 1ntegers
      """

  Scenario: values can change over time
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        + one :INT32 := 1;
      
        - printf (format:CSTRING, arg:INT32) <- External `printf`;
      
        - main <- Export
        (
          printf("Hello World to %dntegers", one);
          one := 2;
          printf(" and %dntegers", one);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World to 1ntegers and 2ntegers
      """

