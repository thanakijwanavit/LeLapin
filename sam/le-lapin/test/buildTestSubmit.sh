/usr/local/Caskroom/miniconda/base/bin/sam build&&\
    /usr/local/Caskroom/miniconda/base/bin/sam local invoke -e testEmail.json SendEmailFunction&&\
    /usr/local/Caskroom/miniconda/base/bin/sam local invoke -e testOrder.json SubmitOrderFunction&&\
    /usr/local/Caskroom/miniconda/base/bin/sam deploy
