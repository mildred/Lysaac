Feature: Types must be able to contain values
    

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
      
        - one :INT32 := 1;
      
        - printf (format:CSTRING, arg:INT32) <- External `printf`;
      
        - main <-
        (
          printf("Hello World to %dntegers", one);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
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
      
        - main <-
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

