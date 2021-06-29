class dokuwiki {
    package {
        'apache2':
            ensure => present
    }
    package {
        'php7.3':
            ensure => present
    }
    file {
        'download dokuwiki':
            path => '/usr/src/dokuwiki.tgz',
            ensure => present,
            source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz'
    }
    exec {
        'extract dokuwiki':
            command => 'tar xavf dokuwiki.tgz',
            cwd => '/usr/src',
            path => ['/usr/bin'],
            require => File['download dokuwiki'],
            unless => 'test -d /usr/src/dokuwiki-2020-07-29/'
    }
    file {
        'rename dokuwiki':
            path => '/usr/src/dokuwiki',
            ensure => present,
            source => '/usr/src/dokuwiki-2020-07-29',
            recurse => true,
            require => Exec['extract dokuwiki']
    }
    file {
        'delete extracted dokuwiki':
            path => '/usr/src/dokuwiki-2020-07-29',
            ensure => absent,
            require => File['rename dokuwiki']
    }
    #file {
    #    'delete archive':
    #        path => '/usr/src/dokuwiki.tgz',
    #        ensure => absent
    #}
}

define install_wiki($site_name) {
    file {
        "create ${site_name} directory":
            ensure  => directory,
            path    => "/var/www/${site_name}",
            source  => '/usr/src/dokuwiki',
            recurse => true,
            owner   => 'www-data',
            group   => 'www-data',
            require => File['rename dokuwiki']
    }
}

node server0 {
    include dokuwiki
    install_wiki {
        'recettes':
            site_name => 'recettes.wiki'
        ;
        'tajineworld':
            site_name => 'tajineworld.com'
        ;
        'toto':
            site_name => 'toto.com'
        ;
    }
}

node server1 {
    include dokuwiki
    install_wiki {
        'politique':
            site_name => 'politique.wiki',
    }
}
