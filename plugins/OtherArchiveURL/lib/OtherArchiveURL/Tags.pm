package OtherArchiveURL::Tags;

use strict;

sub _another_url {
	my ($ctx, $args, $cond) = @_;
	my $blog = $ctx->stash('blog')
	  or return;
	my $archive_type = $ctx->{current_archive_type} || $ctx->{archive_type} || '';
	my $time_stamp = $ctx->{current_timestamp} || '';
#	my $tag = $ctx->stash('tag');

	require MT::FileInfo;
	require MT::Template;
	if ($archive_type || $time_stamp) {
		my $template_id;
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
		return unless $template_id
		  or doLog('Cant Load Template');

		if ($archive_type eq 'Category') {
			#category archive
			my $category = ($ctx->stash('category') || $ctx->stash('archive_category'))
			  or return;
			if ($args->{map_id}) {
				my @finfos = MT::FileInfo->load({
								blog_id        => $blog->id,
								archive_type   => $archive_type,
								category_id    => $category->id,
								template_id    => $template_id,
								templatemap_id => $args->{map_id},
							}) || return;
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
							}) || return;
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		elsif ($archive_type eq 'Category-Daily') {
			doLog('Cant Export OtherArchiveURL for Category-Daily');
		}
		elsif ($archive_type eq 'Category-Weekly') {
			doLog('Cant Export OtherArchiveURL for Category-Weekly');
		}
		elsif ($archive_type eq 'Category-Monthly') {
			doLog('Cant Export OtherArchiveURL for Category-Monthly');
		}
		elsif ($archive_type eq 'Category-Yearly') {
			doLog('Cant Export OtherArchiveURL for Category-Yearly');
		}
		elsif ($archive_type eq 'Individual') {
			#entry
			my $entry = $ctx->stash('entry')
			  or return $ctx->_no_entry_error();
			if ($args->{map_id}) {
				my @finfos = MT::FileInfo->load({
								blog_id     => $blog->id,
								archive_type => $archive_type,
								entry_id => $entry->id,
								template_id => $template_id,
								templatemap_id => $args->{map_id},
							}) || return;
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
							}) || return;
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		elsif ($archive_type eq 'Page') {
			#page
			my $entry = $ctx->stash('entry')
			  or return $ctx->_no_entry_error();
			if ($args->{map_id}) {
				my @finfos = MT::FileInfo->load({
								blog_id     => $blog->id,
								archive_type => $archive_type,
								entry_id => $entry->id,
								template_id => $template_id,
								templatemap_id => $args->{map_id},
							}) || return;
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
							}) || return;
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
							}) || return;
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
							}) || return;
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		elsif ($archive_type eq 'Daily') {
			doLog('Cant Export OtherArchiveURL for DailyArchive');
		}
		elsif ($archive_type eq 'Weekly') {
			doLog('Cant Export OtherArchiveURL for WeeklyArchive');
		}
		elsif ($archive_type eq 'Yearly') {
			doLog('Cant Export OtherArchiveURL for YearlyArchive');
		}
		elsif ($ctx->stash('entry')) {
			my $entry = $ctx->stash('entry');
			my $entry_type = ($entry->class eq 'entry') ? 'Individual' : 'Page';
			if ($args->{map_id}) {
				my @finfos = MT::FileInfo->load({
								blog_id     => $blog->id,
								archive_type => $entry_type,
								entry_id => $entry->id,
								template_id => $template_id,
								templatemap_id => $args->{map_id},
							}) || return;
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
			else {
				my @finfos = MT::FileInfo->load({
								blog_id     => $blog->id,
								archive_type => $entry_type,
								entry_id => $entry->id,
								template_id => $template_id,
							}) || return;
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		elsif ($archive_type eq 'Author') {
			doLog('Cant Export OtherArchiveURL for AuthorArchive');
		}
		elsif ($archive_type eq 'Author-Monthly') {
			doLog('Cant Export OtherArchiveURL for Author-MonthlyArchive');
		}
		elsif ($archive_type eq 'Author-Daily') {
			doLog('Cant Export OtherArchiveURL for Author-DailyArchive');
		}
		elsif ($archive_type eq 'Author-Weekly') {
			doLog('Cant Export OtherArchiveURL for Author-WeeklyArchive');
		}
		elsif ($archive_type eq 'Author-Yearly') {
			doLog('Cant Export OtherArchiveURL for Author-YearlyArchive');
		}
		else {
			# Not Support Other Archive Type yet.
			doLog('Cant Export OtherArchiveURL for ' . $archive_type . 'Archive');
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
