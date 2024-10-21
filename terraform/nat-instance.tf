resource "aws_instance" "nat_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = <<-EOF
                                #!/bin/bash
                                sudo yum install iptables-services -y
                                sudo systemctl enable iptables
                                sudo systemctl start iptables
                                echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/custom-ip-forwarding.conf
                                sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
                                sudo /sbin/iptables -t nat -A POSTROUTING -o enX0 -j MASQUERADE
                                sudo /sbin/iptables -F FORWARD
                                sudo service iptables save
                              EOF
  tags = {
    Name = "NAT-instance"
  }
}

output "nat_instance_ip" {
  value       = aws_instance.nat_instance.public_ip
  description = "NAT instance Public IP address."
}

# Route table entry to forward traffic from Private subnet to NAT instance
resource "aws_route" "outbound_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
}