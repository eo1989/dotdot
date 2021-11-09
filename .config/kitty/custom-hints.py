#!/Users/eo/.pyenv/shims/python
# -*- coding: utf-8 -*-
import re


def mark(text, args, Mark, extra_cli_args, *a):
    """
    this fx responsible for finding all matching text.
    'exta_cli_args' are any extra arguments passed
    on the cmd line when invoking the kitten.
    mark all individual words for potential selection
    """
    for idx, m in enumerate(re.finditer(r'\w+', text)):
        start, end = m.span()
        mark_text = text[start:end].replace('\n', '').replace('\0', '')
        """
        empty dict below will be available as groupdicts in handle_result()
        & can be arbitrary data
        """
        yield Mark(idx, start, end, mark_text, {})


def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    """
    resp for performing some action on selected text
    matches is a list of the selected entries & groupdicts contains
    the arb data assoc. w/ ea. entry in mark() above
    """
    matches, groupdicts = [], []
    for m, g in zip(data['match'], data['groupdicts']):
        if m:
            matches.append(m), groupdicts.append(g)
    for word, match_data in zip(matches, groupdicts):
        """
        Look up the word in a dict, the open_url fx will open
        the provided url in the system browser
        """
        boss.open_url(f'https://www.google.com/search?q=define:{word}')
