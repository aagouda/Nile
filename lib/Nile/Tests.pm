
#package Nile::Tests;

	#use Nile::Base;
	use MooseX::Declare;

# injects 'action' and 'function'

class Nile::Tests {
	
	use Nile::Base;

	#use Method::Signatures::Simple ('method_keyword' => 'action', 'function_keyword' => 'function');
	#use Method::Signatures::Simple ('method_keyword' => 'method');
	
	use Nile::Declare (method => 'method, action', function => 'function', invocant=>'$this', 'inject'=>'my ($me) = $this->me;');
	#use Nile::Declare ('method_keyword' => 'method', 'function_keyword' => 'function', );
	#use Nile::Declare ('method_keyword' => 'method');
	
	has fullname => (is => 'rw', default => "Ahmed Elsheshtawy");
	
	method lname ($lname) {
		say "lname in $lname";
		return $lname;
	}

	action name : PublicGet($name) {
		say "me: ". $me;
		return $this->fullname;
	}

	method fname ($fname) {
		say "fname in $fname";
		return $fname;
	}

	method names ($fname, @names) {
		say "fname $fname";
		return @names;
	}

	method hashs ($lname, %names) {
		say "lname $lname";
		say "k: " . $_ ."=".$names{$_} for (keys %names);
		return %names;
	}

	sub helper : Public(/log/cat/news) Tag {
		my $self= shift;
		return $self->fullname . " @_";
	}
	
	sub me {
		"me sub ";
	}

}
1;