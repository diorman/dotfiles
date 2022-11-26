import os

HOMEPATH = os.getenv("HOME")
CODEPATH = f'{HOMEPATH}/Code'

def which(program: str) -> str:
    return f'{HOMEPATH}/.nix-profile/bin/{program}'
