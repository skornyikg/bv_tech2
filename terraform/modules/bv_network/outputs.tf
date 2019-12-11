
output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "private_subnet_ids_str" {
  value = split(",",join(",", aws_subnet.private.*.id))
}
