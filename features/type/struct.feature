Feature: Types must be able to contain values

  Scenario: Assignment should be possible
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
