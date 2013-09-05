node default {
    include bootstrap
}

node "test1" inherits default {
    include apache
    include php
}

node "test2" inherits default {
    include apache
    include php
}
