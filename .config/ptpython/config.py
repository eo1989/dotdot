# ruff: # noqa F401,F841,C901

"""
Config
"""

import sys

# from contextlib import suppress
from typing import Any

from prompt_toolkit.application import Application
from prompt_toolkit.cursor_shapes import CursorShape, ModalCursorShapeConfig
from prompt_toolkit.enums import EditingMode
from prompt_toolkit.keys import Keys
from prompt_toolkit.filters import EmacsInsertMode, ViNavigationMode

# from prompt_toolkit.key_binding.bindings.named_commands import (
#     backward_char,
#     forward_char,
#     unix_word_rubout,
# )
from prompt_toolkit.key_binding.key_processor import KeyPress, KeyPressEvent
from prompt_toolkit.key_binding.vi_state import InputMode
from prompt_toolkit.output.color_depth import ColorDepth
# from prompt_toolkit.styles import Style

from ptpython.completer import CompletePrivateAttributes
from ptpython.layout import CompletionVisualisation
from ptpython.repl import PythonRepl
# from ptpython.style import default_ui_style

# sys.ps1 = ">>> "


# https://github.com/prompt-toolkit/python-prompt-toolkit/pull/1900
def get_cursor_shape(self, application: Application[Any]) -> CursorShape: # pyright: ignore[reportExplicitAny]
    if application.editing_mode == EditingMode.VI:
        if application.vi_state.input_mode in {
            InputMode.INSERT,
            InputMode.INSERT_MULTIPLE,
        }:
            return CursorShape.BLINKING_BEAM

        if application.vi_state.input_mode in {
            InputMode.NAVIGATION,
        }:
            return CursorShape.BLINKING_UNDERLINE

        if application.vi_state.input_mode in {
            InputMode.REPLACE,
            InputMode.REPLACE_SINGLE,
        }:
            return CursorShape.BEAM

    # default
    return CursorShape.BEAM


ModalCursorShapeConfig.get_cursor_shape = get_cursor_shape


def configure(repl: PythonRepl) -> None:
    repl.enable_auto_suggest = True
    repl.enable_dictionary_completion = True
    repl.enable_fuzzy_completion = False
    repl.accept_input_on_enter = 1
    repl.complete_private_attributes = CompletePrivateAttributes.IF_NO_PUBLIC
    repl.enable_output_formatting = True
    repl.enable_pager = True
    repl.enable_open_in_editor = True
    repl.app.timeoutlen = 0.5
    repl.app.ttimeoutlen = 0.05

    repl.show_signature = True
    repl.show_docstring = True
    repl.show_meta_enter_message = True
    repl.completion_visualisation = CompletionVisualisation.POP_UP
    repl.completion_menu_scroll_offset = 1
    repl.show_line_numbers = True
    repl.show_status_bar = True
    repl.show_sidebar_help = True
    repl.swap_light_and_dark = False
    repl.highlight_matching_parenthesis = True
    repl.wrap_lines = False

    repl.vi_mode = True
    repl.cursor_shape_config = "Modal (vi)"

    repl.all_prompt_styles |= {"python": PythonRepl(repl)}
    # use the classic prompt. (display >>> instead of 'In [1]'.)
    # repl.prompt_style = "python"

    # Enable input validation. (Don't try to execute when the input contains
    # syntax errors.)
    repl.enable_input_validation = True

    # Use this colorscheme for the code.
    repl.use_code_colorscheme("material")

    # Set color depth (keep in mind that not all terminals support true color).

    # repl.color_depth = "DEPTH_1_BIT"  # Monochrome.
    # repl.color_depth = "DEPTH_4_BIT"  # ANSI colors only.
    # repl.color_depth = "DEPTH_8_BIT"  # The default, 256 colors.
    repl.color_depth = ColorDepth.DEPTH_24_BIT  # True color.

    # Min/max brightness
    repl.min_brightness = 0.0  # Increase for dark terminal backgrounds.
    repl.max_brightness = 1.0  # Decrease for light terminal backgrounds.

    # Syntax.
    repl.enable_syntax_highlighting = True

    # Get into Vi navigation mode at startup
    repl.vi_start_in_navigation_mode = True

    # Preserve last used Vi input mode between main loop iterations
    repl.vi_keep_last_used_mode = True

    repl.show_result = sys.displayhook  # noqa

    @repl.add_key_binding("K", filter=ViNavigationMode())  # noqa
    # @repl.add_key_binding("escape", "c-h", filter=ViInsertMode()) # noqa
    # def _(event: KeyPress) -> None:
    #     """
    #
    #     :param event:
    #     :type event: KeyPressEvent
    #     :rtype None
    #     """
    #     Buffe

    @repl.add_key_binding("c-j", filter=EmacsInsertMode())
    def _(event: KeyPressEvent) -> None:
        """

        :param event:
        :type event: KeyPressEvent
        :rtype None
        """
        buffer = event.current_buffer
        buffer.newline()

    @repl.add_key_binding("c-x", "c-j", filter=EmacsInsertMode())
    def _(event: KeyPressEvent) -> None:
        """

        :param event:
        :type event: KeyPressEvent
        :rtype None
        """
        buffer = event.current_buffer
        buffer.join_next_line()

    # @repl.add_key_binding(*ALT_SHIFT_CR, filter=EmacsInsertMode())

    @repl.add_key_binding(Keys.ControlA)
    def _(event: KeyPressEvent) -> None:
        event.cli.key_processor.feed(KeyPress(Keys.Home))

    @repl.add_key_binding(Keys.ControlE)
    def _(event: KeyPressEvent) -> None:
        event.cli.key_processor.feed(KeyPress(Keys.End))

    @repl.add_key_binding(Keys.ControlP)
    def _(event: KeyPressEvent) -> None:
        if event.app.current_buffer.complete_state:
            event.app.current_buffer.complete_previous(disable_wrap_around=True)
        else:
            event.app.current_buffer.history_backward()

    @repl.add_key_binding(Keys.ControlN)
    def _(event: KeyPressEvent) -> None:
        if event.app.current_buffer.complete_state:
            event.app.current_buffer.complete_next(disable_wrap_around=True)
        else:
            event.app.current_buffer.history_forward()

    @repl.add_key_binding(Keys.ControlSpace)
    def _(event: KeyPressEvent) -> None:
        event.app.current_buffer.start_completion(select_first=False)

    @repl.add_key_binding(Keys.ControlR)
    def _(event: KeyPressEvent | int):
        from subprocess import Popen, PIPE
        from collections import OrderedDict

        # REPL history. Oldest item first -> Newest item first
        lines = event.app.current_buffer.history.get_strings()[::-1]
        lines = list(OrderedDict.fromkeys(lines))  # uniquify

        fzf = Popen(
            [
                "fzf",
                "--layout=reverse",
                "--scheme=history",
                "--prompt",
                "REPL History> ",
                "--height",
                "~30%",
                "+m",
            ],
            stdout=PIPE,
            stdin=PIPE,
        )
        for line in lines:
            line = line.replace("\n", "\r")
            fzf.stdin.write((line + "\n").encode(encoding='utf8'))  # type: ignore

        fzf.stdin.flush()  # noqa
        fzf_output = fzf.communicate()[0].decode()

        if fzf_output:
            fzf_output = fzf_output.replace("\r", "\n").rstrip("\n")
            event.app.current_buffer.text = ""  # clear the input buffer
            event.app.current_buffer.insert_text(fzf_output, overwrite=True)

        event.app.renderer.reset()
