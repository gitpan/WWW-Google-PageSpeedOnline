package WWW::Google::PageSpeedOnline;

use Carp;
use Data::Dumper;

use Moose;
use Moose::Util::TypeConstraints;

use JSON;
use Readonly;
use HTTP::Request;
use LWP::UserAgent;
use Data::Validate::URI qw/is_web_uri/;
use namespace::clean;

=head1 NAME

WWW::Google::PageSpeedOnline - Interface to Google Page Speed Online API.

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';
Readonly my $API_VERSION => 'v1';
Readonly my $BASE_URL    => "https://www.googleapis.com/pagespeedonline/$API_VERSION/runPagespeed";
Readonly my $DEFAULT_STRATEGY => 'desktop';
Readonly my $DEFAULT_LOCALE   => 'en-US';
Readonly my $STRATEGIES  => {'desktop' => 1, 'mobile' => 1};
Readonly my $RULES       => 
{
    'AVOIDCSSIMPORT'                        => 1,
    'INLINESMALLJAVASCRIPT'                 => 1,
    'SPECIFYCHARSETEARLY'                   => 1,
    'SPECIFYACACHEVALIDATOR'                => 1,
    'SPECIFYIMAGEDIMENSIONS'                => 1,
    'MAKELANDINGPAGEREDIRECTSCACHEABLE'     => 1,
    'MINIMIZEREQUESTSIZE'                   => 1,
    'PREFERASYNCRESOURCES'                  => 1,
    'MINIFYCSS'                             => 1,
    'SERVERESOURCESFROMACONSISTENTURL'      => 1,
    'MINIFYHTML'                            => 1,
    'OPTIMIZETHEORDEROFSTYLESANDSCRIPTS'    => 1,
    'PUTCSSINTHEDOCUMENTHEAD'               => 1,
    'MINIMIZEREDIRECTS'                     => 1,
    'INLINESMALLCSS'                        => 1,
    'MINIFYJAVASCRIPT'                      => 1,
    'DEFERPARSINGJAVASCRIPT'                => 1,
    'SPECIFYAVARYACCEPTENCODINGHEADER'      => 1,
    'LEVERAGEBROWSERCACHING'                => 1,
    'OPTIMIZEIMAGES'                        => 1,
    'SPRITEIMAGES'                          => 1,
    'REMOVEQUERYSTRINGSFROMSTATICRESOURCES' => 1,
    'SERVESCALEDIMAGES'                     => 1,
    'AVOIDBADREQUESTS'                      => 1,
    'USEANAPPLICATIONCACHE'                 => 1,
};

Readonly my $LOCALES     =>
{
    'ar'    => 'Arabic',
    'bg'    => 'Bulgarian',
    'ca'    => 'Catalan',                       
    'zh-TW' => 'Traditional Chinese (Taiwan)',
    'zh-CN' => 'Simplified Chinese',
    'fr'    => 'Croatian',
    'cs'    => 'Czech',
    'da'    => 'Danish',
    'nl'    => 'Dutch',
    'en-US' => 'English',
    'en-GB' => 'English UK',
    'fil'   => 'Filipino',
    'fi'    => 'Finnish',
    'fr'    => 'French',
    'de'    => 'German',
    'el'    => 'Greek',
    'lw'    => 'Hebrew',
    'hi'    => 'Hindi',
    'hu'    => 'Hungarian',
    'id'    => 'Indonesian',
    'it'    => 'Italian',
    'ja'    => 'Japanese',
    'ko'    => 'Korean',
    'lv'    => 'Latvian',
    'lt'    => 'Lithuanian',
    'no'    => 'Norwegian',
    'pl'    => 'Polish',
    'pr-BR' => 'Portuguese (Brazilian)',
    'pt-PT' => 'Portuguese (Portugal)',
    'ro'    => 'Romanian',
    'ru'    => 'Russian',
    'sr'    => 'Serbian',
    'sk'    => 'Slovakian',
    'sl'    => 'Slovenian',
    'es'    => 'Spanish',
    'sv'    => 'Swedish',
    'th'    => 'Thai',
    'tr'    => 'Turkish',
    'uk'    => 'Ukrainian',
    'vi'    => 'Vietnamese'
};

