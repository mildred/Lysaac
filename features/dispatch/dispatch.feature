Feature: Dispatching types

  When the program uses a polymorphic value, it knows ahead of time its static
  type. It also have access to the value itself (either a pointer or the
  expanded value itself) and the dynamic type, through an interface table that
  is located in a neighbour variable.
  
  Thus, we can deduce that expanded values cannot be converted to one of their
  parent types unless they either uses less expanded space, or the exact same
  space.
  
  Because the interface is always available as a secondary variable, care must
  be taken so that this interface is passed around everywhere the value is
  passed. Also, the interface might need to be transformed if the value is
  copied to a new variable with a different static type.
  
  The content of this interface is a pointer to a table containing function
  pointers to slots of the object. The order of the function pointers depends on
  the static type. Because of multiple inheritance, transforming the interface
  to match a parent type is not strainghtforward. This is considered an
  implementation detail. The object must know how to transform itself.
  
  A good practice would be to have the first slot in the interface always be the
  special cast slot. Given the object itself and a static type to cast the
  object into, it should either fail or return an interface for the object to
  the given type.
  
  @wip
  Scenario:
    Given the following prototypes in "c":
      | Prototype |
      | BLOCK     |
      | CSTRING   |
      | INT32     |
      | BIT       |

    And a file "c/root.li" with
      """
      Section Header
      
        + name := ROOT;
        
      Section PUBLIC
      
        - whoami :CSTRING <- "ROOT";
      
      """

    And a file "c/child.li" with
      """
      Section Header
      
        + name := CHILD1;
      
      Section Inherit
      
        + parent_root :Expanded ROOT;
        
      Section PUBLIC
      
        - whoami :CSTRING <- "CHILD1";
      
      """

    And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - puts (format:CSTRING) <- External `puts`;
        
        - test obj:ROOT <-
        (
          puts (obj.whoami);
        );

        - main <- Export
        (
          puts (ROOT.whoami);
          puts (CHILD1.whoami);
          test (ROOT.whoami);
          test (CHILD1.whoami);
        );
      
      """
    When I execute the cluster "c"
    Then I should see
      """
      ROOT
      WHOAMI
      ROOT
      WHOAMI
      """
