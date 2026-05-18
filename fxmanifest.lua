fx_version 'cerulean'
game 'gta5'

author 'KERRYGAMER'
description 'QBCore Drug Script'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'shared/config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qb-core',
    'qb-target',
    'progressbar'
}
