#!/bin/bash
# rustup shell setup
# affix colons on either side of $PATH to simplify matching
echo -n RUST
# case ":${PATH}:" in
#     *:"$HOME/.cargo/bin":*)
case ":$HOME/.cargo/bin:" in
    *"${PATH}"*)
	echo " already loaded"
        ;;
    *)
        # Prepending path in case a system-installed rustc needs to be overridden
        export PATH="${HOME}/.cargo/bin:${PATH}"
	echo " prepended path"
        ;;
esac
