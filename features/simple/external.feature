Feature: Simple external procedure call

  Scenario: puts Hello World
    Given a file "c/string.li" with
      """
      Section Header
      
        + name := STRING;
        
        - constant := String; // const char*
      
      """
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN
        
      Section Public
      
        - puts str:STRING <- External `puts`;
      
        - main <-
        (
          puts "Hello World";
        );
      
      """
     When I execute "c" "MAIN"
     Then I should see
      """
      Hello World
      """