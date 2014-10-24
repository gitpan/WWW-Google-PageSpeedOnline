package WWW::Google::PageSpeedOnline::Stats;

$WWW::Google::PageSpeedOnline::Stats::VERSION = '0.11';

use 5.006;

use Moo;
use namespace::clean;

=head1 NAME

WWW::Google::PageSpeedOnline::Stats - Placeholder for the stat of WWW::Google::PageSpeedOnline

=head1 VERSION

Version 0.11

=cut

has totalRequestBytes       => (is => 'ro');
has htmlResponseBytes       => (is => 'ro');
has cssResponseBytes        => (is => 'ro');
has imageResponseBytes      => (is => 'ro');
has javascriptResponseBytes => (is => 'ro');
has otherResponseBytes      => (is => 'ro');
has numberStaticResources   => (is => 'ro');
has numberCssResources      => (is => 'ro');
has numberJsResources       => (is => 'ro');
has numberResources         => (is => 'ro');

=head1 METHODS

=head2 totalRequestBytes()

Returns the total request bytes.

=head2 htmlResponseBytes()

Returns the HTML response bytes.

=head2 cssResponseBytes()

Returns the CSS response bytes.

=head2 imageResponseBytes()

Returns the image response bytes.

=head2 javascriptResponseBytes()

Returns the javascript response bytes.

=head2 otherResponseBytes()

Returns the other response bytes.

=head2 numberStaticResources()

Returns the number static resources.

=head2 numberCssResources()

Returns the number CSS resources.

=head2 numberJsResources()

Returns the number JS resources.

=head2 numberResources()

Returns the number resources.

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-google-pagespeedonline at
rt.cpan.org>, or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Google-PageSpeedOnline>.
I will be notified, and then you'll automatically be notified of progress on your
bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Google::PageSpeedOnline::Stats

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Google-PageSpeedOnline>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Google-PageSpeedOnline>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Google-PageSpeedOnline>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Google-PageSpeedOnline/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Mohammad S Anwar.

This  program  is  free software; you can redistribute it and/or modify it under
the  terms  of the the Artistic License (2.0). You may obtain a copy of the full
license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any  use,  modification, and distribution of the Standard or Modified Versions is
governed by this Artistic License.By using, modifying or distributing the Package,
you accept this license. Do not use, modify, or distribute the Package, if you do
not accept this license.

If your Modified Version has been derived from a Modified Version made by someone
other than you,you are nevertheless required to ensure that your Modified Version
 complies with the requirements of this license.

This  license  does  not grant you the right to use any trademark,  service mark,
tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge patent license
to make,  have made, use,  offer to sell, sell, import and otherwise transfer the
Package with respect to any patent claims licensable by the Copyright Holder that
are  necessarily  infringed  by  the  Package. If you institute patent litigation
(including  a  cross-claim  or  counterclaim) against any party alleging that the
Package constitutes direct or contributory patent infringement,then this Artistic
License to you shall terminate on the date that such litigation is filed.

Disclaimer  of  Warranty:  THE  PACKAGE  IS  PROVIDED BY THE COPYRIGHT HOLDER AND
CONTRIBUTORS  "AS IS'  AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES. THE IMPLIED
WARRANTIES    OF   MERCHANTABILITY,   FITNESS   FOR   A   PARTICULAR  PURPOSE, OR
NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY YOUR LOCAL LAW. UNLESS
REQUIRED BY LAW, NO COPYRIGHT HOLDER OR CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL,  OR CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE
OF THE PACKAGE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1; # End of WWW::Google::PageSpeedOnline::Stats
