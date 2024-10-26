echo "Updating brew packages"
brew update && \
  brew upgrade

echo "Updating npm packages"
pnpm update --global -L
npm -g update
yarn global upgrade

