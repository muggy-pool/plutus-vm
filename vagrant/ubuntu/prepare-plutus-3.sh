# Configure NIX cache for quicker builds
mkdir -p /home/$1/.config/nix
cat >> /home/$1/.config/nix/nix.conf <<EOF
substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
EOF

# Prepare editor environment for Haskell highlighting
#curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#vim +'PlugInstall --sync' +qa 2>&1

# Clone approrpiate repositories
mkdir ~/git
cd ~/git
git clone https://github.com/input-output-hk/plutus-pioneer-program.git
git clone https://github.com/input-output-hk/plutus-apps.git

# Leftover code from previous classes
#touch updatePlutus.sh
#echo "nix build -f default.nix plutus.haskell.packages.plutus-core.components.library" >> updatePlutus.sh
#echo "nix-build -A plutus-playground.client" >> updatePlutus.sh
#echo "nix-build -A plutus-playground.server" >> updatePlutus.sh
#echo "nix-build -A plutus-playground.generate-purescript" >> updatePlutus.sh
#echo "nix-build -A plutus-playground.start-backend" >> updatePlutus.sh
#echo "nix-build -A plutus-pab" >> updatePlutus.sh
#echo "nix-shell --command \"cd plutus-pab; plutus-playground-generate-purs; cd ..; cd plutus-playground-server; plutus-playground-generate-purs\"" >> updatePlutus.sh
#cd ./plutus
#/bin/bash ../updatePlutus.sh

# Configure script for week 01 class
touch week01-updatePlutus.sh
cat >> week01-updatePlutus.sh <<EOF
cd ~/git/plutus-pioneer-program/code/week01
build_tag=\$(grep -A1 plutus-apps.git cabal.project | grep tag | awk '{print \$2}')
cd ~/git/plutus-apps
git checkout \$build_tag

# Add host 0.0.0.0 -> to access the frontend in browser 192.168.5.x
cp plutus-playground-client/package.json plutus-playground-client/package.json.bak 
sed 's/--mode=development/--mode=development --host 0.0.0.0/g' plutus-playground-client/package.json.bak > plutus-playground-client/package.json

# Enter nix-shell environment (and build if needed)
nix-shell

# Build and execute week 1 exercises
cd ~/git/plutus-pioneer-program/code/week01
cabal update
cabal build
build-and-serve-docs &
cd ~/git/plutus-apps/plutus-playground-client
plutus-playground-server &
sleep 60
npm start
EOF


#/bin/bash ./week01-updatePlutus.sh
