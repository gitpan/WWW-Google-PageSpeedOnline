#!perl

use strict; use warnings;
use WWW::Google::PageSpeedOnline;
use Test::More tests => 9;
    
my ($api_key, $page, $title);
$api_key = 'Your_API_Key';

eval { $page = WWW::Google::PageSpeedOnline->new(); };
like($@, qr/Attribute \(api_key\) is required/);

$page = WWW::Google::PageSpeedOnline->new($api_key);
eval { $page->process(); };
like($@, qr/ERROR: Missing input param./);

eval { $page->process(url => 'http://localhost'); };
like($@, qr/ERROR: Input param has to be a ref to HASH./);

eval { $page->process({ulr => 'http://localhost'}); };
like($@, qr/ERROR: Missing key 'url'./);

eval { $page->process({url => 'http:localhost'}); };
like($@, qr/ERROR: Invalid value for key 'url': \[http:localhost\]./);

eval { $page->process({url      => 'http://code.google.com/speed/page-speed/', 
                       strategy => 'deesktop'}); };
like($@, qr/ERROR: Invalid value for key 'strategy': \[deesktop\]./);

eval { $page->process({url      => 'http://code.google.com/speed/page-speed/', 
                       strategy => 'desktop',
                       rule     => 'XYZ'}); };
like($@, qr/ERROR: Key 'rule' has to be a ref to ARRAY./);

eval { $page->process({url      => 'http://code.google.com/speed/page-speed/', 
                       strategy => 'desktop',
                       rule     => ['XYZ']}); };
like($@, qr/ERROR: Invalid value for key 'rule': \[XYZ\]./);

eval { $page->process({url      => 'http://code.google.com/speed/page-speed/', 
                       strategy => 'desktop',
                       rule     => ['AvoidCssImport'],
                       temp     => 1}); };
like($@, qr/ERROR: Invalid number of keys found in the param hash./);