#! ~/.pyenv/versions/3.9.0/bin/python

from typing import List
from kitty.boss import Boss

def main(args: List[str]) -> str:
    """
    main entry point for this kitten, itll be executed in
    the overlay window when the kitten is launched.    
    """
    answer = input('Enter some text: ')
    # whatever this fx returns will be avaiable in the handle_result() function
    return answer


def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    # get the kitty window into which to paste answer
    w = boss.target_id_map.get(target_window_id)
    if w is not None:
        w.paste(answer)


"""
now map ctrl+k kitten mykitten.py
pass arguments via: map ctrl+k kitten mykitten.py arg1 arg2
these will be avialbe as the args parameter in the main() and handle_result() functions.
Note also that the cwd of the kitten is set to the working directory of whatever program is running
in the activve kitty window. The special argument @selection is replaced by the currently
selected text in the active kitty window.
"""
