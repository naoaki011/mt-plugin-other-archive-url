package OtherArchiveURL::Tags;

use strict;
use Data::Dumper;

sub _another_url {
	my ($ctx, $args, $cond) = @_;
	my $blog = $ctx->stash('blog') or return;
	my $template_id;
	my $archive_type = $ctx->{current_archive_type};
#	my $archive_type_ext = $ctx->{archive_type};
	my $time_stamp = $ctx->{current_timestamp};
#	my $tag = $ctx->stash('tag');

	require MT::FileInfo;
	require MT::Template;
	if ($archive_type) { #archive only

		# $template_id : TemplateID of parse ArchiveMappings.
		if ($args->{id}) {
			$template_id = $args->{id};
		}
		elsif ($args->{identifier}) {
			# idetifier="archive_listing"
			my $tmpl = MT::Template->load({
										blog_id => $blog->id,
										identifier => $args->{identifier}
										});
			$template_id = $tmpl->id;
		}
		elsif ($args->{label}) {
			# label="Category Archives"
			my $tmpl = MT::Template->load({
										blog_id => $blog->id,
										name => $args->{label}
										});
			$template_id = $tmpl->id;
		}

		if ($archive_type eq 'Category') {
			#category archive
			my $category = ($ctx->stash('category') || $ctx->stash('archive_category')) or return;
			if ($args->{map_id}) {
				my @finfos = MT::FileInfo->load({
											blog_id        => $blog->id,
											archive_type   => $archive_type,
											category_id    => $category->id,
											template_id    => $template_id,
											templatemap_id => $args->{map_id},
											});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
			else {
				my @finfos = MT::FileInfo->load({
											blog_id     => $blog->id,
											archive_type => $archive_type,
											category_id => $category->id,
											template_id => $template_id,
											});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		elsif ($archive_type eq 'Individual') {
			#entry
			my $entry = $ctx->stash('entry') or return $ctx->_no_entry_error();
			if ($args->{map_id}) {
				my @finfos = MT::FileInfo->load({
											blog_id     => $blog->id,
											archive_type => $archive_type,
											entry_id => $entry->id,
											template_id => $template_id,
											templatemap_id => $args->{map_id},
											});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
			else {
				my @finfos = MT::FileInfo->load({
											blog_id     => $blog->id,
											archive_type => $archive_type,
											entry_id => $entry->id,
											template_id => $template_id,
											});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		elsif ($archive_type eq 'Page') {
			#page
			my $entry = $ctx->stash('entry') or return $ctx->_no_entry_error();
			doLog($entry->id);
			if ($args->{map_id}) {
				my @finfos = MT::FileInfo->load({
											blog_id     => $blog->id,
											archive_type => $archive_type,
											entry_id => $entry->id,
											template_id => $template_id,
											templatemap_id => $args->{map_id},
											});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
			else {
				my @finfos = MT::FileInfo->load({
											blog_id     => $blog->id,
											archive_type => $archive_type,
											entry_id => $entry->id,
											template_id => $template_id,
											});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		elsif (($archive_type eq 'Monthly') && ($time_stamp)) {
			#monthly archive
			if ($args->{map_id}) {
				my @finfos = MT::FileInfo->load({
											blog_id      => $blog->id,
											archive_type => $archive_type,
											startdate    => $time_stamp,
											template_id  => $template_id,
											templatemap_id => $args->{map_id},
										});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
			else {
				my @finfos = MT::FileInfo->load({
											blog_id      => $blog->id,
											archive_type => $archive_type,
											startdate    => $time_stamp,
											template_id  => $template_id,
										});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		else {
			# Not Support Other Archive Type yet.
		}
	}
}

sub doLog {
    my ($msg) = @_; 
    use MT::Log; 
    my $log = MT::Log->new; 
    if ( defined( $msg ) ) { 
        $log->message( $msg ); 
    }
    $log->save or die $log->errstr; 
}

1;
