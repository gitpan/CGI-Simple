use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'            => 'CGI::Simple',
    'VERSION_FROM'    => 'Simple.pm',
    'PREREQ_PM'       => {},
    'MAN3PODS'        => {
        'Simple.pm'           => '$(INST_MAN3DIR)/CGI::Simple.$(MAN3EXT)',
        'Simple/Cookie.pm'    => '$(INST_MAN3DIR)/CGI::Simple::Cookie.$(MAN3EXT)',
        'Simple/Standard.pm'  => '$(INST_MAN3DIR)/CGI::Simple::Standard.$(MAN3EXT)',
        'Simple/Util.pm'      => '$(INST_MAN3DIR)/CGI::Simple::Util.$(MAN3EXT)',
    },
);
