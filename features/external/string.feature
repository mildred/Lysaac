Feature: Simple external procedure call

  Scenario: puts Hello World
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - puts str:CSTRING <- External `puts`;
      
        - main <- Export
        (
          puts "Hello World";
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World
      
      """

  Scenario: puts Hello World (with braces)
    Given a file "c/cstring.li" with
      """
      Section Header
      
        + name := Reference CSTRING;
        
        - role := String; // const char*
        - type := Integer 8;
      
      """
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - puts(str:CSTRING) <- External `puts`;
      
        - main <- Export
        (
          puts("Hello World");
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World
      
      """
