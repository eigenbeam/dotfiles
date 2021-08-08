  # JavaScript & TypeScript

LSP:

1. Install [nvm](https://github.com/creationix/nvm) to install and manage NodeJS versions.
2. Install and use a version of Node:
    ```
     $ nvm install <version>
     $ nvm alias default <version>
     $ nvm use default
     ```
3. Create and setup an ES5 project:
    ```
     $ mkdir foo && cd foo
     $ npm init -y
     $ npm install -D eslint
     $ npx eslint --init
     ```
4. (Optional) Create and setup an ES.next project:
    ```
     $ # ES5 steps above, and:
     $ npm install -D babel-cli babel-preset-env
     $ echo "{'presets': ['env']}" > .babelrc
     $ npm install -S babel-polyfill
     ```
 Language Servers
 Theia-ide (Preferred): https://github.com/theia-ide/typescript-language-server
   `$ npm i -D typescript-language-server`
 Sourcegraph: https://github.com/sourcegraph/javascript-typescript-langserver
   `$ npm i -D javascript-typescript-langserver`
TODO
(setq nodejs-repl-command "npx ts-node"))

  # Python

LSP:

1. Install [pyenv](https://github.com/pyenv/pyenv),
    [pyenv-installer](https://github.com/pyenv/pyenv-installer), and
    [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
    to install and manage Python versions and virtualenvs.
2. Create & setup the project:
     $ mkdir foo && cd foo
      $ pyenv virtualenv 3.7.3 foo
      $ pyenv activate foo
      $ pip install autopep8 flake8 ipython jedi "ptvsd>=4.2"
3. Install the Palantir Python Language Server:

      $ pip install python-language-server

    and optionally:

      $ pip install pyls-mypy
      $ pip install pyls-isort
      $ pip install pyls-black
4. Add a dir-local variable to activate the virtualenv. `M-x
    add-dir-local-variable`. For `python-mode` set `pyvenv-activate` to
    the name of the virtualenv. E.g., in the root of your project,
    there will be a .dir-locals.el with:

      ((python-mode
        (pyvenv-activate . "/home/kbeam/.pyenv/versions/py-lab")))
