Feature: Internal ObjectSize

  Scenario: values are different on different objects
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
        - object_size :INT32 <- Internal `object_size`;
      
        - main <- Export
        (
          printf("Object size: %d", object_size);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Object size: 4
      """
