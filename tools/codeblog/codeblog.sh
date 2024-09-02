#!/bin/sh
#
#
USAGE='[-title <title>] [-stamp <stamp>] <outname> <readme> [codefile] [...]'
#
#
#



warn(){ echo "$*" >&2; }
die(){ warn "$*"; exit 1;  }


stamp=
title=
while [ $# -gt 0 ] ; do
    case "$1" in
        -stamp)
            stamp="${2:-}"
            [ -n "$stamp" ] || die "no stamp, usage $USAGE" 
            shift
            ;;
        -title)
            title="${2:-}"
            [ -n "$title" ] || die "no title, usage $USAGE" 
            shift
            ;;
        -*) die "Err invalid arg $1" ;;
        *) break;;
    esac
    shift
done

outname="$1"
shift
readme="$1"
shift

[ -n "$outname" ] || die "Usage: $USAGE"
[ -n "$readme" ] || die "Usage: $USAGE"

[ -f "$readme" ] || die "Err: no valid readme" 

case "$readme" in
    readme*|Readme*|README*) : ;;
    *) die "Err: readme does not look like readme (usage)";;
esac

stamp="$(date +'%Y%m%d%H%M%S')"
[ -n "$stamp" ] || die "Err:no stamp"

outdir="${outname}_$stamp"

htmlfile="${outdir}.html"

if [ -f "$htmlfile" ]; then
    sleep 2
    stamp2="$(date +'%Y%m%d%H%M%S')"
    [ -n "$stamp2" ] || die "Err:no stamp"
    outdir="${outname}_$stamp2"
    htmlfile="${outdir}.html"
    [ -f "$htmlfile" ] || die "Err: htmlfile $htmlfile already exists" 
fi





tmpfile="$(mktemp /tmp/codeblog.XXXXXX)"

cat "$readme" > "$tmpfile"

if [ "$#" -gt 0 ] ; then
    if [ -d "$outdir" ]; then
        die "Err: outdir $outdir already exists" 
    else
        mkdir -p "$outdir"
    fi

    archive_file="${outdir}.zip"
    [ -f "$archive_file" ] && die "Err: archive file $archive_file already exists" 

    cp "$readme" "$outdir/"

    {
    echo ""
    echo ""
    echo "## Sources"

    for file in $@; do
        if [ -f "$file" ] ; then
            cp "$file" "$outdir/"
            echo " "
            echo "[$file]($outdir/$file)"
            echo '```{ .numberLines }'
            #echo '```{ .numberLines }'
            cat "$file"
            echo '```'
        else 
            warn "File $file not exists"
        fi
    done
    } >> "$tmpfile"

    zip -r  "$archive_file" "$outdir"

fi

has_archive_title=

for archive in * ; do 
    [ -f "$archive" ] || continue
    case "$archive" in
        "$outname"_*[!0-9]*.zip|"$outname"_*[!0-9]*.tar.gz) : ;;
        "$outname"_*.zip|$outname.zip|"$outname"_*.tar.gz|$outname.tar.gz) 
            if [ -z "$has_archive_title" ] ; then
                {
                echo ""
                echo "## Downloads"
                echo ""
                } >> "$tmpfile" 
                has_archive_title=1
            fi
            echo "[$archive]($archive)"  >> "$tmpfile"
            ;;
        *) : ;;
    esac
done

if [ -n "$title" ] ; then
    pandoc --metadata title="$title" -s "$tmpfile" > "$htmlfile"
else
    pandoc -s "$tmpfile" > "$htmlfile"
fi

if [ -f "$htmlfile" ] ; then
    echo "OK: written to $htmlfile"
else
    die "Err: could no write to $htmlfile"
fi

