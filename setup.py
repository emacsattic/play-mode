from distutils.core import setup

setup (name = "Plywood",
       version = "0.5.1",
       description = "A system for typing and typesetting plays",
       author = "Monty Taylor",
       author_email = "mordred@inaugust.com",
       url = "http://inaugust.com/",

       py_modules = ['Plywood','WxPly'],
       scripts = ['plywood','plywood.real'],

      )
