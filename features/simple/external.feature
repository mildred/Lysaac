Feature: Simple external procedure call

  Scenario: puts Hello World
    Given a file "c/cstring.li" with
      """
      Section Header
      
        + name := CSTRING;
        
        - role := String; // const char*
      
      """
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - puts str:STRING <- External `puts`;
      
        - main <-
        (
          puts "Hello World";
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World
      """
