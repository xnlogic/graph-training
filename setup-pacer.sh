gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
 \curl -sSL https://get.rvm.io | bash -s stable

rvm install jruby
gem install pacer

echo -e "\n\nYou're good to go."
echo -e "Next, run the \033[0;32m irb \033[0m and start using Pacer interactively."