=head1 DESCRIPTION

Google Page  Speed  is  a tool that helps developers optimize their web pages by analyzing the
pages and generating tailored suggestions to make the pages faster. You can use the Page Speed 
Online API to programmatically generate Page Speed scores & suggestions. Currently it supports 
version v1. Courtesy limit is 250 queries per day.

IMPORTANT:The version v1 of the Google Page Speed Online API is in Labs and its features might
change unexpectedly until it graduates.

=head1 STRATEGIES

    +-------------+
    | Strategy    |
    +-------------+
    | desktop     |
    | mobile      |
    +-------------+

=head1 RULES

    +---------------------------------------+
    | Rule                                  |
    +---------------------------------------+
    | AvoidCssImport                        |
    | InlineSmallJavaScript                 |
    | SpecifyCharsetEarly                   |
    | SpecifyACacheValidator                |
    | SpecifyImageDimensions                |
    | MakeLandingPageRedirectsCacheable     |
    | MinimizeRequestSize                   |
    | PreferAsyncResources                  |
    | MinifyCss                             |
    | ServeResourcesFromAConsistentUrl      |
    | MinifyHTML                            |
    | OptimizeTheOrderOfStylesAndScripts    |
    | PutCssInTheDocumentHead               |
    | MinimizeRedirects                     |
    | InlineSmallCss                        |
    | MinifyJavaScript                      |
    | DeferParsingJavaScript                |
    | SpecifyAVaryAcceptEncodingHeader      |
    | LeverageBrowserCaching                |
    | OptimizeImages                        |
    | SpriteImages                          | 
    | RemoveQueryStringsFromStaticResources |
    | ServeScaledImages                     |
    | AvoidBadRequests                      |
    | UseAnApplicationCache                 | 
    +---------------------------------------+

=head1 LOCALES

    +-------+------------------------------+
    | Code  | Description                  | 
    +-------+------------------------------+
    | ar    | Arabic                       | 
    | bg    | Bulgarian                    |
    | ca    | Catalan                      |  
    | zh-TW | Traditional Chinese (Taiwan) |
    | zh-CN | Simplified Chinese           |
    | fr    | Croatian                     |
    | cs    | Czech                        |
    | da    | Danish                       |
    | nl    | Dutch                        |
    | en-US | English                      |
    | en-GB | English UK                   |
    | fil   | Filipino                     |
    | fi    | Finnish                      |
    | fr    | French                       |
    | de    | German                       |
    | el    | Greek                        |
    | lw    | Hebrew                       |
    | hi    | Hindi                        |
    | hu    | Hungarian                    |
    | id    | Indonesian                   |
    | it    | Italian                      | 
    | ja    | Japanese                     | 
    | ko    | Korean                       |
    | lv    | Latvian                      |
    | lt    | Lithuanian                   |
    | no    | Norwegian                    |
    | pl    | Polish                       |
    | pr-BR | Portuguese (Brazilian)       |
    | pt-PT | Portuguese (Portugal)        | 
    | ro    | Romanian                     |
    | ru    | Russian                      |
    | sr    | Serbian                      |
    | sk    | Slovakian                    |
    | sl    | Slovenian                    |
    | es    | Spanish                      | 
    | sv    | Swedish                      |
    | th    | Thai                         |
    | tr    | Turkish                      | 
    | uk    | Ukrainian                    | 
    | vi    | Vietnamese                   | 
    +-------+------------------------------+

=cut

type 'true_false' => where { $_ =~ m(^\btrue\b|\bfalse\b$)i };
has 'api_key'     => (is => 'ro', isa => 'Str', required => 1);
has 'browser'     => (is => 'rw', isa => 'LWP::UserAgent', default => sub { return LWP::UserAgent->new(); });
has 'prettyprint' => (is => 'rw', isa => 'true_false', default => 'true');

around BUILDARGS => sub 
{
    my $orig  = shift;
    my $class = shift;

    if (@_ == 1 && ! ref $_[0]) 
    {
        return $class->$orig(api_key => $_[0]);
    }
    else 
    {
        return $class->$orig(@_);
    }
};

=head1 CONSTRUCTOR

