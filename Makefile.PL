use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Nile',
	LICENSE => "perl",
    VERSION_FROM      => 'lib/Nile.pm', # finds $VERSION
    PREREQ_PM         => {
			Moose => 0,
			MooseX::NonMoose => 0,
			MooseX::MethodAttributes => 0,
			namespace::autoclean => 0,
			CGI::Carp => 0,
			URI => 0,
			Encode => 0,
			URI::Escape => 0,
			Crypt::RC4 => 0,
			Capture::Tiny => 0,
			Time::Local => 0,
			File::Slurp => 0,
			Time::HiRes => 0,
			MIME::Base64 => 0,
			Data::Dumper => 0,
			HTTP::Tiny => 0,
			Log::Tiny => 0,
			CGI::Simple => 0,
			HTTP::AcceptLanguage => 0,
			Import::Into => 0,
			Module::Load => 0,
			Module::Runtime => 0,
			XML::TreePP => 0,
			IO::Compress::Gzip => 0,
			DBI => 0,
			Hash::AsObject => 0,
			DateTime => 0,
			Router::Generic => 0,
			
	}, # e.g., Module::Name => 1.1

    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Nile.pm', # retrieve abstract from module
       AUTHOR         => 'Ahmed Amin ELsheshtawy احمد امين الششتاوى <mewsoft@cpan.org>') : ()),
);
