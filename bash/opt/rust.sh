#!/bin/bash
# rustup shell setup
# affix colons on either side of $PATH to simplify matching
case ":$HOME/.cargo/bin:" in
    *"${PATH}"*)
        ;;
    *)
        # Prepending path in case a system-installed rustc needs to be overridden
        export PATH="${HOME}/.cargo/bin:${PATH}"
        ;;
esac
