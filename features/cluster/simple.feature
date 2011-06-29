Feature: Simple cluster with no dependancy

  Scenario: no sub directories
    Given a file "c/main.li"
      And a file "c/toto.li"
     When I show the cluster "c"
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◇ MAIN (c/main.li)
      ╰─◇ TOTO (c/toto.li)
      
      """

  Scenario: one sub directories
    Given a file "c/main.li"
      And a file "c/a/toto.li"
      And a file "c/b/tata.li"
     When I show the cluster "c"
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◇ MAIN (c/main.li)
      ├─◇ TATA (c/b/tata.li)
      ╰─◇ TOTO (c/a/toto.li)
      
      """

  Scenario: two sub directories
    Given a file "c/main.li"
      And a file "c/a/toto.li"
      And a file "c/a/b/tata.li"
     When I show the cluster "c"
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◇ MAIN (c/main.li)
      ├─◇ TATA (c/a/b/tata.li)
      ╰─◇ TOTO (c/a/toto.li)
      
      """

  Scenario: two sub directories, not in the cluster
    Given a file "c/main.li"
      And a file "c/a/b/toto.li"
      And a file "c/a/b/tata.li"
     When I show the cluster "c"
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ╰─◇ MAIN (c/main.li)
      
      """
