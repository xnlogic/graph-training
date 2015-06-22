gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
 \curl -sSL https://get.rvm.io | bash -s stable

rvm install jruby
gem install pacer

echo "You're good to go."
echo "Now, type in 'irb' and start using Pacer interactively."

