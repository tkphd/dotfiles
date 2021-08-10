#!/bin/bash

SUB=job.sub

if [[ $# == 1 ]]; then
    SUB=$1
elif [[ $# > 1 ]]; then
    echo "Unexpected invocation. Usage:"
    echo "  $0 job.sub"
    exit
fi

echo "# HTCondor Submit Script" >  ${SUB}
echo ""                         >> ${SUB}
echo "universe = vanilla"       >> ${SUB}
echo ""                         >> ${SUB}
echo "executable = "            >> ${SUB}
echo "arguments = "             >> ${SUB}
echo "transfer_input_files = "  >> ${SUB}
echo ""                         >> ${SUB}
echo "error  = ${SUB/sub/err}"  >> ${SUB}
echo "log    = ${SUB/sub/log}"  >> ${SUB}
echo "output = ${SUB/sub/out}"  >> ${SUB}
echo ""                         >> ${SUB}
echo "request_cpus = 1"         >> ${SUB}
echo "request_memory = 1GB"     >> ${SUB}
echo "request_disk = 1GB"       >> ${SUB}
echo ""                         >> ${SUB}
echo "should_transfer_files = YES" >> ${SUB}
echo "when_to_transfer_output = ON_EXIT" >> ${SUB}
echo ""                         >> ${SUB}
echo "queue 1"                  >> ${SUB}
