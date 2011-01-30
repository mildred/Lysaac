Feature: Hello World

  Scenario: Hello
    Given a file "hello.li"
      """
      Section Header
        + name := HELLO;
      Section Public
        - main <-
        (
          Internal.Println "Hello World !";
        );
      """
     When I compile "HELLO"
     Then it should execute to
      """
      Hello World !

      """
