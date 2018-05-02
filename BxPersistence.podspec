Pod::Spec.new do |s|

    s.name             = 'BxPersistence'
    s.version = '1.0.0'
    s.swift_version    = '4.1'
    s.summary          = 'Universal Interface for Database Access.'

    s.description      = 'BxPersistence provides an uniform interface for accessing databases and collections.'

    s.homepage          = 'https://bxpersistence.borchero.com'
    s.documentation_url = 'https://bxpersistence.borchero.com/docs'
    s.license           = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
    s.author            = { 'Oliver Borchert' => 'borchero@icloud.com' }
    s.source            = { :git => 'https://github.com/borchero/BxPersistence.git',
                            :tag => s.version.to_s }

    s.platform = :ios
    s.ios.deployment_target = '11.0'

    s.source_files = 'BxPersistence/**/*'

    s.dependency 'RxSwift', '~> 4.0'
    s.dependency 'BxUtility', '~> 1.0'

    s.framework = 'Foundation'

end
