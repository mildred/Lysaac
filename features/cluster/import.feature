Feature: Cluster import

  Scenario: Cluster includes library
    Given a file "c/main.li"
      And a file "c/toto.cli" with
      """
      Section Header
      
        + name := Cluster TOTO;
        - path := "./deps/toto";
      
      """
      And a file "c/deps/toto/toto.li"
     When I run lysaac c
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◆ TOTO (c/toto.cli)
      │ │ Cluster in: c/deps/toto
      │ ╰─◇ TOTO (c/deps/toto/toto.li)
      ╰─◇ MAIN (c/main.li)
      
      """

  Scenario: Cluster includes a library in standard path
    Given a file "c/main.li"
      And a file "c/toto.cli" with
      """
      Section Header
      
        + name := Cluster TOTO;
        - path := "toto";
      
      """
      And a file "toto/toto.li"
     When I set LYSAAC_PATH="$CWD"
      And I run lysaac c
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◆ TOTO (c/toto.cli)
      │ │ Cluster in: $CWD/toto
      │ ╰─◇ TOTO ($CWD/toto/toto.li)
      ╰─◇ MAIN (c/main.li)
      
      """

  Scenario: Cluster includes unknown library in standard path
    Given a file "c/main.li"
      And a file "c/toto.cli" with
      """
      Section Header
      
        + name := Cluster TOTO;
        - path := "toto";
      
      """
     When I run lysaac c
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◆ TOTO (c/toto.cli)
      │   Could not find cluster
      ╰─◇ MAIN (c/main.li)
      
      """
