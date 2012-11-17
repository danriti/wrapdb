#!/bin/bash

rails destroy model user
rails destroy model project
rails destroy model endpoint
rails destroy model dictionary
rails destroy model erray
rails destroy model item
rails destroy model tuple

#rails destroy model calendar
#rails destroy model venue
#rails destroy model player
#rails destroy model sport
#rails destroy model match
#rails destroy model invite

rake db:drop