The constructor  expects  at  the least the API Key that you can get from Google for FREE. You
can also  provide  prettyprint switch as well, which can have either true or false values. You
can pass param as scalar the API key, if that is the only the thing you would want to pass in.
In case you would want to pass prettyprint switch then you would have to pass as hashref like:

    +-------------+----------+----------------------------------------------------------------------------------+
    | Parameter   | Default  | Meaning                                                                          |
    +-------------+----------+----------------------------------------------------------------------------------+
    | api_key     | Required | API Key                                                                          |
    | prettyprint | true     | Returns the response in a human-readable format. Valid values are true or false. |
    +-------------+----------+----------------------------------------------------------------------------------+

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;
    
    my ($api_key, $page);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    # or
    $page    = WWW::Google::PageSpeedOnline->new({api_key => $api_key});
    # or
    $page    = WWW::Google::PageSpeedOnline->new({api_key=>$api_key, prettyprint=>'true'});

=head1 METHODS

=head2 process()

    +-----------+----------+-----------------------------------------------------------------------------------+
    | Parameter | Default  | Meaning                                                                           |
    +-----------+----------+-----------------------------------------------------------------------------------+
    | url       | Required | The URL of the page for which the Page Speed Online API should generate results.  |     
    | locale    | en-US    | The locale that results should be generated in.                                   |
    | strategy  | desktop  | The strategy to use when analyzing the page. Valid values are desktop and mobile. |
    | rule      | N/A      | The Page Speed rules to run. Can have multiple rules something like for example,  |
    |           |          | ['AvoidBadRequests', 'MinifyJavaScript'] to request multiple rules.               |
    +-----------+----------+-----------------------------------------------------------------------------------+

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;
    
    my ($api_key, $page);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});

=cut

sub process
{
    my $self  = shift;
    my $param = shift;
    
    _validate_param($param);
    
    my $url   = $self->_get_url($param);
    my $stats = $self->_process($url);
    
    $self->{result} = $stats->{formattedResults}->{ruleResults};
    $self->{stats}  = $stats->{pageStats};
    $self->{score}  = $stats->{score};
    $self->{title}  = $stats->{title};
    $self->{id}     = $stats->{id};
}

=head2 get_stats()

Returns the page stats in XML format, something like below:

    <?xml version="1.0" encoding="UTF-8"?>
    <PageStats>
        <Hosts unit="number">7</Hosts>
        <Request unit="bytes">2711</Request>
        <Response unit="bytes">
                <HTML>92198</HTML>
                <CSS>37683</CSS>
                <Image>13906</Image>
                <Javascript>247174</Javascript>
                <Other>8802</Other>
        </Response>
        <Resources unit="number">
                <Static>16</Static>
                <CSS>2</CSS>
                <Javascript>6</Javascript>
                <Resource>22</Resource>
        </Resources>
    </PageStats>
    
    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;
    
    my ($api_key, $page, $stats);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $stats   = $page->get_stats();

=cut

sub get_stats
{
    my $self  = shift;
    my $stats = $self->{stats};
    
    my $xml = qq {<?xml version="1.0" encoding="UTF-8"?>\n};
    $xml .= qq {<PageStats>\n};
    $xml .= qq {\t<Hosts unit="number">}  . $stats->{numberHosts}       . qq {</Hosts>\n};
    $xml .= qq {\t<Request unit="bytes">} . $stats->{totalRequestBytes} . qq {</Request>\n};
    $xml .= qq {\t<Response unit="bytes">\n};
    $xml .= qq {\t\t<HTML>}       . $stats->{htmlResponseBytes}         . qq {</HTML>\n};
    $xml .= qq {\t\t<CSS>}        . $stats->{cssResponseBytes}          . qq {</CSS>\n};
    $xml .= qq {\t\t<Image>}      . $stats->{imageResponseBytes}        . qq {</Image>\n};
    $xml .= qq {\t\t<Javascript>} . $stats->{javascriptResponseBytes}   . qq {</Javascript>\n};
    $xml .= qq {\t\t<Other>}      . $stats->{otherResponseBytes}        . qq {</Other>\n};
    $xml .= qq {\t</Response>\n};
    $xml .= qq {\t<Resources unit="number">\n};
    $xml .= qq {\t\t<Static>}     . $stats->{numberStaticResources}     . qq {</Static>\n};
    $xml .= qq {\t\t<CSS>}        . $stats->{numberCssResources}        . qq {</CSS>\n};
    $xml .= qq {\t\t<Javascript>} . $stats->{numberJsResources}         . qq {</Javascript>\n};
    $xml .= qq {\t\t<Resource>}   . $stats->{numberResources}           . qq {</Resource>\n};
    $xml .= qq {\t</Resources>\n};
    $xml .= qq {</PageStats>};
    return $xml;
}

