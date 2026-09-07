clear -all

set ROOT [file normalize [file join [pwd] "../.."]]

analyze -sv -f [file join $ROOT Formal/scripts/rtl.f]
analyze -sv -f [file join $ROOT Formal/scripts/sva.f]
analyze -sv -f [file join $ROOT Formal/scripts/formal_sources.f]

elaborate -top formal_top

clock aclk
reset -expression {!aresetn}

prove -all
report -summary -file [file join $ROOT Formal/reports/formal_summary.rpt]

exit
