Feature: Integers constants can be of any integer type, not just i32

  Scenario:
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      | BIT       |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - zero :BIT   := 0;
        - one  :INT32 := 1;
      
        - printf (format:CSTRING, arg:BIT, arg:INT32) <- External `printf`;
      
        - main <- Export
        (
          printf("Hello World to %d and %d", zero, one);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World to 0 and 1
      """
