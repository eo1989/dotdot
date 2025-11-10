import os
import tempfile as tmp
from shutil import which

FZF_URL = "https://github.com/junegunn/fzf"


class FzfPrompt:
    def __init__(self, executable=None) -> None:
        if executable:
            self.executable = executable
        elif not which("fzf") and not executable:
            raise SystemError(f"Cant find 'fzf' installed on PATH. ({FZF_URL})")
        else:
            self.executable = "fzf"

    def prompt(self, choices=None, fzf_options="", delimiter="\n"):
        # lets convert list to strings [1, 2, 3] => "1\n2\n3"
        choices_str = delimiter.join(map(str, choices))
        selection = []

        with tmp.NamedTemporaryFile(delete=False) as input_file:
            with tmp.NamedTemporaryFile(delete=False) as output_file:
                # create a temp file with list entries as lines
                input_file.write(choices_str.encode("utf-8"))
                input_file.flush()

        # invoke fzf externally && write to outptu file
        os.system(
            f'{self.executable} {fzf_options} < "{input_file.name}" > "{output_file.name}"'
        )

        # get selected opts
        with open(output_file.name, encoding="utf-8") as f:
            for line in f:
                selection.append(line.strip("\n"))

        os.unlink(input_file.name)
        os.unlink(output_file.name)

        return selection
