Feature: Cluster import

  Scenario: Cluster includes library
    Given a file "c/main.li"
      And a file "c/toto.cli" with
      """
      Section Header
      
        + name := Cluster TOTO;
        - path := "deps/toto";
      
      """
      And a file "c/deps/toto/toto.li"
     When I run lysaac c
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◆ TOTO (c/toto.cli)
      │ │ Cluster in: deps/toto
      │ ╰─◇ TOTO (c/deps/toto/toto.li)
      ╰─◇ MAIN (c/main.li)
      
      """
