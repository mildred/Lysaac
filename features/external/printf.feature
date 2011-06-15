Feature: External procedure call with integer and two arguments

  Scenario: puts Hello World
    Given a file "c/cstring.li" with
      """
      Section Header
      
        + name := Reference CSTRING;
        
        - role := String;
        - type := Integer 8;
      
      """
      And a file "c/int32.li" with
      """
      Section Header
      
        + name := Expanded INT32;
        
        - role := Integer;
        - type := Integer 32;
      
      """
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