=head2 get_result()

Returns the page result in XML format, like below:

    <?xml version="1.0" encoding="UTF-8"?>
    <PageResults>
        <Rule name="Avoid CSS @import" impact="0" score="100"/>
        <Rule name="Inline Small JavaScript" impact="0" score="100"/>
        <Rule name="Specify a character set" impact="0" score="100"/>
        <Rule name="Specify a cache validator" impact="1" score="75"/>
        <Rule name="Specify image dimensions" impact="0" score="100"/>
        <Rule name="Make landing page redirects cacheable" impact="0" score="100"/>
        ....
        ....
        ....
    </PageResults>
    
    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;
    
    my ($api_key, $page, $result);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $result  = $page->get_result();

=cut

sub get_result
{
    my $self = shift;
    
    my ($result, $xml);
    $result = $self->{result};
    $xml = qq {<?xml version="1.0" encoding="UTF-8"?>\n};
    $xml.= qq {<PageResults>\n};
        
    foreach (sort keys %{$result})
    {
        $xml .= qq {\t<Rule name="} . $result->{$_}->{localizedRuleName} . qq {" };
        $xml .= qq {impact="}       . $result->{$_}->{ruleImpact}        . qq {" };
        $xml .= qq {score="}        . $result->{$_}->{ruleScore}         . qq {"/>\n};
    }
    $xml .= qq {</PageResults>\n};
    
    return $xml;
}

=head2 get_advise()

Returns the page advise in XML format, like below:

    <?xml version="1.0" encoding="UTF-8"?>
    <PageAdvise>
        <Rule id="DeferParsingJavaScript">
                <Header>232.9KiB of JavaScript is parsed during initial page load. Defer parsing JavaScript to reduce blocking of page rendering.</Header>
                <Items>
                        <Item>http://code.google.com/js/codesite_head.pack.04102009.js (65.4KiB)</Item>
                        ....
                        ....
                        ....
                </Items>
        </Rule>
        <Rule id="LeverageBrowserCaching">
                <Header>The following cacheable resources have a short freshness lifetime. Specify an expiration at least one week in the future for the following resources:</Header>
                <Items>
                        <Item>http://google-code-feed-gadget.googlecode.com/svn/trunk/images/cleardot.gif (3 minutes)</Item>
                        <Item>http://code.google.com/css/codesite.pack.04102009.css (60 minutes)</Item>
                        ....
                        ....
                        ....
        </Rule>
        ....
        ....
        ....
    </PageAdvise>

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;
    
    my ($api_key, $page, $advise);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $advise  = $page->get_advise();

=cut

sub get_advise
{
    my $self = shift;
    
    my ($result, $xml);
    my ($rule, $block, $url, $header, $item);
    
    $result = $self->{result};
    $xml = qq {<?xml version="1.0" encoding="UTF-8"?>\n};
    $xml.= qq {<PageAdvise>\n};
        
    foreach $rule (sort keys %{$result})
    {
        next unless exists $result->{$rule}->{urlBlocks};
        $xml .= qq {\t<Rule id="} . $rule . qq {">\n};
        foreach $block (@{$result->{$rule}->{urlBlocks}})
        {
            $header = _format($block->{header}->{format}, $block->{header}->{args});
            $xml .= qq {\t\t<Header>$header</Header>\n};
            if (exists($block->{urls}) && (scalar(@{$block->{urls}})))
            {
                $xml .= qq {\t\t<Items>\n};
                foreach $url (@{$block->{urls}})
                {
                    $item = _format($url->{result}->{format}, $url->{result}->{args});
                    $xml .= qq {\t\t\t<Item>} . $item . qq {</Item>\n};
                }
                $xml .= qq {\t\t</Items>\n};
            }    
        }
        $xml .= qq {\t</Rule>\n};
    }
    $xml .= qq {</PageAdvise>\n};
    
    return $xml;
}

