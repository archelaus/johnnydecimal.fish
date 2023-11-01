if test -z "$JOHNNYDECIMAL_BASE"
    echo "No Johnny.Decimal basedir given"
    return 1
else
    set -gx JOHNNYDECIMAL_BASE /tmp/jd
end

function _johnny_fetchpath
    set -l targetpath $JOHNNYDECIMAL_BASE/$_j_area*/$_j_category*/$_j_category.$_j_unique*
    set -g retval (realpath $targetpath)
end

function _johnny_splitdecimal
    # set _j_category (string sub --length 2 $argv[1])
    # set _j_unique (string sub --start 4 --length 2 $argv[1])

    echo $argv[1] | read -d. -g _j_category _j_unique

    set -l _j_area_lower (math "round($_j_category / 10) * 10")
    set -l _j_area_upper (math "$_j_area_lower + 9")
    set -g _j_area (printf '%02d-%02d' $_j_area_lower $_j_area_upper)
end

function jcd
    if not test (count $argv) -eq 1
        echo "Usage:"
        echo '$ jcd AC.ID (Area Category ID)'
        return
    end
    _johnny_splitdecimal $argv[1]
    _johnny_fetchpath
    pushd "$retval"
end

function jcp
    if test (count $argv) -lt 2
        echo "Usage:"
        echo '$ jcd AC.ID SRC'
        return
    end
    _johnny_splitdecimal $argv[1]
    _johnny_fetchpath
    cp --no-clobber --verbose --recursive $argv[2..] "$retval"
end

function jmv
    if test (count $argv) -lt 2
        echo "Usage:"
        echo '$ jmv AC.ID SRC'
        return
    end
    _johnny_splitdecimal $argv[1]
    _johnny_fetchpath
    mv --no-clobber --verbose $argv[2..] "$retval"
end

function jmkarea
    if test (count $argv) -lt 2
        echo "Usage:"
        echo '$ jmkarea AREA DESC'
        return
    end
    _johnny_splitdecimal $argv[1].00
    mkdir --verbose "$JOHNNYDECIMAL_BASE/$_j_area $argv[2]"
end

function jmkcat
    if test (count $argv) -lt 2
        echo "Usage:"
        echo '$ jmkcat CATEGORY DESC'
        return
    end
    _johnny_splitdecimal $argv[1]
    set -l targetpath "$JOHNNYDECIMAL_BASE/$_j_area "*
    mkdir --verbose "$targetpath/$_j_category $argv[2]"
end

function jmkuni
    if test (count $argv) -lt 2
        echo "Usage:"
        echo '$ jmkuni AC.ID DESC'
        return
    end
    _johnny_splitdecimal $argv[1]
    set -l targetpath "$JOHNNYDECIMAL_BASE/$_j_area "*"/$_j_category "*
    mkdir --verbose "$targetpath/$_j_category.$_j_unique $argv[2]"
end
