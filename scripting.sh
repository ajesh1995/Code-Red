resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYlFbrq0+Hy+5M0ll3HL7GQEKSLJuYrMC8ZX0jtacXo75AodsCIjExnW5iYTrGKO/FvbAFdIKZ9TzFe8w0lCuay3VeMWWSQb05bnRw7keFhguSY0Wb8+XHTN+HyY5HpGHcz6JdC7z1hThrYoQCaeD9xhYcIbzPHFEgO7tbtqZl5h3g67g1otTdKHjJYi8TpThKUCHfj4dUqBsgLG3d3sxaP3zOQp5fC9zF1Xm490CUIyIsAaYBmcieYC0hAMdCRr8jjFk9rfQqvJrqufRrpcA9HpEFytrYBq+lw8mIPWiZP8G3tjGa2R2FEry7F/dVMAv3Z/x23fYNC/DGmfQxAheN imported-openssh-key"
}
