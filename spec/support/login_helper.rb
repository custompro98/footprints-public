def login_as(user)
  allow(controller).to receive(:current_user).and_return(user)
end

