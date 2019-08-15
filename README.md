### Dotfiles

these files are meant to be pulled all at once and then symlinked where needed

### Python Project Setup

- init.vim already has its own neovim python environment, project specific python modules should be installed in every
  project

- `pip install -U pylint yapf jedi mypy`

- you should then activate the project virtual environment before starting vim because deoplete will look on the path
  for executables, not in the neovim environment. The executables need to be in the same environment as the project
  requirements in order to find them
