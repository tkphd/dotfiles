#!/bin/bash
# Remove spaces from filenames

for T in d f; do
    find . -name "* *" -type $T -exec rename 'y/ /-/' "{}" \;
    find . -name "*(*" -type $T -exec rename 'y/(/-/' "{}" \;
    find . -name "*)*" -type $T -exec rename 'y/)/-/' "{}" \;
    find . -name "*-*" -type $T -exec rename 's/-{2,10}/-/g' "{}" \;
done
