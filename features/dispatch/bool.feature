Feature: Dispatching of booleans

  The compiler manages different inheritance trees. These trees cannot mix.
  Multiple inheritance is accepted only if the two types have the same common
  root. This is easily managed using a super object OBJECT.
  
  BOOLeans have a separate inheritance tree suited for their use.
  
  A type can be inherited if and only if it has a slot matked with the keyword
  Dispatch. This slot can be obtained by inheritance. The root of the
  inheritance tree is the type that does not inherit but have a Dispatch slot.
  
  When trying to determine the dynamic type of a value, differents checks are
  made:
  
    - First, the Dispatch slot is loaded. If its value is equals to an unique
      known direct child type, then this type is the dynamic type.
  
    - If this fails, the previous operation is repeated with the grand-children
      and so on, until exhaustion of the known inheritance tree.

    - If this fails, or if there is ambiguity at any of the above steps, the
      type of the Dispatch slot is considered. if the type has a Dispatcher
      slot, this slot is called. The slot is called with Self and the pointer to
      the slot of the type where it was first defined in the inheritance tree.
      The function returns the pointer to the slot of the dynamic type.

  @wip
  Scenario:
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      | BIT       |
      | BOOL      |
      | TRUE      |
      | FALSE     |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - puts (format:CSTRING) <- External `puts`;
        
        - test b:BOOL <-
        (
          b.if {
            puts("This is TRUE");
          }.else {
            puts("This is FALSE");
          };
        );
      
        - main <- Export
        (
          test FALSE;
          test TRUE;
          test FALSE;
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      This is FALSE
      This is TRUE
      This is FALSE
      
      """