=head2 get_score()

Returns the page score.

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;
    
    my ($api_key, $page, $score);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $score   = $page->get_score();

=cut

sub get_score
{
    my $self = shift;
    return $self->{score};
}

=head2 get_title()

Returns the page title.

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;
    
    my ($api_key, $page, $title);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $title   = $page->get_title();

=cut

sub get_title
{
    my $self = shift;
    return $self->{title};
}

=head2 get_id()

Returns the page id.

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;
    
    my ($api_key, $page, $id);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $id      = $page->get_id();

=cut

sub get_id
{
    my $self = shift;
    return $self->{id};
}

sub _process
{
    my $self = shift;
    my $url  = shift;
        
    my ($request, $response, $content);
    $request  = HTTP::Request->new(GET => $url);
    $response = $self->{browser}->request($request);
    croak("ERROR: Could fetch data [$url][".$response->status_line."]\n")
        unless $response->is_success;
    $content = $response->content;
    croak("ERROR: No data found for URL [$url].\n")
        unless defined $content;
        
    return from_json($content);
}

sub _get_url
{
    my $self  = shift;
    my $param = shift;
    
    my $url = sprintf("%s?key=%s&prettyprint=%s", $BASE_URL, $self->api_key, $self->prettyprint);
    $param->{locale}   = $DEFAULT_LOCALE   unless exists $param->{locale};
    $param->{strategy} = $DEFAULT_STRATEGY unless exists $param->{strategy};
    $url .= sprintf("&strategy=%s", $param->{strategy});
    $url .= sprintf("&locale=%s", $param->{locale});
    foreach (@{$param->{rule}})
    {
        $url .= sprintf("&rule=%s", $_);
    }
    return $url;
}

sub _validate_param
{
    my $param = shift;
    
    croak("ERROR: Missing input param.\n")
        unless defined($param);
    croak("ERROR: Input param has to be a ref to HASH.\n")
        if (ref($param) ne 'HASH');
    croak("ERROR: Missing key 'url'.\n")
        unless exists($param->{url});
    croak("ERROR: Invalid value for key 'url': [".$param->{url} . "].\n")
        unless is_web_uri($param->{url});
    croak("ERROR: Invalid value for key 'strategy': [".$param->{strategy} . "].\n")
        if (defined($param->{strategy}) && !exists($STRATEGIES->{lc($param->{strategy})}));
    croak("ERROR: Key 'rule' has to be a ref to ARRAY.\n")
        if (defined($param->{rule}) && (ref($param->{rule}) ne 'ARRAY'));
    
    my $count = 2;
    $param->{strategy} = $DEFAULT_STRATEGY unless defined $param->{strategy};
    if (exists($param->{rule}))
    {
        foreach (@{$param->{rule}})
        {
            croak("ERROR: Invalid value for key 'rule': [$_].\n")
                unless exists ($RULES->{uc($_)});
        }
        $count++;
    }    
    croak("ERROR: Invalid number of keys found in the param hash.\n")
        if (scalar(keys %{$param}) != $count);
}

sub _format
{
    my $data = shift;
    my $args = shift;
    
    $data =~ s/\s+/ /g;
    my $counter = 1;
    foreach my $arg (@{$args})
    {
        $data =~ s/\$$counter/$arg->{value}/e;
        $counter++;
    }
    return $data;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-google-pagespeedonline at rt.cpan.org>
or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Google-PageSpeedOnline>.
I will be notified and then you'll automatically be notified of progress on your bug as I make
changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Google::PageSpeedOnline

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Google-PageSpeedOnline>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Google-PageSpeedOnline>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Google-PageSpeedOnline>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Google-PageSpeedOnline/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mohammad S Anwar.

This  program  is  distributed  in  the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See http://dev.perl.org/licenses/ for more information.

=cut

no Moose; # keywords are removed from the WWW::Google::PageSpeedOnline package

1; # End of WWW::Google::PageSpeedOnline