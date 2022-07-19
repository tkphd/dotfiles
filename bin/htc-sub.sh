#!/bin/bash
set -e
SUB=job.sub

if [[ $# == 1 ]]; then
    SUB="$1"
elif [[ $# -gt 1 ]]; then
    echo "Unexpected invocation. Usage:"
    echo "  $0 «job.sub»"
    exit
else
    echo "Defaulting to «job.sub»"
fi

[[ -f "${SUB}" ]] && \
    echo "Warning: this script will over-write ${SUB}"

echo "# HTCondor Submit Script"          >  ${SUB}
{
    echo ""
    echo "universe = vanilla"
    echo ""
    echo "executable = "
    echo "arguments = "
    echo "transfer_input_files = "
    echo ""
    echo "error  = ${SUB/sub/err}"
    echo "log    = ${SUB/sub/log}"
    echo "output = ${SUB/sub/out}"
    echo ""
    echo "request_cpus = 1"
    echo "request_memory = 1GB"
    echo "request_disk = 1GB"
    echo ""
    echo "should_transfer_files = YES"
    echo "when_to_transfer_output = ON_EXIT"
    echo ""
    echo "queue 1"
} >> ${SUB}
