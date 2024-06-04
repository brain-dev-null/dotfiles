possible_venv_dirs=("venv" "env" ".env" ".venv")
for file in "${possible_venv_dirs[@]}"; do
  if [ -f "./$file/bin/activate" ]; then
    source ./$file/bin/activate
    break
  fi
done
