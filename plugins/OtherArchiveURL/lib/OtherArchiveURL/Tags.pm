package OtherArchiveURL::Tags;

use strict;

sub _another_url {
	my ($ctx, $args, $cond) = @_;
	my $blog = $ctx->stash('blog')
	  or return;
	my $archive_type = $ctx->{current_archive_type} || $ctx->{archive_type} || '';
	my $time_stamp = $ctx->{current_timestamp} || '';
	my $map_id = $args->{map_id} || '';

	require MT::FileInfo;
	require MT::Template;
	if ($archive_type || $time_stamp) {
		unless ($archive_type) {
			my $entry = $ctx->stash('entry');
			if ($entry) {
				$archive_type = 'Individual' if ($entry->class eq 'entry');
				$archive_type = 'Page' if ($entry->class eq 'page');
			}
		}
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
			$template_id = $tmpl->id if $tmpl;
		}
		elsif ($args->{label}) {
			# label="Category Archives"
			my $tmpl = MT::Template->load({
								blog_id => $blog->id,
								name => $args->{label}
							});
			$template_id = $tmpl->id if $tmpl;
		}
		elsif ($args->{archive_file_name}) {
			require MT::TemplateMap;
			# archive_file_name="%c/%f"
			my $tmplmap = MT::TemplateMap->load({
								blog_id => $blog->id,
								archive_type => $archive_type,
								file_template => $args->{archive_file_name}
							});
			$template_id = $tmplmap->template_id if $tmplmap;
			$map_id = $tmplmap->id if $tmplmap;
		}
		return unless $template_id
		  or doLog('Cant Load Template');

		if ($archive_type eq 'Category') {
			#category archive
			my $category = ($ctx->stash('category') || $ctx->stash('archive_category'))
			  or return;
			if ($map_id}) {
				my @finfos = MT::FileInfo->load({
								blog_id        => $blog->id,
								archive_type   => $archive_type,
								category_id    => $category->id,
								template_id    => $template_id,
								templatemap_id => $map_id,
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
								category_id  => $category->id,
								template_id  => $template_id,
							});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
			require MT::TemplateMap;
			my $pref_tmplmap = MT::TemplateMap->load({
								blog_id      => $blog->id,
								archive_type => $archive_type,
								is_preferred => 1,
							});
			if ($pref_tmplmap) {
				my @finfos = MT::FileInfo->load({
								blog_id      => $blog->id,
								archive_type => $archive_type,
								category_id  => $category->id,
								templatemap_id => $pref_tmplmap->id,
							}) || return;
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		elsif (($archive_type  =~ /^Category-(Daily|Weekly|Monthly|Yearly)$/) && ($time_stamp)) {
			my $category = ($ctx->stash('category') || $ctx->stash('archive_category'))
			  or return;
			if ($map_id) {
				my @finfos = MT::FileInfo->load({
								blog_id        => $blog->id,
								archive_type   => $archive_type,
								category_id    => $category->id,
								startdate      => $time_stamp,
								template_id    => $template_id,
								templatemap_id => $map_id,
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
								category_id  => $category->id,
								startdate    => $time_stamp,
								template_id  => $template_id,
							});
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
			require MT::TemplateMap;
			my $pref_tmplmap = MT::TemplateMap->load({
								blog_id      => $blog->id,
								archive_type => $archive_type,
								is_preferred => 1,
							});
			if ($pref_tmplmap) {
				my @finfos = MT::FileInfo->load({
								blog_id      => $blog->id,
								archive_type => $archive_type,
								category_id  => $category->id,
								startdate    => $time_stamp,
								templatemap_id => $pref_tmplmap->id,
							}) || return;
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		elsif (($archive_type =~ /^(Daily|Weekly|Monthly|Yearly)$/) && ($time_stamp)) {
			if ($map_id) {
				my @finfos = MT::FileInfo->load({
								blog_id      => $blog->id,
								archive_type => $archive_type,
								startdate    => $time_stamp,
								template_id  => $template_id,
								templatemap_id => $map_id,
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
			require MT::TemplateMap;
			my $pref_tmplmap = MT::TemplateMap->load({
								blog_id      => $blog->id,
								archive_type => $archive_type,
								is_preferred => 1,
							});
			if ($pref_tmplmap) {
				my @finfos = MT::FileInfo->load({
								blog_id      => $blog->id,
								archive_type => $archive_type,
								startdate    => $time_stamp,
								templatemap_id => $pref_tmplmap->id,
							}) || return;
				foreach my $finfo (@finfos) {
					return $finfo->url;
					last; #if template have multiple archive-mapping in same archive_type. return first only.
				}
			}
		}
		else {
			my $entry = $ctx->stash('entry');
			if ($entry) {
				if ($archive_type) {
					if ($map_id) {
						my @finfos = MT::FileInfo->load({
										blog_id      => $blog->id,
										archive_type => $archive_type,
										entry_id     => $entry->id,
										template_id  => $template_id,
										templatemap_id => $map_id,
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
										entry_id     => $entry->id,
										template_id  => $template_id,
									});
						foreach my $finfo (@finfos) {
							return $finfo->url;
							last; #if template have multiple archive-mapping in same archive_type. return first only.
						}
					}
					require MT::TemplateMap;
					my $pref_tmplmap = MT::TemplateMap->load({
										blog_id      => $blog->id,
										archive_type => $archive_type,
										is_preferred => 1,
									});
					if ($pref_tmplmap) {
						my @finfos = MT::FileInfo->load({
										blog_id      => $blog->id,
										archive_type => $archive_type,
										entry_id     => $entry->id,
										templatemap_id => $pref_tmplmap->id,
									}) || return;
						foreach my $finfo (@finfos) {
							return $finfo->url;
							last; #if template have multiple archive-mapping in same archive_type. return first only.
						}
					}
				}
				else {
					# Not Support Other Archive Type yet.
					doLog('Cant Export OtherArchiveURL for ' . $archive_type . 'Archive');
				}
			}
			else {
				my $author = $ctx->stash('author') || $ctx->stash('user');
				if ($author) {
					if ($archive_type eq 'Author') {
						if ($map_id) {
							my @finfos = MT::FileInfo->load({
											blog_id      => $blog->id,
											archive_type => $archive_type,
											author_id    => $author->id,
											template_id  => $template_id,
											templatemap_id => $map_id,
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
											author_id    => $author->id,
											template_id  => $template_id,
										});
							foreach my $finfo (@finfos) {
								return $finfo->url;
								last; #if template have multiple archive-mapping in same archive_type. return first only.
							}
						}
						require MT::TemplateMap;
						my $pref_tmplmap = MT::TemplateMap->load({
											blog_id      => $blog->id,
											archive_type => $archive_type,
											is_preferred => 1,
										});
						if ($pref_tmplmap) {
							my @finfos = MT::FileInfo->load({
											blog_id      => $blog->id,
											archive_type => $archive_type,
											author_id    => $author->id,
											templatemap_id => $pref_tmplmap->id,
										}) || return;
							foreach my $finfo (@finfos) {
								return $finfo->url;
								last; #if template have multiple archive-mapping in same archive_type. return first only.
							}
						}
					}
					elsif (($archive_type  =~ /^Author-(Daily|Weekly|Monthly|Yearly)$/) && ($time_stamp)) {
						if ($map_id) {
							my @finfos = MT::FileInfo->load({
											blog_id      => $blog->id,
											archive_type => $archive_type,
											author_id    => $author->id,
											startdate    => $time_stamp,
											template_id  => $template_id,
											templatemap_id => $map_id,
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
											author_id    => $author->id,
											startdate    => $time_stamp,
											template_id  => $template_id,
										});
							foreach my $finfo (@finfos) {
								return $finfo->url;
								last; #if template have multiple archive-mapping in same archive_type. return first only.
							}
						}
						require MT::TemplateMap;
						my $pref_tmplmap = MT::TemplateMap->load({
											blog_id      => $blog->id,
											archive_type => $archive_type,
											is_preferred => 1,
										});
						if ($pref_tmplmap) {
							my @finfos = MT::FileInfo->load({
											blog_id      => $blog->id,
											archive_type => $archive_type,
											author_id    => $author->id,
											startdate    => $time_stamp,
											templatemap_id => $pref_tmplmap->id,
										}) || return;
							foreach my $finfo (@finfos) {
								return $finfo->url;
								last; #if template have multiple archive-mapping in same archive_type. return first only.
							}
						}
					}
					else {
						# Not Support Other Archive Type yet.
						doLog('Cant Export OtherArchiveURL for ' . $archive_type . 'Archive');
					}
				}
				else {
					# Not Support Other Archive Type yet.
					doLog('Cant Export OtherArchiveURL for ' . $archive_type . 'Archive');
				}
			}
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
