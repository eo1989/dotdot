import pynvim
from pynvim.api.nvim import Nvim
from time import sleep
import asyncio as asyn


@pynvim.plugin
class MyPlug(object):
    def __init__(arg, nvim: Nvim) -> None:
        self.nvim = nvim

    @pynvim.function("LongBlock")
    def long_block(self, args):
        sleep(5)
        self.nvim.command('echo "done w/ blocking stuff"')

    @pynvim.function("AsyncNoBlock")
    def async_no_block(self, args):
        async def no_block():
            await asyn.sleep(5)
            self.nvim.command('echo "done w/ async stuff"')

        self.nvim.loop.create_task(no_block())
