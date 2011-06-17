Feature: Simple blocks

  @wip
  Scenario: puts Hello World in a BLOCK
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      And a file "c/block.li" with
      """
      Section Header
      
        + name := BLOCK;
        
        - role := Block;
      
      Section Public
      
        - value <- Internal Value;
      
      """
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - puts str:CSTRING <- External `puts`;
        
        - receiver blc:{} <-
        (
          blc.value;
        );
      
        - main <-
        (
          receiver {
            puts "In my block";
          };
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      In my block
      
      """
